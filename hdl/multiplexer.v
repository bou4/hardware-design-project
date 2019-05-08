module multiplexer #(parameter WIDTH = 32) (
    input  wire [WIDTH-1 : 0] a,
    input  wire [WIDTH-1 : 0] b,
    input  wire [WIDTH-1 : 0] c,
    input  wire [WIDTH-1 : 0] d,
    input  wire [1 : 0] sel,
    output reg  [WIDTH-1 : 0] result

);

    always @(a, b, c, d, sel)
        begin
            case (sel)
                2'b00: result <= a;
                2'b01: result <= b;
                2'b10: result <= c;
                2'b11: result <= d;
            endcase
        end

endmodule
