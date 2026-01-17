
	list p=16f913
	include	"p16f913.inc"
	__CONFIG _WDT_OFF & _MCLRE_ON & _DEBUG_ON & _IESO_OFF  & _FOSC_INTOSCIO & _FCMEN_OFF & _PWRTE_ON & _BOREN_OFF

    include defines.inc
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/display/lcd_driver_pic16f.inc
    include ../../PicLibDK/macro_resets.inc
    include ../../PicLibDK/stacks/macro_stack_operation.inc

    
    org   000h
    PAGESEL init 
    goto init

    org  0004h
vector_table
    context_store16f

    ; isr handling
    check_tmr0_isr  ISR_timer0
    
ISR_exit
    context_restore16f


    retfie


ISR_timer0
    bcf INTCON,T0IF
    clrwdt
ISR_timer0_1
    goto ISR_exit

    org 800h
init 

    ;config_porta_digit_16f
    ;config_watchdog  .10, 1

    lcd_config_lcdcon  b'11', b'11'
    lcd_config_lcdps  0, 0, 3

    lcd_config_lcdsegments LCDSE0, 0xff
    lcd_config_lcdsegments LCDSE1, 0x0


    BANKSEL OPTION_REG

	movlw	b'11000000'
	movwf	OPTION_REG

    configure_tmr0   .7, .1


    configure_ports_16f  PORTA, b'11111111'
    configure_ports_16f  PORTB, b'11111111'
    configure_ports_16f  PORTC, b'11111111'


    config_osccon b'110', 0, 1
	movlw	b'11000000'
	movwf	INTCON

    
    clear_memory  status_bits,0x7f - 0x20 ; here status_bits is cleared



init2
    clear_memory 0xa0,10
    clear_memory 0x120, 0x16f - 0x120 
    
    ;end init

    BANKSEL status_bits
    ;run marked
    bsf status_bits, run_system


    PAGESEL main 
    goto main 


;loop
main 
    goto main 

    END