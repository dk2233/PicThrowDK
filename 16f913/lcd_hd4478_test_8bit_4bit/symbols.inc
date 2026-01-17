
;RA0 - led green
;RA1 - led red
;RA2 - ds18b20 
;RA3 - 
;RA4 - 
;RA5 - 
;RA6 - 
;RA7 - 


;RB7 - ICD
;RB6 - ICD
;RB5 -  
;RB4 -  
;RB3 - 
;RB2 - lcd E
;RB1 - lcd RW
;RB0 - lcd RS




;RC7 - Lcd db7
;RC6 - Lcd db6
;RC5 - Lcd db5
;RC4 - Lcd db4
;RC3 - Lcd db3
;RC2 - Lcd db2
;RC1 - Lcd db1
;RC0 - LCD db0
;led_state
previous_0            equ      4;jezeli jest wlaczony to poprzednia cyfra nie byla wyswietlana bo byla 0
process_led      equ     5 
disable_show     equ 6



;program_states

interrupt_tmr1     equ 0






mcu_freq  equ  .4000000


;status_bits bits 
run_system equ 7


how_many_tmr2_count_1sec    equ .16
how_many_tmr1_count_1sec    equ .2



led_green_port   equ  PORTA 
led_green_pin	 equ 0
led_red_port   equ  PORTA 
led_red_pin	 equ 1

; lcd configuration

#define port_lcd_e    PORTB
#define port_lcd_rw   PORTB
#define port_lcd_rs   PORTB 
#define lcd_port_data   PORTC
#define lcd_enable_pin  2
#define lcd_RW_pin      1
#define lcd_RS_pin      0
#define lcd_TRIS_data   TRISC
#define lcd_location_4_bit_in_H   0

#define func_name_send_data   lcd_handler_send_data
#define func_check_busy       lcd_handler_check_busy
#define lcd_one_line_size    .16

;configuration of ds18b20

port_ds18b20   equ     PORTA
port_pin_ds18b20    equ    2
tris_of_ds18b20_port   equ  TRISA
#define minus_symbol   led_minus