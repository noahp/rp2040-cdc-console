cmake_minimum_required(VERSION 3.13)

# Enable ccache if available
find_program(
  CCACHE_PROGRAM
  ccache
)
if(CCACHE_PROGRAM)
  set_property(
    GLOBAL
    PROPERTY RULE_LAUNCH_COMPILE
             "${CCACHE_PROGRAM}"
  )
endif()

set(default_build_type RelWithDebInfo)
if(NOT
   CMAKE_BUILD_TYPE
)
  message(
    STATUS
      "Setting build type to '${default_build_type}' as none was specified."
  )
  set(CMAKE_BUILD_TYPE "${default_build_type}")
endif()

# initialize pico-sdk from submodule note: this must happen before project()
include(pico-sdk/pico_sdk_init.cmake)

project(rp2040_cdc_console)

# initialize the Raspberry Pi Pico SDK
pico_sdk_init()

add_executable(
  ${CMAKE_PROJECT_NAME}
  src/main.c
  src/memfault_platform_port.c
)

# pull in common dependencies
target_link_libraries(
  ${CMAKE_PROJECT_NAME}
  pico_stdlib
)

# add gnu build id linker option
target_link_options(
  ${CMAKE_PROJECT_NAME}
  PRIVATE
  LINKER:--build-id
)
# vendor the linker script to add the necessary stuff for build id:
# https://docs.memfault.com/docs/mcu/arm-cortex-m-guide/#add-a-unique-identifier-to-target
get_filename_component(
  pico_linker_file_abs
  "${CMAKE_CURRENT_LIST_DIR}/src/memmap_default.ld"
  ABSOLUTE
)
set_target_properties(
  ${CMAKE_PROJECT_NAME}
  PROPERTIES PICO_TARGET_LINKER_SCRIPT
             ${pico_linker_file_abs}
)

# enable usb output, disable uart output
pico_enable_stdio_usb(
  ${CMAKE_PROJECT_NAME}
  1
)
pico_enable_stdio_uart(
  ${CMAKE_PROJECT_NAME}
  0
)

# create map/bin/hex/uf2 file etc.
pico_add_extra_outputs(${CMAKE_PROJECT_NAME})

# add memfault
set(MEMFAULT_SDK_ROOT third_party/memfault-firmware-sdk)

list(
  APPEND
  MEMFAULT_COMPONENTS
  core
  util
  panics
  metrics
  demo
)
include(${MEMFAULT_SDK_ROOT}/cmake/Memfault.cmake)
memfault_library(
  ${MEMFAULT_SDK_ROOT}
  MEMFAULT_COMPONENTS
  MEMFAULT_COMPONENTS_SRCS
  MEMFAULT_COMPONENTS_INC_FOLDERS
)
target_sources(
  ${CMAKE_PROJECT_NAME}
  PRIVATE
    ${MEMFAULT_COMPONENTS_SRCS}
    ${MEMFAULT_SDK_ROOT}/ports/panics/src/memfault_platform_ram_backed_coredump.c
)
target_include_directories(
  ${CMAKE_PROJECT_NAME}
  PRIVATE ${MEMFAULT_COMPONENTS_INC_FOLDERS}
          ${MEMFAULT_SDK_ROOT}/ports/include
          ${MEMFAULT_PORT_ROOT}
          src
          # needed for CMSIS headers for NVIC_SystemReset
          pico-sdk/src/rp2_common/cmsis/stub/CMSIS/Core/Include
)
