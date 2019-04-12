################################################################
# CREATE BLOCK DESIGN
################################################################
create_bd_design -dir $bdDir top

# Create interface ports
## Differential system clock inputs
create_bd_intf_port -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -mode Slave default_sysclk1_300

set_property -dict [ list \
CONFIG.FREQ_HZ {300000000} \
] [get_bd_intf_ports default_sysclk1_300]

# Create ports
## Directional push buttons
create_bd_port -dir I gpio_sw_s
create_bd_port -dir I gpio_sw_c

## Differential reference clock inputs
create_bd_port -dir I mgtrefclk0_x0y5_p
create_bd_port -dir I mgtrefclk0_x0y5_n

## Serial data ports
create_bd_port -from 9 -to 0 -dir I gthrxn
create_bd_port -from 9 -to 0 -dir I gthrxp
create_bd_port -from 9 -to 0 -dir O gthtxn
create_bd_port -from 9 -to 0 -dir O gthtxp

# Create instance: clk_wiz_0, and set properties
create_bd_cell -vlnv xilinx.com:ip:clk_wiz:6.0 -type IP clk_wiz_0

set_property -dict [list \
CONFIG.CLK_IN1_BOARD_INTERFACE {default_sysclk1_300} \
CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
CONFIG.USE_BOARD_FLOW {true} \
CONFIG.USE_LOCKED {false} \
CONFIG.USE_RESET {false} \
] [get_bd_cells clk_wiz_0]

# Create instance: vio_0, and set properties
create_bd_cell -vlnv xilinx.com:ip:vio:3.0 -type IP vio_0

set_property -dict [list \
CONFIG.C_PROBE_OUT9_WIDTH {32} \
CONFIG.C_PROBE_OUT8_WIDTH {32} \
CONFIG.C_PROBE_OUT7_WIDTH {32} \
CONFIG.C_PROBE_OUT6_WIDTH {32} \
CONFIG.C_PROBE_OUT5_WIDTH {32} \
CONFIG.C_PROBE_OUT4_WIDTH {32} \
CONFIG.C_PROBE_OUT3_WIDTH {32} \
CONFIG.C_PROBE_OUT2_WIDTH {32} \
CONFIG.C_PROBE_OUT1_WIDTH {32} \
CONFIG.C_PROBE_OUT0_WIDTH {32} \
CONFIG.C_NUM_PROBE_OUT {10} \
CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
CONFIG.C_NUM_PROBE_IN {0} \
] [get_bd_cells vio_0]

# Create instance: vio_1, and set properties
create_bd_cell -vlnv xilinx.com:ip:vio:3.0 -type IP vio_1

set_property -dict [list \
CONFIG.C_PROBE_OUT1_WIDTH {5} \
CONFIG.C_PROBE_OUT0_WIDTH {10} \
CONFIG.C_NUM_PROBE_OUT {2} \
CONFIG.C_EN_PROBE_IN_ACTIVITY {0} \
CONFIG.C_NUM_PROBE_IN {0} \
] [get_bd_cells vio_1]

# Create instance: xlconcat_0, and set properties
create_bd_cell -vlnv xilinx.com:ip:xlconcat:2.1 -type IP xlconcat_0

set_property -dict [list \
CONFIG.NUM_PORTS {10} \
] [get_bd_cells xlconcat_0]

# Create instance: debouncer_0
create_bd_cell -type module -reference debouncer debouncer_0

# Create instance: txpippm_controllers_0
create_bd_cell -type module -reference txpippm_controllers txpippm_controllers_0

# Create instance: gth_transceivers_buffer_0
create_bd_cell -vlnv ugent.be:user:gth_transceivers_buffer:1.0 -type IP gth_transceivers_buffer_0

# Create interface connections
connect_bd_intf_net [get_bd_intf_pins clk_wiz_0/CLK_IN1_D] [get_bd_intf_ports default_sysclk1_300]

# Create port connections
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins gth_transceivers_buffer_0/hb_gtwiz_reset_clk_freerun_in]

