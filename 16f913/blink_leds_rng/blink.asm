;this program blinks 
; a few leds connected to one of the ports
;different light effects



   
	list p=16f913
	include	"p16f913.inc"

    include defines.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/macro_random.inc

common_var udata
w_temp res 1
status_temp res 1
pclath_temp  res 1
fsr_temp res 1
status_bits  res 1    

blink_ud udata
tmr1_count_to_1sec  res 1
rng_seed  res 2 

    extern init, change_led, rand_generate

    global tmr1_count_to_1sec, status_bits, rng_seed
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
    
    rand_8bit_init rng_seed
    goto main



main 
    clrwdt
    BANKSEL status_bits    
    btfsc status_bits, tmr1_isr_reached
    call change_led

    ;BANKSEL rng_seed
    ;btfsc rng_seed,3
    ;movlw 1 
    ;btfsc rng_seed,5
    ;movlw 3
    ;addwf rng_seed,f
    ;SKPC 

    call rand_generate


    goto main

    END
