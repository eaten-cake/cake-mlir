import torch
from torch import nn

from cake_mlir import frontend, transform

import subprocess

# x : (1, 10), y : (1, 10)
class MyModel(nn.Module):
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

    def forward(self, x, y):
        return torch.add(x, y)

model = MyModel()
model.eval()

x = torch.rand(1, 10)
y = torch.rand(1, 10)

mod = frontend.from_torch(model, (x, y))

mod = transform.lowering_to_llvm(mod)

def translate_to_llvmir(mod):
    command = "cake-translate --mlir-to-llvmir"
    result = subprocess.run(command, input=str(mod), capture_output=True, text=True, shell=True)
    return result.stdout

llvmir = translate_to_llvmir(mod)

def compile_to_object(llvmir):
    command = "llc -filetype=obj -o output.o"
    clang_model_so = "clang++ -shared -o model.so output.o"
    result = subprocess.run(command, input=llvmir, capture_output=True, text=True, shell=True)
    result = subprocess.run(clang_model_so, capture_output=True, text=True, shell=True)
    return result.returncode

ret = compile_to_object(llvmir)

print(ret)
