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

button_port equ PORTB 
button_pin  equ 0

button_debounce_value  equ  .50
how_many_tmr0_count_1sec    equ .1000
how_many_tmr1_count_change_game equ .24

;status_bits bits 
game_change   equ 5
key_pressed    equ  4
tmr0_1ms_handle  equ 3
move_led    equ 2
change_led_direction   equ 1
tmr1_isr_reached  equ 0 


game_0  equ 1
game_0_how_many_tmr1_mv_led  equ .8


game_1  equ 2
game_2  equ 4


;game_status 
game_change_direction  equ 0
game_blink_led  equ 1


;key_state1
key1_pressed  equ   0
key1_used equ 1