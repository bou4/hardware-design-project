################################################################
# CREATE DIRECTORIES
################################################################
set bdDir ./bd
file mkdir $bdDir

set outDir ./out
file mkdir $outDir

set rptDir ./rpt
file mkdir $rptDir

################################################################
# SET TARGET PART
################################################################
set_part xcvu095-ffva2104-2-e

set_property BOARD_PART xilinx.com:vcu108:part0:1.5 [current_project]
set_property TARGET_LANGUAGE Verilog [current_project]
set_property SIMULATOR_LANGUAGE Verilog [current_project]

################################################################
# SET SOURCE MANAGEMENT MODE
################################################################
set_property SOURCE_MGMT_MODE All [current_project]

################################################################
# CREATE CUSTOM IP CATALOG
################################################################
set_property IP_REPO_PATHS ./ip [current_project]

update_ip_catalog

################################################################
# READ SOURCES
################################################################
read_verilog [glob ./hdl/*.v]

################################################################
# READ CONSTRAINTS
################################################################
read_xdc [glob ./xdc/*.xdc]

################################################################
# CREATE BLOCK DESIGNS
################################################################
source ./scripts/bd/top.tcl

################################################################
# RUN SYNTHESIS
################################################################
#synth_design -top top

#report_timing_summary -file $rptDir/post_synth_timing_summary.rpt

################################################################
# RUN PLACEMENT AND LOGIC OPTIMIZATION
################################################################
#opt_design
#power_opt_design
#place_design
#phys_opt_design

#report_timing_summary -file $rptDir/post_place_timing_summary.rpt

################################################################
# RUN ROUTER
################################################################
#route_design

#report_timing_summary -file $rptDir/post_route_timing_summary.rpt

################################################################
# EXPORT HARDWARE
################################################################
#write_bitstream $outDir/system.bit
