#ifndef CAKE_MLIR_DIALECT_CAKEDIALECT_TD_
#define CAKE_MLIR_DIALECT_CAKEDIALECT_TD_

include "mlir/IR/DialectBase.td"

def Cake_Dialect : Dialect {
    let name = "cake";
    let summary = "A dialect for learn Dialect";
    let description = [{
        learn custom dialect.
    }];

    let cppNamespace = "::mlir::cake";

    let useDefaultTypePrinterParser = 1;
    let hasConstantMaterializer = 1;
}

#endif // CAKE_MLIR_DIALECT_CAKEDIALECT_TD_