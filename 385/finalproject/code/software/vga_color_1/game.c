#include "get_kb.h"
#include "sprite_draw.h"
#include "game.h"

struct game_state
{
	int level;
	enum Elements sprites[ROWS][COLUMNS];
	enum Elements first_sprites[ROWS][COLUMNS];
	enum Elements second_sprites[ROWS][COLUMNS];
	int char_x;
	int char_y;
	int hp;
	int atk;
	int gold;
	int key_y;
	int key_b;
};

int game_init_sprites[15][20] = {
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 18, 14, 22, 16, 0},
{0, 2, 12, 11, 11, 11, 3, 11, 11, 11, 11, 11, 11, 2, 0, 29, 26, 14, 26, 0},
{0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 11, 2, 0, 0, 0, 0, 0, 0},
{0, 2, 10, 11, 11, 7, 11, 2, 11, 11, 11, 2, 11, 2, 0, 0, 0, 0, 0, 0},
{0, 2, 11, 3, 11, 2, 11, 2, 11, 11, 11, 2, 11, 2, 0, 19, 0, 30, 28, 0},
{0, 2, 2, 7, 2, 2, 11, 2, 2, 2, 7, 2, 11, 2, 0, 14, 0, 30, 28, 0},
{0, 2, 11, 11, 11, 2, 11, 5, 11, 11, 11, 2, 11, 2, 0, 18, 0, 0, 28, 0},
{0, 2, 11, 11, 11, 2, 3, 2, 2, 2, 2, 2, 11, 2, 0, 0, 0, 0, 0, 0},
{0, 2, 2, 7, 2, 2, 11, 11, 11, 11, 11, 11, 11, 2, 0, 0, 0, 0, 0, 0},
{0, 2, 11, 11, 11, 2, 2, 7, 2, 2, 2, 7, 2, 2, 0, 20, 30, 0, 30, 0},
{0, 2, 11, 11, 11, 2, 11, 11, 11, 2, 11, 11, 11, 2, 0, 20, 31, 0, 28, 0},
{0, 2, 11, 11, 11, 2, 11, 1, 11, 2, 11, 11, 11, 2, 0, 0, 0, 0, 0, 0},
{0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
};

int game_init_sprites_2[15][20] = {
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 18, 14, 22, 16, 0},
{0, 2, 11, 11, 2, 11, 11, 11, 2, 11, 2, 11, 6, 2, 0, 29, 26, 14, 26, 0},
{0, 2, 11, 11, 2, 11, 13, 11, 2, 11, 7, 9, 11, 2, 0, 0, 0, 0, 0, 0},
{0, 2, 11, 10, 2, 11, 11, 11, 2, 11, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0},
{0, 2, 8, 2, 2, 2, 11, 2, 2, 11, 2, 11, 11, 2, 0, 19, 0, 30, 28, 0},
{0, 2, 11, 11, 11, 11, 11, 11, 4, 11, 11, 11, 5, 2, 0, 14, 0, 30, 28, 0},
{0, 2, 7, 2, 2, 11, 11, 11, 2, 11, 2, 2, 2, 2, 0, 18, 0, 0, 28, 0},
{0, 2, 11, 11, 2, 2, 11, 2, 2, 11, 2, 11, 10, 2, 0, 0, 0, 0, 0, 0},
{0, 2, 11, 11, 2, 11, 11, 11, 2, 11, 7, 11, 11, 2, 0, 0, 0, 0, 0, 0},
{0, 2, 11, 11, 2, 11, 11, 11, 2, 11, 2, 2, 2, 2, 0, 20, 30, 0, 30, 0},
{0, 2, 2, 2, 2, 2, 11, 2, 2, 11, 2, 11, 9, 2, 0, 20, 31, 0, 28, 0},
{0, 2, 12, 1, 11, 11, 11, 11, 2, 11, 7, 11, 11, 2, 0, 0, 0, 0, 0, 0},
{0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
};

int game_over[15][20] = {
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 18, 14, 22, 16, 0, 23, 27, 16, 25, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
};

void register_sprite(struct game_state* game_ptr, int x, int y){
	enum Elements sprite = game_ptr->sprites[y][x];
	drawSpriteAtLocation(sprite, x, y);
}

