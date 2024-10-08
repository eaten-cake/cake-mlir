import onnx

from cake_mlir.extras import onnx_importer as ONNXImporter
from cake_mlir.dialects import torch as torch_dialect
from cake_mlir.ir import Module, Context, UnitAttr
from cake_mlir import passmanager
from ... import transform

def from_onnx(
        model : onnx.ModelProto,
) -> Module:
    ctx = Context()
    torch_dialect.register_dialect(ctx)

    model_proto = onnx.shape_inference.infer_shapes(model)
    model_info = ONNXImporter.ModelInfo(model_proto)

    module = model_info.create_module(ctx)
    importer = ONNXImporter.NodeImporter.define_function(model_info.main_graph, module.operation)
    importer.import_all()
    module.operation.regions[0].blocks[0].operations[0].attributes["llvm.emit_c_interface"] = UnitAttr.get(ctx)

    backend_legal_ops = [
        "aten.flatten.using_ints",
        "aten.adaptive_avg_pool1d",
        "aten.unflatten.int",
    ]
    option_string = "{backend-legal-ops=" + ",".join(backend_legal_ops) + "}"

    passes = [
        "func.func(convert-torch-onnx-to-torch)",
        # "func.func(convert-torch-to-tensor)",
        # "func.func(convert-torch-to-arith)",
        # f"torch-lower-to-backend-contract{option_string}",
        # "torch-simplification-pipeline",
        "torch-backend-to-tosa-backend-pipeline",
        # "func.func(convert-torch-to-tosa)",
    ]

    pipeline_str = transform.sequential(passes)

    with ctx:
        pm = passmanager.PassManager.parse(pipeline_str)
        pm.run(module.operation)
    
    return module



