module bit_synchronizers #(parameter WIDTH = 1) (
    input  wire clk_in,
    input  wire [WIDTH-1 : 0] bits_in,
    output wire [WIDTH-1 : 0] bits_out
);

    genvar index;

    generate for(index = 0; index < WIDTH; index = index+1)
    begin : generate_bit_synchronizer

        bit_synchronizer bit_synchronizer_inst (
            .clk_in  (clk_in                  ),
            .bit_in  (bits_in  [index : index]),
            .bit_out (bits_out [index : index])
        );

    end
    endgenerate

endmodule
