`timescale 1ns / 1ps

module add_2bit_tb;//a test bench does not have any ports of its own!

	/* Input nets */
	reg [1:0] A; //these are regs because they are modified in 
	reg [1:0] B; //a behavioral block

	/* Output nets */
	wire [1:0] Sum; //these are wires because they will be driven
	wire Carry;//by the inantiated module

	/* Instantiate the Unit Under Test (UUT) */
	adder_2bit uut ( //this is a different way
		.A(A),       //to instantiate a module.
		.B(B),       //the nice thing about this style
		.Sum(Sum),   //is that the order does not matter!
		.Carry(Carry)//notice the ports are in a different order!
	);


    /*-this is a behavioral block which is executed only once!  *
     *-the statements within this behavioral block are executed *
     *-sequentially because we are using blocking statements    *
     *-an '=' sign within a behavioral construct is considered a*
     * blocking statement. We will talk more about this later...*/
	initial 
      begin

        /* Initialize inputs*/
        A = 0;
        B = 0;

        #35; //just delay 25 ns  
        {A,B} = 4'b0000; 
        #35;
        if({Carry, Sum} != 3'b000)
            $display("!!!!! 4'b0000 FAILED !!!!! ");
		else
			$display("2-bit adder test 4'b0000 PASSED");
        
        {A,B} = 4'b0001; 
        #35;
        if({Carry, Sum} != 3'b001)
            $display("!!!!! 4'b0001 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b0001 PASSED");
            
        {A,B} = 4'b0010; 
        #35;
        if({Carry, Sum} != 3'b010)
            $display("!!!!! 4'b0010 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b0010 PASSED");
            
        {A,B} = 4'b0011; 
        #35;
        if({Carry, Sum} != 3'b011)
            $display("!!!!! 4'b0011 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b0011 PASSED");
  
        {A,B} = 4'b0100;
        #35;
        if({Carry, Sum} != 3'b001)
            $display("!!!!! 4'b0100 FAILED !!!!!");
		else
			$display("2-bit adder test 4'b0100 PASSED");
        
        {A,B} = 4'b0101; 
        #35;
        if({Carry, Sum} != 3'b010)
            $display("!!!!! 4'b0101 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b0101 PASSED");
            
        {A,B} = 4'b0111; 
        #35;
        if({Carry, Sum} != 3'b100)
            $display("!!!!! 4'b0111 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b0111 PASSED");
            
        {A,B} = 4'b1000; 
        #35;
        if({Carry, Sum} != 3'b010)
            $display("!!!!! 4'b1000 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b1000 PASSED");
        
        {A,B} = 4'b1001; 
        #35;
        if({Carry, Sum} != 3'b011)
            $display("!!!!! 4'b1001 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b1001 PASSED");
            
        {A,B} = 4'b1010; 
        #35;
        if({Carry, Sum} != 3'b100)
            $display("!!!!! 4'b1010 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b1010 PASSED");
            
        {A,B} = 4'b1011; 
        #35;
        if({Carry, Sum} != 3'b101)
            $display("!!!!! 4'b1011 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b1011 PASSED");
  
        {A,B} = 4'b1100; 
        #35;
        if({Carry, Sum} != 3'b011)
            $display("!!!!! 4'b1100 FAILED !!!!!");
		else
			$display("2-bit adder test 4'b1100 PASSED");
        
        {A,B} = 4'b1101; 
        #35;
        if({Carry, Sum} != 3'b100)
            $display("!!!!! 4'b1101 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b1101 PASSED");
            
        {A,B} = 4'b1111; 
        #35;
        if({Carry, Sum} != 3'b110)
            $display("!!!!! 4'b1111 FAILED !!!!!");
        else
            $display("2-bit adder test 4'b1111 PASSED");
        $stop;
	end
      
endmodule

