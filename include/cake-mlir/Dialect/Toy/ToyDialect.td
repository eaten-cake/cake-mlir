#ifndef TOY_DIALECT
#define TOY_DIALECT

include "mlir/IR/DialectBase.td"

// Provide a definition of the 'toy' dialect in the ODS framework so that we
// can define our operations.
def Toy_Dialect : Dialect {
  let name = "toy";
  let cppNamespace = "::mlir::toy";
}

#endif // TOY_DIALECT