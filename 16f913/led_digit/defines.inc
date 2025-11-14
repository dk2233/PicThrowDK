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
;RC3 - przycisk
;RC2 - grzałka
;RC1 - DATownik - tzn printer
;RC0 - buzzer_port

         cblock 20h
         segment_digit1
         segment_digit10
         segment_digit100
         segment_digit1000
         
         leds_common
         value_for_one_digit_segment
         segment_digit1_temp
         segment_digit10_temp
         segment_digit100_temp
         segment_digit1000_temp
         ktora_segment_digit
         ktora_segment_digit_set
         port_change
         zegar_miganie
         zegar4
         zegar3_off
         
         zegar_tmr2
         zegar_tmr1
         
         temp_B;czasowo dla portb
         temp_C;czasowo dla portc
         temp_1
         led_state ; leds_common state - which digit,  
         program_states
         sygnaly
         stan_RB7
         
         litera1
         litera2
         litera3
         litera4
         
         
         znaczniki_startu
         n
         co_pokazuje_menu
         pozycja_menu
         ktora_probka
         wynik_pomiaru_h
         wynik_pomiaru_l
         wynik_pomiaru_01
         segment_digit_temp1
         segment_digit_temp10
         segment_digit_temp100
         segment_digit_temp1000
         
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

        

button_port     equ     PORTC
button          equ     3


led_green_port   equ  PORTA 
led_green_pin	 equ 0



nadpradowy_port   equ      PORTB
nadpradowy        equ      0



;domyslnie jest to portA 

;dla pic16f876
;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;
;domyslnie        jest to porta6
;dla pic16f876
;        IF       procek==1


;        ENDIF

;dla pic16f916
;        IF       procek==2
;button_port      equ      PORTC
;button           equ      3

;        ENDIF




;dla pic16f916


;ktora_cyfra
inc1              equ      0
inc10             equ      1
inc100            equ      2
inc1000           equ      3


;led_state
key_down_1000    equ      0 ;1
key_zero         equ      1 ;10
key_up_10        equ      2 ;100
key_reset    equ      3 ;1000
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
#define LED_SEGMENT  .4

;ledy
led1              equ      0
led10             equ      1
led100            equ      2
led1000           equ      3

leds_start        equ      b'00001000'

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