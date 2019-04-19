################################################################
# CREATE BLOCK DESIGN
################################################################
create_bd_design -dir $bdDir top

################################################################
# DESIGN PROCEDURES
################################################################
proc create_hier_cell_microblaze_0_local_memory { parentCell nameHier } {
    if { $parentCell eq "" || $nameHier eq "" } {
        catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_microblaze_0_local_memory() - Empty argument(s)!"}
        return
    }

    # Get object for parentCell
    set parentObj [get_bd_cells $parentCell]
    
    if { $parentObj == "" } {
        catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
        return
    }

    # Make sure parentObj is hier blk
    set parentType [get_property TYPE $parentObj]
    
    if { $parentType ne "hier" } {
        catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
        return
    }

    # Save current instance; Restore later
    set oldCurInst [current_bd_instance .]

    # Set parent object as current
    current_bd_instance $parentObj

    # Create cell and set as current instance
    set hier_obj [create_bd_cell -type hier $nameHier]
    
    current_bd_instance $hier_obj

    # Create interface pins
    create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 DLMB
    create_bd_intf_pin -mode MirroredMaster -vlnv xilinx.com:interface:lmb_rtl:1.0 ILMB

    # Create pins
    create_bd_pin -dir I -type clk LMB_Clk
    create_bd_pin -dir I -type rst SYS_Rst

    # Create instance: dlmb_bram_if_cntlr, and set properties
    set dlmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 dlmb_bram_if_cntlr ]
    
    set_property -dict [ list \
        CONFIG.C_ECC {0} \
    ] $dlmb_bram_if_cntlr

    # Create instance: dlmb_v10, and set properties
    set dlmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 dlmb_v10 ]

    # Create instance: ilmb_bram_if_cntlr, and set properties
    set ilmb_bram_if_cntlr [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_bram_if_cntlr:4.0 ilmb_bram_if_cntlr ]
    
    set_property -dict [ list \
        CONFIG.C_ECC {0} \
    ] $ilmb_bram_if_cntlr

    # Create instance: ilmb_v10, and set properties
    set ilmb_v10 [ create_bd_cell -type ip -vlnv xilinx.com:ip:lmb_v10:3.0 ilmb_v10 ]

    # Create instance: lmb_bram, and set properties
    set lmb_bram [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 lmb_bram ]
    
    set_property -dict [ list \
        CONFIG.Memory_Type {True_Dual_Port_RAM} \
        CONFIG.use_bram_block {BRAM_Controller} \
    ] $lmb_bram

    # Create interface connections
    connect_bd_intf_net -intf_net microblaze_0_dlmb [get_bd_intf_pins DLMB] [get_bd_intf_pins dlmb_v10/LMB_M]
    connect_bd_intf_net -intf_net microblaze_0_dlmb_bus [get_bd_intf_pins dlmb_bram_if_cntlr/SLMB] [get_bd_intf_pins dlmb_v10/LMB_Sl_0]
    connect_bd_intf_net -intf_net microblaze_0_dlmb_cntlr [get_bd_intf_pins dlmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTA]
    connect_bd_intf_net -intf_net microblaze_0_ilmb [get_bd_intf_pins ILMB] [get_bd_intf_pins ilmb_v10/LMB_M]
    connect_bd_intf_net -intf_net microblaze_0_ilmb_bus [get_bd_intf_pins ilmb_bram_if_cntlr/SLMB] [get_bd_intf_pins ilmb_v10/LMB_Sl_0]
    connect_bd_intf_net -intf_net microblaze_0_ilmb_cntlr [get_bd_intf_pins ilmb_bram_if_cntlr/BRAM_PORT] [get_bd_intf_pins lmb_bram/BRAM_PORTB]

    # Create port connections
    connect_bd_net -net SYS_Rst_1 [get_bd_pins SYS_Rst] [get_bd_pins dlmb_bram_if_cntlr/LMB_Rst] [get_bd_pins dlmb_v10/SYS_Rst] [get_bd_pins ilmb_bram_if_cntlr/LMB_Rst] [get_bd_pins ilmb_v10/SYS_Rst]
    connect_bd_net -net microblaze_0_Clk [get_bd_pins LMB_Clk] [get_bd_pins dlmb_bram_if_cntlr/LMB_Clk] [get_bd_pins dlmb_v10/LMB_Clk] [get_bd_pins ilmb_bram_if_cntlr/LMB_Clk] [get_bd_pins ilmb_v10/LMB_Clk]

    # Restore current instance
    current_bd_instance $oldCurInst
}

