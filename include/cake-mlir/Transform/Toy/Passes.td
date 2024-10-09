#ifndef TOY_PASSES
#define TOY_PASSES

include "mlir/Pass/PassBase.td"

def ToyShapeInferencePass : Pass<"toy-ShapeInference"> {
  let summary = "Toy dialect shape inference pass";
  let description = [{
    Interface to access a registered method to infer the return types for an
    operation that can be used during type inference.
  }];
  let dependentDialects = ["mlir::toy::ToyDialect"];
}

#endif // TOY_PASSES