void update_num(struct game_state* game_ptr, int num, int y_t, int x_t, int y_o, int x_o){
	switch (num)
	{
	case 0:
		game_ptr -> sprites[y_t][x_t] = BLACK;
		game_ptr -> sprites[y_o][x_o] = NUM_0;
		break;
	case 1:
		game_ptr -> sprites[y_t][x_t] = BLACK;
		game_ptr -> sprites[y_o][x_o] = NUM_1;
		break;
	case 2:
		game_ptr -> sprites[y_t][x_t] = BLACK;
		game_ptr -> sprites[y_o][x_o] = NUM_2;
		break;
	case 5:
		game_ptr -> sprites[y_t][x_t] = BLACK;
		game_ptr -> sprites[y_o][x_o] = NUM_5;
		break;
	case 10:
		game_ptr -> sprites[y_t][x_t] = NUM_1;
		game_ptr -> sprites[y_o][x_o] = NUM_0;
		break;
	case 11:
		game_ptr -> sprites[y_t][x_t] = NUM_1;
		game_ptr -> sprites[y_o][x_o] = NUM_1;
		break;
	case 12:
		game_ptr -> sprites[y_t][x_t] = NUM_1;
		game_ptr -> sprites[y_o][x_o] = NUM_2;
		break;
	case 15:
		game_ptr -> sprites[y_t][x_t] = NUM_1;
		game_ptr -> sprites[y_o][x_o] = NUM_5;
		break;
	case 20:
		game_ptr -> sprites[y_t][x_t] = NUM_2;
		game_ptr -> sprites[y_o][x_o] = NUM_0;
		break;
	case 21:
		game_ptr -> sprites[y_t][x_t] = NUM_2;
		game_ptr -> sprites[y_o][x_o] = NUM_1;
		break;
	case 22:
		game_ptr -> sprites[y_t][x_t] = NUM_2;
		game_ptr -> sprites[y_o][x_o] = NUM_2;
		break;
	case 25:
		game_ptr -> sprites[y_t][x_t] = NUM_2;
		game_ptr -> sprites[y_o][x_o] = NUM_5;
		break;
	default:
		break;
	}
	register_sprite(game_ptr, x_t, y_t);
	register_sprite(game_ptr, x_o, y_o);

}

void update_key_y(struct game_state* game_ptr, int key_num){
	update_num(game_ptr, key_num, 10, 17, 10, 18);
}

void update_key_b(struct game_state* game_ptr, int key_num){
	update_num(game_ptr, key_num, 11, 17, 11, 18);
}

void update_hp(struct game_state* game_ptr, int hp_num){
	int x_o = 18;
	int y_o = 5;
	int x_t = 17;
	int y_t = 5;
	update_num(game_ptr, hp_num, y_t, x_t, y_o, x_o);
}

void update_atk(struct game_state* game_ptr, int atk_num){
	int x_o = 18;
	int y_o = 6;
	int x_t = 17;
	int y_t = 6;
	update_num(game_ptr, atk_num, y_t, x_t, y_o, x_o);
}

void update_gold(struct game_state* game_ptr, int atk_num){
	int x_o = 18;
	int y_o = 7;
	int x_t = 17;
	int y_t = 7;
	update_num(game_ptr, atk_num, y_t, x_t, y_o, x_o);

}

void initialize_game(struct game_state* game_ptr){
	game_ptr -> level = 1;
	game_ptr -> char_x = 7;
	game_ptr -> char_y = 12;
	game_ptr -> hp = 10;
	game_ptr -> atk = 10;
	game_ptr -> gold = 0;
	game_ptr -> key_y = 1;
	game_ptr -> key_b = 0;
	for (int x = 0; x < COLUMNS; ++x){
		for (int y = 0; y < ROWS; ++y){
			game_ptr -> sprites[y][x] = game_init_sprites[y][x];
    		register_sprite(game_ptr, x, y);
			game_ptr -> second_sprites[y][x] = game_init_sprites_2[y][x];
		}
	}
}