proc create_hier_cell_microblaze_0_gth_transceivers_buffer { parentCell nameHier } {
    if { $parentCell eq "" || $nameHier eq "" } {
        catch {common::send_msg_id "BD_TCL-102" "ERROR" "create_hier_cell_microblaze_0_gth_transceivers_buffer() - Empty argument(s)!"}
        return
    }

    # Get object for parentCell
    set parentObj [get_bd_cells $parentCell]

    if { $parentObj == "" } {
        catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
        return
    }

    # Make sure parentObj is hier blk
    set parentType [get_property TYPE $parentObj]

    if { $parentType ne "hier" } {
        catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
        return
    }

    # Save current instance; Restore later
    set oldCurInst [current_bd_instance .]

    # Set parent object as current
    current_bd_instance $parentObj

    # Create cell and set as current instance
    set hier_obj [create_bd_cell -type hier $nameHier]

    current_bd_instance $hier_obj

    # Create interface pins

    # Create pins
    create_bd_pin -dir I -from 9 -to 0 gthrxn_in
    create_bd_pin -dir I -from 9 -to 0 gthrxp_in
    create_bd_pin -dir O -from 9 -to 0 gthtxn_out
    create_bd_pin -dir O -from 9 -to 0 gthtxp_out
    create_bd_pin -dir I hb_gtwiz_reset_all_in
    create_bd_pin -dir I hb_gtwiz_reset_clk_freerun_in
    create_bd_pin -dir I mgtrefclk0_x0y5_n
    create_bd_pin -dir I mgtrefclk0_x0y5_p
    create_bd_pin -dir I pulse_in
    create_bd_pin -dir I -from 9 -to 0 sel_in
    create_bd_pin -dir I -from 4 -to 0 stepsize_in

    # Create instance: gth_transceivers_buf_0, and set properties
    set gth_transceivers_buf_0 [ create_bd_cell -type ip -vlnv ugent.be:user:gth_transceivers_buffer:1.0 gth_transceivers_buf_0 ]

    # Create instance: txpippm_controllers_0, and set properties
    set txpippm_controllers_0 [ create_bd_cell -type module -reference txpippm_controllers txpippm_controllers_0 ]

    # Create instance: vio_0, and set properties
    set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]

    set_property -dict [ list \
        CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
        CONFIG.C_NUM_PROBE_IN {0} \
        CONFIG.C_NUM_PROBE_OUT {10} \
        CONFIG.C_PROBE_OUT0_WIDTH {32} \
        CONFIG.C_PROBE_OUT1_WIDTH {32} \
        CONFIG.C_PROBE_OUT2_WIDTH {32} \
        CONFIG.C_PROBE_OUT3_WIDTH {32} \
        CONFIG.C_PROBE_OUT4_WIDTH {32} \
        CONFIG.C_PROBE_OUT5_WIDTH {32} \
        CONFIG.C_PROBE_OUT6_WIDTH {32} \
        CONFIG.C_PROBE_OUT7_WIDTH {32} \
        CONFIG.C_PROBE_OUT8_WIDTH {32} \
        CONFIG.C_PROBE_OUT9_WIDTH {32} \
    ] $vio_0

    # Create instance: xlconcat_0, and set properties
    set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
    
    set_property -dict [ list \
        CONFIG.NUM_PORTS {10} \
    ] $xlconcat_0

    # Create port connections
    connect_bd_net -net gth_transceivers_buf_0_gthtxn_out [get_bd_pins gthtxn_out] [get_bd_pins gth_transceivers_buf_0/gthtxn_out]
    connect_bd_net -net gth_transceivers_buf_0_gthtxp_out [get_bd_pins gthtxp_out] [get_bd_pins gth_transceivers_buf_0/gthtxp_out]
    connect_bd_net -net gth_transceivers_buf_0_gtwiz_userclk_tx_active_out [get_bd_pins gth_transceivers_buf_0/gtwiz_userclk_tx_active_out] [get_bd_pins txpippm_controllers_0/gtwiz_userclk_tx_active_in]
    connect_bd_net -net gth_transceivers_buf_0_gtwiz_userclk_tx_usrclk2_out [get_bd_pins gth_transceivers_buf_0/gtwiz_userclk_tx_usrclk2_out] [get_bd_pins vio_0/clk]
    connect_bd_net -net gth_transceivers_buf_0_gtwiz_userclk_tx_usrclk_out [get_bd_pins gth_transceivers_buf_0/gtwiz_userclk_tx_usrclk_out] [get_bd_pins txpippm_controllers_0/gtwiz_userclk_tx_usrclk_in]
    connect_bd_net -net gth_transceivers_buf_0_hb_gtwiz_reset_all_out [get_bd_pins gth_transceivers_buf_0/hb_gtwiz_reset_all_out] [get_bd_pins txpippm_controllers_0/gtwiz_reset_all_in]
    connect_bd_net -net gthrxn_in_1 [get_bd_pins gthrxn_in] [get_bd_pins gth_transceivers_buf_0/gthrxn_in]
    connect_bd_net -net gthrxp_in_1 [get_bd_pins gthrxp_in] [get_bd_pins gth_transceivers_buf_0/gthrxp_in]
    connect_bd_net -net hb_gtwiz_reset_all_in_1 [get_bd_pins hb_gtwiz_reset_all_in] [get_bd_pins gth_transceivers_buf_0/hb_gtwiz_reset_all_in]
    connect_bd_net -net hb_gtwiz_reset_clk_freerun_in_1 [get_bd_pins hb_gtwiz_reset_clk_freerun_in] [get_bd_pins gth_transceivers_buf_0/hb_gtwiz_reset_clk_freerun_in]
    connect_bd_net -net mgtrefclk0_x0y5_n_1 [get_bd_pins mgtrefclk0_x0y5_n] [get_bd_pins gth_transceivers_buf_0/mgtrefclk0_x0y5_n]
    connect_bd_net -net mgtrefclk0_x0y5_p_1 [get_bd_pins mgtrefclk0_x0y5_p] [get_bd_pins gth_transceivers_buf_0/mgtrefclk0_x0y5_p]
    connect_bd_net -net pulse_in_1 [get_bd_pins pulse_in] [get_bd_pins txpippm_controllers_0/pulse_in]
    connect_bd_net -net sel_in_1 [get_bd_pins sel_in] [get_bd_pins txpippm_controllers_0/sel_in]
    connect_bd_net -net stepsize_in_1 [get_bd_pins stepsize_in] [get_bd_pins txpippm_controllers_0/stepsize_in]
    connect_bd_net -net txpippm_controllers_0_txpippmen_out [get_bd_pins gth_transceivers_buf_0/txpippmen_in] [get_bd_pins txpippm_controllers_0/txpippmen_out]
    connect_bd_net -net txpippm_controllers_0_txpippmovrden_out [get_bd_pins gth_transceivers_buf_0/txpippmovrden_in] [get_bd_pins txpippm_controllers_0/txpippmovrden_out]
    connect_bd_net -net txpippm_controllers_0_txpippmpd_out [get_bd_pins gth_transceivers_buf_0/txpippmpd_in] [get_bd_pins txpippm_controllers_0/txpippmpd_out]
    connect_bd_net -net txpippm_controllers_0_txpippmsel_out [get_bd_pins gth_transceivers_buf_0/txpippmsel_in] [get_bd_pins txpippm_controllers_0/txpippmsel_out]
    connect_bd_net -net txpippm_controllers_0_txpippmstepsize_out [get_bd_pins gth_transceivers_buf_0/txpippmstepsize_in] [get_bd_pins txpippm_controllers_0/txpippmstepsize_out]
    connect_bd_net -net vio_0_probe_out0 [get_bd_pins vio_0/probe_out0] [get_bd_pins xlconcat_0/In0]
    connect_bd_net -net vio_0_probe_out1 [get_bd_pins vio_0/probe_out1] [get_bd_pins xlconcat_0/In1]
    connect_bd_net -net vio_0_probe_out2 [get_bd_pins vio_0/probe_out2] [get_bd_pins xlconcat_0/In2]
    connect_bd_net -net vio_0_probe_out3 [get_bd_pins vio_0/probe_out3] [get_bd_pins xlconcat_0/In3]
    connect_bd_net -net vio_0_probe_out4 [get_bd_pins vio_0/probe_out4] [get_bd_pins xlconcat_0/In4]
    connect_bd_net -net vio_0_probe_out5 [get_bd_pins vio_0/probe_out5] [get_bd_pins xlconcat_0/In5]
    connect_bd_net -net vio_0_probe_out6 [get_bd_pins vio_0/probe_out6] [get_bd_pins xlconcat_0/In6]
    connect_bd_net -net vio_0_probe_out7 [get_bd_pins vio_0/probe_out7] [get_bd_pins xlconcat_0/In7]
    connect_bd_net -net vio_0_probe_out8 [get_bd_pins vio_0/probe_out8] [get_bd_pins xlconcat_0/In8]
    connect_bd_net -net vio_0_probe_out9 [get_bd_pins vio_0/probe_out9] [get_bd_pins xlconcat_0/In9]
    connect_bd_net -net xlconcat_0_dout [get_bd_pins gth_transceivers_buf_0/gtwiz_userdata_tx_in] [get_bd_pins xlconcat_0/dout]

    # Restore current instance
    current_bd_instance $oldCurInst
}

