/************************************************************************
Avalon-MM Interface VGA Text mode display

Register Map:
0x000-0x257 : VRAM, 80x30 (2400 byte, 600 word) raster order (first column then row)
0x258        : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

IVn = Draw inverse glyph
CODEn = Glyph code from IBM codepage 437

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]

VSYNC signal = bit which flips on every Vsync (time for new frame), used to synchronize software
BKG_R/G/B = Background color, flipped with foreground when IVn bit is set
FGD_R/G/B = Foreground color, flipped with background when Inv bit is set

************************************************************************/

module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,					// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input  logic [7:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0]  red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs						// VGA HS/VS
);

logic [31:0] Palette [8]; // Palelttes
logic [7:0] vram_addr;
logic [31:0] readout_buffer;
logic [31:0] mem_readout, buffer_readout;
logic mem_write, mem_read;
assign mem_write = AVL_WRITE & ~AVL_ADDR[7] & AVL_CS;
assign mem_read = AVL_READ & AVL_CS & ~AVL_ADDR[7];

VRAM vram0 (.clock(CLK), .pixel_clk(pixel_clk), .readout_addr(vram_addr), .AVL_ADDR(AVL_ADDR[6:0]), 
				.DATAWRITE(AVL_WRITEDATA), .AVL_WREN(mem_write), .AVL_REN(mem_read), .AVL_BYTE_EN(AVL_BYTE_EN), 
				 .DATAREAD(mem_readout), .readout_data(readout_buffer));

always_ff @ (posedge CLK) begin
	if (RESET)
		Palette <= '{default:32'b0};

	else if (AVL_CS) begin
		if (AVL_READ & AVL_ADDR[7])
			buffer_readout <= Palette[AVL_ADDR[2:0]];
	
		else if (AVL_WRITE & AVL_ADDR[7]) begin
			unique case (AVL_BYTE_EN)
				4'b1111	:	Palette[AVL_ADDR[2:0]] <= AVL_WRITEDATA;
				4'b1100	:	Palette[AVL_ADDR[2:0]][31:16] <= AVL_WRITEDATA[31:16];
				4'b0011	:	Palette[AVL_ADDR[2:0]][15:0] <= AVL_WRITEDATA[15:0];
				4'b1000	:	Palette[AVL_ADDR[2:0]][31:24] <= AVL_WRITEDATA[31:24];
				4'b0100	:	Palette[AVL_ADDR[2:0]][23:16] <= AVL_WRITEDATA[23:16];
				4'b0010	:	Palette[AVL_ADDR[2:0]][15:8] <= AVL_WRITEDATA[15:8];
				4'b0001	:	Palette[AVL_ADDR[2:0]][7:0] <= AVL_WRITEDATA[7:0];
				default	: ;
			endcase 
		end
	end
end
				 
always_comb begin
	if (AVL_CS & AVL_READ) begin
		if (mem_read)
			AVL_READDATA = mem_readout;
		else
			AVL_READDATA = buffer_readout;
	end
	else 
		AVL_READDATA = 32'hX;
end				 

//put other local variables here
logic [9:0] DrawX, DrawY;
logic pixel_clk, blank, sync;
// logic [18:0] font_addr;
logic [14:0] frame_addr;
logic [3:0] data;

//Declare submodules..e.g. VGA controller, ROMS, etc
vga_controller vga0 (.Clk(CLK), .Reset(RESET), .pixel_clk(pixel_clk), .blank(blank), .sync(sync), .hs(hs), .vs(vs), .DrawX(DrawX), .DrawY(DrawY)); 
// font_rom fonts (.addr(font_addr), .data(data));
frameROM frames (.read_address(frame_addr), .data_Out(data));

// Read and write from AVL interface to register block, note that READ waitstate = 1, so this should be in always_ff

logic [8:0] xchunk, ychunk;
logic [4:0] xoffset;
logic [4:0] yoffset;
logic [8:0] chunkidx;
//logic [9:0] vramidx;
logic [7:0] sprite_idx;
logic [1:0] vramoffset;

logic pixel, inv;
logic [9:0] delayed_offset1, delayed_xoffset1, delayed_yoffset1;
//logic [9:0] delayed_offset2, delayed_xoffset2, delayed_yoffset2;
logic [3:0] color_R, color_G, color_B;
//enum logic [1:0] {setaddr, waitclock, read}
//handle drawing (may either be combinational or sequential - or both).
always_comb begin
	xchunk = DrawX >> 5;
	ychunk = DrawY >> 5;
	chunkidx = ychunk * 20 + xchunk;
end

always_ff @ (posedge pixel_clk) begin
	vram_addr <= chunkidx >> 2;
	
	delayed_offset1 <= chunkidx[1:0];
//	delayed_offset2 <= delayed_offset1;
	vramoffset <= delayed_offset1;
	
	delayed_xoffset1 <= DrawX[4:0];
	delayed_yoffset1 <= DrawY[4:0];
	
	xoffset <= delayed_xoffset1;
//	delayed_xoffset2 <= delayed_xoffset1;
	yoffset <= delayed_yoffset1;
//	delayed_yoffset2 <= delayed_yoffset1;
end

always_comb begin
	unique case (vramoffset)
		2'b00: 
			sprite_idx = readout_buffer[7:0];
		2'b01: 
			sprite_idx = readout_buffer[15:8];
		2'b10: 
			sprite_idx = readout_buffer[23:16];
		2'b11: 
			sprite_idx = readout_buffer[31:24];
	endcase
	frame_addr = sprite_idx * 1024 + yoffset * 32 + xoffset;
	if (data[0] == 1) begin
		color_R = Palette[data[3:1]][24:21];
		color_G = Palette[data[3:1]][20:17];
		color_B = Palette[data[3:1]][16:13];
	end
	else begin
		color_R = Palette[data[3:1]][12:9];
		color_G = Palette[data[3:1]][8:5];
		color_B = Palette[data[3:1]][4:1];
	end
end

always_ff @ (posedge pixel_clk) begin
	if (~blank) begin
		red <= 4'h0;
		green <= 4'h0;
		blue <= 4'h0;
	end
	else if (DrawX <= 1) begin
		red <= 4'h0;
		green <= 4'h0;
		blue <= 4'h0;
	end
	else begin
		begin
			red <= color_R;
			green <= color_G;
			blue <= color_B;
		end
	end
end

endmodule
