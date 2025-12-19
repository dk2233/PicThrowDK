
    list p=16f913 

	include	"p16f913.inc"


    include defines.inc
    include ../../PicLibDK/init16f.inc
    include ../../PicLibDK/interrupts.inc
    include ../../PicLibDK/macro_time.inc

    global keys_init, keys_on_int, keys_machine_state


    extern w_temp, fsr_temp, pclath_temp, status_temp, status_bits



button_ud  udata
button_debounce_counter  res 1



keys_code code 


keys_init 

        BANKSEL OPTION_REG


        enable_pull_up 1

        bcf INTCON, INTF
        bsf INTCON,INTE

        return 


keys_on_int 

    bcf INTCON, INTF
    BANKSEL status_bits
    bsf status_bits, move_led 

    movlw button_debounce_value
    movwf button_debounce_counter

    bcf INTCON, INTE
    bsf status_bits, key_pressed


    context_restore16f
     retfie

;call every 1ms
keys_machine_state

    BANKSEL status_bits
    btfss status_bits, key_pressed
    goto keys_machine_state_end

    decfsz button_debounce_counter,f 
    goto keys_machine_state_end 

    bcf  status_bits, key_pressed
    rb0_int_enable
    


keys_machine_state_end
     return 

        end 
