
get_property(all_targets GLOBAL PROPERTY ALL_TABLEGEN_TARGETS)
add_custom_target(header DEPENDS ${all_targets})
