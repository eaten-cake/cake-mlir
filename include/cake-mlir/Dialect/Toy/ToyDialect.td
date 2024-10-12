#ifndef TOY_DIALECT
#define TOY_DIALECT

include "mlir/IR/DialectBase.td"

// Provide a definition of the 'toy' dialect in the ODS framework so that we
// can define our operations.
def Toy_Dialect : Dialect {
  let name = "toy";
  let cppNamespace = "::mlir::toy";

  // We set this bit to generate a declaration of the `materializeConstant`
  // method so that we can materialize constants for our toy operations.
  let hasConstantMaterializer = 1;

  // We set this bit to generate the declarations for the dialect's type parsing
  // and printing hooks.
  let useDefaultTypePrinterParser = 1;

}

#endif // TOY_DIALECT