
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






mcu_freq  equ  .4000000


;status_bits bits 
run_system equ 7


how_many_tmr2_count_1sec    equ .16
how_many_tmr1_count_1sec    equ .2



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

max_value_to_be_displayed   equ  .9999


;configuration of ds18b20

port_ds18b20   equ     PORTA
port_pin_ds18b20    equ    2
tris_of_ds18b20_port   equ  TRISA