################################################################
# SET OUTPUT DIRECTORY
################################################################
set outputDir ./output

file mkdir $outputDir

################################################################
# SET TARGET PART
################################################################
set_part xcvu095-ffva2104-2-e

set_property BOARD_PART xilinx.com:vcu108:part0:1.5 [current_project]
set_property TARGET_LANGUAGE Verilog [current_project]
set_property SIMULATOR_LANGUAGE Verilog [current_project]

################################################################
# CREATE CUSTOM IP CATALOG
################################################################
set_property IP_REPO_PATHS {./ip} [current_fileset]

update_ip_catalog

################################################################
# CREATE BLOCK DESIGNS
################################################################
source ./bd/microblaze.tcl

################################################################
# READ SOURCES
################################################################
#read_verilog [glob ./hdl/*.v]

################################################################
# READ CONSTRAINTS
################################################################
#read_xdc [glob ./xdc/*.xdc]

################################################################
# RUN SYNTHESIS
################################################################
synth_design -top microblaze

################################################################
# RUN PLACEMENT AND LOGIC OPTIMIZATION
################################################################
opt_design
power_opt_design
place_design
phys_opt_design

################################################################
# RUN ROUTER
################################################################
route_design

################################################################
# GENERATE A BITSTREAM
################################################################
write_bitstream -force $outputDir/system.bit

################################################################
# EXPORT HARDWARE
################################################################
write_sysdef -bitfile $outputDir/system.bit $outputDir/system.sysdef

