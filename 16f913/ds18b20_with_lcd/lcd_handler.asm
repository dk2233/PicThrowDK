
    list p=16f913
    include "p16f913.inc"

    include symbols.inc 
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/display/macro_lcd_hd4478.inc

    global segment_digit


    global lcd_handler_init, lcd_handler_send_data, lcd_handler_check_busy, lcd_handler_write_data
    global lcd_handler_set_address_ddram
lcd_ud   udata
segment_digit  res 4
lcd_temp        res 2

lcd_code    code 



lcd_handler_init 
    m_lcd_init   lcd_set_8_bit, lcd_set_2_lines, lcd_set_5_8_fonts, lcd_disp_inc, lcd_disp_noshift, lcd_display_cursor_on, lcd_display_blink_off, lcd_RW_operates, lcd_temp
    return


;in Wreg place value to send to lcd driver
lcd_handler_send_data
    m_lcd_send_data lcd_temp
    call lcd_handler_check_busy
    return

lcd_handler_check_busy
    m_check_busy lcd_temp
    return

lcd_handler_write_data 
    m_write_lcd  lcd_temp
    call lcd_handler_check_busy

    return 

;place into Wref address of lcd ddram
lcd_handler_set_address_ddram 
    m_lcd_set_address_ddram
    return 

;place into Wref address of lcd cgram
lcd_handler_set_address_cgram 
    m_lcd_set_address_cgram
    return 
    end