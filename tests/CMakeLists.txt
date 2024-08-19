
# generate lit.site.cfg
configure_file(lit.site.cfg.py.in lit.site.cfg.py @ONLY)

set(LLVM_LIT lit)

add_custom_target(check
  COMMAND ${LLVM_LIT} -v "${CMAKE_CURRENT_BINARY_DIR}"
  DEPENDS cake-opt)