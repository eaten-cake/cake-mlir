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
from cake_mlir import runtime

import ctypes
import numpy as np

class CustomModel(nn.Module):

    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(3, 32, 3, padding = 1, stride = 2)
        self.conv2 = nn.Conv2d(32, 32, 3, padding = 1, stride = 2)
        self.fc1 = nn.Linear(32 * 56 * 56, 10)
    
    def forward(self, x):
        x = self.conv1(x)
        x = self.conv2(x)
        x = x.reshape(-1, 32 * 56 * 56)
        x = self.fc1(x)
        return x

# model = torchvision.models.resnet18()
# model = model.eval()

model = CustomModel()
model = model.eval()

x = torch.randn(1, 3, 224, 224)

y = model(x)

print(y.shape)

mod = frontend.from_torch(model, (x,))

mod.operation.regions[0].blocks[0].operations[0].print(
    file=open("out.mlir", "w")
)

mod = lowering_to_llvm(mod)

mod.operation.print(
    file=open("out.mlir", "w")
)

# exit(0)

buffers = model.named_buffers(remove_duplicate=False)

params = {
    **dict(buffers)
}
params_flat, params_spec = pytree.tree_flatten(params)
params_flat = list(params_flat)

engine = execution_engine.ExecutionEngine(mod, shared_libs=["/home/yrx/llvm-project/build/lib/libmlir_c_runner_utils.so"])

with torch.no_grad():
    numpy_inputs = [o.numpy() for o in params_flat]

numpy_inputs.append(x.numpy())

ffi_args = []

res = np.zeros((1, 1000), dtype=np.float32)

res_c = ctypes.pointer(ctypes.pointer(runtime.get_unranked_memref_descriptor(res)))

x_c = ctypes.pointer(ctypes.pointer(runtime.get_unranked_memref_descriptor(x.numpy())))

ffi_args.append(ctypes.pointer(ctypes.pointer(runtime.get_unranked_memref_descriptor(res))))

for arg in numpy_inputs:
    input = ctypes.pointer(ctypes.pointer(runtime.get_unranked_memref_descriptor(arg)))
    ffi_args.append(input)

engine.invoke("forward", res_c, x_c)

# print(res)

torch_result = model(x)

print(torch_result.shape)