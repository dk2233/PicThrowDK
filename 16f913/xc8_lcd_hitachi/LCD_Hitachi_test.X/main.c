/*
 * File:   main.c
 * Author: dan
 *
 * Created on 20 lutego 2026, 12:08
 */
#pragma config WDTE=OFF

#include <xc.h>
#include "init.h"



#include "Lcdhd4478_Driver/lcd_hd4478.h"


void main(void) {
    lcdhd4478_configuration_t lcd_config = {.lcd_is_8bit = 1, .lcd_2_number_line = 1, .lcd_5_10_fonts = 0, .lcd_blinking_on = 1, .lcd_cursor_view_on = 0, .lcd_entry_display_shift_on = 0, .lcd_entry_set_increment_on = 1}; 
    
    pic16f_init();
    
    lcdhd4478_init(lcd_config);
    
    lcdhd4478_display_clear();
    
    lcdhd4478_write("test text");
    
    while(1);
    
    return;
}
