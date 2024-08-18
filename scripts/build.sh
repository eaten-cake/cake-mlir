SCRIPT_PATH=$(readlink -f $BASH_SOURCE)
echo "Script path: $SCRIPT_PATH"
SCRIPT_DIR=$(dirname $SCRIPT_PATH)
echo "Script dir: $SCRIPT_DIR"

mkdir -p $SCRIPT_DIR/../build

cd $SCRIPT_DIR/../build

export LLVM_INSTALL_DIR=/home/yrx/llvm-project/build

cmake .. -G Ninja \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_INSTALL_PREFIX=~/install \
    -DMLIR_ENABLE_BINDINGS_PYTHON=ON \
    -DMLIR_DIR="$LLVM_INSTALL_DIR/lib/cmake/mlir/" \
    -DLLVM_DIR="$LLVM_INSTALL_DIR/lib/cmake/llvm/" \

ninja -j4 install

cd -