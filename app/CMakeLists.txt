cmake_minimum_required(VERSION 3.20.0)

find_package(Zephyr REQUIRED HINTS $ENV{ZEPHYR_BASE})
project(weedy)

# Pigweed links its libraries into zephyr_interface, which everything in
# Zephyr links, including the libraries that generate headers such as
# zephyr/heap_constants.h (included by kernel.h). Pigweed's libraries then
# have to build before those headers exist, so a clean build fails. Link
# them into the app instead and order them after header generation, as
# Zephyr does for its own libraries.
get_target_property(zephyr_interface_libs zephyr_interface INTERFACE_LINK_LIBRARIES)
set(pigweed_libs ${zephyr_interface_libs})
list(FILTER pigweed_libs INCLUDE REGEX "^pw_")
list(FILTER zephyr_interface_libs EXCLUDE REGEX "^pw_")
set_property(TARGET zephyr_interface PROPERTY INTERFACE_LINK_LIBRARIES ${zephyr_interface_libs})
target_link_libraries(app PRIVATE ${pigweed_libs})

function(depend_on_zephyr_generated_headers dir)
  get_property(targets DIRECTORY ${dir} PROPERTY BUILDSYSTEM_TARGETS)
  foreach(target IN LISTS targets)
    get_target_property(type ${target} TYPE)
    if(type MATCHES "^(STATIC|OBJECT)_LIBRARY$")
      add_dependencies(${target} zephyr_generated_headers)
    endif()
  endforeach()
  get_property(subdirs DIRECTORY ${dir} PROPERTY SUBDIRECTORIES)
  foreach(subdir IN LISTS subdirs)
    depend_on_zephyr_generated_headers(${subdir})
  endforeach()
endfunction()
depend_on_zephyr_generated_headers(${ZEPHYR_PIGWEED_MODULE_DIR})

target_sources(app PRIVATE src/main.cc)
target_compile_options(app PRIVATE -Wall -Wextra -Werror)
target_link_libraries(app PRIVATE pw_digital_io_zephyr pw_log)
