include "mlir/Pass/PassBase.td"

def LearnPass : Pass<"LearnPass"> {
    let summary = "A pass that learns something";
    let description = [{
        A pass that learns something.
    }];
}