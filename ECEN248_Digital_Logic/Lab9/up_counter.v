`timescale 1ns / 1ps
`default_nettype none

/* This module descibes a simple 3-bit up-counter using
   half-adder modules built into previous step */

module up_counter(Count, Carry2, En, Clk, Rst);
    // count output needs to be a reg
    output reg [2:0] Count;
    output wire Carry2;
    input wire En, Clk, Rst;
    
    // intermediate nests
    wire [2:0] Carry, Sum;
    
    Threebit_counter UC1(Sum, Carry2, Count, En);
    
    always@ (posedge Clk or posedge Rst)
        if (Rst) // if Rst == 1`b1
            Count <= 0; // reset count
        else
            Count <= Sum;
endmodule

module Threebit_counter(Sum, Carry2, Count, En);
    input wire En;
    input wire [2:0] Count;
    output wire [2:0] Sum;
    output wire Carry2;
    wire [2:0] Carry;
    
    // S, Cout, A, B
    half_adder ha0(Sum[0], Carry[0], En, Count[0]);
    half_adder ha1(Sum[1], Carry[1], Carry[0], Count[1]);
    half_adder ha2(Sum[2], Carry[2], Carry[1], Count[2]);
    
    assign Carry2 = Carry[2];
    
endmodule    