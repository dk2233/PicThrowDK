
;this program 
;sets WDT, debug access,
;clear GPRS using macro
;sets interrupts for tmr0
;
;it is also a test of math procedures
; to build
;gpasm  simple913.asm

	list p=16f913
	include	"p16f913.inc"
	__CONFIG _WDT_OFF & _MCLRE_ON & _DEBUG_ON & _IESO_ON  & _HS_OSC & _FCMEN_ON & _PWRTE_ON

    include defines.inc
    include ../../libs/memory_operation_16f.inc
    include ../../libs/interrupts.inc
    include ../../libs/math_macros.inc
    include ../../libs/init16f.inc
    include ../../libs/macro_time.inc

    
    org   000h
    PAGESEL init 
    goto init

    org  0004h
vector_table
    context_store16f

    ; isr handling
    BANKSEL INTCON
    PAGESEL ISR_timer0
    
    btfsc INTCON,T0IF 
    goto  ISR_timer0

ISR_exit
    context_restore16f


    retfie

    PAGESEL init
    goto init
    include ../../libs/math_function_multiplication.asm
    include ../../libs/multiplication_16f_loop.asm
    include ../../libs/math_function_div.asm

ISR_timer0
    bcf INTCON,T0IF
    BANKSEL timer_l
    incf timer_l,f 
    IFNDEF WDG_TEST
     clrwdt ; this comment to be able to test WDG detection
    ENDIF
    BANKSEL count_to_test
    movf count_to_test,w
    SKPNZ 
    goto  ISR_timer0_1

    BANKSEL count_to_test
    decf  count_to_test,f
    clrwdt
ISR_timer0_1
    goto ISR_exit

    org 800h
init 

    config_watchdog  .10, 1
    config_porta_digit_16f

    BANKSEL OPTION_REG

	movlw	b'11000000'
	movwf	OPTION_REG

    configure_tmr0   .7, .1


    configure_ports_16f  PORTA, b'11111100'
    configure_ports_16f  PORTB, b'11111111'
    configure_ports_16f  PORTC, b'11111111'

    BANKSEL  OSCCON
; OSCCON set for XT 4MHz	
	movlw	b'01101110'
    movwf  OSCCON

	movlw	b'11101000'
	movwf	INTCON


    clear_memory  var1,0x5f ; here status_bits is cleared

    BANKSEL var2
    movlw  0
    movwf  var2
    ;detect that wdg timeout occurs if bit is not set = same
    compare1byte_set_when_same  run_system_marker,  SFR_to_detect_WDG, status_bits, wdg_detected

    BANKSEL status_bits
    btfss  status_bits, wdg_detected
    goto init2 


    compare1byte_set_when_same  run_system_marker, wdg_timeout_marker, status_bits, wdg_detected2


init2
    clear_memory 0xa0,10
    clear_memory var2, 30
    
    ;end init

    BANKSEL status_bits
    ;run marked
    bsf status_bits, run_system

    BANKSEL SFR_to_detect_WDG
    movlw   run_system_marker
    movwf   SFR_to_detect_WDG

    BANKSEL wdg_timeout_marker
    movwf   wdg_timeout_marker

    BANKSEL count_to_test
    movlw   count_to_wdg_timeout
    movwf  count_to_test

    
main 
;here are some "regression tests" 
;for multiplication different procedures
    ;clrwdt
    BANKSEL status_bits
    btfss  status_bits, wdg_detected
    goto main2
    btfss  status_bits, wdg_detected2
    goto main2

    goto main_wdg_detected

