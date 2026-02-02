    list p=16f913
    include "p16f913.inc"


    include symbols.inc

    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/stacks/macro_stack_operation.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/display/led_defines.inc
    include ../../PicLibDK/display/macro_value_to_digits.inc
    include ../../PicLibDK/display/macro_lcd_hd4478.inc

ds18_udata udata

ds18_config_byte   res 1 
ds18_configuration  res 1
ds18_status  res 1
ds18_command_to_be_send  res 1
ds18_number_of_bytes  res 1
ds18_id_bit  res  1
ds18_id_which_byte  res 1
ds18_id_RAM_offset res 1
ds18_received_id_bit_count  res 1
ds18_number_of_receive_bytes res 1 

ds18_number_of_sensors  res 1
ds18_CRC_result  res 1

ds18_measured_temp_01 res 1 
ds18_measured_temp    res 1

ds18_TH res 1 
ds18_TL res 1
ds18_expected_resolution res 1
ds18_which_sensor_id_measure_offset res 1
ds18_which_sensor_count  res 1
n_bit  res 1 
ds18_tmp res 2
ds18_nr_on_lcd_line  res 1
ds18_address_line   res 1
;temperature_handle_choose_id res 1 


;this has to be located in one of continous sections
ds18_ids udata
ds18_read_from_RAM res 9
ds18_read_id_1 res 8 
ds18_read_id_2 res 8 
ds18_read_id_3 res 8 
ds18_read_id_4 res 8 
ds18_read_id_5 res 8 
ds18_read_id_6 res 8 
ds18_read_id_7 res 8 
ds18_read_id_8 res 8 

    extern result_001, result_01, result_ll, result_lh , result_hl, result_H 
    extern fraction_l, fraction_h, stack_sp, stack_of_differences 
    extern number_l, number_h
    extern operandl, operandh
    extern tmp7
    extern program_states
    extern segment_digit

    extern func_div_24bit_16bit
    extern lcd_handler_set_address_ddram, lcd_handler_write_data, lcd_handler_home
    
;global variables
    global ds18_read_id_1, ds18_read_id_2, ds18_read_id_3, ds18_read_id_4, ds18_read_id_5
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
    global ds18_search_rom_all_sensors 
    global ds18_req_scratchpad_read, ds18_req_scratchpad_write, ds18_read_power_supply
    global init_ds1820, check_ds_processing, ds18_match_or_skip_rom, ds18_req_temp_convert
    global ds18_req_id_read, ds18_search_rom, ds18_send_request_loop_send_byte_start
    global ds18_check_resolution


ds18_tab_code code
    include ../../PicLibDK/sensors/ds1820_fraction_tab.inc

ds18_code    CODE 
    include ../../PicLibDK/sensors/ds1820_main.inc
    include ../../PicLibDK/sensors/ds1820_searchROM.inc
    include ../../PicLibDK/sensors/ds1820_req_id_read.inc
    include ../../PicLibDK/sensors/ds1820_readpower.inc
    include ../../PicLibDK/sensors/ds1820_resolution.inc
    include ../../PicLibDK/sensors/ds1820_scratchpad_write.inc







temperature_handle_ds18_conversion_lcd
    ds18_convert_dec_measurement_into_4_digits_display  segment_digit, number_l
    
    BANKSEL segment_digit
    movlw   segment_digit+3
    movwf  FSR

    banksel ds18_status
    movf ds18_nr_on_lcd_line,w
    xorlw lcd_number_of_ds_meas_one_line
    SKPZ 
    goto temperature_handle_ds18_conversion_lcd_0
    clrf ds18_nr_on_lcd_line

    movlw lcd_address_second_line
    xorwf ds18_address_line,w 
    movwf ds18_address_line
    call lcd_handler_set_address_ddram
    
temperature_handle_ds18_conversion_lcd_0
    incf ds18_nr_on_lcd_line,f
    movlw "a"
    addwf ds18_which_sensor_count,w
    incf ds18_which_sensor_count,f
    call lcd_handler_write_data

    btfss ds18_status, ds18_below_zero
    goto temperature_handle_ds18_conversion_lcd_1

    movlw  "-"
    call lcd_handler_write_data

temperature_handle_ds18_conversion_lcd_1

    movf   INDF,w
    SKPNZ 
    goto temperature_handle_ds18_conversion_lcd_2  
    addlw  0x30
    call lcd_handler_write_data
