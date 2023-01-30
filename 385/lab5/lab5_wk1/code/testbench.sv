module testbench();

timeunit 10ns;	

timeprecision 1ns;

logic [9:0] SW;
logic Clk, Run, Continue;
logic [9:0] LED;
logic [6:0] HEX0, HEX1, HEX2, HEX3;

slc3_testtop test (.*);

always begin : CLOCK_GENERATION
	#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

initial begin: TEST_FETCH
    // Reset Phase
    Run = 0;
    Continue = 0;    

    // Only Run is zero, starting transitioning
    #2 Continue = 1;
    
    // Deactivate run
	#2 Run = 1;
    
    // First continue
    #20 Continue = 0;
    #2 Continue = 1;

    // Second continue
    #20 Continue = 0;
    #2 Continue = 1;

    // Third continue
    #20 Continue = 0;
    #2 Continue = 1;
	
end
endmodule
	