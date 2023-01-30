module datapath (input logic            Clk, Reset,
                 input logic            GatePC, GateMDR, GateALU, GateMARMUX,
                 input logic            LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
                 input logic            MIO_EN, SR1MUX, SR2MUX, ADDR1MUX, DRMUX,
                 input logic [1:0]      ADDR2MUX, PCMUX, ALUK,
                 input logic [15:0]     MDR_In,
                 output logic [15:0]    MAR, MDR, IR,
                 output logic [9:0]     LED,
                 output logic           BEN);

    logic [15:0] bus, PC, ALU, PC_Add;
	logic [15:0] SR1, SR2;

    PC_Module PC_module (.Clk, .Reset, .LD_PC, .bus, .PC_Add, .PCMUX, .Data_Out(PC));
    PC_Addr_Adder_Module PC_addr_adder_module(.IR, .PC, .SR1, .ADDR1MUX, .ADDR2MUX, .PC_Add);
    Reg_16 RegMAR (.Clk, .Reset, .Load(LD_MAR), .Data_In(bus), .Data_Out(MAR));
    MDR_Module MDR_module (.Clk, .Reset, .LD_MDR, .MIO_EN, .bus, .MDR_In, .MDR);
    Reg_16 RegIR (.Clk, .Reset, .Load(LD_IR), .Data_In(bus), .Data_Out(IR));
    Reg_File reg_file(.Clk, .Reset, .LD_REG, .DRMUX, .SR1MUX, .IR, .Data(bus), .SR1_o(SR1), .SR2_o(SR2));
    ALU_Module ALU_module(.IR, .SR1, .SR2, .ALUK, .SR2MUX_sel(SR2MUX), .ALU_o(ALU));
    Condition_Module condition_module(.Clk, .Reset, .LD_CC, .LD_BEN, .bus, .IR, .BEN_o(BEN));
    LED_Module LED_module(.LD_LED, .IR, .LED);

    always_comb begin
        if (GatePC == 1'b1) bus = PC;
        else if (GateMDR == 1'b1) bus = MDR;
        else if (GateALU == 1'b1) bus = ALU;
        else if (GateMARMUX == 1'b1) bus = PC_Add;
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


module Reg_1 (input  logic Clk, Reset, Load,
              input  logic Data_In,
              output logic Data_Out);

    always_ff @ (posedge Clk)
    begin
		if (Reset) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			Data_Out <= 1'h0;
		else if (Load)
			Data_Out <= Data_In;
    end
endmodule


module PC_Module (input logic           Clk, Reset, LD_PC,
                  input logic [15:0]    bus, PC_Add,
                  input logic [1:0]     PCMUX,
                  output logic [15:0]   Data_Out);
    
    logic [15:0] Data_In;
    logic Load;
    assign Load = LD_PC;

    Reg_16 RegPC (.Clk, .Reset, .Load, .Data_In, .Data_Out);

    always_comb begin
        if (PCMUX == 2'b00) Data_In = Data_Out + 1;
        else if (PCMUX == 2'b01) Data_In = PC_Add;
        else if (PCMUX == 2'b10) Data_In = bus;
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


module ALU_Module (input [15:0] IR, SR1, SR2,
                   input [1:0]	ALUK,
                   input SR2MUX_sel,
                   output logic [15:0] ALU_o);
			
	logic [15:0] B;
	
	always_comb begin
		if (SR2MUX_sel == 1'b1)
			B = {{11{IR[4]}}, IR[4:0]};
		else
			B = SR2;
		
		unique case	(ALUK)
			2'b00 :	ALU_o = SR1 + B;
			2'b01 :	ALU_o = SR1 & B;
			2'b10 :	ALU_o = ~SR1;
			2'b11 :	ALU_o = SR1;
		endcase
	end
	
endmodule


module PC_Addr_Adder_Module (input [15:0] IR, PC, SR1,
                             input ADDR1MUX,
                             input [1:0] ADDR2MUX,
                             output logic [15:0] PC_Add);

	logic [15:0] operand1, operand2;
	
	always_comb begin
		unique case (ADDR1MUX)
			1'b0 : operand2 = PC;
			1'b1 : operand2 = SR1;
		endcase

		unique case	(ADDR2MUX)
			2'b00 :	operand1 = 16'h0000;
			2'b01 :	operand1 = {{10{IR[5]}}, IR[5:0]};
			2'b10 :	operand1 = {{7{IR[8]}}, IR[8:0]};
			2'b11 :	operand1 = {{5{IR[10]}}, IR[10:0]};
		endcase
		
		PC_Add = operand1 + operand2;
	end
endmodule


module Reg_File (input Clk, Reset, LD_REG, DRMUX, SR1MUX,
                 input [15:0] IR, Data,
                 output logic [15:0] SR1_o, SR2_o);
	
    logic [7:0] Load;
	logic [15:0] Registers_o [7:0];
	logic [2:0] SR1, SR2, DR;
	Reg_16 Registers [7:0] (.Clk, .Reset, .Load, .Data_In(Data), .Data_Out(Registers_o));
	assign SR2 = IR[2:0];


	always_comb begin
		if (LD_REG) 
			begin
				unique case (DR)
					3'b000	: 	Load = 8'h01;
					3'b001	: 	Load = 8'h02;
					3'b010	: 	Load = 8'h04;
					3'b011	: 	Load = 8'h08;
					3'b100	: 	Load = 8'h10;
					3'b101	: 	Load = 8'h20;
					3'b110	: 	Load = 8'h40;
					3'b111	: 	Load = 8'h80;		
				endcase
			end
		else	
			Load = 8'h00;

		if (SR1MUX == 1'b1) SR1 = IR[8:6];
		else SR1 = IR[11:9];
		
		if (DRMUX == 1'b1) DR = 3'b111;
		else DR = IR[11:9];
		
        SR1_o = Registers_o[SR1];
        SR2_o = Registers_o[SR2];

	end

endmodule


module Condition_Module (input logic Clk, Reset, LD_CC, LD_BEN,
                         input logic [15:0] bus, IR,
                         output logic BEN_o);

	Reg_1 RegBEN (.Clk, .Reset, .Load(LD_BEN), .Data_In(BEN), .Data_Out(BEN_o));
	Reg_1 RegNZP [2:0] (.Clk, .Reset, .Load(LD_CC), .Data_In(nzp), .Data_Out(nzp_o));
    logic [2:0] nzp, nzp_o;
    logic BEN;
	
	always_comb begin
		if (bus == 16'h0000) nzp = 3'b010;
		else if (bus[15] == 1'b0) nzp = 3'b001;
		else nzp = 3'b100;
		BEN = (nzp_o[2] & IR[11]) | (nzp_o[1] & IR[10]) | (nzp_o[0] & IR[9]);
	end
endmodule


module LED_Module (input LD_LED,
                   input [15:0] IR,
                   output logic [9:0] LED);

	always_comb begin
        LED = 10'h000;
		if (LD_LED == 1'b1) LED = IR[9:0];
	end
endmodule