int game_play(){
	BYTE rcode;
	BOOT_MOUSE_REPORT buf;		//USB mouse report
	BOOT_KBD_REPORT kbdbuf;
	BYTE runningdebugflag = 0;//flag to dump out a bunch of information when we first get to USB_STATE_RUNNING
	BYTE errorflag = 0; //flag once we get an error device so we don't keep dumping out state info
	BYTE device;
	WORD keycode;
	printf("initializing MAX3421E...\n");
	MAX3421E_init();
	printf("initializing USB...\n");
	USB_init();

	//initialize palette
	for (int i = 0; i < 16; i++)
	{
		setColorPalette (i, colors[i].red, colors[i].green, colors[i].blue);
	}

	// initialize the game
	struct game_state game;
	initialize_game(&game);


	// main loop
    while(1){
        MAX3421E_Task();
		USB_Task();
		if (GetUsbTaskState() == USB_STATE_RUNNING) {
			if (!runningdebugflag) {
				runningdebugflag = 1;
				device = GetDriverandReport();
			} else if (device == 1) {
				//run keyboard debug polling
				rcode = kbdPoll(&kbdbuf);
				if (rcode == hrNAK) {
					continue; //NAK means no new data
				} else if (rcode) {
					printf("Rcode: ");
					printf("%x \n", rcode);
					continue;
				}
				printf("keycodes: ");
				for (int i = 0; i < 6; i++) {
					printf("%x ", kbdbuf.keycode[i]);
				}
				printf("\n");
                int key = kbdbuf.keycode[0];
				int intended_x;
				int intended_y;
				
                switch (key){
                    case KEY_W:
						intended_x = game.char_x;
						intended_y = game.char_y - 1;
                        break;
                    case KEY_A:
                        intended_x = game.char_x - 1;
                        intended_y = game.char_y;
                        break;
                    case KEY_S:
						intended_x = game.char_x;
                        intended_y = game.char_y + 1;
                        break;
                    case KEY_D:
                        intended_x = game.char_x + 1;
                        intended_y = game.char_y;
                        break;
					case KEY_R:
						initialize_game(&game);
						continue;
					default:
						intended_x = game.char_x;
						intended_y = game.char_y;
						break;
                }

				switch (game.sprites[intended_y][intended_x]){
					case BRAVER:
						break;
					case WALL:
						break;
					case MONSTER_G:
						game.sprites[game.char_y][game.char_x] = GROUND;
						register_sprite(&game, game.char_x, game.char_y);
						game.char_x = intended_x;
						game.char_y = intended_y;
						game.sprites[game.char_y][game.char_x] = BRAVER;
						register_sprite(&game, game.char_x, game.char_y);
						if (game.atk < 15) game.hp -= (15 - game.atk);
						if (game.hp < 0){
							initialize_game(&game);
							break;
						}
						else{
							update_hp(&game, game.hp);
						}
						printf("hp ok!");
						game.atk += 2;
						update_atk(&game, game.atk);
						printf("atk ok!");
						game.gold += 5;
						update_gold(&game, game.gold);
						break;
					case MONSTER_R:
						game.sprites[game.char_y][game.char_x] = GROUND;
						register_sprite(&game, game.char_x, game.char_y);
						game.char_x = intended_x;
						game.char_y = intended_y;
						game.sprites[game.char_y][game.char_x] = BRAVER;
						register_sprite(&game, game.char_x, game.char_y);
						if (game.atk < 15) game.hp -= (15 - game.atk);
						if (game.hp < 0){
							initialize_game(&game);
							break;
						}
						else{
							update_hp(&game, game.hp);
						}
						printf("hp ok!");
						game.atk += 3;
						update_atk(&game, game.atk);
						printf("atk ok!");
						game.gold += 5;
						update_gold(&game, game.gold);
						break;
					case KEY_Y:
						game.key_y += 1;
						game.sprites[game.char_y][game.char_x] = GROUND;
						register_sprite(&game, game.char_x, game.char_y);
						game.char_x = intended_x;
						game.char_y = intended_y;
						game.sprites[game.char_y][game.char_x] = BRAVER;
						register_sprite(&game, game.char_x, game.char_y);
						update_key_y(&game, game.key_y);
						break;
					case KEY_B:
						game.key_b += 1;
						game.sprites[game.char_y][game.char_x] = GROUND;
						register_sprite(&game, game.char_x, game.char_y);
						game.char_x = intended_x;
						game.char_y = intended_y;
						game.sprites[game.char_y][game.char_x] = BRAVER;
						register_sprite(&game, game.char_x, game.char_y);
						update_key_b(&game, game.key_b);
						break;
					case GROUND:
						game.sprites[game.char_y][game.char_x] = GROUND;
						register_sprite(&game, game.char_x, game.char_y);
						game.char_x = intended_x;
						game.char_y = intended_y;
						game.sprites[game.char_y][game.char_x] = BRAVER;
						register_sprite(&game, game.char_x, game.char_y);
						break;
					case DOOR_Y:
						if (game.key_y > 0){
							game.key_y -= 1;
							game.sprites[game.char_y][game.char_x] = GROUND;
							register_sprite(&game, game.char_x, game.char_y);
							game.char_x = intended_x;
							game.char_y = intended_y;
							game.sprites[game.char_y][game.char_x] = BRAVER;
							register_sprite(&game, game.char_x, game.char_y);
							update_key_y(&game, game.key_y);
							break;
						}
						else{
							break;
						}
					case DOOR_B:
						if (game.key_b > 0){
							game.key_b -= 1;
							game.sprites[game.char_y][game.char_x] = GROUND;
							register_sprite(&game, game.char_x, game.char_y);
							game.char_x = intended_x;
							game.char_y = intended_y;
							game.sprites[game.char_y][game.char_x] = BRAVER;
							register_sprite(&game, game.char_x, game.char_y);
							update_key_b(&game, game.key_b);
							break;
						}
						else{
							break;
						}

					case LOTION_R:
						game.hp = 10;
						game.sprites[game.char_y][game.char_x] = GROUND;
						register_sprite(&game, game.char_x, game.char_y);
						game.char_x = intended_x;
						game.char_y = intended_y;
						game.sprites[game.char_y][game.char_x] = BRAVER;
						register_sprite(&game, game.char_x, game.char_y);
						update_hp(&game, game.hp);
						break;
					case LOTION_B:
						game.atk += 10;
						game.sprites[game.char_y][game.char_x] = GROUND;
						register_sprite(&game, game.char_x, game.char_y);
						game.char_x = intended_x;
						game.char_y = intended_y;
						game.sprites[game.char_y][game.char_x] = BRAVER;
						register_sprite(&game, game.char_x, game.char_y);
						update_atk(&game, game.atk);
						break;
					case STAIRS:
						if (game.level == 1){
							for (int x = 0; x < COLUMNS; x++){
								for (int y = 0; y < ROWS; y++){
									game.first_sprites[y][x] = game.sprites[y][x];
									game.sprites[y][x] = game.second_sprites[y][x];
									register_sprite(&game, x, y);
								}
							}
							game.sprites[game.char_y][game.char_x] = GROUND;
							register_sprite(&game, game.char_x, game.char_y);
							game.level = 2;
							game.char_x = 3;
							game.char_y = 12;
							update_key_y(&game, game.key_y);
							update_key_b(&game, game.key_b);
							update_hp(&game, game.hp);
							update_atk(&game, game.atk);
							update_gold(&game, game.gold);
							break;
						}
						else if (game.level == 2){
							for (int x = 0; x < COLUMNS; x++){
								for (int y = 0; y < ROWS; y++){
									game.second_sprites[y][x] = game.sprites[y][x];
									game.sprites[y][x] = game.first_sprites[y][x];
									register_sprite(&game, x, y);
								}
							}
							game.sprites[game.char_y][game.char_x] = GROUND;
							register_sprite(&game, game.char_x, game.char_y);
							game.level = 1;
							game.char_x = 3;
							game.char_y = 2;
							register_sprite(&game, game.char_x, game.char_y);
							update_key_y(&game, game.key_y);
							update_key_b(&game, game.key_b);
							update_hp(&game, game.hp);
							update_atk(&game, game.atk);
							update_gold(&game, game.gold);
							break;
						}
						break;
					case MONSTER_S:
						game.sprites[game.char_y][game.char_x] = GROUND;
						register_sprite(&game, game.char_x, game.char_y);
						game.char_x = intended_x;
						game.char_y = intended_y;
						game.sprites[game.char_y][game.char_x] = BRAVER;
						register_sprite(&game, game.char_x, game.char_y);
						if (game.atk < 30) game.hp -= (30 - game.atk);
						if (game.hp < 0){
							for (int x = 0; x < COLUMNS; x++){
								for (int y = 0; y < ROWS; y++){
									game.sprites[y][x] = game_over[y][x];
									register_sprite(&game, x, y);
								}
							}
							usleep(100000);
							initialize_game(&game);
							break;
						}
						else{
							update_hp(&game, game.hp);
						}
						printf("hp ok!");
						game.atk += 10;
						update_atk(&game, game.atk);
						printf("atk ok!");
						game.gold += 15;
						update_gold(&game, game.gold);
						break;

					default:
						break;
				}

				// printf("\n");
			}
        }
    }
}
