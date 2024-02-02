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


####################################################################################
# Python code to generate the .sof file from qsys and qpf tcl files

# Requirements to successfully run this script:
# Python version >= 3.5
# Quartus environment

#author: Padmanabhan Ayyaswamy
#version: 9 JAN 2023
####################################################################################
# import libraries
import subprocess
import sys
import os, glob, re

# define directories
cwd_1 = "./hw"
cwd_2 = "./scripts"

# Find project name & qpf, qsys tcl directories
os.chdir(cwd_2)
cntr=0
qpf_name = ''
for file in glob.glob("*.tcl*"):
    if ".gz" in file:
        gz_unzip = subprocess.Popen("gzip -d {}".format(file),shell=True)
        gz_unzip.wait()
        sep_qproj = '.gz'
        file = file.split(sep_qproj,1)[0]
    with open (file,'r') as f1:
        line_f1 = f1.readlines()
        for i,line in enumerate(line_f1):
            if 'project_exists ' in line:
                qpf_tcl = file
                qpf_tcl_dir = "../scripts/" + qpf_tcl
                qpf_name = line_f1[i].replace(" ","").split("project_exists",1)[1]
                qpf_name = re.sub(r"[{}]",'',qpf_name).replace(']','').rstrip()
            elif 'project_new -overwrite' in line:
                qpf_tcl = file
                qpf_tcl_dir = "../scripts/" + qpf_tcl
                qpf_name = line_f1[i].replace(" ","").split("project_new-overwrite",1)[1].rstrip()             
            elif ('create_system ' in line) or ('set sys_name ' in line):
                qsys_tcl = file
                qsys_tcl_dir = "../scripts/" + qsys_tcl
                qsys_name = line_f1[i].replace(" ","").split("create_system",1)[1]
                print(qsys_name)

qpf_dir = qpf_name +".qpf"
qsys_dir = qsys_name + ".qsys"

# print(qpf_name)
# print(qpf_dir)
# print(qsys_tcl_dir)
os.chdir("../")

logfile = open('logfile.txt', 'wb')

#Generate qpf file

generate_qpf = subprocess.Popen(["quartus_sh","-t",str(qpf_tcl_dir)], stdout=subprocess.PIPE, stderr=subprocess.STDOUT,cwd=cwd_1)
for line in generate_qpf.stdout:
    logfile.write(line)
generate_qpf.wait()

# Generate qsys file
generate_qsys = subprocess.Popen(["qsys-script","--script={}".format(qsys_tcl_dir),"--quartus-project={}".format(qpf_dir)], stdout=subprocess.PIPE, stderr=subprocess.STDOUT,cwd=cwd_1)
for line in generate_qsys.stdout:
    logfile.write(line)
generate_qsys.wait()

# Generate ip
generate_ip = subprocess.Popen(["quartus_ipgenerate","{}".format(qpf_dir)], stdout=subprocess.PIPE, stderr=subprocess.STDOUT,cwd=cwd_1)
for line in generate_ip.stdout:
    logfile.write(line)
generate_ip.wait()


# Hex file generation
app_creation = subprocess.Popen(["niosv-shell < scripts/niosv_app_creation.sh"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT,shell= True)
for line in app_creation.stdout:
    logfile.write(line)
app_creation.wait()


# Synthesis
quartus_sync = subprocess.Popen(["quartus_syn","{}".format(qpf_dir)], stdout=subprocess.PIPE, stderr=subprocess.STDOUT,cwd=cwd_1)
for line in quartus_sync.stdout:
    logfile.write(line)
quartus_sync.wait()

# Fitting
quartus_fit = subprocess.Popen(["quartus_fit","{}".format(qpf_dir)],stdout=subprocess.PIPE, stderr=subprocess.STDOUT,cwd=cwd_1)
for line in quartus_fit.stdout:
    logfile.write(line)
quartus_fit.wait()

# Timing analysis
quartus_sta = subprocess.Popen(["quartus_sta","{}".format(qpf_name),"-c","{}".format(qpf_name), "--mode=finalize"],stdout=subprocess.PIPE, stderr=subprocess.STDOUT,cwd=cwd_1)
for line in quartus_sta.stdout:
    logfile.write(line)
quartus_sta.wait()

# Assembly
quartus_asm = subprocess.Popen(["quartus_asm","{}".format(qpf_dir)],stdout=subprocess.PIPE, stderr=subprocess.STDOUT,cwd=cwd_1)
for line in quartus_asm.stdout:
    logfile.write(line)
quartus_asm.wait()
