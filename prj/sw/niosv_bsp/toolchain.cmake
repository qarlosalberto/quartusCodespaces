set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR "Nios V")
set(CMAKE_CROSSCOMPILING True)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CMAKE_AR riscv32-unknown-elf-ar)
set(CMAKE_ASM_COMPILER riscv32-unknown-elf-gcc)
set(CMAKE_C_COMPILER riscv32-unknown-elf-gcc)
set(CMAKE_CXX_COMPILER riscv32-unknown-elf-g++)

set(ToolchainPrefix riscv32-unknown-elf- CACHE STRING "Toolchain prefix." FORCE)

set(ToolchainObjdump riscv32-unknown-elf-objdump CACHE STRING "Objdump executable." FORCE)
set(ToolchainObjdumpFlags -Sdtx CACHE STRING "Objdump flags." FORCE)

if(NOT CMAKE_BUILD_TYPE)
    message(STATUS "Defaulting build type to Debug.")
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build." FORCE)
endif()

set(CMAKE_C_FLAGS_DEBUG "-g")
set(CMAKE_CXX_FLAGS_DEBUG "-g")

set(CMAKE_C_FLAGS_RELEASE "-O2")
set(CMAKE_CXX_FLAGS_RELEASE "-O2")

add_compile_options(
    $<$<COMPILE_LANGUAGE:ASM>:-Wa,-gdwarf2>
    -DALT_SINGLE_THREADED
    -Wall -Wformat-security
    -Wformat
    -Wformat-security
    -fstack-protector-strong
    -march=rv32ia -mabi=ilp32
)

add_link_options(
    -march=rv32ia -mabi=ilp32
    -nostdlib
)

add_compile_definitions(
    ALT_LOG_FLAGS=0
    __hal__
)

remove_definitions(
)

enable_language(ASM)
enable_language(C)
enable_language(CXX)
