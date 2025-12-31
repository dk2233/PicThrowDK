	include	"p16f84a.inc"

    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/stacks/macro_stack_operation.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/interrupts_common.inc
    include ../../PicLibDK/display/led_defines.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc

;27 + 17 + 9 
ds18_udata udata

ds18_config_byte   res 1 
ds18_configuration  res 1
ds18_status  res 1
ds18_command_to_be_send  res 1
ds18_number_of_bytes  res 1
ds18_id_bit  res  1
ds18_id_which_byte  res 1
;ds18_id_RAM_offset res 1
ds18_received_id_bit_count  res 1
ds18_number_of_receive_bytes res 1 

ds18_number_of_sensors  res 1
ds18_CRC_result  res 1

ds18_measured_temp_01 res 1 
ds18_measured_temp    res 1

ds18_which_sensor_id_measure_offset res 1
ds18_which_sensor_count  res 1
n_bit  res 1 
ds18_tmp res 1
;temperature_handle_choose_id res 1 


;this has to be located in one of continous sections
ds18_ids udata
ds18_read_from_RAM res 9
ds18_read_id_1 res 8
ds18_read_id_2 res 8 
;ds18_read_id_3 res 8 

    extern result_001, result_01, result_ll, result_lh , result_hl, result_H 
    extern fraction_l, fraction_h 
    extern number_l, number_h
    extern operandl, operandh
    extern value_for_one_digit_segment, segment_digit
    extern program_states
    extern led_dot_display
    extern tmr0_count_to_1sec


    extern func_div_24bit_16bit

    
;global variables
    global ds18_read_from_RAM
    global ds18_CRC_result
    global ds18_status
    global ds18_which_sensor_count
    global ds18_received_id_bit_count



;functions global
    global ds18_translate_measurements_to_dec, ds18_receive_data_from_sensor, check_CRC_DS
    global PIN_HI, PIN_LO, send_bit_1, send_bit_0
    global ds18_temperature_handle
    global ds18b20_start
    global ds18_req_scratchpad_read
    global init_ds1820, ds18_match_or_skip_rom, ds18_req_temp_convert
    global ds18_send_request_loop_send_byte_start


ds18_tab_code code
    include ../../PicLibDK/sensors/ds1820_fraction_tab.inc

ds18_code    CODE 
    include symbols.inc
    include ../../PicLibDK/sensors/ds1820_main.inc
    ;include ../../PicLibDK/sensors/ds1820.inc







temperature_handle_ds18_conversion_led

    ds18_convert_dec_measurement_into_4_digits_display  segment_digit, number_l
    return 


ds18b20_start

    BANKSEL ds18_configuration
    bcf  ds18_configuration, ds18_multiple_sensors

    ;get scratchpad 
    ;call  ds18_req_scratchpad_read 

    return

ds18_temperature_handle
    BANKSEL program_states
    bcf   program_states, tmr0_interrupt

    decfsz tmr0_count_to_1sec,f 
    return 

    movlw how_many_tmr0_count_1sec
    movwf tmr0_count_to_1sec

    BANKSEL ds18_status
    btfss ds18_status,ds18_wait_for_measurement    
    goto   temperature_handle_init_temperature_measurement

    bcf ds18_status, ds18_wait_for_measurement
;read temperature from ds18
    call  ds18_req_scratchpad_read
    movwf result_ll

    BANKSEL ds18_status
    btfss  ds18_status, ds18_crc_fault
    bcf  led_dot_display,light_dot1  

    ;show dot as crc fault

    btfsc  ds18_status, ds18_crc_fault
    bsf  led_dot_display,light_dot1  
    ;check result
    movf  result_ll,w 
    xorlw 0 ; check returned value
    SKPZ ;if not 0 do not refresh temp
    return

    call  ds18_translate_measurements_to_dec

    PAGESEL temperature_handle_ds18_conversion_led
    call temperature_handle_ds18_conversion_led
    BANKSEL led_dot_display
    bsf led_dot_display, light_dot10
    return



temperature_handle_init_temperature_measurement
    ;call ds18_temperature_handle_choose_id

    call ds18_req_temp_convert
    bcf  led_dot_display, light_dot10
    
    btfsc  ds18_status, ds18_init_error
    goto   temperature_handle_error

    ;btfsc ds18_configuration, ds18_normal_power
    ;movlw 1
    ;btfsc ds18_configuration, ds18_parasite_power
    movlw  led_null
    movwf  segment_digit+1
    ;movf   ds18_which_sensor_count,w
    movwf  segment_digit
    movlw  led_S
    movwf  segment_digit+2
    movlw  0xd
    movwf  segment_digit+3
    return 

temperature_handle_error
    movlw  led_minus
    movwf  segment_digit
    movwf  segment_digit+1
    movwf  segment_digit+2
    movlw  led_e 
    movwf   segment_digit+3

    return
    END