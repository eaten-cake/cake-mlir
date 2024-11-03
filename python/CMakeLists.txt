include(AddMLIRPython)

# Specifies that all MLIR packages are co-located under the `mlir_standalone`
# top level package (the API has been embedded in a relocatable way).
# TODO: Add an upstream cmake param for this vs having a global here.
add_compile_definitions("MLIR_PYTHON_PACKAGE_PREFIX=cake_mlir.")

set(PYTHON_SOURCE_DIR ${CakeMLIR_SOURCE_DIR}/lib/Bindings/Python)

################################################################################
# Sources
################################################################################

declare_mlir_python_sources(CakeMLIRPythonSources)
declare_mlir_python_extension(CakeMLIRPythonExtension)

# Add Torch importer sources.
declare_mlir_python_sources(CakeMLIRPythonSources.Torch.Importers
  ADD_TO_PARENT CakeMLIRPythonSources
  ROOT_DIR "${CakeMLIR_SOURCE_DIR}/3rdparty/torch-mlir/python/torch_mlir"
  SOURCES
    extras/fx_importer.py
    extras/onnx_importer.py
    extras/fx_decomp_util.py
)

# add __init__.py
declare_mlir_python_sources(
  CakeMLIRPythonSources.Core
  ADD_TO_PARENT CakeMLIRPythonSources
  ROOT_DIR "${CakeMLIR_SOURCE_DIR}/python/cake_mlir"
  SOURCES
    __init__.py
)

