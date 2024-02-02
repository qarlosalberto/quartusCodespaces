cmake_minimum_required(VERSION 3.14)

add_subdirectory(../niosv_bsp niosv_bsp)

include(../niosv_bsp/toolchain.cmake)

project(niosv_app)

add_executable(niosv_app.elf)

target_sources(niosv_app.elf
    PRIVATE
        main.c
)

target_include_directories(niosv_app.elf
    PRIVATE
    PUBLIC
)

target_link_libraries(niosv_app.elf
    PRIVATE
        -T "${BspLinkerScript}" -nostdlib
        "${ExtraArchiveLibraries}"
        -Wl,--start-group "${BspLibraryName}" -lc -lstdc++ -lgcc -lm -Wl,--end-group
)

# Create objdump from ELF.
set(objdump niosv_app.elf.objdump)
add_custom_command(
    OUTPUT "${objdump}"
    DEPENDS niosv_app.elf
    COMMAND "${ToolchainObjdump}" "${ToolchainObjdumpFlags}" niosv_app.elf >
            "${objdump}"
    COMMENT "Creating ${objdump}."
    VERBATIM
)
add_custom_target(create-objdump ALL DEPENDS "${objdump}")

# Report space free for stack + heap. Note that the file below is never created
# so the report is always output on build.
set(stack_report_file niosv_app.elf.stack_report)
add_custom_command(
    OUTPUT "${stack_report_file}"
    DEPENDS niosv_app.elf
    COMMAND niosv-stack-report -p "${ToolchainPrefix}" niosv_app.elf
    COMMENT "Reporting memory available for stack + heap in niosv_app.elf."
    VERBATIM
)
add_custom_target(niosv-stack-report ALL DEPENDS "${stack_report_file}")
