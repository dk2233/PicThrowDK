
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
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/math/math_macros.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/macro_time.inc

    
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

    include ../../PicLibDK/math/math_function_multiplication.asm
    include ../../PicLibDK/math/multiplication_16f_loop.asm
    include ../../PicLibDK/math/math_function_div.asm

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


    clear_memory  var1,0x7f - 0x20 ; here status_bits is cleared

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
    clear_memory var2, 0x16f - var2 
    
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
    ;BANKSEL status_bits
    ;btfss  status_bits, wdg_detected
    ;goto main2
    ;btfss  status_bits, wdg_detected2
    ;goto main2

    ;goto main_wdg_detected

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

    nop
    
    compare2bytes  var4*var5, result_ll, errors_mul_8bit, 0


    movlw   3
    movwf   operandl
    movlw   6
    movwf   number_l
    macro_mul_16f  number_h, number_l ,operandl,result_lh, result_ll  
    
    compare2bytes  3*6, result_ll, errors_mul_8bit, 1

    movlw   var4
    movwf   operandl
    movlw   var4
    movwf   number_l
    macro_mul_16f  number_h, number_l ,operandl,result_lh, result_ll  
    nop
    compare2bytes  var4*var4, result_ll , errors_mul_8bit, 2
    
    movlw   var6
    movwf   operandl
    movlw   var6
    movwf   number_l
    macro_mul_16f  number_h, number_l ,operandl,result_lh, result_ll  
    nop
    compare2bytes  var6 * var6, result_ll,  errors_mul_8bit, 3

    movlw   var7
    movwf   operandl
    movlw   var7
    movwf   number_l
    macro_mul_16f  number_h, number_l ,operandl,result_lh, result_ll  
    nop
    compare2bytes  var7 * var7, result_ll,  errors_mul_8bit, 4

    VARIABLE var8 = 0x99
    VARIABLE var9 = 0x34

    movlw   var8
    movwf   operandl
    movlw   var9
    movwf   number_l
    macro_mul_16f  number_h, number_l ,operandl,result_lh, result_ll  
    nop
    compare2bytes  var8 * var9, result_ll,  errors_mul_8bit, 5
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
    nop
    compare4bytes 0x99986667,     result_ll , errors16bit, 0

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
    compare4bytes 0x99986667,    result_ll , errors16bit, 1



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

    compare4bytes 0xfffe0001,    result_ll , errors16bit, 1
    nop

    PAGESEL mul16f 
    call mul16f
    nop
    compare4bytes 0xfffe0001,    result_ll , errors_sum_loop, 1
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

    compare4bytes 0x005eaff1 ,   result_ll , errors16bit, 2
    nop

    PAGESEL mul16f 
    call mul16f

    compare4bytes 0x005eaff1,    result_ll, errors_sum_loop, 2

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

    compare4bytes 0,   result_ll, errors16bit, 3

    PAGESEL mul16f 
    call mul16f


    compare4bytes 0,    result_ll, errors_sum_loop, 3
    
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

    compare4bytes 0x5f0f,    result_ll, errors16bit, 4
    PAGESEL mul16f 
    call mul16f
    nop
    compare4bytes 0x5f0f,    result_ll, errors_sum_loop, 4
    
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

    compare4bytes 0x0146f4,    result_ll, errors_sum_loop, 5
    compare2bytes 0x5b68, result_001, errors_sum_loop, 1
    nop
    
