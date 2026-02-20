/* 
 * File:   lcd_hd4478.h
 * Author: dan
 *
 * Created on 20 lutego 2026, 13:01
 */

#ifndef LCD_HD4478_H
#define	LCD_HD4478_H

#ifdef	__cplusplus
extern "C" {
#endif
#include <stdint.h>
#include "lcd_config.h"
    
typedef struct {
    uint8_t  lcd_is_8bit:1;
    uint8_t  lcd_2_number_line:1;
    uint8_t  lcd_5_10_fonts:1;
    uint8_t  lcd_cursor_view_on:1;
    uint8_t  lcd_blinking_on:1;
    uint8_t  lcd_entry_set_increment_on:1;
    uint8_t  lcd_entry_display_shift_on:1;
       

} lcdhd4478_configuration_t;


#define LCD_CONCAT(x, y)  x ## y
#define LCD_XCONCAT(x,y)  LCD_CONCAT(x, y)
#define LCD_PORT_PIN_LETTER   R

#define LCD_PORT_E_PIN     LCD_XCONCAT(LCD_PORT_PIN_LETTER,LCD_PORT_E_BIT)
#define LCD_PORT_E_TRIS_BIT LCD_XCONCAT(TRIS, LCD_PORT_E_BIT)

#define LCD_PORT_RS_PIN     LCD_XCONCAT(R,LCD_PORT_RS_BIT)
#define LCD_PORT_RS_TRIS_BIT LCD_XCONCAT(TRIS, LCD_PORT_RS_BIT)

#define LCD_PORT_RW_PIN     LCD_XCONCAT(R,LCD_PORT_RW_BIT)
#define LCD_PORT_RW_TRIS_BIT LCD_XCONCAT(TRIS, LCD_PORT_RW_BIT)

#define lcd_cmd_display_clear   0b00000001
#define lcd_cmd_return_home     0b00000010
#define lcd_cmd_set_entry       0b00000100

#define lcd_cmd_display_set     0b00001000
#define lcd_cmd_function_set    0b00100000
#define lcd_cmd_CGRAM_address_set       0b01000000
#define lcd_cmd_DDRAM_address_set       0b10000000
#define lcd_display_off         lcd_cmd_display_set

#define lcd_cmd_8_bit_pos  4u
#define lcd_cmd_NL_pos     3u
#define lcd_cmd_fonts_size_pos    2u
#define lcd_RW_operates  1 
#define lcd_RW_grounded   0

#define lcd_wait_time_after_cmd    100
#define lcd_wait_time_after_home    1520

#define lcd_entry_inc_pos     1u
#define lcd_entry_shift_pos   0u
#define lcd_disp_inc       1
#define lcd_disp_dec       0
#define lcd_disp_shift     1
#define lcd_disp_noshift     0

#define lcd_cursor        0

#define lcd_display_cursor_on   1
#define lcd_display_cursor_off  0
#define lcd_display_blink_on   1
#define lcd_display_blink_off   0
#define lcd_display_on_pos   2u
#define lcd_display_cursor_pos   1u
#define lcd_display_blink_pos   0u

#define lcd_init_8bit	0b00110000
#define lcd_init_4bit	0b00100000
#define display_clear	0b00000001

#define lcd_address_first_line   0
#define lcd_address_second_line   0x40

#ifdef LCD_HD4478_8BIT 
#define lcd_tris_normal_state_mask  0 
#define lcd_tris_check_busy_mask   0xff 
    
#elif defined(LCD_HD4478_4BIT)
#undef LCD_HD4478_8BIT
    #ifdef LCD_POSITION_4_BIT_HIGH
    #define lcd_tris_normal_state_mask  0x0f //and  with tris this value and as a result normal tris for lcd is set
    #define lcd_tris_check_busy_mask    0xff //and & this value to tris 
 
    
    #elif defined(LCD_POSITION_4_BIT_LOW)
    #define lcd_tris_normal_state_mask  0xf0 // and &
    #define lcd_tris_check_busy_mask    0xff // add
   
    #else 
    #error "Please set postion of 4 bits data line"
    #endif
  
#else
#error "Please set data comunication type"
#endif

#define lcdhd4478_display_clear()   lcdhd4478_send_data(lcd_cmd_display_clear);    
#define lcdhd4478_set_DDRAM_addres(x)   lcdhd4478_send_data(lcd_cmd_DDRAM_address_set + x);    
#define lcdhd4478_set_CGRAM_addres(x)   lcdhd4478_send_data(lcd_cmd_CGRAM_address_set + x);

   
extern void lcdhd4478_init(lcdhd4478_configuration_t lcd_config);

extern void lcdhd4478_send_data(uint8_t data);
    
extern void lcdhd4478_write(char * word);


#ifdef	__cplusplus
}
#endif

#endif	/* LCD_HD4478_H */