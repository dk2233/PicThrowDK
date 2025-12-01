;this program 
;sets interrupts for tmr0
; led segments x4 is controlled
;increased every 1 sec
;gpasm  led_example.asm

	list p=16f913
	include	"p16f913.inc"
	__CONFIG _WDT_OFF & _MCLRE_ON & _DEBUG_ON & _IESO_OFF  & _FOSC_INTOSCIO & _FCMEN_OFF & _PWRTE_ON & _BOREN_OFF
    include defines.inc 
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/macro_time.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc
    include ../../PicLibDK/macro_resets.inc



    org 0000h
    goto init 

    org 0004h
interrupts 
    context_store16f 

    check_tmr0_isr ISR_timer0

    check_tmr1_isr ISR_timer1

    check_tmr2_isr ISR_timer2

ISR_exit
    context_restore16f
    retfie

ISR_timer0
    bcf  INTCON,T0IF
    BANKSEL led_state
    bsf led_state, process_led

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



    include ../../PicLibDK/math/math_function_div.asm
    include ../../PicLibDK/display/led_segment.inc
    include ../../PicLibDK/sensors/ds1820.inc




translate_value_to_port_pins 
    ;portc - 4 lower bits 
    ;portb - 4 lower bits filleds with higher bits from value_for_one_digit_segment

    BANKSEL port_led_L

    movlw  0xf0 
    andwf  port_led_L,f ;clear lower bits
    
    movlw  0xf0 
    andwf  port_led_H,f ;clear lower bits

    MOVF    value_for_one_digit_segment,w  
    andlw   0x0f 

    addwf   port_led_L,f 

    swapf   value_for_one_digit_segment,w 
    andlw   0x0f

    addwf   port_led_H,f  


    return



;TODO move this as increment 16 bit value macro
change_timer_seconds

    BANKSEL program_states
    bcf  program_states, increment_1sec
    
    BANKSEL led_green_port
    bcf   led_green_port, led_green_pin

    bcf  operandl,0
    
    compare2bytes max_value_to_be_displayed, timer_l , operandl, 0 

    btfsc operandl,0
    goto  change_timer_seconds_1 

    movlw 0 
    movwf timer_h
    movwf timer_l
    goto change_timer_seconds_2

change_timer_seconds_1

    BANKSEL timer_l
    incf   timer_l,f 
    btfsc  STATUS,Z 
    incf   timer_h,f

change_timer_seconds_2
    
    movf  timer_l,w 
    movwf number_l
    movf  timer_h,W
    movwf number_h


    call split_number_to_digits

    BANKSEL led_dot_display
    btfsc led_dot_display, light_dot1 
    goto  change_timer_seconds_dot_off 

    bsf   led_dot_display, light_dot1 
    bcf   led_dot_display, light_dot10
    return
    
change_timer_seconds_dot_off
    BANKSEL led_dot_display
    bcf   led_dot_display, light_dot1 
    bsf   led_dot_display, light_dot10

    return


temperature_handle
    BANKSEL program_states
    bcf   program_states, increment_1sec

    BANKSEL led_green_port
    btfsc led_green_port,led_green_pin 
    goto  temperature_handle_led1 

    bsf   led_green_port, led_green_pin
    goto  temperature_handle_led2

temperature_handle_led1
    bcf   led_green_port, led_green_pin

temperature_handle_led2

    BANKSEL ds18_status
    btfss ds18_status,ds18_wait_for_measurement    
    goto   temperature_handle_init_temperature_measurement

    bcf ds18_status, ds18_wait_for_measurement
;read temperature from ds18
    call  ds18_req_scratchpad_read

    BANKSEL ds18_status
    btfss  ds18_status, ds18_crc_fault
    bcf  led_dot_display,light_dot1  

    ;show dot as crc fault

    btfsc  ds18_status, ds18_crc_fault
    bsf  led_dot_display,light_dot1  

    xorlw 0 ; check returned value
    SKPZ ;if not 0 do not refresh temp
    return

    call  ds18_translate_measurements_to_dec

    call ds18_convert_dec_measurement_into_4_digits
    return



temperature_handle_init_temperature_measurement
    call ds18_req_temp_convert
    BANKSEL led_dot_display
    bcf  led_dot_display, light_dot10
    
    BANKSEL ds18_status
    btfsc  ds18_status, ds18_init_error
    goto   temperature_handle_error

    btfsc ds18_configuration, ds18_normal_power
    movlw 1
    btfsc ds18_configuration, ds18_parasite_power
    movlw 0
    movwf  segment_digit1
    
    movwf  segment_digit10
    movlw  led_S
    movwf  segment_digit100
    movlw  0xd
    movwf  segment_digit1000
    return 

temperature_handle_error
    movlw  led_minus
    movwf  segment_digit1
    movwf  segment_digit10
    movwf  segment_digit100

    return

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


    clear_memory segment_digit1, 0x5f
    clear_memory ds18_read_from_RAM, 0x16f - 0x120

    call led_digit_init

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
    
    call ds18_req_id_read
    xorlw 0 
    SKPNZ 
    goto init2_read_id_ok

    BANKSEL  led_red_port
     
    bsf  led_red_port, led_red_pin

