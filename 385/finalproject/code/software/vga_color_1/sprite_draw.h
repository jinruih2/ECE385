#ifndef SPRITE_DRAW_H_
#define SPRITE_DRAW_H_

#define COLUMNS 20
#define ROWS 15

#include <system.h>
#include <alt_types.h>

struct TEXT_VGA_STRUCT {
	alt_u32 VRAM [ROWS*COLUMNS/4]; // 75 addresses 
	//modify this by adding const bytes to skip to palette, or manually compute palette
	const alt_u32 PLACE_HOLDER [53]; // so COLOR points to 128
	alt_u32 COLOR [8];
};

struct COLOR{
	char name [20];
	alt_u8 red;
	alt_u8 green;
	alt_u8 blue;
};


//you may have to change this line depending on your platform designer
static volatile struct TEXT_VGA_STRUCT* vga_ctrl = 0x00004000;

//CGA colors with names
static struct COLOR colors[]={
	{"color0", 0x0, 0x0, 0x0},
	{"color1", 0xf, 0xf, 0xf},
	{"color2", 0x4, 0x4, 0x4},
	{"color3", 0x6, 0x6, 0x6},
	{"color4", 0xc, 0xc, 0xc},
	{"color5", 0xd, 0x6, 0x6},
	{"color6", 0xf, 0x8, 0x8},
	{"color7", 0x9, 0x6, 0x4},
	{"color8", 0x7, 0x4, 0x2},
	{"color9", 0xd, 0xa, 0x8},
	{"color10", 0xf, 0x6, 0x0},
	{"color11", 0xa, 0xc, 0xa},
	{"color12", 0xc, 0xe, 0xc},
	{"color13", 0x9, 0xf, 0xf},
	{"color14", 0x8, 0x8, 0xb},
	{"color15", 0xc, 0xc, 0xf}
};



void textVGAColorClr();
void textVGADrawColorText(char* str, int x, int y, alt_u8 background, alt_u8 foreground);
void setColorPalette (alt_u8 color, alt_u8 red, alt_u8 green, alt_u8 blue); //Fill in this code

void groundTest();


#endif /* SPRITE_DRAW_H_ */
