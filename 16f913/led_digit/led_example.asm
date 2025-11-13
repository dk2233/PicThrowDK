
;this program 
;sets interrupts for tmr0
; led segments x4 is controlled
;increased every 1 sec
;gpasm  led_example.asm

	list p=16f913
	include	"p16f913.inc"
	__CONFIG _WDT_OFF & _MCLRE_ON & _DEBUG_ON & _IESO_ON  & _HS_OSC & _FCMEN_ON & _PWRTE_ON

    include defines.inc
    include ../../libs/memory_operation_16f.inc
    include ../../libs/interrupts.inc
    include ../../libs/math_macros.inc
    include ../../libs/init16f.inc
    include ../../libs/macro_time.inc

    
    org   000h
    PAGESEL init 
    goto init

    org  0004h
vector_table
    context_store16f

    ; isr handling
    PAGESEL ISR_timer0
    
    btfsc INTCON,T0IF 
    goto  ISR_timer0

    BANKSEL PIR1
    btfsc   PIR1, TMR2IF
    goto    ISR_timer2




ISR_exit
    context_restore16f


    retfie

    PAGESEL init
    goto init
    include ../../libs/math_function_multiplication.asm
    include ../../libs/multiplication_16f_loop.asm
    include ../../libs/math_function_div.asm
    include ../../libs/led_segment.inc

ISR_timer0
    bcf INTCON,T0IF
    BANKSEL led_state 
    bsf   led_state, process_led

    goto ISR_exit


ISR_timer2 
    BANKSEL PIR1
    bcf   PIR1, TMR2IF

    goto  ISR_exit

translate_value_to_port_pins 
    ;portc - 4 lower bits 
    ;portb - 4 lower bits filleds with higher bits from value_for_leds

    BANKSEL port_led_L

    movlw  0xf0 
    andwf  port_led_L,f ;clear lower bits
    
    movlw  0xf0 
    andwf  port_led_H,f ;clear lower bits

    MOVF    value_for_leds,w  
    andlw   0x0f 

    addwf   port_led_L,f 

    swapf   value_for_leds,w 
    andlw   0x0f

    addwf   port_led_H,f  


    return

main 

     clrwdt ; this comment to be able to test WDG detection

    BANKSEL refresh_led
    btfsc   led_state, process_led
    call refresh_led

    goto main

    org 800h
init 

    config_watchdog  .15, 1
    config_porta_digit_16f

    BANKSEL OPTION_REG

	movlw	b'11000000'
	movwf	OPTION_REG

    configure_tmr0   3, 1 ; prescaler 16 -> 4/8Mhz * 256 * 16


    configure_ports_16f  PORTA, b'11111100'
    configure_ports_16f  PORTB, b'11000000'
    configure_ports_16f  PORTC, b'00110000'

    BANKSEL  OSCCON
; OSCCON set for HS 8MHz	
	movlw	b'01110111'
    movwf  OSCCON

	movlw	b'11100000'
	movwf	INTCON

    configure_tmr2  2, .15, .252

    BANKSEL   PIE1
    bsf  PIE1, TMR2IE

    clear_memory  segment_digit1,0x5f ; here status_bits is cleared

    BANKSEL var2
    movlw  0
    movwf  var2
    ;detect that wdg timeout occurs if bit is not set = same
    compare1byte_set_when_same  run_system_marker,  SFR_to_detect_WDG, status_bits, wdg_detected

    BANKSEL status_bits
    btfss  status_bits, wdg_detected
    goto init2 


    compare1byte_set_when_same  run_system_marker, wdg_timeout_marker, status_bits, wdg_detected2


init2
    clear_memory 0xa0,10
    clear_memory var2, 30
    

    BANKSEL status_bits
    ;run marked
    bsf status_bits, run_system

    BANKSEL SFR_to_detect_WDG
    movlw   run_system_marker
    movwf   SFR_to_detect_WDG

    BANKSEL wdg_timeout_marker
    movwf   wdg_timeout_marker

    BANKSEL leds 
    movlw   leds_start
    movwf  leds
    PAGESEL main
    goto main 
    
    END