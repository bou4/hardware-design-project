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

    reg txpippmen_int;

    localparam [1 : 0] state_pulse_low      = 2'b00;
    localparam [1 : 0] state_pulse_rising_0 = 2'b01;
    localparam [1 : 0] state_pulse_rising_1 = 2'b11;
    localparam [1 : 0] state_pulse_high     = 2'b10;

    reg [1 : 0] state_current_int;
    reg [1 : 0] state_next_int;

    always @(posedge gtwiz_userclk_tx_usrclk_in)
        begin
            if(reset_sync)
                begin
                    state_current_int <= state_pulse_low;
                end
            else
                begin
                    state_current_int <= state_next_int;
                end
        end

    always @(state_current_int, pulse_in)
        begin
            case ({state_current_int, pulse_in})
                {state_pulse_low, 1'b1}:
                    begin
                        state_next_int <= state_pulse_rising_0;
                    end
                {state_pulse_rising_0, 1'b0}, {state_pulse_rising_0, 1'b1}:
                    begin
                        state_next_int <= state_pulse_rising_1;
                    end
                {state_pulse_rising_1, 1'b0}, {state_pulse_rising_1, 1'b1}:
                    begin
                        state_next_int <= state_pulse_high;
                    end
                {state_pulse_high, 1'b0}:
                    begin
                        state_next_int <= state_pulse_low;
                    end
                default:
                    begin
                        state_next_int <= state_current_int;
                    end
            endcase
        end

    always @(state_current_int)
        begin
            case (state_current_int)
                state_pulse_low:
                    begin
                        txpippmen_int <= 1'b0;
                    end
                state_pulse_rising_0:
                    begin
                        txpippmen_int <= 1'b1;
                    end
                state_pulse_rising_1:
                    begin
                        txpippmen_int <= 1'b1;
                    end
                state_pulse_high:
                    begin
                        txpippmen_int <= 1'b0;
                    end
            endcase
        end

    assign txpippmen_out       = {CHANNEL_COUNT {txpippmen_int}} & sel_in;
    // Normal operation
    assign txpippmovrden_out   = {CHANNEL_COUNT {1'b0}};
    // Use the TX phase interpolator PPM controller
    assign txpippmsel_out      = {CHANNEL_COUNT {1'b1}};
    // Do not power down the TX phase interpolator PPM controller
    assign txpippmpd_out       = {CHANNEL_COUNT {1'b0}};

    assign txpippmstepsize_out = {CHANNEL_COUNT {stepsize_in}};

endmodule
