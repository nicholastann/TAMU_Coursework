`timescale 1ns / 1ps
`default_nettype none

/* Using structural Verilog and built-in gate-level primitive,
 * construct the D latch described in lab */

module d_latch(Q, notQ, En, D);
    input wire D, En; // only 2 inputs for the D-latch
    output wire Q, notQ; // 2 outputs, Q, and ~Q
    
    // intermediate wires after initial gates
    wire nandEnD, nandEnDnot;
    
    // delay
    nand #2 nand0(Q, nandEnD, notQ);
    nand #2 nand1(notQ, nandEnDnot, Q);
    
    // D and ~D are NAND with En, assign wires
    assign nandEnD = ~(En & D);
    assign nandEnDnot = ~(En & ~D);
endmodule
