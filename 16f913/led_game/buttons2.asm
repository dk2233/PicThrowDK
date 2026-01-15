
    list p=16f913 

	include	"p16f913.inc"


    include defines.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/macro_time.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/macro_keys.inc

y
    global button_process2


    extern w_temp, fsr_temp, pclath_temp, status_temp, status_bits

    extern blink_led_count_1sec, led_port_temp
    global  key2_press_timeL

    extern led_blink_led_control

    extern game_change_proc



button_ud  udata
button_debounce_counter  res 1
key2_state   res 1
key2_debounce_cnt  res 1
key2_press_timeL res 2



keys_code code 




button_process2 

    button_handler  button_port, button_pin, key2_state, status_bits, key2_pressed, key2_debounce_cnt, button_debounce_value, key2_press_timeL
    return


        end 
