module txpippm_controller (
    input  wire sel_in,
    input  wire pulse_in,
    input  wire [5-1 : 0] stepsize_in,
    // TXUSRCLK input
    input  wire gtwiz_userclk_tx_usrclk_in,
    input  wire gtwiz_userclk_tx_active_in,
    // User-provided ports for reset helper block(s) (free-running clock domain)
    input  wire gtwiz_reset_all_in,
    // TX phase interpolator PPM controller (async)
    output wire txpippmen_out,
    output wire txpippmovrden_out,
    output wire txpippmsel_out,
    output wire txpippmpd_out,
    output wire [5-1 : 0] txpippmstepsize_out
);

    wire reset_int = gtwiz_reset_all_in || ~gtwiz_userclk_tx_active_in;

    wire reset_sync;

    (* DONT_TOUCH = "TRUE" *)
    reset_synchronizer reset_synchronizer_reset_inst (
        .clk_in    (gtwiz_userclk_tx_usrclk_in),
        .reset_in  (reset_int                 ),
        .reset_out (reset_sync                )
    );

    // TODO: Implement state machine

    // Normal operation
    assign txpippmovrden_out   = 1'b0;
    // Use the TX phase interpolator PPM controller
    assign txpippmsel_out      = 1'b1;
    // Do not power down the TX phase interpolator PPM controller
    assign txpippmpd_out       = 1'b0;

    assign txpippmstepsize_out = stepsize_in;

endmodule
