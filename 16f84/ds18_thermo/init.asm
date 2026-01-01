
	__CONFIG _WDT_OFF   & _FOSC_XT & _PWRTE_ON 
	include	"p16f84a.inc"
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/interrupts_common.inc
    include ../../PicLibDK/interrupts_rb0.inc

    include ../../PicLibDK/ports_macro.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/display/led_defines.inc



    code
    global init

    include symbols.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc
    extern ds18b20_start
    extern led_digit_init
    extern func_div_24bit_16bit
    extern translate_value_to_port_pins
    extern segment_digit


    extern tmr0_count_to_1sec


init 


    disable_pull_up
    rb0_int_disable
    ;4 MHz quartz OSC used  4/4e6  * 256 * 128 = 32 ms
    configure_tmr0  b'110', 1 ;128 prescaler

    configure_ports_16f  PORTA, b'11110000'
    configure_ports_16f  PORTB, b'00000000'

    enable_all_isr
    bsf INTCON, TMR0IE

    clear_memory 0x0c, 0x4f

    movlw how_many_tmr0_count_1sec
    movwf tmr0_count_to_1sec

    call led_digit_init

    movlw  led_null
    movwf  segment_digit
    movwf  segment_digit+1

    movwf  segment_digit+2

    movwf  segment_digit+3

    call ds18b20_start
    return
    END