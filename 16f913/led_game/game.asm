
    list p=16f913 

	include	"p16f913.inc"


    include defines.inc

    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/stacks/macro_stack_operation.inc

    include macros.inc

    extern status_bits, key1_press_timeL, key1_flags


    global count_to_game_change_tmr1, game_number, game_status

    global check_games, game_init, game_change_proc

    extern show_led
    extern stack_push_to, stack_pop

    extern rand_generate_pseudo

;to change game simply press longer - 2 sec key and then change blink diode
;game 1 - simple move of light led up and down
;game 2 - you need to move light led by one only when led lights
;game 3 - 

game_ud udata
game_number  res 1
game0_cnt_led_move  res 1
game0_reg   res 1
game1_reg   res 1
game2_reg   res 1
game_status res 1

count_to_game_change_tmr1  res 1

game_size  equ 2 

first_game_bit  equ  1 
last_game_bit   equ  (1 << game_size)


games_code code 

;check how long key is still pressed
;if condition to go into menu is fullfilled just go there
game_keys_press_change_game
    ;check if key is still pressed
    BANKSEL game_status
    btfss game_status, game_key_press_released2
    return

    bcf game_status, game_key_press_released2

    compare16bit_literal  how_many_key_pressed_counts_to_menu, key1_press_timeL
    ;what is in Wreg will be push into stack    
    call stack_push_to
    xorlw compare_return_equal
    SKPNZ
    goto game_keys_press_change_game_equal_or_greater

    call stack_pop
    xorlw compare_return_greater
    SKPNZ
    goto game_keys_press_change_game_equal_or_greater

    ;less than going into menu - return 
    return
game_keys_press_change_game_equal_or_greater    
    ;check if pin is released
    ;BANKSEL button_port
    ;btfsc button_port, button_pin ; both condition checked 
    ;goto  keys_130ms_change_game_button_released_set_game 
    ;goto keys_130ms_change_game_end

keys_130ms_change_game_button_released_set_game
    BANKSEL status_bits
    btfss status_bits, game_change
    goto $+3

    bcf status_bits, game_change
    goto $+2
    bsf status_bits, game_change

keys_130ms_change_game_end    
    return 

check_games 
    BANKSEL button_port
    ;check if key is still pressed 
    btfsc  button_port, button_pin
    call   game_keys_press_change_game

    BANKSEL status_bits
    btfsc status_bits, game_change
    goto game_change_proc

    BANKSEL game_number
    movlw game_0
    xorwf game_number,w
    SKPNZ
    goto check_games0


    movlw game_1
    xorwf game_number,w
    SKPNZ
    goto check_games1

    movlw game_2
    xorwf game_number,w
    SKPNZ
    goto check_games2
check_games_end
    return

;proc to move bit (light led) on reg
;when reach last position it will return to start position
game_change_proc
    blink_of_led_in_game 1
    BANKSEL game_status
    btfss game_status, game_key_press_released
    goto game_change_proc_end  
    bcf game_status, game_key_press_released
    movlw LOW game_number
    movwf FSR 
    BANKISEL game_number
    move_bit_around_reg  game_status, game_change_direction, first_game_bit, last_game_bit
game_change_proc_end
    movlw  LOW game_number
    movwf  FSR 
    BANKISEL game_number
    call show_led
    return 

check_games0
    blink_of_led_in_game 0

    BANKSEL status_bits
    btfss status_bits, tmr1_isr_reached
    goto check_games0_end

    decfsz game0_cnt_led_move,f
    goto  check_games0_end
    ;led move pass 
    movlw game_0_how_many_tmr1_mv_led
    movwf game0_cnt_led_move
    movlw LOW game0_reg
    movwf FSR 
    BANKISEL game0_reg    
    move_bit_around_reg status_bits, change_led_direction,  start_led_pin, last_led_pin

check_games0_end
    call show_led
    return 

check_games1
    BANKSEL game_status
    btfss game_status, game_key_press
    goto check_games1_end 
    BANKISEL game1_reg    
    move_bit_around_reg status_bits, change_led_direction,  start_led_pin, last_led_pin
    bcf game_status, game_key_press

check_games1_end
    movlw LOW game1_reg
    movwf FSR 
    ;btfss status_bits, move_led
    ;goto check_games1_end2


    ;BANKISEL game1_reg    
    ;move_bit_around_reg status_bits, change_led_direction,  start_led_pin, last_led_pin
;check_games1_end2
    BANKISEL game1_reg    
    call show_led
    return

check_games2
    BANKSEL game_status
    blink_of_led_in_game 0

    btfss game_status, game_key_press
    goto check_games2_end
    ;bsf status_bits, move_led 
    call rand_generate_pseudo
    BANKSEL game2_reg
    movwf game2_reg
    bcf game_status, game_key_press

check_games2_end
    movlw LOW game2_reg
    movwf FSR 
    BANKISEL game2_reg    
    call show_led
    return


game_init 

    BANKSEL count_to_game_change_tmr1
    movlw  how_many_tmr1_count_change_game
    movwf  count_to_game_change_tmr1

    movlw first_game_bit
    movwf game_number
    movwf game0_reg
    movwf game1_reg
    call show_led




    movlw game_0_how_many_tmr1_mv_led
    movwf game0_cnt_led_move
    return

    end