temperature_handle_ds18_conversion_lcd_2
    movlw segment_digit+2
    xorwf FSR,w 
    SKPNZ 
    goto temperature_handle_ds18_conversion_lcd_3
    decf  FSR,f 
    goto temperature_handle_ds18_conversion_lcd_1

temperature_handle_ds18_conversion_lcd_3    
    decf FSR,f
    movf INDF,w
    addlw 0x30 
    call lcd_handler_write_data

    movlw "." 
    call lcd_handler_write_data

    decf FSR,f
    movf INDF,w
    addlw 0x30 
    call lcd_handler_write_data

    movlw  0xdf
    call lcd_handler_write_data

    movlw "C"
    call lcd_handler_write_data


    return 


ds18b20_start
    BANKSEL ds18_configuration
    
    movlw lcd_address_first_line
    movwf ds18_address_line

    call ds18_search_rom_all_sensors

    bsf  ds18_configuration, ds18_multiple_sensors

    movlw LOW ds18_read_id_1
    movwf FSR 
    movwf ds18_which_sensor_id_measure_offset
    BANKISEL ds18_read_id_1
    ;get power type 0xb4
    call  ds18_read_power_supply

    movlw LOW ds18_read_id_1
    movwf FSR 
    BANKISEL ds18_read_id_1
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
     return
    ;set new config
    ;ds18_set_resolution tmp7

    movlw  LOW ds18_read_from_RAM
    addlw  DS18B20_TH_byte 
    movwf  FSR 
    BANKISEL ds18_read_from_RAM
    movf   INDF,w 
    BANKSEL ds18_TH
    movwf  ds18_TH 
    incf   FSR,f 
    movf   INDF,w 
    movwf  ds18_TL 

    call  ds18_req_scratchpad_write  
    return

ds18_temperature_handle_choose_id

    BANKSEL ds18_which_sensor_id_measure_offset
    movf    ds18_which_sensor_id_measure_offset,w 
    BANKISEL ds18_read_id_1
    movwf FSR 

    movf  INDF,w 
    SKPZ 
    return

    movlw LOW ds18_read_id_1
    BANKSEL ds18_which_sensor_id_measure_offset
    movwf ds18_which_sensor_id_measure_offset
    movwf FSR 
    clrf ds18_which_sensor_count
    clrf ds18_nr_on_lcd_line
    movlw lcd_address_first_line
    movwf ds18_address_line
    call lcd_handler_home
    return

ds18_temperature_handle
    BANKSEL ds18_status
    btfss ds18_status,ds18_wait_for_measurement    
    goto   temperature_handle_init_temperature_measurement

    bcf ds18_status, ds18_wait_for_measurement
;read temperature from ds18
    call ds18_temperature_handle_choose_id
    call  ds18_req_scratchpad_read
    movwf result_ll

    movlw DS18B20_id_size
    BANKSEL ds18_which_sensor_id_measure_offset
    addwf ds18_which_sensor_id_measure_offset,f

    BANKSEL ds18_status
    ;btfss  ds18_status, ds18_crc_fault
    ;show dot as crc fault

    ;btfsc  ds18_status, ds18_crc_fault
    ;bsf  led_dot_display,light_dot1  
    ;check result
    movf  result_ll,w 
    xorlw 0 ; check returned value
    SKPZ ;if not 0 do not refresh temp
    return

    call  ds18_translate_measurements_to_dec

    PAGESEL temperature_handle_ds18_conversion_lcd
    call temperature_handle_ds18_conversion_lcd
    ;BANKSEL led_dot_display
    ;bsf led_dot_display, light_dot10
    return



temperature_handle_init_temperature_measurement
    call ds18_temperature_handle_choose_id

    call ds18_req_temp_convert
    
    BANKSEL ds18_status
    btfsc  ds18_status, ds18_init_error
    goto   temperature_handle_error

    ;btfsc ds18_configuration, ds18_normal_power
    ;movlw 1
    ;btfsc ds18_configuration, ds18_parasite_power
    ;movlw 0
    return 

temperature_handle_error
    movlw  led_minus
    BANKSEL segment_digit
    movwf  segment_digit
    movwf  segment_digit+1
    movwf  segment_digit+2

    return
    END