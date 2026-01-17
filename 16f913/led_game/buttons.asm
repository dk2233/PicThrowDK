
    list p=16f913 

	include	"p16f913.inc"


    include defines.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/macro_keys.inc


    global keys_init, keys_on_int, button_process


    extern w_temp, fsr_temp, pclath_temp, status_temp, status_bits

    extern blink_led_count_1sec, led_port_temp

    global  key1_press_timeL, key1_flags

    extern game_status

    extern led_blink_led_control

    extern game_change_proc



button_ud  udata
button_debounce_counter  res 1
key1_flags   res 1
key1_state   res 1
key1_debounce_cnt  res 1
key1_press_timeL res 2




keys_code code 


keys_init 

        enable_pull_up 1
        rb0_int_disable
        return 


button_process 

    button_handler  button_port, button_pin, key1_state, key1_flags, key1_pressed, key1_debounce_cnt, button_debounce_value, key1_press_timeL
    BANKSEL key1_flags
    btfss key1_flags, key1_pressed
    goto  $+4
    bsf game_status, game_key_press
    bsf game_status, game_key_press2
    bcf key1_flags, key1_pressed

    btfss key1_flags, key1_pressed_released
    goto $+4 
    bsf game_status, game_key_press_released
    bsf game_status, game_key_press_released2
    bcf key1_flags, key1_pressed_released

    return

;NOT USED
;on interrupt
;turn off port change
;enable tmr1 int to measure button being pressed
keys_on_int 

    bcf INTCON, INTF
    BANKSEL status_bits

    context_restore16f
     retfie


        end 
