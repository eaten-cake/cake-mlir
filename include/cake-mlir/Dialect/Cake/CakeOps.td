#ifndef CAKE_MLIR_DIALECT_CAKE_CAKEOPS_TD_
#define CAKE_MLIR_DIALECT_CAKE_CAKEOPS_TD_

include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"
include "mlir/IR/OpBase.td"
include "mlir/IR/CommonTypeConstraints.td"

include "CakeDialect.td"

// def Cake_2DTensor : AnyTypeOf<[2DTensorOf<[AnyType]>], "2-d tensor", "::mlir::TensorType">;

// cake basic class
class CakeOp<string mnemonic, list<Trait> traits = []> : Op<Cake_Dialect, mnemonic, traits>;

def MatmulOp : CakeOp<"matmul", [Pure, SameOperandsAndResultType]> {
    let summary = "matrix multiplication operation";
    let arguments = (ins F32Tensor:$lhs, F32Tensor:$rhs);
    let results = (outs F32Tensor:$result);
    let assemblyFormat = "$lhs `,` $rhs attr-dict `:` type($result)";
}



#endif // CAKE_MLIR_DIALECT_CAKE_CAKEOPS_TD_