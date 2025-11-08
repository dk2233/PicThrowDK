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

;RC7 - led display 8 segment
;Rc6
;RC5
;RC4
;RC3
;RC2
;RC1
;RC0  

;
;include "p16f873.inc"

	cblock 20h
	var1
	errors_mul_8bit
	errors16bit
	errors_sum_loop

	status_bits 

	endc
	;common variables for all banks
	cblock	70h
	w_temp
	status_temp
	pclath_temp
	temp_var
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
	timer_l
	temp_l
	temp_lh
	temp_hl
	temp_hh
	A_low
	A_high
	B_low
	B_high



	endc


freq 	equ 10000000

led_green_port   equ  PORTA 
led_green_pin	 equ 0

led_red_port   equ  PORTA 
led_red_pin    equ 1

;status_bits bits 
