How it works

This project implements a 4-bit Universal Shift Register (USR) in Verilog.
The register can:

Hold its current state (S1S0=00)

Shift Right (S1S0=01) → the serial right input (SR) enters the MSB

Shift Left (S1S0=10) → the serial left input (SL) enters the LSB

Parallel Load (S1S0=11) → the 4-bit input D[3:0] is loaded directly into the register

The current register state is always visible on the 4 output pins Q[3:0].

The design uses the global Tiny Tapeout signals:

clk (rising-edge triggered)

rst_n (active-low reset, clears the register to 0000)

ena (operations only occur when high)

How to test

Reset the register: drive rst_n = 0 for at least one clock, then release it (rst_n = 1).

Select mode using ui_in[1:0] (S1:S0):

00 → Hold

01 → Shift Right

10 → Shift Left

11 → Parallel Load

Provide data:

ui_in[7:4] = D[3:0] (parallel load input)

ui_in[2] = SL (serial left input)

ui_in[3] = SR (serial right input)

Observe outputs:

uo_out[3:0] = Q[3:0] (register contents)

✅ Example:

To load 1011 into the register: set ui_in = 8'b1011_1100 (D=1011, S1S0=11), then clock once → outputs show 1011.

Next clock with S1S0=01 and SR=1 shifts right, inserting a 1 at MSB.

This behavior can be tested in simulation with cocotb (test_usr.py), which already drives sequences and checks the outputs.

External hardware

No external hardware is required.
The register’s outputs (Q[3:0]) can optionally be connected to LEDs for a visible demo, or to other digital logic for use as a shift register inside a larger design
