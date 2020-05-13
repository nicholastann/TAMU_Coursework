`timescale 1ns / 1ps
`default_nettype none

module top_level(LEDs, SWs, BTNs, FastClk);
  output wire [3:0] LEDs;
  input wire FastClk;
  input wire [1:0] BTNs;
  input wire [1:0] SWs;
  wire [3:0] Clocks;
  wire [2:0] Count;
  wire Carry2;
  reg SlowClk;
  
  always@(*)
    case(SWs)
	   2'b00:SlowClk=Clocks[0];
		2'b01:SlowClk=Clocks[1];
		2'b10:SlowClk=Clocks[2];
		2'b11:SlowClk=Clocks[3];
	 endcase
	
 up_counter counter(Count, Carry2, BTNs[0], SlowClk, BTNs[1]);
 
 assign LEDs[0]=Count[0];
 assign LEDs[1]=Count[1];
 assign LEDs[2]=Count[2];
 assign LEDs[3]=Carry2;
 
 clock_divider clk_div0(
    .ClkOut(Clocks),
	 .ClkIn(FastClk)
	);
	
endmodule