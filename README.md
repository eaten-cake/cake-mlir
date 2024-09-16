## e2e AI compiler

### 快速开始

#### 下载源代码

```bash
git clone https://github.com/eaten-cake/cake-mlir.git
cd cake-mlir
git submodule update --init --recursive 
```

#### 安装python环境依赖

```bash
pip install -r requirements.txt
```

#### 编译源代码

使用`scripts/build.sh`脚本构建，若需要修改编译选项，可更改脚本。

项目默认的安装目录在`~/install`

```bash
./scripts/build.sh
```