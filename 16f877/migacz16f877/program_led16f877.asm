;nowy program



list	p=16f877a
include	p16f877a.in
	__CONFIG _WDT_OFF & _INTOSCIO & _MCLRE_ON & _DEBUG_OFF & _IESO_OFF
	
	cblock		0x20
	czas
	do_sekundy
	next_moment
	endc
	
begin
;prescaling ustawiony na 1:256
	bsf	STATUS,RP0
	movlw	b'11000111'	
	movwf	OPTION_REG
	
	
	movlw	b'11111100'
	movwf	 TRISB	

	;ustawiam oscon na 4MhZ HighF	
	movlw	b'01100111'
	movwf	OSCCON
;wszystkie analogi na cyfre
	movlw	b'11111111'
	movwf	CMCON0
	movlw	b'00000000'
	movwf	ANSEL
	
	bcf	STATUS,RP0
	


	movlw	0xc
;czyszczenie pamieci	
	movwf	FSR
petla1
	clrf	INDF
	incf	FSR,f
	movlw	0x4f
	xorwf	FSR,w
	btfss STATUS,Z
	goto	petla1
	
	
	
	
;g³owny program
main
;1 sprawdz czy sekunda
;2 zapal lampke 
	movf	next_moment,w
	xorwf	TMR0,w
	btfsc	STATUS,Z
	call	sek_check
;jezeli nie to moze zarejestr TMR1 over	 
	
	;btfss	PIR1,TMR1IF
	;goto	LOOP
;zlicz na TMR0 tylko 250 impulsów czyli
	
	;movlw	0xfa
	;incf	do_sekundy,f
	;bcf	PIR1,TMR1IF
	
	
	goto	main
	
copy_tmr0
	
	movlw	0xFa
	addwf	TMR0,w
	movwf	next_moment
	return

		
sek_check
;;
	call	copy_tmr0
	incf    do_sekundy,f
	movlw	10h
;po 10h	(16*250*256=1024000 cykle czyli 1,000 s) zeruj czas2
	xorwf	do_sekundy,w
	btfsc	STATUS,Z
;je¿eli czwarty bit to zlicz sekunda
	;btfsc	do_sekundy,4
	call	zlicz_sekunda	
;
	return

zlicz_sekunda
	clrf	do_sekundy
	btfsc	PORTB,0
	goto	ustaw_druga	
	bsf	PORTB,0
	bcf	PORTB,1
	return
ustaw_druga
	bsf	PORTB,1
	bcf	PORTB,0
	
	return
	end		
