import torch
import torchvision

import cake_mlir as mlc

def main():
    model = torchvision.models.resnet18()
    model = model.eval()

    input_shape = (1, 3, 224, 224)
    output_shape = (1, 1000)

    input = torch.randn(input_shape)
    
    mod = mlc.frontend.from_torch(model, (input,))

    mod.operation.write_bytecode(
        file=open("resnet18", "wb")
    )

    # mod = mlc.transform.lowering_to_llvm(mod)

    # llvmir, _ = mlc.transform.lowering_to_llvmir(mod)

    # print("hi")



if __name__ == '__main__':
    main()