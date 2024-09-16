// RUN: cake-opt %s

module {
    func.func @dot(%a: tensor<2048x2048xf32>, %b: tensor<2048x2048xf32>) -> tensor<2048x2048xf32> {
        %res = stablehlo.dot %a, %b : (tensor<2048x2048xf32>, tensor<2048x2048xf32>) -> tensor<2048x2048xf32>
        return %res : tensor<2048x2048xf32>
    }
}