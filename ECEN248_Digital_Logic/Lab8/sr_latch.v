`timescale 1ns / 1ps
`default_nettype none

/* Using structural Verilog and built-in gate-level primitive,
 * construct the SR latch described in lab */

module sr_latch(Q, notQ, En, S, R);
    
    output wire Q, notQ;
    input wire En, S, R;
    
    /* intermediate nests */
    wire nandSEN, nandREN;
    
    // delay
    nand #2 nand0(Q, nandSEN, notQ); // 2ns delay
    nand #2 nand1(notQ, nandREN, Q);

    // assign intermediate wires
    assign nandSEN = ~(S & En);
    assign nandREN = ~(R & En); 
endmodule
