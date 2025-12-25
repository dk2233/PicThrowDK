
    list p=16f913 

	include	"p16f913.inc"


    include defines.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/macro_time.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/macro_keys.inc


    global keys_init, keys_on_int, keys_machine_state, button_process


    extern w_temp, fsr_temp, pclath_temp, status_temp, status_bits

    extern blink_led_count_1sec, led_port_temp
    global  key1_press_timeL

    extern led_blink_led_control

    extern game_change_proc



button_ud  udata
button_debounce_counter  res 1
key1_state   res 1
key1_debounce_cnt  res 1
key1_press_timeL res 2



keys_code code 


keys_init 

        enable_pull_up 1
        rb0_int_disable
        return 


button_process 

    button_handler  button_port, button_pin, key1_state, status_bits, key_pressed, key1_debounce_cnt, button_debounce_value, key1_press_timeL
    ;btfss status_bits, key_pressed
    return


;on interrupt
;turn off port change
;enable tmr1 int to measure button being pressed
keys_on_int 

    bcf INTCON, INTF
    BANKSEL status_bits

    movlw button_debounce_value ;how many int we have to pass
    movwf button_debounce_counter

    rb0_int_disable
    bsf status_bits, key_pressed

    tmr1_interrupt_enable


    context_restore16f
     retfie

;call every 1ms
keys_machine_state
    BANKSEL status_bits

    decrement_16bit_value blink_led_count_1sec, 1
    SKPZ
    goto keys_machine_state_debounce_key1

    call led_blink_led_control

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
