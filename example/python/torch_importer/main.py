import torch
from torch import nn
import torchvision
from torch.export import export

from cake_mlir import passmanager, execution_engine, runtime, frontend
from cake_mlir.extras import fx_importer
from cake_mlir.dialects import torch as torch_dialect, math
from cake_mlir.extras.fx_decomp_util import get_decomposition_table

import ctypes
import numpy as np

model = torchvision.models.resnet18(pretrained=True)
model = model.eval()

x = torch.randn(1, 3, 224, 224)

mod = frontend.from_torch(model, (x,))

# pipeline_str = """
#     builtin.module(
#         stablehlo-legalize-to-linalg,

#         canonicalize,

#         convert-elementwise-to-linalg,
#         convert-tensor-to-linalg,

#         one-shot-bufferize{bufferize-function-boundaries},
#         buffer-deallocation-pipeline,

#         convert-linalg-to-affine-loops,
#         lower-affine,

#         expand-strided-metadata,

#         convert-scf-to-cf,
#         convert-cf-to-llvm,
#         convert-math-to-llvm,
#         convert-arith-to-llvm,
#         convert-func-to-llvm,
#         finalize-memref-to-llvm,
#         reconcile-unrealized-casts

#     )
# """

pipeline_str = """
    builtin.module(
        stablehlo-legalize-to-linalg

    )
"""

pm = passmanager.PassManager.parse(pipeline_str, mod.context)

pm.run(mod.operation)

mod.operation.print(
    file=open("out.mlir", "w"),
)

engine = execution_engine.ExecutionEngine(mod)

np_x = ctypes.pointer(ctypes.pointer(runtime.get_ranked_memref_descriptor(x.numpy())))
res = ctypes.pointer(ctypes.pointer(runtime.get_ranked_memref_descriptor(np.zeros((1, 1000), dtype=np.float32))))

engine.invoke("forward", res, np_x)

res_np = runtime.ranked_memref_to_numpy(res[0])

print(res_np)

torch_res = model(x)

print(torch_res)