connect_bd_net [get_bd_pins vio_0/clk] [get_bd_pins gth_transceivers_buffer_0/gtwiz_userclk_tx_usrclk2_out]
connect_bd_net [get_bd_pins vio_0/probe_out9] [get_bd_pins xlconcat_0/In9]
connect_bd_net [get_bd_pins vio_0/probe_out8] [get_bd_pins xlconcat_0/In8]
connect_bd_net [get_bd_pins vio_0/probe_out7] [get_bd_pins xlconcat_0/In7]
connect_bd_net [get_bd_pins vio_0/probe_out6] [get_bd_pins xlconcat_0/In6]
connect_bd_net [get_bd_pins vio_0/probe_out5] [get_bd_pins xlconcat_0/In5]
connect_bd_net [get_bd_pins vio_0/probe_out4] [get_bd_pins xlconcat_0/In4]
connect_bd_net [get_bd_pins vio_0/probe_out3] [get_bd_pins xlconcat_0/In3]
connect_bd_net [get_bd_pins vio_0/probe_out2] [get_bd_pins xlconcat_0/In2]
connect_bd_net [get_bd_pins vio_0/probe_out1] [get_bd_pins xlconcat_0/In1]
connect_bd_net [get_bd_pins vio_0/probe_out0] [get_bd_pins xlconcat_0/In0]

connect_bd_net [get_bd_pins vio_1/clk] [get_bd_pins gth_transceivers_buffer_0/gtwiz_userclk_tx_usrclk_out]
connect_bd_net [get_bd_pins vio_1/probe_out1] [get_bd_pins txpippm_controllers_0/stepsize_in]
connect_bd_net [get_bd_pins vio_1/probe_out0] [get_bd_pins txpippm_controllers_0/sel_in]

connect_bd_net [get_bd_pins xlconcat_0/dout] [get_bd_pins gth_transceivers_buffer_0/gtwiz_userdata_tx_in]

connect_bd_net [get_bd_pins debouncer_0/clk] [get_bd_pins gth_transceivers_buffer_0/gtwiz_userclk_tx_usrclk_out]
connect_bd_net [get_bd_pins debouncer_0/reset] [get_bd_pins gth_transceivers_buffer_0/hb_gtwiz_reset_all_out]
connect_bd_net [get_bd_pins debouncer_0/button_in] [get_bd_ports gpio_sw_s] 
connect_bd_net [get_bd_pins debouncer_0/button_out] [get_bd_pins txpippm_controllers_0/pulse_in]

connect_bd_net [get_bd_pins txpippm_controllers_0/gtwiz_userclk_tx_usrclk_in] [get_bd_pins gth_transceivers_buffer_0/gtwiz_userclk_tx_usrclk_out]
connect_bd_net [get_bd_pins txpippm_controllers_0/gtwiz_userclk_tx_active_in] [get_bd_pins gth_transceivers_buffer_0/gtwiz_userclk_tx_active_out]
connect_bd_net [get_bd_pins txpippm_controllers_0/gtwiz_reset_all_in] [get_bd_pins gth_transceivers_buffer_0/hb_gtwiz_reset_all_out]
connect_bd_net [get_bd_pins txpippm_controllers_0/txpippmen_out] [get_bd_pins gth_transceivers_buffer_0/txpippmen_in]
connect_bd_net [get_bd_pins txpippm_controllers_0/txpippmovrden_out] [get_bd_pins gth_transceivers_buffer_0/txpippmovrden_in]
connect_bd_net [get_bd_pins txpippm_controllers_0/txpippmsel_out] [get_bd_pins gth_transceivers_buffer_0/txpippmsel_in]
connect_bd_net [get_bd_pins txpippm_controllers_0/txpippmpd_out] [get_bd_pins gth_transceivers_buffer_0/txpippmpd_in]
connect_bd_net [get_bd_pins txpippm_controllers_0/txpippmstepsize_out] [get_bd_pins gth_transceivers_buffer_0/txpippmstepsize_in]

connect_bd_net [get_bd_pins gth_transceivers_buffer_0/hb_gtwiz_reset_all_in] [get_bd_ports gpio_sw_c] 
connect_bd_net [get_bd_pins gth_transceivers_buffer_0/mgtrefclk0_x0y5_p] [get_bd_ports mgtrefclk0_x0y5_p]
connect_bd_net [get_bd_pins gth_transceivers_buffer_0/mgtrefclk0_x0y5_n] [get_bd_ports mgtrefclk0_x0y5_n]
connect_bd_net [get_bd_pins gth_transceivers_buffer_0/gthrxn_in] [get_bd_ports gthrxn]
connect_bd_net [get_bd_pins gth_transceivers_buffer_0/gthrxp_in] [get_bd_ports gthrxp]
connect_bd_net [get_bd_pins gth_transceivers_buffer_0/gthtxn_out] [get_bd_ports gthtxn]
connect_bd_net [get_bd_pins gth_transceivers_buffer_0/gthtxp_out] [get_bd_ports gthtxp]

validate_bd_design

save_bd_design

make_wrapper -top [get_files top.bd]

generate_target {synthesis implementation} [get_files top.bd]
