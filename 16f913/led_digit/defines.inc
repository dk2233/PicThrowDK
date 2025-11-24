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
;RB5 - LED CC 
;RB4 - LED CC
;RB3 - LED
;RB2 - LED
;RB1 - LED
;RB0 - LED 




;RC7 - 1000
;RC6 - 100
;RC5 - 10
;RC4 - 1
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
         led_dot_display
         
         value_for_one_digit_segment
         zegar_miganie
         zegar4
         zegar3_off
         
         zegar_tmr2
         zegar_tmr1
         
         temp_B;czasowo dla portb
         temp_C;czasowo dla portc
         temp_1
         program_states
         sygnaly
         
         
         
         
         tmr2_count_to_1sec
         timer_l
         timer_h
         
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


how_many_tmr2_count_1sec    equ .31




led_green_port   equ  PORTA 
led_green_pin	 equ 0
led_red_port   equ  PORTA 
led_red_pin	 equ 1

;configuration of LED procedure
#define LED_SEGMENT  .3

;ledy
led1              equ      0
led10             equ      1
led100            equ      2
led1000           equ      3

port_led_L          equ      PORTC ; 4 bits lower
port_led_H          equ      PORTB

segment_digit1_port       equ      PORTC
segment_digit1b           equ      6

segment_digit10_port      equ      PORTC
segment_digit10b          equ      7

segment_digit100_port     equ      PORTB
segment_digit100b         equ     4

segment_digit1000_port    equ      PORTB
segment_digit1000b        equ      5

max_value_to_be_displayed   equ  .999