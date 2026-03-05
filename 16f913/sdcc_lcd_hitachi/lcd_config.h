/* 
 * File:   newfile.h
 * Author: dan
 *
 * Created on 20 lutego 2026, 13:01
 */

#ifndef LCD_CONFIG_H
#define	LCD_CONFIG_H

#define NO_BIT_DEFINES
#include <pic14/pic16regs.h>
#include <pic14/pic16fam.h>
#include "ecu_config.h"

#ifdef	__cplusplus
extern "C" {
#endif



#define LCD_HD4478_4BIT
#define LCD_POSITION_4_BIT_HIGH
#define LCD_PORT_DATA   PORTC
#define LCD_PORT_TRIS_DATA   TRISC
    
#define LCD_PORT_TRIS_E   TRISBbits
#define LCD_PORT_E         PORTBbits
#define LCD_PORT_E_BIT     B2


#define LCD_PORT_RW        PORTBbits
#define LCD_PORT_RW_BIT     B1
#define LCD_PORT_TRIS_RW   TRISBbits

#define LCD_PORT_RS        PORTBbits
#define LCD_PORT_RS_BIT     B0
#define LCD_PORT_TRIS_RS   TRISBbits
    
#define LCD_HD4478_RW_USAGE

extern void delay_proc_44ms(void);

#define DELAY_MS(x)     delay_proc_44ms()
#define NOP_FUNC       __asm \
nop \
__endasm 

    
#ifdef	__cplusplus
}
#endif

#endif	/* LCD_CONFIG_H */

