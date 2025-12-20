
    list p=16f913 

	include	"p16f913.inc"
    include ../../PicLibDK/macro_keys.inc
    include ../../PicLibDK/math/math_macros.inc


    include defines.inc

    global task_1ms, task_tmr1

    extern keys_machine_state, button_process, led_blink_led_control

    extern game_keys_130ms_change_game, check_games, change_led, game_change_proc

    extern game_status

    extern status_bits, blink_led_count_1sec


task1ms_code code
;this task check if button is pressed
;check if blink led passes
task_1ms


    call button_process

how_much_decrement equ 1
    btfss game_status, game_blink_led
    goto task_1ms_1
    decrement_16bit_value   blink_led_count_1sec, how_much_decrement
    SKPNZ
    call led_blink_led_control


task_1ms_1    
    BANKSEL status_bits    

    bcf status_bits, tmr0_1ms_handle
    return

task_tmr1

    call game_keys_130ms_change_game

    ;check game possibilities
    call check_games
    BANKSEL status_bits
    bcf status_bits, tmr1_isr_reached
    return


    end