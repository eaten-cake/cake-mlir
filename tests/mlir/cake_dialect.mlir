// RUN: cake-opt %s

module {
    // func.func @matmul(%lhs: tensor<2048x2048xf32>, %rhs: tensor<2048x2048xf32>) -> tensor<2048x2048xf32> {
    //     %res = cake.matmul %lhs, %rhs : tensor<2048x2048xf32>
    //     return %res : tensor<2048x2048xf32>
    // }
    func.func @tosa_matmul(%arg0: tensor<1x2048x2048xi32>, %arg1: tensor<1x2048x2048xi32>) -> tensor<1x2048x2048xi32> {
        %0 = tosa.matmul %arg0, %arg1 : (tensor<1x2048x2048xi32>, tensor<1x2048x2048xi32>) -> tensor<1x2048x2048xi32>
        return %0 : tensor<1x2048x2048xi32>
    }
}