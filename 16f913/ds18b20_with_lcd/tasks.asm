
    list p=16f913 

	include	"p16f913.inc"
    include symbols.inc
    include ../../PicLibDK/macro_keys.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/display/macro_lcd_hd4478.inc


    global task_tmr1_1sec, task_tmr0_2ms

    global lcd_cyclic_init


    extern lcd_handler_home, lcd_handler_write_data, lcd_handler_set_address_ddram

    extern ds18_temperature_handle

    extern light_change

    extern button_process



    extern program_states, blink_led_count_1sec
tasks_ud udata 
lcd_position  res  1
lcd_letter    res  1
lcd_letter_line res 1
lcd_address   res  1


tasks_code code
;this task check if button is pressed
;check if blink led passes
task_tmr1_1sec


    BANKSEL program_states    
    bcf program_states, increment_1sec

    ;pagesel lcd_cyclic
    ;call lcd_cyclic

    PAGESEL ds18_temperature_handle
    call ds18_temperature_handle
    return

task_tmr0_2ms
    banksel program_states

    PAGESEL button_process
    call button_process

    PAGESEL light_change
    btfsc  program_states, buttton_pressed
    call light_change 
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