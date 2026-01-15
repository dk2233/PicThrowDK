;this program blinks 
; a few leds connected to one of the ports
;different light effects



   
	list p=16f913
	include	"p16f913.inc"
	__CONFIG _WDT_OFF & _MCLRE_ON & _DEBUG_ON & _IESO_OFF  & _FCMEN_OFF & _PWRTE_ON & _INTOSCIO

    include defines.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/macro_time_tmr1_tmr2.inc

    org  000h 
    PAGESEL init 

    goto init 

    org 004h  
interrupts 
    context_store16f 

    BANKSEL INTCON

    PAGESEL ISR_timer0
    btfsc INTCON, T0IF 
    goto ISR_timer0

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
    bsf   status_bits, tmr2_isr_reached


    goto ISR_exit

ISR_timer2 
    BANKSEL PIR1
    bcf  PIR1,  TMR2IF

    goto ISR_exit

change_led 
    BANKSEL status_bits
    bcf  status_bits, tmr2_isr_reached 
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
    btfsc status_bits, tmr2_isr_reached
    call change_led

    goto main

    org 800h

init 

    config_watchdog  .13 , 1

    config_porta_digit_16f

    configure_ports_16f  PORTC , b'00000000' 

    ;BANKSEL OSCCON
    ;movlw b'01110111'
    ;movwf OSCCON
    config_osccon  b'100', 0, 1 

    clear_memory  0x20, 0x5f 
    clear_memory  0xa0, (0xff - 0xa0)

    movlw b'11000000'
    movwf INTCON

    config_tmr1_as_timer  b'01', 1

    BANKSEL led_port
    movlw start_led_pin 
    movwf led_port
    PAGESEL main 
    goto main
    END

