
    list p=16f913
    include "p16f913.inc"

    include symbols.inc 
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/display/macro_lcd_hd4478.inc

    global segment_digit


    global lcd_handler_init, lcd_handler_send_data, lcd_handler_check_busy, lcd_handler_write_data
    global lcd_handler_home
    global lcd_handler_set_address_ddram
lcd_ud   udata
segment_digit  res 4
lcd_temp        res 2
lcd_n    res 1

lcd_code    code 


#define lcd_handler_how_many_custom_gfx    8
lcd_handler_init 
;as argument here just put lcd_set_4_bit or lcd_set_8_bit
    m_lcd_init   lcd_set_4_bit, lcd_set_2_lines, lcd_set_5_8_fonts, lcd_disp_inc, lcd_disp_noshift, lcd_display_cursor_off, lcd_display_blink_on, lcd_RW_operates, lcd_temp
    movlw .8
    call lcd_handler_set_address_cgram

    clrf lcd_n
lcd_handler_init_1
    ;PAGESELW tab_sprites
    
    movlw 1
    movwf PCLATH
    banksel lcd_n
    movf lcd_n,w
    BANKSEL PCL
    call tab_sprites

    call lcd_handler_write_data
    incf lcd_n,f
    movlw lcd_handler_how_many_custom_gfx * 8
    xorwf lcd_n,w 
    SKPZ 
    goto lcd_handler_init_1


    movlw  lcd_cmd_display_clear
    call lcd_handler_send_data

    return
tab_sprites
    addwf PCL,f


tab_bell
    lcd_sprite_bell
tab_heart
    ; Heart symbol
; Heart symbol
    lcd_sprite_heart

tab_heart2 
    lcd_sprite_heart

tab_smiley
    lcd_sprite_smiley
    lcd_sprite_rock
tab_weird1
    lcd_sprite_body

    lcd_sprite_body2
    lcd_sprite_body3
;in Wreg place value to send to lcd driver
lcd_handler_send_data
    m_lcd_send_data lcd_temp
    PAGESEL lcd_handler_check_busy
    call lcd_handler_check_busy
    return

lcd_handler_check_busy
    m_check_busy lcd_temp
    return

lcd_handler_write_data 
    m_write_lcd  lcd_temp
    PAGESEL lcd_handler_check_busy
    call lcd_handler_check_busy

    return 

;place into Wref address of lcd ddram
lcd_handler_set_address_ddram 
    m_lcd_set_address_ddram
    return 

lcd_handler_home 
    m_return_home
    return

lcd_handler_set_address_cgram
    m_lcd_set_address_cgram
    return 

    end