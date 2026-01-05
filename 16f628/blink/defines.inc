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



led_port   equ  PORTB 
last_led_pin	 equ  b'00010000'
start_led_pin  equ 1

;status_bits bits 
run_system equ 7
wdg_detected  equ 6
wdg_detected2 equ 5


;status_bits 
tmr1_isr_reached  equ 0 
change_led_direction   equ 1


how_many_tmr1_count_1sec  equ  .2
