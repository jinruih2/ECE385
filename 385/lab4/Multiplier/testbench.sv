module testbench();

timeunit 10ns;
			
timeprecision 1ns;

logic Clk = 0;
logic Reset_Load_Clear, Run;
logic [7:0] Din, Aval, Bval, ans_a, ans_b;
logic Xval;
logic [6:0] HexAUout, HexALout, HexBUout, HexBLout;

integer ErrorCnt = 0;

Multiplier multiplier(.*);

always begin CLK_GEN:
	#1 Clk = ~Clk;
end


initial begin CLK_INIT:
    Clk = 1;
end 

initial begin TESTCASES:


    // -59 * 7 = -413
    Reset_Load_Clear = 0;
	Din = 8'hc5; // -59d, 11000101b
    #2 Reset_Load_Clear = 1;
	#10 Din = 8'h07; // 7, 00000111b
	#2 Run = 0;
	#2 Run = 1;
    // FE63h = 1111 1110 0110 0011b = -413
	ans_a = 8'hfe;
	ans_b = 8'h63;
    #40 if (!((Aval == ans_a) & (Bval == ans_b)))
		ErrorCnt++;


    // 7 * 59 = 413
    #40 Reset_Load_Clear = 0;
	Din = 8'h07; // 7d, 00000111b
    #2 Reset_Load_Clear = 1;
	#10 Din = 8'h3b; // 59d, 00111011b
	#2 Run = 0;
	#2 Run = 1;
    // 019Dh = 0000 0001 1001 1101b = 413
	ans_a = 8'h01; 
	ans_b = 8'h9d;
    #40 if (!((Aval == ans_a) & (Bval == ans_b)))
		ErrorCnt++;


    // -7 * -59 = 413
    #40 Reset_Load_Clear = 0;
	Din = 8'hf9; // -7d, 11111001b
    #2 Reset_Load_Clear = 1;
	#10 Din = 8'hc5; // -59d, 11000101b
	#2 Run = 0;
	#2 Run = 1;
    // 019Dh = 0000 0001 1001 1101b = 413
	ans_a = 8'h01;
	ans_b = 8'h9d;
    #40 if (!((Aval == ans_a) & (Bval == ans_b)))
		ErrorCnt++;


    // -7 * 59 = -413
    #40 Reset_Load_Clear = 0;
	Din = 8'hf9; // -7, 11111001b
    #2 Reset_Load_Clear = 1;
	#10 Din = 8'h3b; // 59, 00111011b
	#2 Run = 0;
	#2 Run = 1;
    // FE63h = 1111 1110 0110 0011b = -413
	ans_a = 8'hfe;
	ans_b = 8'h63;
    #40 if (!((Aval == ans_a) & (Bval == ans_b)))
		ErrorCnt++;

end

endmodule
