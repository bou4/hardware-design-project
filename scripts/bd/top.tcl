################################################################
# CREATE BLOCK DESIGN
################################################################
create_bd_design -dir $bdDir top

# Create interface ports
## Differential system clock inputs
create_bd_intf_port -vlnv xilinx.com:interface:diff_clock_rtl:1.0 -mode Slave default_sysclk1_300

## LEDs
create_bd_intf_port -vlnv xilinx.com:interface:gpio_rtl:1.0 -mode Master led_8bits

## Directional push buttons
create_bd_intf_port -vlnv xilinx.com:interface:gpio_rtl:1.0 -mode Master push_buttons_5bits

## 4-pole DIP switch
create_bd_intf_port -vlnv xilinx.com:interface:gpio_rtl:1.0 -mode Master dip_switches_4bits

# Create ports
## Differential reference clock inputs
create_bd_port -dir I mgtrefclk0_x0y5_p
create_bd_port -dir I mgtrefclk0_x0y5_n

## Serial data ports
create_bd_port -from 9 -to 0 -dir I gthrxn
create_bd_port -from 9 -to 0 -dir I gthrxp
create_bd_port -from 9 -to 0 -dir O gthtxn
create_bd_port -from 9 -to 0 -dir O gthtxp

# Create instance: clk_wiz_0, and set properties
set clk_wiz_0 [ create_bd_cell -vlnv xilinx.com:ip:clk_wiz:6.0 -type IP clk_wiz_0 ]

set_property -dict [list \
CONFIG.CLK_IN1_BOARD_INTERFACE {default_sysclk1_300} \
CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
CONFIG.USE_BOARD_FLOW {true} \
CONFIG.USE_LOCKED {false} \
CONFIG.USE_RESET {false} \
] [get_bd_cells clk_wiz_0]

# Create instance: gth_transceivers_buffer_0
create_bd_cell -vlnv ugent.be:user:gth_transceivers_buffer:1.0 -type IP gth_transceivers_buffer_0

# Create instance: txpippm_controller_0
create_bd_cell -type module -reference txpippm_controller txpippm_controller_0

# Create interface connections
connect_bd_intf_net [get_bd_intf_ports default_sysclk1_300] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]	

# Create port connections
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins gth_transceivers_buffer_0/hb_gtwiz_reset_clk_freerun_in]

connect_bd_net [get_bd_ports mgtrefclk0_x0y5_p] [get_bd_pins gth_transceivers_buffer_0/mgtrefclk0_x0y5_p]
connect_bd_net [get_bd_ports mgtrefclk0_x0y5_n] [get_bd_pins gth_transceivers_buffer_0/mgtrefclk0_x0y5_n]

connect_bd_net [get_bd_ports gthrxn] [get_bd_pins gth_transceivers_buffer_0/gthrxn_in]
connect_bd_net [get_bd_ports gthrxp] [get_bd_pins gth_transceivers_buffer_0/gthrxp_in]
connect_bd_net [get_bd_ports gthtxn] [get_bd_pins gth_transceivers_buffer_0/gthtxn_out]
connect_bd_net [get_bd_ports gthtxp] [get_bd_pins gth_transceivers_buffer_0/gthtxp_out]

validate_bd_design

save_bd_design