init2_read_id_ok
    movlw   .8
    movwf  operandh
    mem_cpy_FSR  ds18_read_from_RAM, ds18_read_id, operandl, operandh

    ;get power type 0xb4
    call  ds18_read_power_supply

    ;get scratchpad 
    call  ds18_req_scratchpad_read 

    BANKSEL  ds18_expected_resolution 
    movlw    .12
    movwf   ds18_expected_resolution
    BANKISEL ds18_read_from_RAM
    movlw  LOW ds18_read_from_RAM
    MOVWF  FSR 
    call ds18_check_resolution
    BANKSEL ds18_expected_resolution
    xorwf   ds18_expected_resolution,w 
    SKPNZ  
    goto tests
    ;set new config
    ds18_set_resolution tmp7

    BANKISEL ds18_read_from_RAM
    movlw  LOW ds18_read_from_RAM
    addlw  DS18B20_TH_byte 
    movwf  FSR 
    movf   INDF,w 
    BANKSEL ds18_TH
    movwf  ds18_TH 
    incf   FSR,f 
    movf   INDF,w 
    movwf  ds18_TL 

    call  ds18_req_scratchpad_write  

;here we will check proper calculations of ds18 procedures   

;both temperature conversion to dec from scratchpad
;+ 
;conversion to decimal digits to display on led or lcd
tests 
    movel_2bytes 0xffe5 , ds18_read_from_RAM
    call  ds18_translate_measurements_to_dec
    compare1byte 0x1, ds18_measured_temp, ds18_error_temp_conversion, 0 
    compare1byte 0x7, ds18_measured_temp_01, ds18_error_temp_conversion, 0 
    call ds18_convert_dec_measurement_into_4_digits
    compare4bytes  0x14000107, segment_digit1, ds18_error_temp_display, 0

    movel_2bytes 0xff60 , ds18_read_from_RAM
    call  ds18_translate_measurements_to_dec
    compare1byte 0xa, ds18_measured_temp, ds18_error_temp_conversion, 1 
    compare1byte 0x0, ds18_measured_temp_01, ds18_error_temp_conversion, 1 
    call ds18_convert_dec_measurement_into_4_digits
    compare4bytes  0x14010000, segment_digit1, ds18_error_temp_display, 1

    movel_2bytes 0xfc90 , ds18_read_from_RAM
    call  ds18_translate_measurements_to_dec
    compare1byte 0x37, ds18_measured_temp, ds18_error_temp_conversion, 2 
    compare1byte 0x0, ds18_measured_temp_01, ds18_error_temp_conversion, 2 
    call ds18_convert_dec_measurement_into_4_digits
    compare4bytes  0x14050500, segment_digit1, ds18_error_temp_display, 2

    movel_2bytes 0xfe6f , ds18_read_from_RAM
    call  ds18_translate_measurements_to_dec
    compare1byte .25, ds18_measured_temp, ds18_error_temp_conversion, 3 
    compare1byte 0x1, ds18_measured_temp_01, ds18_error_temp_conversion, 3 

    call ds18_convert_dec_measurement_into_4_digits
    compare4bytes  0x14020501, segment_digit1, ds18_error_temp_display, 3

    nop
    movel_2bytes 0xfff8 , ds18_read_from_RAM
    call  ds18_translate_measurements_to_dec
    compare1byte .0, ds18_measured_temp, ds18_error_temp_conversion, 4 
    compare1byte 0x5, ds18_measured_temp_01, ds18_error_temp_conversion, 4 
    call ds18_convert_dec_measurement_into_4_digits
    compare4bytes  0x14000005, segment_digit1, ds18_error_temp_display, 4

    movel_2bytes 0x191 , ds18_read_from_RAM
    call  ds18_translate_measurements_to_dec
    compare1byte .25, ds18_measured_temp, ds18_error_temp_conversion, 5 
    compare1byte 0x1, ds18_measured_temp_01, ds18_error_temp_conversion, 5 

    call ds18_convert_dec_measurement_into_4_digits
    compare4bytes  0x020501, segment_digit1, ds18_error_temp_display, 5

    movel_2bytes 0xfd96 , ds18_read_from_RAM
    call  ds18_translate_measurements_to_dec
    compare1byte .38, ds18_measured_temp, ds18_error_temp_conversion, 6 
    compare1byte 0x6, ds18_measured_temp_01, ds18_error_temp_conversion, 6 

    call ds18_convert_dec_measurement_into_4_digits
    compare4bytes  0x14030806, segment_digit1, ds18_error_temp_display, 6
    ;check if any of errors status is not 0
    compare2bytes 0, ds18_error_temp_conversion, led_red_port, led_red_pin


main 
    clrwdt
    BANKSEL program_states
    btfsc program_states, increment_1sec 
    call  temperature_handle
    ;call change_timer_seconds 

    btfsc led_state, process_led
    call refresh_led

    ;bcf  led_state, process_led


    goto main 
    END





