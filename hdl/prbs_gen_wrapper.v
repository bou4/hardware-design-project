module prbs_gen_wrapper #(
    parameter size = 32,
    parameter length = 7,
    parameter [0 : length-1] primpoly = 0
) (
    input  wire gtwiz_userclk_tx_usrclk2_in,
    input  wire gtwiz_reset_all_in,
    output wire [size-1 : 0] data_out
);

    prbs_gen #(
        .size(size),
        .length(length),
        .primpoly(primpoly)
    ) prbs_gen_inst (gtwiz_userclk_tx_usrclk2_in, gtwiz_reset_all_in, data_out);    

endmodule

