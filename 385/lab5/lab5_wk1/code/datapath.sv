module datapath (input logic            Clk, Reset,
                 input logic            GatePC, GateMDR, GateMARMUX,
                 input logic            LD_MAR, LD_PC, LD_MDR, LD_IR,
                 input logic            MIO_EN, 
                 input logic [1:0]      PCMUX,
                 input logic [15:0]     MDR_In,
                 output logic [15:0]    MAR, MDR, IR);

    logic [15:0] bus, PC;

    PC_Module PC_module (.Clk, .Reset, .LD_PC, .bus, .PCMUX, .Data_Out(PC));
    Reg_16 RegMAR (.Clk, .Reset, .Load(LD_MAR), .Data_In(bus), .Data_Out(MAR));
    MDR_Module MDR_module (.Clk, .Reset, .LD_MDR, .MIO_EN, .bus, .MDR_In, .MDR);
    Reg_16 RegIR (.Clk, .Reset, .Load(LD_IR), .Data_In(bus), .Data_Out(IR));

    always_comb begin
        if (GatePC == 1'b1) bus = PC;
        else if (GateMDR == 1'b1) bus = MDR;
        else bus = 16'bX;
    end

endmodule


module Reg_16 (input  logic         Clk, Reset, Load,
               input  logic [15:0]  Data_In,
               output logic [15:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
		if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			Data_Out <= 16'h0;
		else if (Load)
			Data_Out <= Data_In;
    end
endmodule


module PC_Module (input logic           Clk, Reset, LD_PC,
                  input logic [15:0]    bus, // for week 1 we don't need PC from bus
                  input logic [1:0]     PCMUX,
                  output logic [15:0]   Data_Out);
    
    logic [15:0] Data_In;
    logic Load;
    assign Load = LD_PC;

    Reg_16 RegPC (.Clk, .Reset, .Load, .Data_In, .Data_Out);

    always_comb begin
        if (PCMUX == 2'b00) Data_In = Data_Out + 1;
        // we will only use the PC <- PC + 1 case, othewise we will just do nothing
        else Data_In = Data_Out;
    end

endmodule


module MDR_Module (input logic Clk, Reset, LD_MDR, MIO_EN,
                   input logic [15:0] bus, MDR_In,
                   output logic [15:0] MDR);
    
    logic [15:0] Data_In;
    logic Load;
    assign Load = LD_MDR;

    Reg_16 RegPC (.Clk, .Reset, .Load, .Data_In, .Data_Out(MDR));

    always_comb begin
        if (MIO_EN == 1'b1) Data_In = MDR_In;
        else Data_In = bus;
    end
endmodule


