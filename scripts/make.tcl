################################################################
# CREATE DIRECTORIES
################################################################
set outDir ./out
file mkdir $outDir

set bdDir ./bd
file mkdir $bdDir

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
set_property IP_REPO_PATHS {./ip} [current_project]

update_ip_catalog

################################################################
# CREATE BLOCK DESIGNS
################################################################
source ./scripts/bd/microblaze.tcl

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
# EXPORT HARDWARE
################################################################
write_bitstream -force $outDir/system.bit

write_sysdef -bitfile $outDir/system.bit $outDir/system.sysdef
