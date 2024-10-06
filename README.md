## Cake-MLIR

用于学习用的MLIR项目，主要面向AI模型的端到端编译，目前仅支持Pytorch

### 快速开始

#### 下载源代码

```bash
git clone https://github.com/eaten-cake/cake-mlir.git
cd cake-mlir
git submodule update --init --recursive 
```

#### 安装python环境依赖

**务必保证环境中按照的python版本在3.10及以上，否则可能导致依赖包版本不兼容。**

```bash
pip install -r requirements.txt
```

#### 编译源代码

使用`scripts/build.sh`脚本构建，若需要修改编译选项，可更改脚本。

项目默认的安装目录在`~/install`

```bash
./scripts/build.sh
```