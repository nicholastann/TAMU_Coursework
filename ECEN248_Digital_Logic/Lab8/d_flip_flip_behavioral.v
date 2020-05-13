`timescale 1ns / 1ps
`default_nettype none

/* Verilog behavioral model of a flip-flop without enable.
   The lab FPGA prefers this sort of storage element over the D-latch */
   
module d_flip_flip_behavioral(
    output reg Q,
    output wire notQ,
    input wire D,
    input wire Clk // clock is trigger signal     
);

    /* describe behavior of D flip-flop */
    always@ (posedge Clk) // trigger edge is the positive (rising) edge
        Q <= D; // non-blocking assignment
        
    assign notQ = ~Q; // obvious
    
endmodule
