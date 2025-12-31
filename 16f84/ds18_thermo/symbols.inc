
;RA0 - LED CC 1
;RA1 - LED CC 10
;RA2 -  IW
;RA3 - 
;RA4 - ds18b20


;RB7 - LED /ICD
;RB6 - LED /ICD
;RB5 - LED CC 1000
;RB4 - LED CC 100
;RB3 - LED
;RB2 - LED
;RB1 - LED
;RB0 - LED 




;led_state
previous_0            equ      4;jezeli jest wlaczony to poprzednia cyfra nie byla wyswietlana bo byla 0
process_led      equ     5 
disable_show     equ 6



;program_states

tmr0_interrupt     equ 0


how_many_tmr0_count_1sec  equ  .31



mcu_freq  equ  .4000000




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


;configuration of ds18b20

port_ds18b20   equ     PORTA
port_pin_ds18b20    equ    4
tris_of_ds18b20_port   equ  TRISA
#define minus_symbol   led_minus
#define DS18_CHECK_BUSY_AFTER_CONVERT_START