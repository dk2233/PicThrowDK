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

    extern init, change_led

    global tmr1_count_to_1sec, status_bits
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



main 
    clrwdt
    BANKSEL status_bits    
    btfsc status_bits, tmr1_isr_reached
    call change_led

    goto main

    END
