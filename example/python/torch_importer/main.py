import torch
from torch import nn
from torch.export import export

from cake_mlir import ir, passmanager
from cake_mlir.extras import fx_importer 
from cake_mlir.dialects import torch as torch_dialect

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

print(importer.module)

pipeline_str = """
    builtin.module(
        torchdynamo-export-to-torch-backend-pipeline,
        torch-backend-to-linalg-on-tensors-backend-pipeline
    )
"""

pm = passmanager.PassManager.parse(pipeline_str, ctx)

pm.run(importer.module.operation)

print(importer.module)