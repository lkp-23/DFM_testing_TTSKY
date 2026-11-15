/*
 * 8-bit counter for Tiny Tapeout
 *  ui_in[0]  = count enable (1 = count up each clock)
 *  ui_in[1]  = load (1 = load value from uio_in on next clock)
 *  uio_in    = value to load
 *  uo_out    = current count
 */
`default_nettype none

module tt_um_counter (
    input  wire [7:0] ui_in,    // dedicated inputs
    output wire [7:0] uo_out,   // dedicated outputs
    input  wire [7:0] uio_in,   // bidirectional pins: input path
    output wire [7:0] uio_out,  // bidirectional pins: output path
    output wire [7:0] uio_oe,   // bidirectional pins: output enable (1 = output)
    input  wire       ena,      // high when the design is selected
    input  wire       clk,      // clock
    input  wire       rst_n     // active-low reset
);

    reg [7:0] count;

    always @(posedge clk) begin
        if (!rst_n)
            count <= 8'd0;
        else if (ui_in[1])
            count <= uio_in;
        else if (ui_in[0])
            count <= count + 8'd1;
    end

    assign uo_out  = count;
    assign uio_out = 8'b0;   // bidirectional pins not driven
    assign uio_oe  = 8'b0;   // all bidirectional pins used as inputs

    // Mark unused inputs so the tools don't warn
    wire _unused = &{ena, ui_in[7:2], 1'b0};

endmodule