# Add frontend sources.
declare_mlir_python_sources(
  CakeMLIRPythonSources.Frontend
  ADD_TO_PARENT CakeMLIRPythonSources
  ROOT_DIR "${CakeMLIR_SOURCE_DIR}/python/cake_mlir"
  # SOURCES
  #   frontend/__init__.py
  #   frontend/torch/torch_importer.py
  #   frontend/onnx/onnx_importer.py
  SOURCES_GLOB
    frontend/*.py
)

# Add utils sources.
declare_mlir_python_sources(
  CakeMLIRPythonSources.Utils
  ADD_TO_PARENT CakeMLIRPythonSources
  ROOT_DIR "${CakeMLIR_SOURCE_DIR}/python/cake_mlir"
  # SOURCES
  #   utils/__init__.py
  #   utils/common.py
  SOURCES_GLOB
    utils/*.py
)

# Add transform sources.
declare_mlir_python_sources(
  CakeMLIRPythonSources.Transform
  ADD_TO_PARENT CakeMLIRPythonSources
  ROOT_DIR "${CakeMLIR_SOURCE_DIR}/python/cake_mlir"
  # SOURCES
  #   transform/__init__.py
  #   transform/transform.py
  #   transform/build_module.py
  #   transform/basic.py
  #   transform/passes/passes.py
  #   transform/passes/__init__.py
  SOURCES_GLOB
    transform/*.py
)

# Add structure sources.
declare_mlir_python_sources(
  CakeMLIRPythonSources.Structure
  ADD_TO_PARENT CakeMLIRPythonSources
  ROOT_DIR "${CakeMLIR_SOURCE_DIR}/python/cake_mlir"
  # SOURCES
  #   ds/module.py
  #   ds/__init__.py
  SOURCES_GLOB
    ds/*.py
)

# Add runtime sources.
declare_mlir_python_sources(
  CakeMLIRPythonSources.Runtime
  ADD_TO_PARENT CakeMLIRPythonSources
  ROOT_DIR "${CakeMLIR_SOURCE_DIR}/python/cake_mlir"
  SOURCES_GLOB
   Runtime/*.py
)

declare_mlir_python_sources(
  CakeMLIRPythonSources.Tests
  ADD_TO_PARENT CakeMLIRPythonSources
  ROOT_DIR ${CakeMLIR_SOURCE_DIR}/python/cake_mlir
  SOURCES
    test/__init__.py
    test/cake_py_test.py
)

# declare_mlir_dialect_python_bindings(
#   ADD_TO_PARENT 
#   ROOT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/cake_mlir"
#   TD_FILE dialects/StandaloneOps.td
#   SOURCES
#     dialects/standalone.py
#   DIALECT_NAME standalone)

# declare_mlir_python_extension(CakeMLIR.Extension
#   MODULE_NAME _standaloneDialects
#   ADD_TO_PARENT CakeMLIR
#   SOURCES
#     StandaloneExtension.cpp
#   EMBED_CAPI_LINK_LIBS
#     StandaloneCAPI
# )

declare_mlir_python_sources(CakeMLIRPythonSources.Torch.Dialects
  ROOT_DIR "${CakeMLIR_SOURCE_DIR}/3rdparty/torch-mlir/python/torch_mlir"
  ADD_TO_PARENT CakeMLIRPythonSources
)

declare_mlir_dialect_python_bindings(
  ADD_TO_PARENT CakeMLIRPythonSources.Torch.Dialects
  ROOT_DIR "${CakeMLIR_SOURCE_DIR}/3rdparty/torch-mlir/python/torch_mlir"
  TD_FILE dialects/TorchBinding.td
  SOURCES dialects/torch/__init__.py
  DIALECT_NAME torch
)

################################################################################
# Torch Extensions
################################################################################

declare_mlir_python_extension(CakeMLIRPythonExtension.Torch.Main
  MODULE_NAME _torchMlir
  ADD_TO_PARENT CakeMLIRPythonExtension
  SOURCES
    ../3rdparty/torch-mlir/python/TorchMLIRModule.cpp
  EMBED_CAPI_LINK_LIBS
    TorchMLIRCAPI
  PRIVATE_LINK_LIBS
    LLVMSupport
)

declare_mlir_python_extension(CakeMLIRPythonExtension.Tests
  MODULE_NAME _cakePythonTest
  ADD_TO_PARENT CakeMLIRPythonExtension
  ROOT_DIR ${PYTHON_SOURCE_DIR}
  SOURCES
    PythonTest.cc
  
)

################################################################################
# Common CAPI
################################################################################

set(_source_components
  MLIRPythonSources
  MLIRPythonExtension.Core
  MLIRPythonExtension.RegisterEverything

  CakeMLIRPythonSources.Core
  CakeMLIRPythonSources.Frontend
  CakeMLIRPythonSources.Transform
  CakeMLIRPythonSources.Structure
  CakeMLIRPythonSources.Runtime
  CakeMLIRPythonSources.Utils
  CakeMLIRPythonSources.Tests

  CakeMLIRPythonSources.Torch.Importers
  CakeMLIRPythonSources.Torch.Dialects

  CakeMLIRPythonExtension.Torch.Main
  CakeMLIRPythonExtension.Tests
)

# Add StableHLO Python extensions if requested.
if(CAKE_MLIR_ENABLE_STABLEHLO)
  list(APPEND _source_components StablehloPythonSources)
  list(APPEND _source_components StablehloPythonExtensions)
endif()

# Add the common CAPI library.
add_mlir_python_common_capi_library(CakeMLIRPythonCAPI
  INSTALL_COMPONENT CakeMLIRPythonModules
  INSTALL_DESTINATION python_packages/cake_mlir/cake_mlir/_mlir_libs
  OUTPUT_DIRECTORY "${MLIR_BINARY_DIR}/python_packages/cake_mlir/cake_mlir/_mlir_libs"
  RELATIVE_INSTALL_ROOT "../../../.."
  DECLARED_SOURCES ${_source_components}
)

################################################################################
# Instantiation of all Python modules
################################################################################

add_mlir_python_modules(CakeMLIRPythonModules
  ROOT_PREFIX "${MLIR_BINARY_DIR}/python_packages/cake_mlir/cake_mlir"
  INSTALL_PREFIX "python_packages/cake_mlir/cake_mlir"
  DECLARED_SOURCES ${_source_components}
  COMMON_CAPI_LINK_LIBS
    CakeMLIRPythonCAPI
  )
