# Clock constraints for clocks provided as inputs to the core
# Note: the IP core-level XDC constrains clocks produced by the core, which drive user clocks via helper blocks
# ----------------------------------------------------------------------------------------------------------------------
create_clock -name clk_freerun -period 10.0 [get_ports hb_gtwiz_reset_clk_freerun_in]
create_clock -name clk_mgtrefclk0_x0y5_p -period 8.0 [get_ports mgtrefclk0_x0y5_p]

