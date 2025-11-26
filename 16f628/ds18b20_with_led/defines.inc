;definicje do licznika


;porty licznika

;RA0 - LED CC 1
;RA1 - LED CC 10
;RA2 - LED CC 100
;RA3 - LED CC 1000
;RA4 - 
;RA5 - 
;RA6 - 
;RA7 - 


;RB7 - ICD + LED 
;RB6 - ICD + LED
;RB5 - LED  
;RB4 - LED 
;RB3 - LED
;RB2 - LED
;RB1 - LED
;RB0 - LED 




;RC7 - 
;RC6 - 
;RC5 - 
;RC4 - 
;RC3 - 
;RC2 - 
;RC1 - 
;RC0 - 

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
         
         
         tmr2_count_to_1sec
         timer_l
         timer_h
         
	var2
	temp_l
	temp_lh
	temp_hl
	temp_hh
	A_low
	A_high
	B_low
	B_high

	count_to_test
	wdg_timeout_marker
    status_bits
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
         


        cblock 120h

        endc 

        


;led_state
previous_0            equ      4;jezeli jest wlaczony to poprzednia cyfra nie byla wyswietlana bo byla 0
process_led      equ     5 
disable_show     equ 6



;program_states

increment_1sec     equ 0
przerwanie_t1     equ      2
przerwanie_t0     equ      3
sudo_menu       equ      7 
                                ;oznaczane jezeli juz skopiowalem cyfry do temp









;status_bits bits 
run_system equ 7


how_many_tmr2_count_1sec    equ .16



;configuration of LED procedure
#define LED_SEGMENT  .4

;ledy
led1              equ      0
led10             equ      1
led100            equ      2
led1000           equ      3

port_led          equ      PORTB 

segment_digit1_port       equ      PORTA
segment_digit1b           equ      0

segment_digit10_port      equ      PORTA
segment_digit10b          equ      1

segment_digit100_port     equ      PORTA
segment_digit100b         equ      2

segment_digit1000_port    equ      PORTA
segment_digit1000b        equ      3

max_value_to_be_displayed   equ  .9999