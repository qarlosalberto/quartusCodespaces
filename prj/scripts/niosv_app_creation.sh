# (C) 2001-2023 Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files from any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License Subscription 
# Agreement, Intel FPGA IP License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Intel and sold by 
# Intel or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


find . -type f -name "*.gz" -exec gzip -d -f '{}' '+'
niosv-bsp -c --quartus-project=hw/top.qpf --qsys=hw/qsys_top.qsys --type=hal sw/niosv_bsp/settings.bsp
niosv-app --bsp-dir=sw/niosv_bsp --app-dir=sw/niosv_app --srcs=sw/niosv_app/main.c
cmake -S ./sw/niosv_app -B sw/niosv_app/build
make -C sw/niosv_app/build
elf2hex sw/niosv_app/build/niosv_app.elf -b 0x0 -w 32 -e 0xfffff hw/onchip_mem.hex
#niosv-download -g sw/niosv_app/build/niosv_app.elf -c 1

