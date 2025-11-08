    
context_store16f  macro 
    movwf w_temp
    swapf STATUS,W
    clrf STATUS
    movwf status_temp
    movf  PCLATH,w
    movwf pclath_temp
    endm


context_restore16f macro
    movf  pclath_temp,w 
    movwf PCLATH
    swapf status_temp,w
    movwf STATUS
    swapf w_temp,f
    swapf w_temp,w
    endm