main_wdg_detected
    movel_2bytes 0x4567, operandl

    movel_2bytes 0x18aa, number_l

    movel_2bytes 0x8002, fraction_l
    PAGESEL mul16f
    call    mul16f

    nop
    compare4bytes 0x06afe11a,    result_ll, errors_sum_loop, 6
    compare2bytes 0x0ace, result_001, errors_sum_loop, 6
    nop


    movel_2bytes  0x1020, number_l 
    movel_2bytes  0x0003, operandl

    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll  

    nop
    compare2bytes    0x560, result_ll, errors_div, 0 
    compare1byte     0x0 , number_l , errors_div, 0 ; reminder

    nop
    movel_2bytes  0xffff, number_l 
    movel_2bytes  0x00ff, operandl

    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll  

    nop
    compare2bytes    0x101,  result_ll, errors_div, 1 
    compare1byte     0x0 , number_l , errors_div, 1 ; reminder

    nop 


    movel_2bytes  0xffff, number_l 
    movel_2bytes  0x0001, operandl

    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll  

    nop
    compare2bytes    0xffff,  result_ll, errors_div, 2 
    compare1byte     0x0 , number_l , errors_div, 2 ; reminder

    nop
    movel_2bytes  0x0005, number_l 
    movel_2bytes  0x0002, operandl

    nop
    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll 

    nop
    compare2bytes    0x0002,  result_ll, errors_div, 3
    compare1byte     0x1 , number_l , errors_div, 3 ; reminder

    nop

    movel_2bytes  0x0005, number_l 
    movel_2bytes  0x000a, operandl

    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll 

    nop
    compare2bytes    0x0000,  result_ll, errors_div, 4
    compare1byte     0x05 , number_l , errors_div, 4 ; reminder
    
    nop

    movel_2bytes  0x1101, number_l 
    movel_2bytes  0x000d, operandl

    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll 

    nop
    compare2bytes    0x014e,  result_ll, errors_div, 5
    compare1byte     0x0b , number_l , errors_div, 5 ; reminder

    nop

    movel_2bytes  0xf120, number_l 
    movel_2bytes  0x0078, operandl

    PAGESEL  func_div_16bit_8bit
    call func_div_16bit_8bit

    nop
    compare2bytes    0x0202,  result_ll, errors_div, 6
    compare1byte     0x30 , number_l , errors_div, 6 ; reminder

    nop

    movel_3bytes   0x00f120, result_ll
    movel_2bytes  0x0078, operandl
    PAGESEL func_div_24bit_16bit
    call func_div_24bit_16bit
    compare3bytes    0x0202, result_ll, errors_div, 6
    compare2bytes     0x030 ,  fraction_l, errors_div, 6 ; reminder

    nop 

    movel_3bytes   .36789, result_ll
    movel_2bytes  .10000, operandl
    PAGESEL func_div_24bit_16bit
    call func_div_24bit_16bit
    compare3bytes    0x000003, result_ll, errors_div, 7
    compare2bytes     0x1a85 ,  fraction_l, errors_div, 7 ; reminder


array_values1   equ   0xfe561234
array_values2   equ   0x01020304 
array_values3   equ   0x12340a40
array_values4   equ   0x0a0b0c0d
array_values5   equ   0x0045fe56
array_values6   equ   0x12340102
    nop
    movel_4bytes  array_values1, array2
    nop
    movel_4bytes  array_values2, array3

    movel_4bytes array_values1 , array1 
    movel_4bytes array_values3, array1+4 
    movel_4bytes array_values5, array1+8
    movel_4bytes array_values5, array1+.12
    movel_4bytes array_values6, array1+.16

    movlw  LOW (array1+array1_size)
    movwf  result_001
    
    store_address_of_variable_irp array2, fraction_l

    mem_search_data_on_array  array1, operandh, operandl, result_001, 4, fraction_h, fraction_l, number_l, number_h, result_ll

    compare1byte  2, result_ll, errors_compare_arrays, 0 

    nop 
    store_address_of_variable_irp array3, fraction_l

    mem_search_data_on_array  array1, operandh, operandl, result_001, 4, fraction_h, fraction_l, number_l, number_h, result_ll
    
    compare1byte 0, result_ll, errors_compare_arrays, 1
    nop 
    movel_4bytes  array_values5, array3
    store_address_of_variable_irp array3, fraction_l

    mem_search_data_on_array  array1, operandh, operandl, result_001, 4, fraction_h, fraction_l, number_l, number_h, result_ll
    
    compare1byte 2, result_ll, errors_compare_arrays, 2
    nop
    copy_data_from_ROM operandl, array1, text1
    nop 
    copy_data_from_ROM operandl, array3, text3
    store_address_of_variable_irp array3, fraction_l 

    mem_search_data_on_array  array1, operandh, operandl, result_001, 6, fraction_h, fraction_l, number_l, number_h, result_ll
    compare1byte 2, result_ll, errors_compare_arrays, 3

    nop
    ;check for 4 errors if any is set
    compare4bytes 0,  errors_mul_8bit, status_bits, 0 

    compare1byte  0 , errors_compare_arrays, status_bits, 0 

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

;EEPROM
;    org __EEPROM_START
    ;org 0
text1     
    addwf PCL,f
    dt "saaam string1,string",0
text2
    addwf PCL,f
     dt "2,text,abcd:",0
text3
    addwf PCL,f 
    dt "string",0
    end