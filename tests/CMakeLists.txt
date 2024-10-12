
set(ENABLE_TOY False)
if(CAKE_MLIR_ENABLE_TOY)
  set(ENABLE_TOY True)
endif()

# generate lit.site.cfg
configure_file(lit.site.cfg.py.in lit.site.cfg.py @ONLY)

set(LLVM_LIT lit)

add_custom_target(check
  COMMAND ${LLVM_LIT} -v "${CMAKE_CURRENT_BINARY_DIR}"
  DEPENDS cake-opt)