;define for simple test project


;ports used

;RA0 - 
;RA1 -	
;RA2 - 
;RA3 - 
;RA4 - NC
;RA5 - NC
;RA6 - osc 
;RA7 - osc


;RB7 - ICD
;RB6 - ICD
;RB5
;RB4
;RB3
;RB2
;RB1
;RB0  

;RC7 - leds that will be changed max 8
;Rc6
;RC5
;RC4
;RC3
;RC2
;RC1
;RC0  


	cblock 20h

	status_bits



	endc
	;common variables for all banks
	cblock	70h
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



led_port   equ  PORTC 
last_led_pin	 equ  b'00001000'
start_led_pin  equ 1

;status_bits bits 
run_system equ 7
wdg_detected  equ 6
wdg_detected2 equ 5


;status_bits 
tmr2_isr_reached  equ 0 
change_led_direction   equ 1
