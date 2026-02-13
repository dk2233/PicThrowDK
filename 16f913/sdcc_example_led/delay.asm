
    list p=16f913
	;__CONFIG _WDT_OFF & _MCLRE_ON & _DEBUG_ON & _IESO_OFF  & _FOSC_INTOSCIO & _FCMEN_OFF & _PWRTE_ON & _BOREN_OFF
	include	"p16f913.inc"



    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/math/math_macros.inc
    include config.inc


    extern STK00 
delay_udata   udata 

temp res 2
delay_time_arg  res 2

delay_code    code 

    global _delay_proc_500ms

;example how to use argument from c function
_delay_proc_500ms
    movwf delay_time_arg+1
    BANKSEL delay_time_arg
    movf STK00,w 
    movwf delay_time_arg
    
    wait_specific_time_no_tmr_us   mcu_freq, .500000, temp

    return
    end 

