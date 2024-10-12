#ifndef TOY_TYPES
#define TOY_TYPES

include "ToyDialect.td"

include "mlir/IR/AttrTypeBase.td"

// A base class for all types in this dialect
class Toy_Type<string name, string typeMnemonic> : TypeDef<Toy_Dialect, name> {
  let mnemonic = typeMnemonic;
}

def Toy_StructType : Toy_Type<"ToyStruct", "struct"> {
    let summary = "A toy struct";

    let description = [{
      A type for toy struct.
    }];

    let parameters = (ins ArrayRefParameter<"mlir::Type"> : $elementTypes);
    let assemblyFormat = "`<` $elementTypes `>`";
}

#endif // TOY_TYPES