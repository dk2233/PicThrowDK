;define for simple test project

;oscilator not used


;ports used

;RA0 - 
;RA1 -	
;RA2 - 
;RA3 - 
;RA4 - NC
;RA5 - NC
;RA6 -  
;RA7 - 


;RB7 - ICD
;RB6 - ICD
;RB5
;RB4
;RB3
;RB2
;RB1
;RB0  - key

;RC7 - leds that will be changed max 8
;Rc6 - led
;RC5 - led
;RC4 - led
;RC3 - led
;RC2 - led
;RC1 - led
;RC0 - led



led_port equ   PORTC
last_led_pin	 equ  b'00010000'
start_led_pin  equ 1

button_debounce_value  equ  .50

;status_bits bits 
run_system equ 7

key_pressed    equ  4
tmr0_1ms_handle  equ 3
move_led    equ 2
change_led_direction   equ 1
tmr2_isr_reached  equ 0 
