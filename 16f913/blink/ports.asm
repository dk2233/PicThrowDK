
    list p=16f913 

	include	"p16f913.inc"


    include defines.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/macro_time.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc


    global keys_init, keys_on_int, keys_machine_state


    extern w_temp, fsr_temp, pclath_temp, status_temp, status_bits
    extern blink_led_count_1sec, led_port_temp



button_ud  udata
button_debounce_counter  res 1



keys_code code 


keys_init 

        BANKSEL OPTION_REG


        enable_pull_up 1

        bcf INTCON, INTF
        bsf INTCON,INTE

        return 


keys_on_int 

    bcf INTCON, INTF
    BANKSEL status_bits
    bsf status_bits, move_led 

    movlw button_debounce_value
    movwf button_debounce_counter

    rb0_int_disable
    bsf status_bits, key_pressed


    context_restore16f
     retfie

;call every 1ms
keys_machine_state

    BANKSEL status_bits
    bcf status_bits, tmr0_1ms_handle
    decrement_16bit_value blink_led_count_1sec, 1
    SKPZ
    goto keys_machine_state_debounce_key1
    movel_2bytes how_many_tmr0_count_1sec, blink_led_count_1sec
    
    movf led_port,w 
    SKPNZ
    goto keys_machine_state_light_again
    movwf led_port_temp
    clrf led_port
    goto keys_machine_state_debounce_key1

keys_machine_state_light_again

    movf led_port_temp,w
    movwf led_port


keys_machine_state_debounce_key1
    btfss status_bits, key_pressed
    goto keys_machine_state_end

    decfsz button_debounce_counter,f 
    goto keys_machine_state_end 

    bcf  status_bits, key_pressed
    rb0_int_enable
    


keys_machine_state_end
     return 

        end 
