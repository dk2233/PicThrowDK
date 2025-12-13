;definicje do licznika


;porty licznika

;RA0 - 
;RA1 - 
;RA2 - 
;RA3 - 
;RA4 - 
;RA5 - 
;RA6 - 
;RA7 - 


;RB7 - ICD
;RB6 - ICD
;RB5 - LED CC 1000
;RB4 - LED CC 100
;RB3 - LED
;RB2 - LED
;RB1 - LED
;RB0 - LED 




;RC7 - 
;RC6 - 
;RC5 - LED CC 10
;RC4 - LED CC 1
;RC3 - LED
;RC2 - LED
;RC1 - LED
;RC0 - LED

         cblock 20h
         segment_digit1
         segment_digit10
         segment_digit100
         segment_digit1000
         
         leds_common
         led_state ; leds_common state - which digit, 
         led_dot_display ; each bits 
         
         value_for_one_digit_segment     
         
         program_states
         
         tmr1_count_to_1sec
         tmr2_count_to_1sec
         timer_l
         timer_h
         
	temp_l
	temp_lh
	temp_hl
	temp_hh
	A_low
	A_high
	B_low
	B_high

    tmp7
    ;definitions related to ds18b20 measurements
    ds8_CRC_result
    n_bit 
    ds18_status
    ds18_configuration
    ds18_number_of_receive_bytes 
    ds18_number_of_bytes
    ds18_command_to_be_send
    ds18_measured_temp
    ds18_measured_temp_01

    ds18_TH ;first byte that will be write to ds18b20
    ds18_TL
    ds18_config_byte
    ds18_expected_resolution

    ds18_error_temp_conversion
    ds18_error_temp_display
    ds18_number_of_sensors
    ds18_which_sensor_id_measure_offset
    ds18_which_sensor_count
    ds18_received_id_bit_count
    ds18_id_bit
    ds18_id_which_byte
    ds18_id_RAM_offset

         endc
         
         cblock   70h
         w_temp
         status_temp
         pclath_temp
         fsr_temp
	result_001
	result_01
	result_ll
	result_lh
	result_hl
	result_H
	operandl
	operandh

	fraction_l
	fraction_h
	number_l
	number_h
         endc     
         


        cblock 0xa0
        ds18_read_from_RAM : 9; tablica odebranych bajtów
        ds18_read_one_id:8
        stack_sp
        stack_of_differences:8



        endc 

        cblock 120h 
        ds18_read_id_1:8
        ds18_read_id_2:8
        ds18_read_id_3:8
        ds18_read_id_4:8
        ds18_read_id_5:8
        ds18_read_id_6:8

        endc

        cblock 198h
        endc
        



