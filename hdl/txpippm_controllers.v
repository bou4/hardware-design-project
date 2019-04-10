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

    genvar channel_index;

    generate for(channel_index = 0; channel_index < CHANNEL_COUNT; channel_index = channel_index+1)
        begin : generate_txpippm_controller

            txpippm_controller txpippm_controller_inst (
                .sel_in                     (sel_in              [(channel_index+1)*1-1 : (channel_index)*1]),
                .pulse_in                   (pulse_in                                                       ),
                .stepsize_in                (stepsize_in                                                    ),
                .gtwiz_userclk_tx_usrclk_in (gtwiz_userclk_tx_usrclk_in                                     ),
                .gtwiz_userclk_tx_active_in (gtwiz_userclk_tx_active_in                                     ),
                .gtwiz_reset_all_in         (gtwiz_reset_all_in                                             ),
                .txpippmen_out              (txpippmen_out       [(channel_index+1)*1-1 : (channel_index)*1]),
                .txpippmovrden_out          (txpippmovrden_out   [(channel_index+1)*1-1 : (channel_index)*1]),
                .txpippmsel_out             (txpippmsel_out      [(channel_index+1)*1-1 : (channel_index)*1]),
                .txpippmpd_out              (txpippmpd_out       [(channel_index+1)*1-1 : (channel_index)*1]),
                .txpippmstepsize_out        (txpippmstepsize_out [(channel_index+1)*5-1 : (channel_index)*5])
            );

        end
    endgenerate

endmodule
