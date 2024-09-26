import torch
from torch import nn

from cake_mlir import frontend, transform

import onnx

class BatchNorm(nn.Module):

    def __init__(self):
        super(BatchNorm, self).__init__()
        self.bn = nn.BatchNorm2d(3)

    def forward(self, x):
        return self.bn(x)
    
model = BatchNorm().eval()

input = torch.randn(1, 3, 224, 224)

# module = frontend.from_torch(model, (input,))

torch.onnx.export(model, input, "batch_norm.onnx", opset_version=17)

model_proto = onnx.load("batch_norm.onnx")

module = frontend.from_onnx(model_proto)

module = transform.lowering_to_llvm(module)

print(module)

