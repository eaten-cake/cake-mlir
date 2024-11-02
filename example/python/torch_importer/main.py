import torch
from torch import nn
import torchvision
from torch.export import export
import torch.utils._pytree as pytree

from cake_mlir import passmanager, execution_engine, runtime, frontend
from cake_mlir.extras import fx_importer
from cake_mlir.dialects import torch as torch_dialect, math
from cake_mlir.extras.fx_decomp_util import get_decomposition_table
from cake_mlir.transform import lowering_to_llvm, add_call_interface, lowering_to_linalg
from cake_mlir import runtime

import ctypes
import numpy as np

import time
import subprocess
import os

def save2file(text, filename):
    with open(filename, "w") as f:
        f.write(text)


def lowering_to_llvmir(mod = None):
    command = "cake-translate --mlir-to-llvmir"
    result = subprocess.run(command, shell=True, text=True, capture_output=True, input=str(mod))
    return result.stdout

def compile2lib(mod = None):
    command = "llc -filetype=obj -relocation-model=pic -o model.o llvmir.ll"
    link_cmd = "clang++ -shared -fPIC -o libmodel.so model.o -L/home/yrx/develop/cake-mlir/scripts/../build/lib -lcake_runtime"
    result = subprocess.run(command, shell=True, text=True, capture_output=True)
    result = subprocess.run(link_cmd, shell=True, text=True, capture_output=True)
    return (result.stdout, result.stderr)

class CustomModel(nn.Module):

    def __init__(self):
        super().__init__()
        self.conv1 = nn.Conv2d(3, 3, 3, padding = 1, stride = 2)
    
    def forward(self, x):
        x = self.conv1(x)
        # x = torch.add(x, 1)
        # x = x + y
        return x

# model = torchvision.models.resnet18()
# model = model.eval()

model = CustomModel()
model = model.eval()

input_shape = (1, 3, 64, 64)
output_shape = (1, 3, 32, 32)

# x = torch.randn(input_shape)
x = torch.zeros(input_shape)
y = torch.ones(output_shape)

output = model(x)
print(x.shape, output.shape)

mod = frontend.from_torch(model, (x,))

mod.operation.print(
    file=open("tosa.mlir", "w")
)

mod = lowering_to_linalg(mod)

mod.operation.print(
    file=open("linalg.mlir", "w")
)

mod = lowering_to_llvm(mod)

# mod = add_call_interface(mod, 1)

mod.operation.print(
    file=open("llvmir.mlir", "w")
)

llvmir = lowering_to_llvmir(mod)

save2file(llvmir, "llvmir.ll")

out, err = compile2lib(llvmir)

llvm_home = os.environ.get("LLVM_HOME")

engine = execution_engine.ExecutionEngine(mod, shared_libs=[f"{llvm_home}/build/lib/libmlir_c_runner_utils.so"])

ffi_args = []

res = np.zeros(output_shape, dtype=np.float32)

res_c = ctypes.pointer(ctypes.pointer(runtime.get_ranked_memref_descriptor(res)))

x_c = ctypes.pointer(ctypes.pointer(runtime.get_ranked_memref_descriptor(x.numpy())))
y_c = ctypes.pointer(ctypes.pointer(runtime.get_ranked_memref_descriptor(y.numpy())))

ffi_args.append(res_c)
ffi_args.append(x_c)
# ffi_args.append(y_c)

start_time = time.time()
engine.invoke("cake_run", *ffi_args)
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

