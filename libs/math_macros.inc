macro_mul_16f  macro  x_h, x, y,rh,rl
    

    ; x_h|x * y = rh|rl
    LOCAL   mult_loop, mult_done,shift_only
    
    ; Initialize
    clrf    rl       
    CLRF    rh       
    clrf    x_h
    
    movf    y,w
    ; Check for zero multiplier
    BTFSC   STATUS, Z
    GOTO    mult_done
    
mult_loop:
    ; Check LSB of multiplier
    ;if it is not even
    BTFSS   y, 0
    GOTO    shift_only
    
    ; Add multiplicand to result
    MOVF    x, W
    addwf   rl,f
    btfsc   STATUS,C
    incf   rh, f    ; Add to high byte
    movf  x_h,w 
    addwf rh,f
    
shift_only:
    ; Shift multiplicand left (multiply by 2)
    
    BCF     STATUS, C
    rlf     x,f
    rlf     x_h,f

    
    BCF     STATUS, C
    RRF     y, F
    
    ; Check if done
    MOVF    y, F
    BTFSS   STATUS, Z
    GOTO    mult_loop
    
mult_done:
    ENDM
