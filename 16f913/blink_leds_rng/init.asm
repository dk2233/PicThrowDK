
	list p=16f913
	include	"p16f913.inc"
	__CONFIG _WDT_OFF & _MCLRE_ON & _DEBUG_ON & _IESO_OFF  & _FCMEN_OFF & _PWRTE_ON & _INTOSCIO

    include defines.inc
    include ../../PicLibDK/macro16f_analog_d.inc
    include ../../PicLibDK/macro16f_comparator.inc
    include ../../PicLibDK/macro16f_osccon.inc
    include ../../PicLibDK/macro16f_ports.inc
    include ../../PicLibDK/display/lcd_driver_pic16f.inc
    include ../../PicLibDK/macro_time_tmr1_tmr2.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/memory_operation_16f.inc

    global init 

    extern tmr1_count_to_1sec

init_code code 
init 

    config_ccp_off
    config_comparator_off
    config_lcd_off
    config16f_analog_off

    BANKSEL OPTION_REG
    movlw  b'11000000'
    movwf  OPTION_REG

    ;4 MHz internal OSC used  4/4e6  * 256 * 8 = 2.05 ms => freq = about 488 Hz
    configure_tmr0  b'000', 1 ;8 prescaler
    config_tmr1_as_timer  b'11', 1 ;1:8 prescaler - 4/4e6 * 256 **2 * 8 = 524 ms
    configure_tmr2  2, b'1111', .244 ; 4/4e6 * 16 * 16 * 244 * 16
    configure_ports_16f  PORTC, b'00000000'
    configure_ports_16f  PORTA, b'11111111'

    config_osccon  osccon_internal_4MHZ, osts_internal_clock_startup, scs_internal_clock 

    movlw  b'11000000'
    movwf  INTCON

    config16f_ansel 1
    config16f_analog_on 1, 0, 0, b'001'
    
    clear_memory  0x30, 0x4f 
    clear_memory  0xa0, (0xff - 0xa0)
    clear_memory  0x120, (0x14f - 0x120)

    tmr0_interrupt_disable
    tmr1_interrupt_enable
    BANKSEL tmr1_count_to_1sec
    movlw how_many_tmr1_count_1sec
    movwf tmr1_count_to_1sec

    BANKSEL led_port
    movlw start_led_pin 
    movwf led_port
    return
    END