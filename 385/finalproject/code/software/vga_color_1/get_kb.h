/*
 * get_kb.h
 */

#ifndef GET_KB_H_
#define GET_KB_H_

#include <stdio.h>
#include "system.h"
#include "altera_avalon_spi.h"
#include "altera_avalon_spi_regs.h"
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include "usb_kb/GenericMacros.h"
#include "usb_kb/GenericTypeDefs.h"
#include "usb_kb/HID.h"
#include "usb_kb/MAX3421E.h"
#include "usb_kb/transfer.h"
#include "usb_kb/usb_ch9.h"
#include "usb_kb/USB.h"


#define KEY_W 0x1a
#define KEY_A 0x4
#define KEY_S 0x16
#define KEY_D 0x7
#define KEY_R 0x15


BYTE GetDriverandReport();
int get_keycode();

#endif /* GET_KB_H_ */
