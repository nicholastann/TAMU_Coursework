`timescale 1ns / 1ps

`define sec1     50000000
`define sec3    150000000
`define sec15   750000000
`define sec30  1500000000

module tlc_fsm(
    output reg [2:0] state, // output for debugging
    output reg RstCount, // use an always block
    output reg [1:0] highwaySignal, farmSignal,
    input wire [30:0] Count, // use n
    input wire Clk, Rst // clock and reset
);
    
    /* declare different states */
    parameter S0 = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              S4 = 3'b100,
              S5 = 3'b101;

    parameter green = 2'b11,
              yellow = 2'b10,
              red = 2'b00;
    
    reg [2:0] nextState;

    always@ (state or Count)
        case (state)
            // state 1
            S0: begin
                if (Count == `sec1) // if we reached 1 second
                begin
                    highwaySignal = red; // results of state 1
                    farmSignal = red;
                    RstCount = 1;
                    nextState = S1;
                end
                else
                begin
                    highwaySignal = red; // otherwise, stay
                    farmSignal = red;
                    RstCount = +1;
                    nextState = S0;
                end
            end
            // state 2
            S1: begin
                if(Count == `sec30)	// if reached 30 seconds
                begin
                    highwaySignal = green; // results of state 2
                    farmSignal = red;       
                    RstCount = 1;
                    nextState = S2;
                end
                else
                begin
                    highwaySignal = green; // otherwise, stay
                    farmSignal = red;
                    RstCount = +1;
                    nextState = S1;
                end
            end
           // state 3
           S2: begin
                if(Count == `sec3)	 // if reached 3 seconds
                begin
                    highwaySignal = yellow; // results of state 3
                    farmSignal = red;  
                    RstCount = 1;
                    nextState = S3;
                end
                else
                begin
                    highwaySignal = yellow; // otherwise, stay
                    farmSignal = red;
                    RstCount = +1;
                    nextState = S2;
                end
            end
            S3: begin
                if(Count == `sec1)	
                begin
                    highwaySignal = red;
                    farmSignal = red;  
                    RstCount = 1;
                    nextState = S4;
                end
                else
                begin
                    highwaySignal = red;
                    farmSignal = red;
                    RstCount = +1;
                    nextState = S3;
                end
            end
            S4: begin
                if(Count == `sec15)	
                begin
                    highwaySignal = red;
                    farmSignal = green;  
                    RstCount = 1;
                    nextState = S5;
                end
                else
                begin
                    highwaySignal = red;
                    farmSignal = green;
                    RstCount = +1;
                    nextState = S4;
                end
            end
            S5: begin
                if(Count == `sec3)	
                begin
                    highwaySignal = red;
                    farmSignal = yellow;  
                    RstCount = 1;
                    nextState = S0;
                end
                else
                begin
                    highwaySignal = red;
                    farmSignal = yellow;
                    RstCount = +1;
                    nextState = S5;
                end
            end
        endcase

    always@ (posedge Clk)
        if(Rst)
            state <= S0;
        else
            state <= nextState;
    
    
endmodule
