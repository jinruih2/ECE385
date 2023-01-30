/*
 * ECE385-HelperTools/PNG-To-Txt
 * Author: Rishi Thakkar
 *
 */

module  frameROM
(
		input [14:0] read_address, // index 32 sprites, each 1024 addresses
		// input Clk,
		output logic [3:0] data_Out
);

// mem has width of 4 bits and a total of 2**15 (32k) addresses
// because we need 4 bits for the palette index of each of the 32*32 pixel per sprite
// and we plan to use 32 sprites.

logic [3:0] mem [0:2**15-1];

initial
begin
	$readmemh("sprite_bytes/new_all.txt", mem);
end

assign data_Out = mem[read_address];


endmodule
