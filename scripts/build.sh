SCRIPT_PATH=$(readlink -f $BASH_SOURCE)
echo "Script path: $SCRIPT_PATH"
SCRIPT_DIR=$(dirname $SCRIPT_PATH)
echo "Script dir: $SCRIPT_DIR"

mkdir -p $SCRIPT_DIR/../build

cd $SCRIPT_DIR/../build

cmake .. -G Ninja \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_INSTALL_PREFIX=~/install \
    -DMLIR_ENABLE_BINDINGS_PYTHON=ON \

ninja -j4 install

cd -