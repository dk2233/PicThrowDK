;this program blinks 
; a few leds connected to one of the ports
;different light effects



   
	list p=16f628a
	include	"p16f628a.inc"

    include defines.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/memory_operation_16f.inc

main_udata udata
w_temp res 1
status_temp res 1
pclath_temp  res 1
fsr_temp res 1
status_bits  res 1    
tmr1_count_to_1sec  res 1

    extern init

    global tmr1_count_to_1sec
reset_code code 
    goto _start 



isr_code code 
interrupts 
    context_store16f 

    BANKSEL INTCON

    check_tmr0_isr  ISR_timer0
    check_tmr1_isr  ISR_timer1
    check_tmr2_isr  ISR_timer2

ISR_exit 
    context_restore16f

    retfie 

ISR_timer0
    bcf INTCON, T0IF

    goto ISR_exit

ISR_timer1 
    BANKSEL PIR1
    bcf PIR1, TMR1IF 
    BANKSEL status_bits
    bsf   status_bits, tmr1_isr_reached

    goto ISR_exit

ISR_timer2 
    BANKSEL PIR1
    bcf  PIR1,  TMR2IF

    goto ISR_exit

main_code code

_start  
    call init 
    goto main


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

main 
    clrwdt
    BANKSEL status_bits    
    btfsc status_bits, tmr1_isr_reached
    call change_led

    goto main

    END
