`timescale 1ns / 1ps
`default_nettype none

/* this module implements a structural Verilog 2-bit adder, using previously defined full_adder module */

module adder_2bit(Carry, Sum, A, B);
    input wire [1:0] A, B; // 2-bit inputs
    output wire [1:0] Sum; // 2-bit output
    output wire Carry; // 1-bit carry output
    
    wire C0; // inital carry from first full-adder
    
    full_adder S0(Sum[0], C0, A[0], B[0], 0); // intial carry is 0
    full_adder S1(Sum[1], Carry, A[1], B[1], C0); // input carry is from previous adder
endmodule
