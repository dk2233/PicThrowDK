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

main_udata    udata
tmr0_count_to_1sec  res 1


    global w_temp, status_temp, pclath_temp, fsr_temp
    global _start, _reset, ISR_procedure, main_loop
    global  tmr0_count_to_1sec
    
    
    extern value_for_one_digit_segment, led_state
    extern result_ll, result_hl
    extern operandl, fraction_l
    extern segment_digit
    extern ds18_configuration

    
    
    extern init 
    extern ds18_temperature_handle
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


    
    bsf ds18_configuration, tmr0_interrupt


    goto ISR_exit


_start 
    call init 
main_loop 
    btfsc ds18_configuration, tmr0_interrupt
    call ds18_temperature_handle


    call refresh_led
    goto main_loop
    END 