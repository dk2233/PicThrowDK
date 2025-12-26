
	__CONFIG _WDT_OFF   & _FOSC_XT & _PWRTE_ON 
	include	"p16f84a.inc"
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/interrupts_common.inc
    include ../../PicLibDK/interrupts_rb0.inc

    include ../../PicLibDK/ports_macro.inc
    include ../../PicLibDK/macro_time_common.inc



    code
    global init

    include symbols.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc
    ;extern ds18b20_start
    extern led_digit_init
    extern func_div_24bit_16bit
    extern translate_value_to_port_pins


    extern tmr0_count_to_1sec


init 


    disable_pull_up
    rb0_int_disable
    ;10 MHz quartz OSC used  4/10e6  * 256 * 256 = 26.2 ms
    configure_tmr0  b'111', 1 ;256 prescaler

    configure_ports_16f  PORTA, b'11110000'
    configure_ports_16f  PORTB, b'00000000'

    enable_all_isr
    bsf INTCON, TMR0IE

    clear_memory 0x0c, 0x4f

    movlw how_many_tmr0_count_1sec
    movwf tmr0_count_to_1sec

    call led_digit_init

    ;call ds18b20_start
    return
    END
    ;.eof