

create_clock -period 5.000 -name clk [get_ports clk]


set_property PACKAGE_PIN N11 [get_ports clk]
set_property PACKAGE_PIN T2 [get_ports rst]
set_property PACKAGE_PIN L5 [get_ports {leds_out[0]}]
set_property PACKAGE_PIN L4 [get_ports {leds_out[1]}]
set_property PACKAGE_PIN M4 [get_ports {leds_out[2]}]
set_property PACKAGE_PIN N3 [get_ports {leds_out[3]}]
set_property PACKAGE_PIN N2 [get_ports {leds_out[4]}]
set_property PACKAGE_PIN M2 [get_ports {leds_out[5]}]
set_property PACKAGE_PIN N1 [get_ports {leds_out[6]}]
set_property PACKAGE_PIN M1 [get_ports {leds_out[7]}]



set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports {leds_out[*]}]
