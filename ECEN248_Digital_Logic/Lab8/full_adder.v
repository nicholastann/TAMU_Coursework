`timescale 1ns / 1ps
`default_nettype none
/* This module describes the gate-level model of a full adder in Verilog */

module full_adder(S, Cout, A, B, Cin);

    /* declare output and input ports */
    // 1-bit wires
    input wire A, B, Cin; // 1-bit wires
    
    output wire S, Cout;
    
    /* use dataflow to describe the gate-level activity */
    assign #6 S = A ^ B ^ Cin;
    assign #12 Cout = (A ^ B) & Cin | (A & B);
    
endmodule