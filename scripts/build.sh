SCRIPT_PATH=$(readlink -f $BASH_SOURCE)
echo "Script path: $SCRIPT_PATH"
SCRIPT_DIR=$(dirname $SCRIPT_PATH)
echo "Script dir: $SCRIPT_DIR"
PROJECT_DIR=$SCRIPT_DIR/..
echo "Project dir: $PROJECT_DIR"

# Load base.sh
source $SCRIPT_DIR/base.sh

mkdir -p $PROJECT_DIR/build

cd $PROJECT_DIR/build

# LLVM installation directory
LLVM_INSTALL_DIR=$(llvm-config --prefix)
# python executable path
# default: current env python path
PYTHON_EXECUTABLE=$(which python)

cmake .. -G Ninja \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
    -DPython3_EXECUTABLE=$PYTHON_EXECUTABLE \
    -DMLIR_DIR="$LLVM_INSTALL_DIR/lib/cmake/mlir/" \
    -DLLVM_DIR="$LLVM_INSTALL_DIR/lib/cmake/llvm/" \
    -DCMAKE_BUILD_TYPE=Debug \
    \
    -DCAKE_MLIR_ENABLE_TORCH_MLIR=ON \
    -DCAKE_MLIR_ENABLE_STABLEHLO=OFF \
    -DCAKE_MLIR_ENABLE_PYTHON_BINDINGS=ON \
    -DCAKE_MLIR_ENABLE_LLD=ON \
    -DCAKE_MLIR_ENABLE_CCACHE=ON \
    -DCAKE_MLIR_ENABLE_TOY=ON \

ninja -j4

# Add the build directory to the python path and PATH
export PYTHONPATH=$PROJECT_DIR/build/python_packages/cake-mlir:$PYTHONPATH
export PATH=$PROJECT_DIR/build/bin:$PATH

ninja check

# Add the following lines to your ~/.bashrc to use the cake-mlir
echo_color "You can write following command in your ~/.bashrc to use the cake-mlir:" "yellow"
echo_color "export PATH=${PROJECT_DIR}/build/bin:\$PATH" "yellow"
echo_color "export LD_LIBRARY_PATH=${PROJECT_DIR}/build/lib:\$LD_LIBRARY_PATH" "yellow"
echo_color "export PYTHONPATH=${PROJECT_DIR}/build/python_packages/cake_mlir:\$PYTHONPATH" "yellow"

cd -