import torch
from torch import nn
from torch.export import export

from cake_mlir import ir, passmanager, execution_engine
from cake_mlir.extras import fx_importer 
from cake_mlir.dialects import torch as torch_dialect

import ctypes

class TestModel(nn.Module):

    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self.linear = nn.Linear(10, 10)
    
    def forward(self, x):
        return self.linear(x)
    
model = TestModel()
model = model.eval()

x = torch.randn(1, 10)

exported_program = export(
    model,
    args=(x,)
)

ctx = ir.Context()
torch_dialect.register_dialect(ctx)

importer = fx_importer.FxImporter(context=ctx)

module = importer.import_frozen_program(
    exported_program
)

pipeline_str = """
    builtin.module(
        torchdynamo-export-to-torch-backend-pipeline,
        torch-backend-to-stablehlo-backend-pipeline,
        stablehlo-legalize-to-linalg,

        canonicalize,

        convert-elementwise-to-linalg,
        convert-tensor-to-linalg,

        one-shot-bufferize,
        buffer-deallocation-pipeline,

        convert-linalg-to-affine-loops,
        lower-affine,

        expand-strided-metadata,

        convert-scf-to-cf,
        convert-cf-to-llvm,
        convert-arith-to-llvm,
        convert-func-to-llvm,
        finalize-memref-to-llvm,
        reconcile-unrealized-casts

    )
"""

pm = passmanager.PassManager.parse(pipeline_str, ctx)

pm.run(importer.module.operation)

importer.module.operation.print(
    file=open("out.mlir", "w")
)

print(importer.module.body)

# importer.module.operation.print(

# )

# engine = execution_engine.ExecutionEngine(importer.module)

c_float32_p = ctypes.c_float * 10

np_x = x.numpy()

c_x = c_float32_p(*np_x.flatten())

# engine.invoke("forward", x)