main2

    VARIABLE var3 = 0x20
    VARIABLE var4 = 0x45
    VARIABLE var5 = 3
    VARIABLE var6 = 0xff 
    VARIABLE var7 = 1

    movlw var4 
    movwf  result_H
    movlw  var6
    subwf  result_H,f 

    movlw  var4
    movwf  result_H 
    movlw  2
    subwf  result_H,f 

    movlw  0 
    movwf  result_H
    movlw  1 
    subwf  result_H,f


    movel_2bytes  0x1010, operandl
    rrf  operandl,F
    rrf  operandh,f

    movel_2bytes  0x0000, operandl 
    rrf  operandl,f 
    rrf operandl,f 


    movlw   var5
    movwf   operandl
    movlw   var4
    movwf   number_l
    macro_mul_16f  number_h, number_l, operandl,result_lh, result_ll  

    
    compare2bytes  LOW(var4*var5), HIGH(var4*var5), result_ll, result_lh, errors_mul_8bit, 0


    movlw   3
    movwf   operandl
    movlw   6
    movwf   number_l
    macro_mul_16f  number_h, number_l ,operandl,result_lh, result_ll  
    
    compare2bytes  LOW(3*6), HIGH(3*6), result_ll, result_lh, errors_mul_8bit, 1

    movlw   var4
    movwf   operandl
    movlw   var4
    movwf   number_l
    macro_mul_16f  number_h, number_l ,operandl,result_lh, result_ll  
    nop
    compare2bytes  LOW(var4*var4), HIGH(var4 * var4), result_ll, result_lh, errors_mul_8bit, 2
    
    movlw   var6
    movwf   operandl
    movlw   var6
    movwf   number_l
    macro_mul_16f  number_h, number_l ,operandl,result_lh, result_ll  
    nop
    compare2bytes  LOW(var6*var6), HIGH(var6 * var6), result_ll, result_lh, errors_mul_8bit, 3

    movlw   var7
    movwf   operandl
    movlw   var7
    movwf   number_l
    macro_mul_16f  number_h, number_l ,operandl,result_lh, result_ll  
    nop
    compare2bytes  LOW(var7*var7), HIGH(var7 * var7), result_ll, result_lh, errors_mul_8bit, 4

    VARIABLE var8 = 0x99
    VARIABLE var9 = 0x34

    movlw   var8
    movwf   operandl
    movlw   var9
    movwf   number_l
    macro_mul_16f  number_h, number_l ,operandl,result_lh, result_ll  
    nop
    compare2bytes  LOW(var8*var9), HIGH(var8 * var9), result_ll, result_lh, errors_mul_8bit, 5
    PAGESEL main

    movlw   var8
    movwf   operandh 
    movlw   var8 
    movwf   operandl 
    movlw   var6 
    movwf   number_l
    movlw   var6 
    movwf   number_h 
    PAGESEL func_multiply16bitx16bit
    call    func_multiply16bitx16bit

    compare4bytes 0x67, 0x66, 0x98, 0x99,   result_ll, result_lh, result_hl, result_H , errors16bit, 0

    nop

    movlw   var8
    movwf   operandh 
    movlw   var8 
    movwf   operandl 
    movlw   var6 
    movwf   number_l
    movlw   var6 
    movwf   number_h 
    clrf    fraction_l
    clrf    fraction_h
    PAGESEL mul16f 
    call mul16f
    compare4bytes 0x67, 0x66, 0x98, 0x99,   result_ll, result_lh, result_hl, result_H , errors_sum_loop, 0



    movlw   0xff
    movwf   operandh 
    movlw   0xff 
    movwf   operandl 
    movlw   0xff 
    movwf   number_l
    movlw   0xff 
    movwf   number_h 
    clrf    fraction_l
    clrf    fraction_h
    PAGESEL func_multiply16bitx16bit
    call    func_multiply16bitx16bit

    compare4bytes 0x01, 0x0, 0xfe, 0xff,   result_ll, result_lh, result_hl, result_H , errors16bit, 1
    nop

    PAGESEL mul16f 
    call mul16f
    compare4bytes 0x01, 0x0, 0xfe, 0xff,   result_ll, result_lh, result_hl, result_H , errors_sum_loop, 1
    nop

    movlw   0x0
    movwf   operandh 
    movlw   0xff 
    movwf   operandl 
    movlw   0xf 
    movwf   number_l
    movlw   0x5f 
    movwf   number_h 
    clrf    fraction_l
    clrf    fraction_h
    PAGESEL func_multiply16bitx16bit
    call    func_multiply16bitx16bit

    compare4bytes 0xf1, 0xaf, 0x5e, 0x0,   result_ll, result_lh, result_hl, result_H , errors16bit, 2
    nop

    PAGESEL mul16f 
    call mul16f

    compare4bytes 0xf1, 0xaf, 0x5e, 0x0,   result_ll, result_lh, result_hl, result_H , errors_sum_loop, 2

    nop
    movlw   0x0
    movwf   operandh 
    movlw   0 
    movwf   operandl 
    movlw   0xf 
    movwf   number_l
    movlw   0x5f 
    movwf   number_h 
    clrf    fraction_l
    clrf    fraction_h
    PAGESEL func_multiply16bitx16bit
    call    func_multiply16bitx16bit

    compare4bytes 0, 0x0, 0x0, 0x0,   result_ll, result_lh, result_hl, result_H , errors16bit, 3

    PAGESEL mul16f 
    call mul16f


    compare4bytes 0, 0x0, 0x0, 0x0,   result_ll, result_lh, result_hl, result_H , errors_sum_loop, 3
    
    nop

    movlw   0x0
    movwf   operandh 
    movlw   0x1
    movwf   operandl 
    movlw   0xf 
    movwf   number_l
    movlw   0x5f 
    movwf   number_h 
    clrf    fraction_l
    clrf    fraction_h
    PAGESEL func_multiply16bitx16bit
    call    func_multiply16bitx16bit

    compare4bytes 0xf, 0x5f, 0x0, 0x0,   result_ll, result_lh, result_hl, result_H , errors16bit, 4
    PAGESEL mul16f 
    call mul16f
    nop
    compare4bytes 0xf, 0x5f, 0x0, 0x0,   result_ll, result_lh, result_hl, result_H , errors_sum_loop, 4
    
    movlw   0x0
    movwf   operandh 
    movlw   0x64
    movwf   operandl 
    movlw   0x3
    movwf   number_h 
    movlw   0x45
    movwf   number_l
    movlw   0x0 
    movwf   fraction_h
    movlw   0xea 
    movwf   fraction_l
    PAGESEL mul16f
    call    mul16f

    compare4bytes 0xf4, 0x46, 0x01, 0x0,   result_ll, result_lh, result_hl, result_H , errors_sum_loop, 5
    compare2bytes 0x5b, 0x68, result_01, result_001, errors_sum_loop, 1
    nop
    
