;this program 
;sets interrupts for tmr0
; led segments x4 is controlled
;increased every 1 sec
;gpasm  led_example.asm

	list p=16f913
	include	"p16f913.inc"
	__CONFIG _WDT_OFF & _MCLRE_ON & _DEBUG_ON & _IESO_ON  & _HS_OSC & _FCMEN_ON & _PWRTE_ON

    include defines.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/macro_time.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc
    include ../../PicLibDK/macro_resets.inc

    
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

    include ../../PicLibDK/math/math_function_div.asm
    include ../../PicLibDK/display/led_segment.inc

ISR_timer0
    bcf INTCON,T0IF
    BANKSEL led_state 
    bsf   led_state, process_led

    goto ISR_exit


ISR_timer2 
    BANKSEL PIR1
    bcf   PIR1, TMR2IF

    BANKSEL  tmr2_count_to_1sec
    decfsz tmr2_count_to_1sec,f
    goto   ISR_timer2_next

    ;increment timer value 
    bsf   program_states,increment_1sec

    movlw   how_many_tmr2_count_1sec 
    movwf   tmr2_count_to_1sec



ISR_timer2_next

    goto  ISR_exit

translate_value_to_port_pins 
    ;portc - 4 lower bits 
    ;portb - 4 lower bits filleds with higher bits from value_for_one_digit_segment

    BANKSEL port_led_L

    movlw  0xf0 
    andwf  port_led_L,f ;clear lower bits
    
    movlw  0xf0 
    andwf  port_led_H,f ;clear lower bits

    MOVF    value_for_one_digit_segment,w  
    andlw   0x0f 

    addwf   port_led_L,f 

    swapf   value_for_one_digit_segment,w 
    andlw   0x0f

    addwf   port_led_H,f  


    return

change_timer_seconds
    BANKSEL program_states
    bcf  program_states, increment_1sec

    BANKSEL led_green_port
    bcf    led_green_port, led_green_pin

    bcf  operandl,0
    
    compare2bytes max_value_to_be_displayed, timer_l , operandl, 0 

    btfsc operandl,0
    goto  change_timer_seconds_1 

    movlw 0 
    movwf timer_h
    movwf timer_l
    goto change_timer_seconds_2

change_timer_seconds_1

    BANKSEL timer_l
    incf   timer_l,f 
    btfsc  STATUS,Z 
    incf   timer_h,f

change_timer_seconds_2
    
    movf  timer_l,w 
    movwf number_l
    movf  timer_h,W
    movwf number_h


    call split_number_to_digits

    return

main 

     clrwdt ; this comment to be able to test WDG detection
    PAGESEL change_timer_seconds
    BANKSEL program_states
    btfsc  program_states, increment_1sec
    call  change_timer_seconds

    PAGESEL refresh_led
    BANKSEL led_state
    btfsc   led_state, process_led
    call refresh_led



    PAGESEL main
    goto main

    org 800h
init 

    config_watchdog  .15, 1
    config_porta_digit_16f

    BANKSEL OPTION_REG
	movlw	b'11000000'
	movwf	OPTION_REG

    configure_tmr0   b'100', 1 ; prescaler 16 -> 4/8Mhz * 256 * 16


    configure_ports_16f  PORTA, b'11111100'
    configure_ports_16f  PORTB, b'11000000'
    configure_ports_16f  PORTC, b'00110000'

    ;signal reset 
    BANKSEL led_green_port
    bsf   led_green_port, led_green_pin
    BANKSEL  OSCCON
; OSCCON set for HS 8MHz	
	;movlw	b'01110111'
    ;movwf  OSCCON

    config_osccon b'111', 1, 1
    

	movlw	b'11100000'
	movwf	INTCON

    configure_tmr2  2, .15, .252

    BANKSEL   PIE1
    bsf  PIE1, TMR2IE

    clear_memory  segment_digit1,0x5f ; here status_bits is cleared


init2
    clear_memory 0xa0,10
    clear_memory var2, 30
    

    BANKSEL tmr2_count_to_1sec
    movlw  how_many_tmr2_count_1sec
    movwf  tmr2_count_to_1sec

    BANKSEL status_bits
    ;run marked
    bsf status_bits, run_system


    BANKSEL PCON
    detect_watchdog_happens
    xorlw  1 
    btfss STATUS,Z
    goto  init3


    BANKSEL led_red_port
    bsf led_red_port,led_red_pin
init3
    PAGESEL led_digit_init
    call led_digit_init
    PAGESEL main
    goto main 
    
    END