proc create_root_design { parentCell } {
    if { $parentCell eq "" } {
        set parentCell [get_bd_cells /]
    }

    # Get object for parentCell
    set parentObj [get_bd_cells $parentCell]
    
    if { $parentObj == "" } {
        catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
        return
    }

    # Make sure parentObj is hier blk
    set parentType [get_property TYPE $parentObj]
    
    if { $parentType ne "hier" } {
        catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
        return
    }

    # Save current instance; Restore later
    set oldCurInst [current_bd_instance .]

    # Set parent object as current
    current_bd_instance $parentObj

    # Create interface ports
    set default_sysclk1_300 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 default_sysclk1_300 ]

    set_property -dict [ list \
        CONFIG.FREQ_HZ {300000000} \
    ] $default_sysclk1_300

    set rs232_uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 rs232_uart ]

    # Create ports
    set gthrxn_in [ create_bd_port -dir I -from 9 -to 0 gthrxn_in ]
    set gthrxp_in [ create_bd_port -dir I -from 9 -to 0 gthrxp_in ]
    set gthtxn_out [ create_bd_port -dir O -from 9 -to 0 gthtxn_out ]
    set gthtxp_out [ create_bd_port -dir O -from 9 -to 0 gthtxp_out ]
    set mgtrefclk0_x0y5_n [ create_bd_port -dir I mgtrefclk0_x0y5_n ]
    set mgtrefclk0_x0y5_p [ create_bd_port -dir I mgtrefclk0_x0y5_p ]

    set reset [ create_bd_port -dir I -type rst reset ]
    
    set_property -dict [ list \
        CONFIG.POLARITY {ACTIVE_HIGH} \
    ] $reset

    # Create instance: gth_transceivers_cont_0, and set properties
    set gth_transceivers_cont_0 [ create_bd_cell -type module -reference gth_transceivers_regs gth_transceivers_cont_0 ]

    # Create instance: axi_uartlite_0, and set properties
    set axi_uartlite_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_uartlite:2.0 axi_uartlite_0 ]

    set_property -dict [ list \
        CONFIG.UARTLITE_BOARD_INTERFACE {rs232_uart} \
        CONFIG.USE_BOARD_FLOW {true} \
    ] $axi_uartlite_0

    # Create instance: clk_wiz_1, and set properties
    set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_1 ]

    set_property -dict [ list \
        CONFIG.CLK_IN1_BOARD_INTERFACE {default_sysclk1_300} \
        CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
        CONFIG.RESET_BOARD_INTERFACE {reset} \
        CONFIG.USE_BOARD_FLOW {true} \
    ] $clk_wiz_1

    # Create instance: mdm_1, and set properties
    set mdm_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm_1 ]

    # Create instance: microblaze_0, and set properties
    set microblaze_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_0 ]

    set_property -dict [ list \
        CONFIG.C_DEBUG_ENABLED {1} \
        CONFIG.C_D_AXI {1} \
        CONFIG.C_D_LMB {1} \
        CONFIG.C_I_LMB {1} \
        CONFIG.G_TEMPLATE_LIST {8} \
    ] $microblaze_0

    # Create instance: microblaze_0_axi_periph, and set properties
    set microblaze_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 microblaze_0_axi_periph ]

    set_property -dict [ list \
        CONFIG.NUM_MI {2} \
    ] $microblaze_0_axi_periph

    # Create instance: microblaze_0_gth_transceivers_buffer
    create_hier_cell_microblaze_0_gth_transceivers_buffer [current_bd_instance .] microblaze_0_gth_transceivers_buffer

    # Create instance: microblaze_0_local_memory
    create_hier_cell_microblaze_0_local_memory [current_bd_instance .] microblaze_0_local_memory

    # Create instance: rst_clk_wiz_1_100M, and set properties
    set rst_clk_wiz_1_100M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_1_100M ]

    set_property -dict [ list \
        CONFIG.RESET_BOARD_INTERFACE {reset} \
        CONFIG.USE_BOARD_FLOW {true} \
    ] $rst_clk_wiz_1_100M

    # Create instance: vio_0, and set properties
    set vio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:vio:3.0 vio_0 ]

    set_property -dict [ list \
        CONFIG.C_NUM_PROBE_IN {4} \
        CONFIG.C_NUM_PROBE_OUT {0} \
    ] $vio_0

    # Create interface connections
    connect_bd_intf_net -intf_net axi_uartlite_0_UART [get_bd_intf_ports rs232_uart] [get_bd_intf_pins axi_uartlite_0/UART]
    connect_bd_intf_net -intf_net default_sysclk1_300_1 [get_bd_intf_ports default_sysclk1_300] [get_bd_intf_pins clk_wiz_1/CLK_IN1_D]
    connect_bd_intf_net -intf_net microblaze_0_M_AXI_DP [get_bd_intf_pins microblaze_0/M_AXI_DP] [get_bd_intf_pins microblaze_0_axi_periph/S00_AXI]
    connect_bd_intf_net -intf_net microblaze_0_axi_periph_M00_AXI [get_bd_intf_pins axi_uartlite_0/S_AXI] [get_bd_intf_pins microblaze_0_axi_periph/M00_AXI]
    connect_bd_intf_net -intf_net microblaze_0_axi_periph_M01_AXI [get_bd_intf_pins gth_transceivers_cont_0/s_axi] [get_bd_intf_pins microblaze_0_axi_periph/M01_AXI]
    connect_bd_intf_net -intf_net microblaze_0_debug [get_bd_intf_pins mdm_1/MBDEBUG_0] [get_bd_intf_pins microblaze_0/DEBUG]
    connect_bd_intf_net -intf_net microblaze_0_dlmb_1 [get_bd_intf_pins microblaze_0/DLMB] [get_bd_intf_pins microblaze_0_local_memory/DLMB]
    connect_bd_intf_net -intf_net microblaze_0_ilmb_1 [get_bd_intf_pins microblaze_0/ILMB] [get_bd_intf_pins microblaze_0_local_memory/ILMB]

    # Create port connections
    connect_bd_net -net gth_transceivers_cont_0_pulse_pulse [get_bd_pins gth_transceivers_cont_0/pulse_pulse] [get_bd_pins microblaze_0_gth_transceivers_buffer/pulse_in] [get_bd_pins vio_0/probe_in2]
    connect_bd_net -net gth_transceivers_cont_0_reset_reset [get_bd_pins gth_transceivers_cont_0/reset_reset] [get_bd_pins microblaze_0_gth_transceivers_buffer/hb_gtwiz_reset_all_in] [get_bd_pins vio_0/probe_in0]
    connect_bd_net -net gth_transceivers_cont_0_sel_sel [get_bd_pins gth_transceivers_cont_0/sel_sel] [get_bd_pins microblaze_0_gth_transceivers_buffer/sel_in] [get_bd_pins vio_0/probe_in1]
    connect_bd_net -net gth_transceivers_cont_0_stepsize_stepsize [get_bd_pins gth_transceivers_cont_0/stepsize_stepsize] [get_bd_pins microblaze_0_gth_transceivers_buffer/stepsize_in] [get_bd_pins vio_0/probe_in3]
    connect_bd_net -net clk_wiz_1_locked [get_bd_pins clk_wiz_1/locked] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked]
    connect_bd_net -net gthrxn_in_1 [get_bd_ports gthrxn_in] [get_bd_pins microblaze_0_gth_transceivers_buffer/gthrxn_in]
    connect_bd_net -net gthrxp_in_1 [get_bd_ports gthrxp_in] [get_bd_pins microblaze_0_gth_transceivers_buffer/gthrxp_in]
    connect_bd_net -net mdm_1_debug_sys_rst [get_bd_pins mdm_1/Debug_SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/mb_debug_sys_rst]
    connect_bd_net -net mgtrefclk0_x0y5_n_1 [get_bd_ports mgtrefclk0_x0y5_n] [get_bd_pins microblaze_0_gth_transceivers_buffer/mgtrefclk0_x0y5_n]
    connect_bd_net -net mgtrefclk0_x0y5_p_1 [get_bd_ports mgtrefclk0_x0y5_p] [get_bd_pins microblaze_0_gth_transceivers_buffer/mgtrefclk0_x0y5_p]
    connect_bd_net -net microblaze_0_Clk [get_bd_pins gth_transceivers_cont_0/axi_aclk] [get_bd_pins axi_uartlite_0/s_axi_aclk] [get_bd_pins clk_wiz_1/clk_out1] [get_bd_pins microblaze_0/Clk] [get_bd_pins microblaze_0_axi_periph/ACLK] [get_bd_pins microblaze_0_axi_periph/M00_ACLK] [get_bd_pins microblaze_0_axi_periph/M01_ACLK] [get_bd_pins microblaze_0_axi_periph/S00_ACLK] [get_bd_pins microblaze_0_gth_transceivers_buffer/hb_gtwiz_reset_clk_freerun_in] [get_bd_pins microblaze_0_local_memory/LMB_Clk] [get_bd_pins rst_clk_wiz_1_100M/slowest_sync_clk] [get_bd_pins vio_0/clk]
    connect_bd_net -net microblaze_0_gth_transceivers_buffer_gthtxn_out [get_bd_ports gthtxn_out] [get_bd_pins microblaze_0_gth_transceivers_buffer/gthtxn_out]
    connect_bd_net -net microblaze_0_gth_transceivers_buffer_gthtxp_out [get_bd_ports gthtxp_out] [get_bd_pins microblaze_0_gth_transceivers_buffer/gthtxp_out]
    connect_bd_net -net reset_1 [get_bd_ports reset] [get_bd_pins clk_wiz_1/reset] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in]
    connect_bd_net -net rst_clk_wiz_1_100M_bus_struct_reset [get_bd_pins microblaze_0_local_memory/SYS_Rst] [get_bd_pins rst_clk_wiz_1_100M/bus_struct_reset]
    connect_bd_net -net rst_clk_wiz_1_100M_mb_reset [get_bd_pins microblaze_0/Reset] [get_bd_pins rst_clk_wiz_1_100M/mb_reset]
    connect_bd_net -net rst_clk_wiz_1_100M_peripheral_aresetn [get_bd_pins gth_transceivers_cont_0/axi_aresetn] [get_bd_pins axi_uartlite_0/s_axi_aresetn] [get_bd_pins microblaze_0_axi_periph/ARESETN] [get_bd_pins microblaze_0_axi_periph/M00_ARESETN] [get_bd_pins microblaze_0_axi_periph/M01_ARESETN] [get_bd_pins microblaze_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]

    # Create address segments
    create_bd_addr_seg -range 0x00001000 -offset 0x80000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs gth_transceivers_cont_0/s_axi/reg0] SEG_gth_transceivers_cont_0_reg0
    create_bd_addr_seg -range 0x00010000 -offset 0x40600000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs axi_uartlite_0/S_AXI/Reg] SEG_axi_uartlite_0_Reg
    create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Data] [get_bd_addr_segs microblaze_0_local_memory/dlmb_bram_if_cntlr/SLMB/Mem] SEG_dlmb_bram_if_cntlr_Mem
    create_bd_addr_seg -range 0x00040000 -offset 0x00000000 [get_bd_addr_spaces microblaze_0/Instruction] [get_bd_addr_segs microblaze_0_local_memory/ilmb_bram_if_cntlr/SLMB/Mem] SEG_ilmb_bram_if_cntlr_Mem

    # Restore current instance
    current_bd_instance $oldCurInst

    validate_bd_design

    save_bd_design
}

################################################################
# EXPORT BLOCK DESIGN
################################################################
create_root_design ""

make_wrapper -top [get_files top.bd]

generate_target {synthesis implementation} [get_files top.bd]
