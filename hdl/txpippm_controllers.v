module txpippm_controllers #(parameter integer CHANNEL_COUNT = 10) (
    input  wire [(CHANNEL_COUNT*1)-1 : 0] sel_in,
    input  wire pulse_in,
    input  wire [5-1 : 0] stepsize_in,
    // TXUSRCLK input
    input  wire gtwiz_userclk_tx_usrclk_in,
    input  wire gtwiz_userclk_tx_active_in,
    // User-provided ports for reset helper block(s) (free-running clock domain)
    input  wire gtwiz_reset_all_in,
    // TX phase interpolator PPM controller (async)
    output wire [(CHANNEL_COUNT*1)-1 : 0] txpippmen_out,
    output wire [(CHANNEL_COUNT*1)-1 : 0] txpippmovrden_out,
    output wire [(CHANNEL_COUNT*1)-1 : 0] txpippmsel_out,
    output wire [(CHANNEL_COUNT*1)-1 : 0] txpippmpd_out,
    output wire [(CHANNEL_COUNT*5)-1 : 0] txpippmstepsize_out
);

    wire reset_int = gtwiz_reset_all_in || ~gtwiz_userclk_tx_active_in;

    wire reset_sync;

    (* DONT_TOUCH = "TRUE" *)
    reset_synchronizer reset_synchronizer_reset_inst (
        .clk_in    (gtwiz_userclk_tx_usrclk_in),
        .reset_in  (reset_int                 ),
        .reset_out (reset_sync                )
    );

    wire txpippmen_int;

    // TODO: Implement state machine


    assign txpippmen_out       = {CHANNEL_COUNT {txpippmen_int}} & sel_in;
    // Normal operation
    assign txpippmovrden_out   = {CHANNEL_COUNT {1'b0}};
    // Use the TX phase interpolator PPM controller
    assign txpippmsel_out      = {CHANNEL_COUNT {1'b1}};
    // Do not power down the TX phase interpolator PPM controller
    assign txpippmpd_out       = {CHANNEL_COUNT {1'b0}};

    assign txpippmstepsize_out = {CHANNEL_COUNT {stepsize_in}};  

endmodule
