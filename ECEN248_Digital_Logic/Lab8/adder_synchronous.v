`timescale 1ns / 1ps
`default_nettype none

/* This module is a synchronous adder using n-bit registers (flip-flops) */
module adder_synchronous(Carry_reg, Sum_reg, Clk, A, B);
    /* Output ports are registers, since they need to hold state */
    output reg Carry_reg;
    output reg [1:0] Sum_reg;
    
    /* Inputs are still wires */
    input wire Clk;
    input wire [1:0] A, B;
    
    /* intermediate nests */
    reg [1:0] A_reg, B_reg; // connect to 2-bit registers
    wire Carry; // need this to connect to the registers later
    wire [1:0] Sum;
    
    /* 2-bit adder is instantiated */
    adder_2bit a2b(Carry, Sum, A_reg, B_reg);
    
    /* this block describes two 2-bit registers */
    
    /* inputs */
    always@ (posedge Clk) // trigger on pos edge
        begin
            A_reg <= A; // non-block assignments, concurrent
            B_reg <= B;
        end
    
    /* outputs */
    always@ (posedge Clk)
        begin
            Carry_reg <= Carry; // wires can drive registers
            Sum_reg <= Sum; // same statement, different bit-width
        end
endmodule
