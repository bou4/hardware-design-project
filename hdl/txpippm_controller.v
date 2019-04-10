module txpippm_controller (
	input  wire enable_in,
	input  wire pulse_in,
	input  wire [5 : 0] stepsize_in,
	
	output wire tpippmen_out,
	output wire txpippmovrden_out,
	output wire txpippmsel_out,
	output wire txpippmpd_out,
	output wire [5 : 0] txpippmstepsize_out
);

endmodule;
