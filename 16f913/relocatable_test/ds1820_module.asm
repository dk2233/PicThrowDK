    .file "ds1820"
    list p=16f913
	include	"p16f913.inc"

    ;include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/stacks/macro_stack_operation.inc
    include ../../PicLibDK/macro_time.inc
    include ../../PicLibDK/interrupts.inc
ds18_udata udata
ds18_config_byte   res 1 
ds18_configuration  res 1
ds18_number_of_bytes  res 1
ds18_command_to_be_send  res 1
ds18_id_bit  res  1
ds18_id_which_byte  res 1
ds18_id_RAM_offset res 1
ds18_number_of_sensors  res 1
ds8_CRC_result  res 1
ds18_status  res 1
ds18_measured_temp_01 res 1 
ds18_measured_temp    res 1
ds18_number_of_receive_bytes res 1 
ds18_received_id_bit_count  res 1
ds18_read_from_RAM res 9
ds18_read_one_id res  8
ds18_read_id_1 res 8 
ds18_read_id_2 res 8 
ds18_read_id_3 res 8 
ds18_TH res 1 
ds18_TL res 1
ds18_expected_resolution res 1
value_for_one_digit_segment res 1

n_bit  res 1 


    extern result_001, result_01, result_ll, result_lh , result_H 
    extern fraction_l, fraction_h, stack_sp, stack_of_differences 
    extern number_l, number_h
    extern operandl, operandh
    extern compare_two_registers
    extern tmp7

    





    global translate_value_to_port_pins
    global ds18_read_id_1
    global ds18_read_one_id
    global ds18b20_start
    global value_for_one_digit_segment

    CODE 
    
    include ../../PicLibDK/sensors/ds1820.inc
    include symbols.inc





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

ds18b20_start
    call ds18_req_id_read
    xorlw 0 
    SKPNZ 
    goto init2_read_id_ok

    BANKSEL  led_red_port
     
    bsf  led_red_port, led_red_pin

init2_read_id_ok
    movlw   .8
    movwf  operandh
    mem_cpy_FSR  ds18_read_from_RAM, ds18_read_one_id, operandl, operandh

    call ds18_search_rom_all_sensors

    BANKSEL ds18_configuration
    bsf  ds18_configuration, ds18_multiple_sensors

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
     return
    ;set new config
    ;ds18_set_resolution tmp7

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
    END
    .eof