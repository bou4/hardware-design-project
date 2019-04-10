module bit_synchronizer #(parameter INITIALIZE = 5'b00000) (
    input  wire clk_in,
    input  wire bit_in,
    output wire bit_out
);

    // Use 5 flip-flops as a single synchronizer, and tag each declaration with the appropriate synthesis attribute to
    // enable clustering. Their GSR default values are provided by the INITIALIZE parameter.

    (* ASYNC_REG = "TRUE" *)
    reg bit_in_meta  = INITIALIZE[0];
    (* ASYNC_REG = "TRUE" *)
    reg bit_in_sync1 = INITIALIZE[1];
    (* ASYNC_REG = "TRUE" *)
    reg bit_in_sync2 = INITIALIZE[2];
    (* ASYNC_REG = "TRUE" *)
    reg bit_in_sync3 = INITIALIZE[3];

    reg bit_in_out   = INITIALIZE[4];

    always @(posedge clk_in) begin
        bit_in_meta  <= bit_in;
        bit_in_sync1 <= bit_in_meta;
        bit_in_sync2 <= bit_in_sync1;
        bit_in_sync3 <= bit_in_sync2;
        bit_in_out   <= bit_in_sync3;
    end

    assign bit_out = bit_in_out;

endmodule
