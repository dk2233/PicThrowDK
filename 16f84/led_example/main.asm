    list p=p16f84a
    include p16f84a.inc

    include symbols.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc
    include ../../PicLibDK/stacks/macro_stack_operation.inc
    include ../../PicLibDK/interrupts_common.inc
;4
common_var1    udata  
w_temp  res 1
status_temp res 1
pclath_temp  res  1
fsr_temp  res 1

;7
main_udata    udata
program_states  res 1
tmp7 res 1
tmr0_count_to_1sec  res 1
value_incremented   res 2


    global w_temp, status_temp, pclath_temp, fsr_temp
    global tmp7
    global _start, _reset, ISR_procedure, main_loop
    global program_states , tmr0_count_to_1sec
    
    
    extern value_for_one_digit_segment, led_state
    extern result_ll, result_hl
    extern operandl, fraction_l
    extern segment_digit

    
    
    extern init 
    extern refresh_led
    extern func_div_24bit_16bit


    
reset_vector code  
_reset
    goto  _start  
isr_vector code 
ISR_procedure     

    context_store16f 

    check_tmr0_isr ISR_timer0

ISR_exit
    context_restore16f
    retfie
    
_start code
ISR_timer0
    bcf  INTCON,T0IF


    
    bsf program_states, tmr0_interrupt


    goto ISR_exit



how_much_increment_every_time  equ 1
increment_value 
    bcf program_states, tmr0_interrupt

    decfsz tmr0_count_to_1sec,f 
    goto ISR_exit

    movlw how_many_tmr0_count_1sec
    movwf tmr0_count_to_1sec

    increment_16bit_value value_incremented, how_much_increment_every_time
    

    compare16bit_literal  max_value_to_be_displayed , value_incremented
    xorlw compare_return_greater

    SKPZ
    goto calc_value 

increment_clear
    clrf value_incremented
    clrf value_incremented+1

calc_value
    macro_16bits_into_N_dec   value_incremented, segment_digit, LED_SEGMENT
    return


_start 
    call init 
main_loop 
    btfsc program_states, tmr0_interrupt
    call increment_value


    call refresh_led
    goto main_loop
    END 