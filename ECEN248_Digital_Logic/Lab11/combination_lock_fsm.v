`timescale 1ns / 1ps
`default_nettype none

/* This module describes the combination-lock
 * FSM discussed in the prelab using behavioral Verilog */
module combination_lock_fsm(
    output reg [1:0] state,
    output wire [3:0] Lock, // asserted when locked
    input wire Key1, // unlock button 0
    input wire Key2, // unlock button 1
    input wire [3:0] Password, // indicate number
    input wire Reset, // reset
    input wire Clk // clock
);

    parameter S0 = 2'b00;
    parameter S1 = 2'b01;
    parameter S2 = 2'b10;
    parameter S3 = 2'b11;
     
    reg [2:0] nextState;

    always@ (*)  
        case(state)
            S0: begin
                if (Password == 4'b1101 && Key1) // if switches 1, 2, and 4 ON
                    nextState = S1;				 // go to next state (S1)
                else
                    nextState = S0; // otherwise, stay in current
                end
            S1: begin
                if (Password == 4'b0111 && Key2) // if switches 2, 3, and 4 ON
                    nextState = S2;              // go to next state (S2)
                else
                    nextState = S0; // otherwise, reset
                end
            S2: begin
                if (Password == 4'b1001 && Key1) // if switches 2, 3, and 4 ON
                    nextState = S3;              // go to next state (S3)
                else                              
                    nextState = S0; // otherwise, reset
                end
            S3: begin
                if (Reset) // final state checks only for reset condition
                    nextState = S0;
                else
                    nextState = S3; // otherwise, continue in S3
                end
        endcase
        
        always@ (po