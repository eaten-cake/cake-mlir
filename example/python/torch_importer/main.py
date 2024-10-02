import torch
from torch import nn
import torchvision
from torch.export import export
import torch.utils._pytree as pytree

from cake_mlir import passmanager, execution_engine, runtime, frontend
from cake_mlir.extras import fx_importer
from cake_mlir.dialects import torch as torch_dialect, math
from cake_mlir.extras.fx_decomp_util import get_decomposition_table
from cake_mlir.transform import lowering_to_llvm 

import ctypes
import numpy as np

model = torchvision.models.resnet18(pretrained=True)
model = model.eval()

x = torch.randn(1, 3, 224, 224)

mod = frontend.from_torch(model, (x,))

mod = lowering_to_llvm(mod)

# mod.operation.print(
#     file=open("out.mlir", "w")
# )

buffers = model.named_buffers(remove_duplicate=False)

params = {
    **dict(buffers)
}
params_flat, params_spec = pytree.tree_flatten(params)
params_flat = list(params_flat)

engine = execution_engine.ExecutionEngine(mod)

with torch.no_grad():
    numpy_inputs = [o.numpy() for o in params_flat]

numpy_inputs.append(x.numpy())



torch_result = model(x)

print(torch_result.shape)