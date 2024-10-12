import lit.formats

config.name = 'cake-mlir'
config.test_format = lit.formats.ShTest(True)
config.suffixes = ['.mlir']

if config.enable_toy:
    config.suffixes.append('.toy')

config.test_source_root = os.path.dirname(__file__)
# 测试的输出文件夹
config.test_exec_root = os.path.join(config.my_obj_root, 'test_output')

# config.substitutions.append(('%extra-protein',
#     os.path.join(config.my_obj_root, 'extra-protein-tool')))