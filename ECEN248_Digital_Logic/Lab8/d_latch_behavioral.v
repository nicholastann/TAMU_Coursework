`timescale 1ns / 1ps // specify 1ns for each delay unit
`default_nettype none

/* Verilog behavioral model of a D-latch */

// Note: the Zybo FPGA from lab will not work with this code!
//       This code describes asynchronous behavior! FPGA implements synchronous

module d_latch_behavioral(
    output reg Q, // Q is driven with a behavioral statement
    output wire notQ, // dataflow
    input wire D, En // wires can drive regs
);

    /* behavior of D-latch described */
    always@ (En or D)
        if (En) // if En ~= 1'b0
            Q = D; // transparent
        else
            D = Q; // pedantic
   
    assign notQ = ~Q; // registers can drive wires

endmodule