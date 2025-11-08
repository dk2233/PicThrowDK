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


compare4bytes  macro a, b, c, d, a1, b1, c1, d1, err, bit
	compare2bytes a,b, a1, b1, err, bit

	compare2bytes c,d, c1, d1, err, bit 

	endm

