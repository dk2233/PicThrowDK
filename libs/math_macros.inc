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



;  division 
;  x_h|x / y
; important is to store all variables in same bank
macro_division_16f macro  x_h, x, y,  rh, rl
    LOCAL macro_division_16f_loop, macro_division_16f_loop_higher_zero, macro_division_16f_loop_1, macro_division_16f_loop_0
    clrf  rh
    clrf  rl 

    PAGESEL  macro_division_16f_loop_0
    check_if_0_NZ_skip_next y
    goto     macro_division_16f_loop_0

macro_division_16f_loop
    check_if_0_NZ_skip_next x_h
    goto    macro_division_16f_loop_higher_zero

    movf     y,w
    subwf    x , f  ;x - y = result to f only if we know there is no 0 in x_h 
    btfsc    STATUS,C ; if not C means we exceeds reg 
    goto     macro_division_16f_loop_1
    
    decf     x_h,f
    goto     macro_division_16f_loop_1
macro_division_16f_loop_higher_zero 
    movf     y,w
    subwf  x,w 
    btfss  STATUS,C  ; if cross byte here - do not really subtract - keep as a reminder
    goto   macro_division_16f_loop_0  ; finish operation

    movwf  x

macro_division_16f_loop_1       
    incf  rl,f 
    btfsc STATUS,Z
    incf  rh,f 
    goto  macro_division_16f_loop

macro_division_16f_loop_0
    ;in x_h|x there is a reminder

    endm 