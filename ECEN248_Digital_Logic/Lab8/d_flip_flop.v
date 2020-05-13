`timescale 1ns / 1ps
`default_nettype none

module d_flip_flop(Q, notQ, Clk, D);
    
    /* all ports are wires */
    output wire Q, notQ; // outputs of slave latch
    input wire Clk, D;
    
    /* internal nets */
    wire notClk, notNotClk;
    wire Q_m; // output of master latch
    wire notQ_m; // notQ_m will be wired to the d_latch but left unconnected
    
    /* structural level wiring */
    d_latch dlatch0(Q_m, notQ_m, notClk, D);
    d_latch dlatch1(Q, notQ, notNotClk, Q_m);
    
    /* ensure that clock is defined according to schematic */
    assign notClk = ~Clk;
    assign notNotClk = ~(~Clk);
    
endmodule
