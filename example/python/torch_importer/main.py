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

import time
import subprocess

def lowering_to_llvmir(mod = None):
    command = "echo 'Hello, World!'"
    result = subprocess.run(command, shell=True, text=True, capture_output=True)
    

lowering_to_llvmir()

exit(0)

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

model = torchvision.models.resnet18()
model = model.eval()

# model = CustomModel()
# model = model.eval()

x = torch.randn(1, 3, 224, 224)

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

res_c = ctypes.pointer(ctypes.pointer(runtime.get_ranked_memref_descriptor(res)))

x_c = ctypes.pointer(ctypes.pointer(runtime.get_ranked_memref_descriptor(x.numpy())))

ffi_args.append(res_c)

for arg in numpy_inputs:
    input = ctypes.pointer(ctypes.pointer(runtime.get_ranked_memref_descriptor(arg)))
    ffi_args.append(input)

start_time = time.time()
engine.invoke("forward", *ffi_args)
end_time = time.time()

print("mlir runtime : %fs" % (end_time - start_time))

res_numpy = runtime.ranked_memref_to_numpy(res_c[0])

start_time = time.time()
torch_result = model(x)
end_time = time.time()

print("torch runtime : %fs" % (end_time - start_time))

with torch.no_grad():
    if np.allclose(res_numpy, torch_result.numpy(), atol=1e-5):
        print("Results match!")
    else:
        print("Results don't match!")


