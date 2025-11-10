clear_memory macro start, size
	local nextm
	BANKISEL start
    movlw	LOW(start)
	movwf	FSR
nextm
	clrf	INDF
	INCF	FSR,f
	movlw	LOW(start + size)
	xorwf	FSR,w
	BTFSS	STATUS,Z
	goto	nextm

	endm



compare2bytes  macro  a, b, a1, b1, err, bit
	BANKSEL err
    movlw   a 
    xorwf   a1,W
    SKPZ	
    bsf     err,bit
	   
    movlw   b
	xorwf   b1,W
    SKPZ
    bsf     err,bit
	endm

macro_division_16f_loop_0
compare4bytes  macro a, b, c, d, a1, b1, c1, d1, err, bit
	compare2bytes a,b, a1, b1, err, bit

	compare2bytes c,d, c1, d1, err, bit 

	endm

;set output bits if not same
compare1byte macro a, a1 , err, bit_err  

	BANKSEL a1
    movlw   a 
    xorwf   a1,W
	BANKSEL err
    SKPZ
	bsf    err, bit_err
	endm 

;set output bits if not same
compare1byte_set_when_same macro a, a1 , reg , bit_same  

	BANKSEL a1
    movlw   a 
    xorwf   a1,W
	BANKSEL reg
    SKPZ
	bcf    reg, bit_same
	SKPNZ
	bsf    reg, bit_same
	endm 
;move literal 2 bytes into ram variable (var , var + 1)
movel_2bytes macro literal , var

    movlw   literal & 0xff
	movwf   var  
    movlw   (literal >> 8) & 0xff
    movwf   var+1
	endm

;in case of Z set
;skip next line
check_if_0_Z_skip_next   macro  reg 
	movf   reg, w 
	SKPZ
	endm 

check_if_0_NZ_skip_next macro reg 
	movf    reg,W
	SKPNZ 
	endm

check_number_skip_if_even macro  reg
	movlw    1 
	andwf    reg,W
	btfsc    STATUS,Z
	endm 

check_number_skip_if_not_even macro  reg
	movlw    1 
	andwf    reg,W
	btfss    STATUS,Z
	endm 