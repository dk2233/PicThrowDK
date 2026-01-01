
	include	"p16f84a.inc"

    include symbols.inc
    include ../../PicLibDK/display/led_defines.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc
;8
led_udata udata
segment_digit res 4 
leds_common res 1
led_state res 1
led_dot_display res 1
value_for_one_digit_segment res 1

    global segment_digit

    global refresh_led
    global led_digit_init
    global translate_value_to_port_pins


    global value_for_one_digit_segment



    global led_dot_display, led_state

    extern program_states



    extern func_div_24bit_16bit


led_code    code 
    include ../../PicLibDK/display/led_segment.inc


translate_value_to_port_pins 
    MOVF    value_for_one_digit_segment,w  
    movwf   port_led 

    return
refresh_led
    m_refresh_led  segment_digit
    return

    end