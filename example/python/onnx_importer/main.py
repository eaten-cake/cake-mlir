import onnx

model_path = "/home/yrx/practice/tvm/models/rnn.onnx"

onnx_model = onnx.load(model_path)

print(type(onnx_model))
print(onnx_model.graph)
