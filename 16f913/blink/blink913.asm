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
    include ../../PicLibDK/macro_time.inc

    global status_bits, w_temp, status_temp, pclath_temp, fsr_temp

    extern change_led, keys_on_int, keys_init, keys_machine_state

    extern blink_led_count_1sec


blink_code    udata 

status_bits res 1 

common_var  udata 
w_temp res 1
status_temp res 1
pclath_temp res 1
fsr_temp  res 1

reset_vector    code   
    PAGESEL init 

    goto init 

isr_vector code
    context_store16f 

    check_tmr0_isr ISR_timer0

    check_tmr1_isr  ISR_timer1

    check_tmr2_isr  ISR_timer2

    check_rb0_int   keys_on_int


ISR_exit 
    context_restore16f

    retfie 

ISR_timer0
    bcf INTCON, TMR0IF

    ;about every 1 ms 

    ;set marker that 1 ms pass
    BANKSEL status_bits
    bsf status_bits, tmr0_1ms_handle

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


main_code code 

main 
    clrwdt
    BANKSEL status_bits    
    btfsc status_bits, move_led
    call change_led

    BANKSEL status_bits    
    btfsc status_bits, tmr0_1ms_handle
    call keys_machine_state

    goto main

init_code code 

init 

    config_watchdog  .13 , 1

    config_porta_digit_16f

    configure_ports_16f  PORTC , b'00000000'

    configure_ports_16f  PORTB,  b'11111111' 

    config_osccon  osccon_internal_2MHZ, osts_internal_clock_startup, scs_internal_clock 

    clear_memory  0x20, 0x5f 
    clear_memory  0xa0, (0xff - 0xa0)

    movlw b'11000000'
    movwf INTCON

    config_tmr1_as_timer  b'01', 1
    nop
    configure_tmr0  b'0', 1 ;prescaler 2 every about 1ms will be tmr0 interruption

    tmr0_interrupt_enable

    movel_2bytes how_many_tmr0_count_1sec, blink_led_count_1sec

    BANKSEL led_port
    movlw start_led_pin 
    movwf led_port

    call keys_init

    PAGESEL main 
    goto main
    END

