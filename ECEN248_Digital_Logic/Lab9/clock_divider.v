`timescale 1ns / 1ps
`default_nettype none

/* This module will demonstrate the concept of clock frequency.
   It uses behavioral Verilog and a simple counter. */
   
module clock_divider(ClkOut, ClkIn);
    /* output port needs to be a reg because it will drive
       with a behavioral statement */
    output wire [3:0] ClkOut;
    input wire ClkIn; // wires can drive regs
    
    // parameters can be changed at compile time
    parameter n = 5; // count 5-bits for now
    
    reg [n-1:0] Count; // count bit width is based on n
    
    // simple behavioral construct to describe a counter
    always@ (posedge ClkIn)
        Count <= Count + 1;
    
    assign ClkOut[3:0] = Count[n-1 : n-4];
    
endmodule
