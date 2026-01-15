
	list p=16f628a
	include	"p16f628a.inc"
	__CONFIG _WDT_OFF & _MCLRE_ON & _LVP_OFF & _BOREN_OFF &  _PWRTE_ON & _INTOSC_OSC_NOCLKOUT

    include defines.inc
    ;include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/init16f_common.inc
    include ../../PicLibDK/macro_time_tmr1_tmr2.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/memory_operation_16f.inc

    global init 

    extern tmr1_count_to_1sec

init_code code 
init 

    config_ccp_off
    config_comparator_off

    BANKSEL OPTION_REG
    movlw  b'11000000'
    movwf  OPTION_REG

    ;4 MHz internal OSC used  4/4e6  * 256 * 8 = 2.05 ms => freq = about 488 Hz
    configure_tmr0  b'010', 1 ;8 prescaler
    config_tmr1_as_timer  b'11', 1 ;1:8 prescaler - 4/4e6 * 256 **2 * 8 = 524 ms
    configure_tmr2  2, b'1111', .244 ; 4/4e6 * 16 * 16 * 244 * 16
    configure_ports_16f  PORTB, b'00000000'
    configure_ports_16f  PORTA, b'11110000'

    ;BANKSEL PIE1 
    ;bsf  PIE1, TMR1IE

    movlw  b'11000000'
    movwf  INTCON

    
    ;config_watchdog  .13 , 1

    clear_memory  0x30, 0x5f 
    clear_memory  0xa0, (0xff - 0xa0)
    clear_memory  0x120, (0x14f - 0x120)

    BANKSEL tmr1_count_to_1sec
    movlw how_many_tmr1_count_1sec
    movwf tmr1_count_to_1sec

    BANKSEL led_port
    movlw start_led_pin 
    movwf led_port
    return
    END