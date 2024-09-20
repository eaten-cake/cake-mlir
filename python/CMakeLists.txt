include(AddMLIRPython)

# Specifies that all MLIR packages are co-located under the `mlir_standalone`
# top level package (the API has been embedded in a relocatable way).
# TODO: Add an upstream cmake param for this vs having a global here.
add_compile_definitions("MLIR_PYTHON_PACKAGE_PREFIX=cake_mlir.")


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

################################################################################
# Common CAPI
################################################################################

set(_source_components
  MLIRPythonSources
  MLIRPythonExtension.Core
  MLIRPythonExtension.RegisterEverything

  CakeMLIRPythonSources.Torch.Importers
  CakeMLIRPythonSources.Torch.Dialects
  CakeMLIRPythonExtension.Torch.Main
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
