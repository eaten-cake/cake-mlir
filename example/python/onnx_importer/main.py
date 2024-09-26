import onnx
from onnx import version_converter, helper

from cake_mlir.extras import onnx_importer, fx_importer
from cake_mlir.dialects import torch as torch_dialect
from cake_mlir import ir, passmanager
from cake_mlir import frontend, transform

import torch
from torch import nn

ctx = ir.Context()
ctx.allow_unregistered_dialects = True
module = ir.Module.parse(
    """
    module {
        func.func @main(%operand : tensor<2x2x2xf64>, %scale : tensor<2xf64>, %offset : tensor<2xf64>, %mean : tensor<2xf64>, %variance : tensor<2xf64>) -> tensor<2x2x2xf64> {
            %result = "stablehlo.batch_norm_inference"(%operand, %scale, %offset, %mean, %variance) {
                epsilon = 0.0 : f32,
                feature_index = 2 : i64
            } : (tensor<2x2x2xf64>, tensor<2xf64>, tensor<2xf64>, tensor<2xf64>, tensor<2xf64>) -> tensor<2x2x2xf64>
            return %result : tensor<2x2x2xf64>
        }
    }
    """, ctx
)

passes = [
    # "func.func(stablehlo-legalize-deprecated-ops)",
    "stablehlo-legalize-to-linalg",
]

pipeline_str = "builtin.module(" + ",".join(passes) + ")"

pm = passmanager.PassManager.parse(pipeline_str, ctx)
pm.run(module.operation)

print(module)

exit(0)

model_path = "/home/yrx/practice/tvm/models/resnet50-v2-7.onnx"

model_proto = onnx.load(model_path)
model_proto = version_converter.convert_version(model_proto, 15)

module = frontend.from_onnx(model_proto)

module = transform.lowering_to_llvm(module)

module.operation.print(
    file=open("out.mlir", "w")
)
