//8-bit multiplier top level module
//for use with ECE 385 Fall 2022


//Always use input/output logic types when possible, prevents issues with tools that have strict type enforcement

module Multiplier (input logic  Clk,      // Internal
                                Reset_Load_Clear,     // KEY0, another name is ClearXA_LoadB
                                Run,      // KEY1
                   input  logic [7:0]  Din,     // input data
                   output logic [6:0]  HexAUout, HexALout, HexBUout, HexBLout,      // output LED displays
                   output logic [7:0]  Aval, Bval,    // 8 bit registers
                   output logic Xval      // 1 bit register X
                   );

      logic Reset_Load_Clear_, Run_;
      logic Shift_XAB, Add, Sub, Clear, Load;
      logic X, M, A_last;
      logic [7:0] Partial;

      assign Reset_Load_Clear_ = ~Reset_Load_Clear;
      assign Run_ = ~Run;
      assign M = Bval[0];
      assign Load = Add | Sub;


	reg_8 RegA (.Clk(Clk),
                  .Reset(Clear),
                  .Shift_In(Xval),
                  .Load(Load),
                  .Shift_En(Shift_XAB), 
                  .D(Partial),
                  .Shift_Out(A_last),
                  .Data_Out(Aval));

	reg_8 RegB (.Clk(Clk),
                  .Reset(),
                  .Shift_In(A_last),
                  .Load(Reset_Load_Clear_),
                  .Shift_En(Shift_XAB), 
                  .D(Din),
                  .Shift_Out(),
                  .Data_Out(Bval));

	reg_1 RegX (.Clk(Clk), 
                  .Reset(Clear), 
                  .Shift_In(X), 
                  .Load(Load),
                  .Shift_Out(Xval));
	
      control Control (.Reset_Load_Clear(Reset_Load_Clear_), .Run(Run_), .*);

      Add_Sub_9 add_sub_9 (.A({Aval[7], Aval}), .B({Din[7], Din}), .S({X, Partial}), .Add, .Sub, .cout());
	HexDriver   HexAU(.In0(Aval[7:4]), .Out0(HexAUout));
	HexDriver   HexAL(.In0(Aval[3:0]), .Out0(HexALout));
	HexDriver   HexBU(.In0(Bval[7:4]), .Out0(HexBUout));
	HexDriver   HexBL(.In0(Bval[3:0]), .Out0(HexBLout));


endmodule
