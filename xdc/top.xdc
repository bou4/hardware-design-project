# Differential reference clock inputs
set_property PACKAGE_PIN R8 [get_ports mgtrefclk0_x0y5_n]
set_property PACKAGE_PIN R9 [get_ports mgtrefclk0_x0y5_p]

create_clock -name clk_mgtrefclk0_x0y5_p -period 8.0 [get_ports mgtrefclk0_x0y5_p]

# Directional push buttons
set_property PACKAGE_PIN D9 [get_ports gpio_sw_s]
set_property IOSTANDARD LVCMOS12 [get_ports gpio_sw_s]

set_property PACKAGE_PIN AW27 [get_ports gpio_sw_c]
set_property IOSTANDARD LVCMOS12 [get_ports gpio_sw_c]
