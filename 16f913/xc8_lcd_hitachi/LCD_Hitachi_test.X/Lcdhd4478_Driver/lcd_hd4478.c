/*
 * File:   lcd_hd4478.c
 * Author: dan
 *
 * Created on 20 lutego 2026, 12:50
 */


#include <xc.h>
#include "lcd_config.h"
#include "lcd_hd4478.h"

static inline void lcdhd4478_enable();

static inline void lcdhd4478_clear_data_port(void);


static inline void lcdhd4478_enable(void)
{
    LCD_PORT_E.LCD_PORT_E_PIN = 1;
    NOP();
    LCD_PORT_E.LCD_PORT_E_PIN = 0;
    
}

static inline void lcdhd4478_clear_data_port(void)
{
#ifdef LCD_HD4478_8BIT
    
    LCD_PORT_DATA = 0;
#else 
#ifdef LCD_POSITION_4_BIT_HIGH
    LCD_PORT_DATA = LCD_PORT_DATA & 0x0f;
    
#elif defined(LCD_POSITION_4_BIT_LOW) 
    LCD_PORT_DATA = LCD_PORT_DATA & 0xf0;
#else 
    #error "Please set postion of 4 bits data line"
#endif
#endif
    
}

static void lcdhd4478_check_busy(void)
{
    uint8_t port_data_state;
    lcdhd4478_clear_data_port();
    
#ifdef LCD_HD4478_RW_USAGE
    LCD_PORT_TRIS_DATA &= lcd_tris_check_busy_mask;
    
    LCD_PORT_RW.LCD_PORT_RW_PIN = 1;
    LCD_PORT_RW.LCD_PORT_RS_PIN = 0;
    
    do 
    {
        LCD_PORT_E.LCD_PORT_E_PIN = 1;
        
#ifdef LCD_HD4478_8BIT
        port_data_state = LCD_PORT_DATA;
        
#elif defined(LCD_HD4478_4BIT)
        
#ifdef LCD_POSITION_4_BIT_HIGH
        port_data_state = LCD_PORT_DATA & 0xf0;
        
        LCD_PORT_E.LCD_PORT_E_PIN = 0;
        LCD_PORT_E.LCD_PORT_E_PIN = 1;
        
        port_data_state |= ((LCD_PORT_DATA  & 0xf0) >> 4);
#else 
        port_data_state = LCD_PORT_DATA & 0x0f;
        
        LCD_PORT_E.LCD_PORT_E_PIN = 0;
        LCD_PORT_E.LCD_PORT_E_PIN = 1;
        
        port_data_state |= ((LCD_PORT_DATA  & 0x0f) << 4);
#endif
#endif
        LCD_PORT_E.LCD_PORT_E_PIN = 0;
        
    } while(port_data_state & 0x80);
    
    LCD_PORT_TRIS_DATA &= lcd_tris_normal_state_mask;
    
#elif defined(LCD_HD4478_RW_GND)
    DELAY_MS(lcd_wait_time_after_cmd);
#else 
#error "LCD driver requires to choose RW connection type"
#endif 
    LCD_PORT_RW.LCD_PORT_RW_PIN = 0;
    LCD_PORT_RW.LCD_PORT_RS_PIN = 0;
    
}


void lcdhd4478_send_data(uint8_t data)
{
    lcdhd4478_clear_data_port();
    
#ifdef LCD_HD4478_8BIT
    
    LCD_PORT_DATA = data;
#else 
#ifdef LCD_POSITION_4_BIT_HIGH
    LCD_PORT_DATA = LCD_PORT_DATA | ((data << 4) & 0xf0);
#elif defined(LCD_POSITION_4_BIT_LOW) 
    LCD_PORT_DATA = LCD_PORT_DATA | (data & 0x0f);
#else 
    #error "Please set postion of 4 bits data line"
#endif
#endif
    lcdhd4478_enable();    
    
#ifdef LCD_POSITION_4_BIT_HIGH
    lcdhd4478_clear_data_port();
    LCD_PORT_DATA = LCD_PORT_DATA | (data & 0xf0);
#elif defined(LCD_POSITION_4_BIT_LOW) 
    lcdhd4478_clear_data_port();
    LCD_PORT_DATA = LCD_PORT_DATA | ((data >> 4) & 0x0f);
#else 
    #error "Please set postion of 4 bits data line"
#endif
#
    lcdhd4478_check_busy();
}



void lcdhd4478_write(char * word)
{
    do {
    LCD_PORT_RW.LCD_PORT_RS_PIN = 1;
    
    lcdhd4478_send_data(*(word++));
    
    LCD_PORT_RW.LCD_PORT_RS_PIN = 0;
    } while(*word !='\0');
}

void lcdhd4478_init(lcdhd4478_configuration_t lcd_config) 
{
    LCD_PORT_TRIS_DATA &= lcd_tris_normal_state_mask;
    LCD_PORT_TRIS_E.LCD_PORT_E_TRIS_BIT = 0;
    LCD_PORT_TRIS_RS.LCD_PORT_RS_TRIS_BIT = 0;
    LCD_PORT_TRIS_RW.LCD_PORT_RW_TRIS_BIT = 0;
        
    
    lcdhd4478_clear_data_port();
#ifdef LCD_HD4478_8BIT 

    LCD_PORT_DATA = lcd_init_8bit;
#elif defined(LCD_HD4478_4BIT)
#undef LCD_HD4478_8BIT
    #ifdef LCD_POSITION_4_BIT_HIGH
    
    LCD_PORT_DATA = LCD_PORT_DATA | (lcd_init_4bit & 0xf0) ;
    
    #elif defined(LCD_POSITION_4_BIT_LOW)
   
    LCD_PORT_DATA = LCD_PORT_DATA | ((lcd_init_4bit >> 4) & 0x0f);

    #else 
    #error "Please set postion of 4 bits data line"
    #endif
    lcdhd4478_enable();
#else
#error "Please set data comunication type"
#endif

    
    DELAY_MS(44);
    
    lcdhd4478_send_data(lcd_cmd_function_set | (lcd_config.lcd_is_8bit << (uint8_t)lcd_cmd_8_bit_pos) | (lcd_config.lcd_2_number_line << (uint8_t)lcd_cmd_NL_pos) | (lcd_config.lcd_5_10_fonts << (uint8_t)lcd_cmd_fonts_size_pos));
    
    lcdhd4478_send_data(lcd_display_off);
    
    lcdhd4478_send_data(display_clear);
    
    lcdhd4478_send_data(lcd_cmd_display_set | (lcd_config.lcd_cursor_view_on << lcd_display_cursor_pos) | (lcd_config.lcd_blinking_on << lcd_display_blink_pos) | (1 << lcd_display_on_pos));

    lcdhd4478_send_data(lcd_cmd_set_entry | (lcd_config.lcd_entry_set_increment_on << lcd_entry_inc_pos) | (lcd_config.lcd_entry_display_shift_on << lcd_entry_shift_pos)) ;

    return;
}
