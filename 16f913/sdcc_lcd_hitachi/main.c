/*
 * File:   main.c
 * Author: dan
 *
 * Created on 20 lutego 2026, 12:08
 */
#define NO_BIT_DEFINES

#include <pic14/pic16regs.h>
#include <pic14/pic16fam.h>
#include "init.h"
#include "ecu_config.h"
#include <stdint.h>
#include "lcd_hd4478.h"

static __code uint16_t __at (_CONFIG) configword1 = _WDT_OFF & _MCLRE_ON & _DEBUG_ON & _IESO_OFF  & _FOSC_INTOSCIO & _FCMEN_OFF & _PWRTE_ON & _BOREN_OFF;

void main(void) {
    lcdhd4478_configuration_t lcd_config = { .lcd_2_number_line = 1, .lcd_5_10_fonts = 0, .lcd_blinking_on = 1, .lcd_cursor_view_on = 0, .lcd_entry_display_shift_on = 0, .lcd_entry_set_increment_on = 1}; 
    
    pic16f_init();
    
    lcdhd4478_init(&lcd_config);
    
    lcdhd4478_display_clear();
    
    lcdhd4478_set_DDRAM_addres(lcd_address_first_line);

    lcdhd4478_set_DDRAM_addres(lcd_address_second_line);

    //lcdhd4478_set_CGRAM_addres(0);

    lcdhd4478_set_DDRAM_addres(lcd_address_first_line);
    
    char * tab = "test\0";
    lcdhd4478_write(tab);

    lcdhd4478_set_DDRAM_addres(lcd_address_second_line);

    lcdhd4478_write("aa aa! \0");

    
    
    while(1)
    {

    }
    
}
