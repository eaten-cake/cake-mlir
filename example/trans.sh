cake-opt /home/yrx/develop/cake-mlir/tests/mlir/hlo.mlir \
    -pass-pipeline="builtin.module( \
        stablehlo-legalize-to-linalg, \
        convert-linalg-to-loops)" \
    #     convert-linalg-to-std)" \
    # --debug \