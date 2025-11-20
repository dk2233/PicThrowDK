    list p=16f628a
    include "p16f628a.inc"
    __CONFIG _WDT_OFF & _MCLRE_ON & _FOSC_INTOSCIO & _LVP_OFF & _BOREN_OFF 

    include defines.inc 
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/macro_time.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc
    include ../../PicLibDK/macro_resets.inc



    org 0000h
    goto init 

    org 0004h
interrupts 
    context_store16f 

    check_tmr0_isr ISR_timer0

    check_tmr2_isr ISR_timer2

ISR_exit
    context_restore16f
    retfie

ISR_timer0
    bcf  INTCON,T0IF
    BANKSEL led_state
    bsf led_state, process_led

    goto ISR_exit
ISR_timer2
    ;ever about 1sec increase value to be displayed
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

    include ../../PicLibDK/math/math_function_div.asm
    include ../../PicLibDK/display/led_segment.inc

translate_value_to_port_pins 
    BANKSEL port_led
    movf value_for_one_digit_segment,w 
    movwf  port_led
    return 

change_timer_seconds

    BANKSEL program_states
    bcf  program_states, increment_1sec

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

init 
    config_ccp_off
    config_comparator_off

    BANKSEL OPTION_REG
    movlw  b'11000000'
    movwf  OPTION_REG

    ;4 MHz internal OSC used  4/4e6  * 256 * 8 = 2.05 ms => freq = about 488 Hz
    configure_tmr0  b'010', 1 ;8 prescaler
    configure_tmr2  2, b'1111', .244 ; 4/4e6 * 16 * 16 * 244 * 16
    configure_ports_16f  PORTB, b'00000000'
    configure_ports_16f  PORTA,b'11110000'

    BANKSEL PIE1 
    bsf  PIE1, TMR2IE

    movlw  b'11100000'
    movwf  INTCON

    clear_memory segment_digit1, 0x5f

    call led_digit_init

    BANKSEL tmr2_count_to_1sec
    movlw how_many_tmr2_count_1sec
    movwf tmr2_count_to_1sec
    
    goto main 

main 
    clrwdt
    BANKSEL program_states
    btfsc program_states, increment_1sec 
    call change_timer_seconds 

    PAGESEL refresh_led 
    btfsc led_state, process_led
    call refresh_led



    goto main 
    END





