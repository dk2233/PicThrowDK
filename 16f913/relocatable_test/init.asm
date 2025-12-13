
    .file "init.asm"

    list p=16f913
	include	"p16f913.inc"
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/macro_time.inc

common_var    udata  
w_temp  res 1
status_temp res 1
pclath_temp  res  1
fsr_temp  res 1


    extern operandl, operandh, tmr1_count_to_1sec
    global w_temp, status_temp, pclath_temp, fsr_temp
    code
    global init

    include symbols.inc
    include ../../PicLibDK/macro_resets.inc
    include ../../PicLibDK/stacks/macro_stack_operation.inc
    include ../../PicLibDK/math/math_macros.inc
    extern func_div_24bit_16bit
    include ../../PicLibDK/display/macro_value_to_digits.inc
    extern translate_value_to_port_pins
    ;include ../../PicLibDK/display/led_segment.inc
    extern ds18b20_start


init 
    ;config_watchdog  .15, 1
    config_porta_digit_16f

    BANKSEL OPTION_REG
    movlw  b'11000000'
    movwf  OPTION_REG

    ;4 MHz internal OSC used  4/4e6  * 256 * 8 = 2.05 ms => freq = about 488 Hz
    configure_tmr0  b'010', 1 ;8 prescaler
    config_tmr1_as_timer  b'11', 1 ; every interrupt pass 524 ms = about 1 sec after two
    configure_tmr2  2, b'1111', .244 ; 4/4e6 * 16 * 16 * 244 * 16

    configure_ports_16f  PORTA, b'11111100'
    configure_ports_16f  PORTB, b'11000000'
    configure_ports_16f  PORTC, b'00110000'

    ;signal reset 
    BANKSEL led_green_port
    bsf   led_green_port, led_green_pin
; OSCCON set for internal 4MHz	
    config_osccon b'110', 0, 1

	movlw	b'11100000'
	movwf	INTCON


    clear_memory 0x20, 0x5f
    clear_memory 0xa0, 0xef - 0xa0
    clear_memory  0x120,  0x16f - 0x120

    ;call led_digit_init

    BANKSEL tmr1_count_to_1sec
    movlw how_many_tmr1_count_1sec
    movwf tmr1_count_to_1sec

    detect_watchdog_happens 
    xorlw   wdg_reset_reason
    btfss   STATUS,Z 

    goto init2 

    BANKSEL led_red_port
    bsf   led_red_port, led_red_pin

init2
    

    call ds18b20_start
    return
    END
    .eof