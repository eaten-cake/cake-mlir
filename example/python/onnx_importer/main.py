import onnx

from cake_mlir.extras import onnx_importer, fx_importer
from cake_mlir.dialects import torch as torch_dialect
from cake_mlir import ir, passmanager

import torch
from torch import nn

model_path = "/home/yrx/practice/tvm/models/add.onnx"

onnx_model = onnx.load(model_path)

model_info = onnx_importer.ModelInfo(onnx_model)

ctx = ir.Context()
ctx.allow_unregistered_dialects = True
torch_dialect.register_dialect(ctx)

module = model_info.create_module(ctx).operation

importer = onnx_importer.NodeImporter.define_function(model_info.main_graph, module)
importer.import_all()

print(module)

pipeline_str = """
    builtin.module(
        inline, func.func(convert-torch-onnx-to-torch)
    )
"""

pm = passmanager.PassManager.parse(pipeline_str, ctx)

pm.run(module)

print(module)