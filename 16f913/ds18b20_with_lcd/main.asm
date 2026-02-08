    list p=p16f913
    include p16f913.inc

    include symbols.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc
    include ../../PicLibDK/macro_resets.inc
    include ../../PicLibDK/stacks/macro_stack_operation.inc
    include ../../PicLibDK/display/macro_lcd_hd4478.inc

    include ../../PicLibDK/display/lcd_defines.inc


common_var    udata  
w_temp  res 1
status_temp res 1
pclath_temp  res  1
fsr_temp  res 1

    udata
tmr1_count_to_1sec res 1 
program_states  res 1
tmp7 res 1
stack_sp res 1 
stack_of_differences res .32


    global w_temp, status_temp, pclath_temp, fsr_temp
    global tmp7
    global stack_sp, stack_of_differences
    global _start, _reset, ISR_procedure, main_loop
    global tmr1_count_to_1sec, program_states 
    
    
    
    extern init 
    extern ds18_temperature_handle
    extern lcd_handler_check_busy, lcd_handler_send_data, lcd_handler_write_data
    extern lcd_handler_set_address_ddram
    extern  task_tmr1_1sec, task_tmr0_2ms


    include ../../PicLibDK/interrupts.inc
    
reset_vector code  
_reset
    PAGESEL _start
    goto  _start  
isr_vector code 
ISR_procedure     

    context_store16f 
    PAGESEL ISR_timer0

    check_tmr0_isr ISR_timer0

    check_tmr1_isr ISR_timer1

    check_tmr2_isr ISR_timer2

ISR_exit
    nop
    context_restore16f
    retfie
    
ISR_timer0
    bcf  INTCON,T0IF
    BANKSEL program_states
    bsf program_states, interrupt_tmr0

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

_start code
_start 
    PAGESEL init
    call init 
    PAGESEL lcd_handler_check_busy
    movlw lcd_address_first_line
    call lcd_handler_set_address_ddram

main_loop 
    BANKSEL program_states
    btfsc program_states, increment_1sec
    call task_tmr1_1sec

    PAGESEL task_tmr0_2ms

    BANKSEL program_states
    btfsc program_states, interrupt_tmr0
    call task_tmr0_2ms

    goto main_loop
    END 