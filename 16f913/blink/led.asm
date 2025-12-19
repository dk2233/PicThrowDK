    list p=16f913 

	include	"p16f913.inc"


    include defines.inc

    
    global change_led

    extern status_bits


led_code    code 
change_led 
    BANKSEL status_bits
    ;bcf  status_bits, tmr2_isr_reached 
    bcf status_bits, move_led
    ;'0001'
    ; 0010
    ; 0100
    ; 1000
    ;10000 

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

    end