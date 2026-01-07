
	list p=16f628a
	include	"p16f628a.inc"

    include defines.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/macro_random.inc

    global change_led


    extern status_bits, tmr1_count_to_1sec

leds_ud   udata 
random  res 1 


    code 

change_led 
    BANKSEL status_bits
    bcf  status_bits, tmr1_isr_reached 

    decfsz  tmr1_count_to_1sec, F
    return 
    movlw how_many_tmr1_count_1sec
    movwf tmr1_count_to_1sec
    ;'0001'
    ; 0010
    ; 0100
    ; 1000
    ;10000 

    goto change_led_method3

    BANKSEL led_port
    movf  led_port,w 
    BANKSEL status_bits
    btfss  status_bits, change_led_direction
    xorlw  last_led_pin

    btfsc  status_bits, change_led_direction
    xorlw  start_led_pin

    SKPNZ
    goto change_led_restart

    bcf STATUS,C
    btfss status_bits,change_led_direction
    rlf  led_port,f 

    btfsc status_bits,change_led_direction
    rrf  led_port,f

    return

change_led_restart
    ;movlw 1
    ;movwf led_port
    btfsc status_bits, change_led_direction
    goto  change_led_restart_right

    rrf led_port,f 
    BANKSEL status_bits
    bsf  status_bits, change_led_direction

    return 

change_led_restart_right 
    BANKSEL status_bits
    bcf  status_bits, change_led_direction
    rlf  led_port,f 
    return

change_led_method2

    movlw  max_value_led_method_2
    xorwf  led_port,w 
    SKPZ
    goto change_led_method2a  
    movlw  start_led_pin
    movwf  led_port
    return

change_led_method2a

    incf led_port,f 

    return


change_led_method3 
    ;movf  led_port,w 
    BANKSEL TMR0
    movf  TMR0,w 
    BANKSEL random
    movwf random 

    rand_8bit  random 

    movf random,w 
    andlw  led_port_mask,w 
    movwf led_port



    return

    END