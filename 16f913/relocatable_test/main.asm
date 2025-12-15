    list p=p16f913
    include p16f913.inc

    include symbols.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/macro_time.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc
    include ../../PicLibDK/macro_resets.inc
    include ../../PicLibDK/stacks/macro_stack_operation.inc

    udata 
fsr_temp  res 1
w_temp  res 1
status_temp res 1 
pclath_temp res 1
tmr1_count_to_1sec res 1 
program_states  res 1
tmp7 res 1
stack_sp res 1 
stack_of_differences res .32
value_for_one_digit_segment res 1


    global value_for_one_digit_segment
    global tmp7
    global stack_sp, stack_of_differences
    global tmr1_count_to_1sec
    global _start, _reset, ISR_procedure, main_loop, program_states
    extern init 
    include ../../PicLibDK/interrupts.inc
    
reset_vector code  
_reset
    PAGESEL _start
    goto  _start  
isr_vector code 
ISR_procedure     

    context_store16f 

    check_tmr0_isr ISR_timer0

    check_tmr1_isr ISR_timer1

    check_tmr2_isr ISR_timer2

ISR_exit
    context_restore16f
    retfie
    
_start code
ISR_timer0
    bcf  INTCON,T0IF
    ;BANKSEL led_state
    ;bsf led_state, process_led

    goto ISR_exit


ISR_timer1 
    BANKSEL PIR1
    bcf  PIR1, TMR1IF

    BANKSEL  tmr1_count_to_1sec
    decfsz tmr1_count_to_1sec,f
    goto   ISR_timer2_next

    ;increment timer value 
    BANKSEL program_states
    bsf   program_states,increment_1sec

    BANKSEL  tmr1_count_to_1sec
    movlw   how_many_tmr1_count_1sec 
    movwf   tmr1_count_to_1sec
    goto  ISR_exit

ISR_timer2
    ;used for DS18B20
    BANKSEL PIR1
    bcf   PIR1, TMR2IF
ISR_timer2_next

    goto  ISR_exit

_start 
    PAGESEL init
    call init 
main_loop 
    nop
    goto main_loop
    END 