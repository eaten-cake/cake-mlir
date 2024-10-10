# add torch-mlir support
set(CAKE_MLIR_ENABLE_TORCH_MLIR ON)
# add stablehlo support
set(CAKE_MLIR_ENABLE_STABLEHLO OFF)
# add python bindings support
set(CAKE_MLIR_ENABLE_PYTHON_BINDINGS ON)
# enable LLD linker
set(CAKE_MLIR_ENABLE_LLD ON)
# enable ccache
set(CAKE_MLIR_ENABLE_CCACHE ON)
# set the path to MLIR cmake
set(MLIR_DIR "")
# set the path to LLVM cmake
set(LLVM_DIR "")
# set the path to Python3 executable
set(Python3_EXECUTABLE "")
# enable toy mlir
set(CAKE_MLIR_ENABLE_TOY ON)
