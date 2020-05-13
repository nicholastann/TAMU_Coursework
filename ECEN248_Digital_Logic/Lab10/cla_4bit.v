`timescale 1ns / 1ps
`default_nettype none

module generate_propagate_unit(G, P, X, Y);
    output wire [15:0] G, P;
    input wire [15:0] X, Y;
    
    assign G = X & Y;
    assign P = X ^ Y;
endmodule

module carry_lookahead_unit(C, G, P, C0);
    output wire [4:1] C;
    input wire [3:0] G, P;
    input wire C0;
    
    assign C[1] = G[0] | P[0] & C0;
    assign C[2] = G[1] | P[1] & G[0] | P[1] & P[0] & C0;
    assign C[3] = G[2] | P[2] & G[1] | P[2] & P[1] & G[0] | P[2] & P[1] & P[0] & C0;
    assign C[4] = G[3] | P[3] & G[2] | P[3] & P[2] & G[1] | P[3] & P[2] & P[1] & G[0] | P[3] & P[2] & P[1] & P[0] & C0;
endmodule

module summation_unit(S, P, C);
    output wire [15:0] S;
    input wire [15:0] P, C;
    
    assign S = P ^ C;
endmodule

module carry_lookahead_4bit(Cout, S, X, Y, Cin);
    output wire Cout;
    output wire [3:0] S;
    input wire [3:0] X, Y;
    input wire Cin;
    
    wire [3:0] G, P;
    wire [4:0] C;
    
    assign C[0] = Cin;
    
    generate_propagate_unit gp0(G, P, X, Y);
    carry_lookahead_unit cl0(C[4:1], G, P, Cin);
    summation_unit s0(S, P, C[3:0]);
    
    assign Cout = C[4];
endmodule
