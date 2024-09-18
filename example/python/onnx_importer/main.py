import onnx

from cake_mlir.extras import onnx_importer
from cake_mlir import ir

import torch
from torch import nn

model_path = "/home/yrx/practice/tvm/models/rnn.onnx"

onnx_model = onnx.load(model_path)

model_info = onnx_importer.ModelInfo(onnx_model)

module = model_info.create_module().operation

importer = onnx_importer.NodeImporter.define_function(model_info.main_graph, module)
importer.import_all()

print(module)

print(model_info.main_graph)

# for node in onnx_model.graph.node:
#     print(node.op_type)

# class TestModel(nn.Module):

#     def __init__(self, *args, **kwargs) -> None:
#         super().__init__(*args, **kwargs)
#         self.linear = nn.Linear(10, 10)
    
#     def forward(self, x):
#         return self.linear(x)
    
# model = TestModel()
# model = model.eval()

# x = torch.randn(1, 10)

# traced_model = torch.jit.trace(model, x)

# print(dir(traced_model.graph))

# node = traced_model.graph.nodes()[0]

# print(dir(node))

# for node in traced_model.graph.nodes():
#     print(node)