
    list p=16f913 

	include	"p16f913.inc"
    include symbols.inc
    include ../../PicLibDK/macro_keys.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/display/macro_lcd_hd4478.inc


    global task_tmr1
    global lcd_cyclic_init


    extern lcd_handler_home, lcd_handler_write_data, lcd_handler_set_address_ddram



    extern program_states, blink_led_count_1sec
tasks_ud udata 
lcd_position  res  1
lcd_letter    res  1
lcd_letter_line res 1
lcd_address   res  1


tasks_code code
;this task check if button is pressed
;check if blink led passes
task_tmr1


    BANKSEL program_states    
    bcf program_states, interrupt_tmr1

    BANKSEL led_green_port
    btfsc led_green_port,led_green_pin
    goto $+3
    bsf   led_green_port, led_green_pin
    goto  $+2

    bcf   led_green_port, led_green_pin

    call lcd_cyclic
    return


lcd_cyclic_init 
    clrf lcd_letter
    call lcd_handler_home
    clrf lcd_address
    clrf lcd_letter_line
    movlw 0x0
    call lcd_handler_set_address_ddram
    return

#define lcd_max_character     .16
lcd_cyclic 
    ;movlw lcd_position
    movlw    0
    addwf    lcd_letter,w
    incf     lcd_letter,f 
    incf     lcd_letter_line,f
    movf lcd_letter_line,w
    xorlw    lcd_one_line_size
    SKPZ 
    goto lcd_cyclic_write
    clrf lcd_letter_line
    movlw   lcd_address_second_line
    xorwf   lcd_address,f
    movf  lcd_address,w 
    call lcd_handler_set_address_ddram

lcd_cyclic_write
    movf lcd_letter,w 
    call lcd_handler_write_data

    movlw lcd_max_character
    xorwf lcd_letter,w
    SKPZ  
    goto  $+4
    BANKSEL lcd_letter
    clrf  lcd_letter

    return

    end