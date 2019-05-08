module prbs_gen(clk, reset, dout);
    parameter size = 8;
    parameter length = 7;

    // dec2bin(primpoly(length,'min','nodisplay')) or Xilinx app note XAPP052 or http://en.wikipedia.org/wiki/Linear_feedback_shift_register    
    parameter [0:length-1] primpoly = 0;

    input clk;
    input reset;

    output reg [size-1:0] dout;

    reg [length-1:0] lfsr;

    genvar c;
    generate
        for (c = 0; c < size; c = c+1) begin
            always @(posedge clk or posedge reset) begin
                if(reset) 
                    dout[c] <= 0;
                else
                    dout[c] <= ^(mask_gen(c) & lfsr);
            end
        end
    endgenerate

    generate
        for (c = 0; c< length; c = c+1) begin
            always @(posedge clk or posedge reset) begin
                if(reset) begin
                    lfsr[c] <= 1'b1;
                end
                else
                    lfsr[c] <= ^(mask_gen(size+c) & lfsr);
            end
        end
    endgenerate

    function automatic logic [length-1:0] mask_gen;
        input integer c;
        integer i;
        logic [length-1:0] temp;
        begin
            temp = 0;
            if(c < length) begin
                temp = 1'b1 << (c);
            end
            else begin
                for(i=0; i< length; i = i +1) begin             
                    if(primpoly[i] == 1) begin
                        temp = temp ^ mask_gen(c-length + i);
                    end
                end
            end
            mask_gen = temp;
        end
    endfunction

endmodule

