import torch
import torchvision

import cake_mlir as mlc
from cake_mlir import execution_engine, runtime

import numpy as np

import os
import ctypes
import time

class MyConv2d(torch.nn.Module):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.conv = torch.nn.Conv2d(3, 3, 3, 1, 1)
        self.relu = torch.nn.ReLU()

    def forward(self, x):
        return self.relu(self.conv(x))

def main(): 

    model = MyConv2d()
    model = model.eval()

    x = torch.zeros((1, 3, 32, 32))

    input_shape = (1, 3, 32, 32)
    output_shape = (1, 3, 32, 32)

    input = torch.randn(input_shape)
    
    mod = mlc.frontend.from_torch(model, (input,))

    mod = mlc.transform.build(mod)

    llvm_home = os.environ.get("LLVM_HOME")

    engine = execution_engine.ExecutionEngine(mod.module, shared_libs=[f"{llvm_home}/build/lib/libmlir_c_runner_utils.so"])

    input_data = ctypes.pointer(ctypes.pointer(runtime.get_ranked_memref_descriptor(x.numpy())))
    res_c = ctypes.pointer(ctypes.pointer(runtime.get_ranked_memref_descriptor(np.zeros(output_shape, dtype=np.float32))))

    start_time = time.time()
    engine.invoke("cake_run", *[res_c, input_data])
    end_time = time.time()

    cake_mlir_run_time = end_time - start_time
    print(f"cake_mlir Inference time: {cake_mlir_run_time} s")

    start_time = time.time()
    res = model(x)
    end_time = time.time()

    torch_run_time = end_time - start_time
    print(f"PyTorch Inference time: {torch_run_time} s")

    cake_mlir_res = runtime.ranked_memref_to_numpy(res_c[0])
    torch_res = res.detach().numpy()

    if np.allclose(cake_mlir_res, torch_res, atol=1e-5):
        print("Results match!")
    else:
        print("Results don't match!")
    print(f"cake_mlir_run_time / torch_run_time: {cake_mlir_run_time / torch_run_time }")


    # llvmir, _ = mlc.transform.lowering_to_llvmir(mod)

    # out, err = mlc.transform.compile2lib(llvmir, "/home/yrx/develop/cake-mlir/build/lib")

    



if __name__ == '__main__':
    main()