main_wdg_detected
    movel_2bytes 0x4567, operandl

    movel_2bytes 0x18aa, number_l

    movel_2bytes 0x8002, fraction_l
    PAGESEL mul16f
    call    mul16f

    compare4bytes 0x1a, 0xe1, 0xaf, 0x06,   result_ll, result_lh, result_hl, result_H , errors_sum_loop, 6
    compare2bytes 0xa, 0xce, result_01, result_001, errors_sum_loop, 6
    nop


    movel_2bytes  0x1020, number_l 
    movel_2bytes  0x0003, operandl

    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll  

    nop
    compare2bytes    0x5, 0x60, result_lh, result_ll, errors_div, 0 
    compare1byte     0x0 , number_l , errors_div, 0 ; reminder

    nop
    movel_2bytes  0xffff, number_l 
    movel_2bytes  0x00ff, operandl

    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll  

    nop
    compare2bytes    0x1, 0x01, result_lh, result_ll, errors_div, 1 
    compare1byte     0x0 , number_l , errors_div, 1 ; reminder

    nop 


    movel_2bytes  0xffff, number_l 
    movel_2bytes  0x0001, operandl

    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll  

    nop
    compare2bytes    0xff, 0xff, result_lh, result_ll, errors_div, 2 
    compare1byte     0x0 , number_l , errors_div, 2 ; reminder

    nop
    movel_2bytes  0x0005, number_l 
    movel_2bytes  0x0002, operandl

    nop
    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll 

    nop
    compare2bytes    0x00, 0x02, result_lh, result_ll, errors_div, 3
    compare1byte     0x1 , number_l , errors_div, 3 ; reminder

    nop

    movel_2bytes  0x0005, number_l 
    movel_2bytes  0x000a, operandl

    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll 

    nop
    compare2bytes    0x00, 0x00, result_lh, result_ll, errors_div, 4
    compare1byte     0x05 , number_l , errors_div, 4 ; reminder
    
    nop

    movel_2bytes  0x1101, number_l 
    movel_2bytes  0x000d, operandl

    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll 

    nop
    compare2bytes    0x01, 0x4e, result_lh, result_ll, errors_div, 5
    compare1byte     0x0b , number_l , errors_div, 5 ; reminder

    nop

    movel_2bytes  0xf120, number_l 
    movel_2bytes  0x0078, operandl

    PAGESEL  func_div_16bit_8bit
    call func_div_16bit_8bit

    nop
    compare2bytes    0x02, 0x02, result_lh, result_ll, errors_div, 6
    compare1byte     0x30 , number_l , errors_div, 6 ; reminder

    nop

    movel_3bytes   0x00f120, result_ll
    movel_2bytes  0x0078, operandl
    PAGESEL func_div_24bit_16bit
    call func_div_24bit_16bit
    compare3bytes    0, 0x02, 0x02, result_hl, result_lh, result_ll, errors_div, 6
    compare2bytes     0, 0x30 , fraction_h , fraction_l, errors_div, 6 ; reminder

    nop 

    movel_3bytes   .36789, result_ll
    movel_2bytes  .10000, operandl
    PAGESEL func_div_24bit_16bit
    call func_div_24bit_16bit
    compare3bytes    0, 0x00, 0x03, result_hl, result_lh, result_ll, errors_div, 7
    compare2bytes     0x1a, 0x85 , fraction_h , fraction_l, errors_div, 7 ; reminder

    nop
    compare2bytes 0, 0 , errors16bit, errors_sum_loop, status_bits, 0 
    compare2bytes  0, 0, errors_mul_8bit, errors_div,  status_bits, 0 

    PAGESEL led_off
    btfsc   led_green_port,led_green_pin
    goto     led_off

    BANKSEL led_green_port
    bsf led_green_port, led_green_pin

;in case of error 
    btfsc    status_bits,0
    bcf    led_red_port, led_red_pin

     PAGESEL main
     goto main    

led_off 
    BANKSEL led_green_port
    bcf     led_green_port,led_green_pin
;in case of error 
    btfsc    status_bits,0
    bsf    led_red_port, led_red_pin

     PAGESEL main
    goto main
    end