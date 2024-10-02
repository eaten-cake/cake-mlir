import onnx
from onnx import version_converter, helper

from cake_mlir.extras import onnx_importer, fx_importer
from cake_mlir.dialects import torch as torch_dialect
from cake_mlir import ir, passmanager
from cake_mlir import frontend, transform

model_path = "resnet18.onnx"

model_proto = onnx.load(model_path)
model_proto = version_converter.convert_version(model_proto, 15)

module = frontend.from_onnx(model_proto)

module.operation.print(
    file=open("out.mlir", "w")
)

# module = transform.lowering_to_llvm(module)


