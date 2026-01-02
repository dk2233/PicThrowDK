    list p=16f913 

	include	"p16f913.inc"


    include defines.inc
    include ../../PicLibDK/memory_operation_16f.inc

    global led_port_temp, blink_led_count_1sec    , show_led


    global change_led, led_blink_led_control

    extern status_bits, game_status


led_ud udata
led_port_temp res 1
blink_led_count_1sec res 2

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
    SKPNZ 
    return 
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

    bcf STATUS,C
    btfsc status_bits,change_led_direction
    rrf  led_port,f

    return

show_led 
    btfsc game_status, game_blink_led
    goto show_led_blink
    movf    INDF,w 
    movwf led_port
    return
show_led_blink
    decfsz blink_led_count_1sec,f
    goto  show_led_blink_end

    call led_blink_led_control

show_led_blink_end
    return
change_led_restart
    btfsc status_bits, change_led_direction
    goto  change_led_restart_right

    bcf STATUS,C
    rrf led_port,f 
    BANKSEL status_bits
    bsf  status_bits, change_led_direction

    return 

change_led_restart_right 
    BANKSEL status_bits
    bcf  status_bits, change_led_direction
    bcf STATUS,C
    rlf  led_port,f 
    return


led_blink_led_control 
    BANKSEL status_bits 
    btfsc status_bits, game_change
    goto  led_blink_rate_game_change 

    movel_2bytes how_many_tmr1_count_1sec, blink_led_count_1sec

    goto led_blink_led_control_1
led_blink_rate_game_change
    movel_2bytes how_many_tmr1_count_1sec/2, blink_led_count_1sec


led_blink_led_control_1
    movf led_port,w 
    SKPNZ
    goto  led_blink_light_again 
    clrf led_port
    return

led_blink_light_again

    movf INDF,w
    movwf led_port

    return 
    end