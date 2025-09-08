`default_nettype none
`timescale 1ns / 1ps

// 4-bit Universal Shift Register (Tiny Tapeout template)
// ui_in mapping:
//   ui_in[0] = S0 (mode select LSB)
//   ui_in[1] = S1 (mode select MSB)
//   ui_in[2] = SL (serial-left input -> enters LSB on shift-left)
//   ui_in[3] = SR (serial-right input -> enters MSB on shift-right)
//   ui_in[7:4] = D[3:0] (parallel load data, D3=MSB)
// uo_out mapping:
//   uo_out[3:0] = Q[3:0] (register state), uo_out[7:4] = 0
//
// Modes (S1 S0):
//   00 = HOLD
//   01 = SHIFT RIGHT (SR -> Q3)
//   10 = SHIFT LEFT  (SL -> Q0)
//   11 = PARALLEL LOAD D[3:0]
//
// Reset: active-low synchronous via rst_n
// Enable: when ena=1, operations occur on rising edge of clk

module tt_um_universal_shift_register (
`ifdef GL_TEST
    // Power pins for gate-level sims (matched by tb.v)
    input  wire VPWR,
    input  wire VGND,
`endif

    // Tiny Tapeout standard I/O
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: input path (unused)
    output wire [7:0] uio_out,  // IOs: output path (unused)
    output wire [7:0] uio_oe,   // IOs: output enable (0=input, 1=output) (unused)

    input  wire clk,            // clock
    input  wire rst_n,          // reset (active low)
    input  wire ena             // enable
);

    // Decode control/data from ui_in
    wire S0 = ui_in[0];
    wire S1 = ui_in[1];
    wire SL = ui_in[2];
    wire SR = ui_in[3];
    wire [3:0] D = ui_in[7:4];  // D[3] is MSB

    // 4-bit state register
    reg [3:0] Q;

    // Synchronous active-low reset, gated by ena
    always @(posedge clk) begin
        if (!rst_n) begin
            Q <= 4'b0000;
        end else if (ena) begin
            case ({S1, S0})
                2'b00: Q <= Q;                 // HOLD
                2'b01: Q <= {SR, Q[3:1]};      // SHIFT RIGHT (SR -> Q3)
                2'b10: Q <= {Q[2:0], SL};      // SHIFT LEFT  (SL -> Q0)
                2'b11: Q <= D;                 // PARALLEL LOAD
                default: Q <= Q;
            endcase
        end
    end

    // Drive outputs: Q on [3:0], rest zeros
    assign uo_out[3:0] = Q;
    assign uo_out[7:4] = 4'b0000;

    // No bidirectional IOs used
    assign uio_out = 8'b0000_0000;
    assign uio_oe  = 8'b0000_0000;

endmodule

`default_nettype wire
