module reset_synchronizer (
    input  wire clk_in,
    input  wire reset_in,
    output wire reset_out
);

    // Use 5 flip-flops as a single synchronizer, and tag each declaration with the appropriate synthesis attribute to
    // enable clustering. Each flip-flop in the synchronizer is asynchronously reset so that the downstream logic is also
    // asynchronously reset but encounters no reset assertion latency. The removal of reset is synchronous, so that the
    // downstream logic is also removed from reset synchronously. This module is designed for active-high reset use.

    (* ASYNC_REG = "TRUE" *)
    reg reset_in_meta  = 1'b0;
    (* ASYNC_REG = "TRUE" *)
    reg reset_in_sync1 = 1'b0;
    (* ASYNC_REG = "TRUE" *)
    reg reset_in_sync2 = 1'b0;
    (* ASYNC_REG = "TRUE" *)
    reg reset_in_sync3 = 1'b0;

    reg reset_in_out   = 1'b0;

    always @(posedge clk_in, posedge reset_in) 
        begin
            if (reset_in) begin
                reset_in_meta  <= 1'b1;
                reset_in_sync1 <= 1'b1;
                reset_in_sync2 <= 1'b1;
                reset_in_sync3 <= 1'b1;
                reset_in_out   <= 1'b1;
            end
            else begin
                reset_in_meta  <= 1'b0;
                reset_in_sync1 <= reset_in_meta;
                reset_in_sync2 <= reset_in_sync1;
                reset_in_sync3 <= reset_in_sync2;
                reset_in_out   <= reset_in_sync3;
            end
        end

    assign reset_out = reset_in_out;

endmodule
