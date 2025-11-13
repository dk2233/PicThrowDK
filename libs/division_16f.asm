;to jest dzieleni max 2-bajtowe i z ulamkiem w jednym bajcie
;resultlh
;resultll
;result_01      trzy bajty wyniku  -> result_01 to ulamek
;wersja dla pic18fxxxx


;reszta_z_dzielenia
 
;operandl


dzielenie
	clrf	resultll
	clrf	resultlh
	clrf     reszta_operacji
	movwf	operandl
;jeeli probuje przez 0 to wroc	
	movf	operandl,w
	btfsc	STATUS,Z
	return
	
dzielenie2
	movf	number_l,w
	movwf	result_01
	movf	operandl,w
	subwf	number_l,f
	btfss 	STATUS,C
	goto	dzielenie_end;je?eli koniec

dzielenie22	
	incf	resultll,f
	
	btfsc	STATUS,Z
	incf	resultlh,f
	
	goto	dzielenie2
dzielenie_end
	movf		dzielonah,w

	btfsc		STATUS,Z
	goto	dzielenie_ulamek
	;return
	decf		dzielonah,f
			
	goto	dzielenie22
	
	
dzielenie_ulamek
         ;jak obliczyc ulamek tzn jaka czesc liczby przez ktora dziele stanowi liczba w result_01
         ;ulamek   =   result_01/operandl*256
         ;jezeli nie ma ulamka - nic nie zostalo to nie licz ulamka
         movf     result_01,w
         btfsc    STATUS,Z
         return
         
         movwf    reszta_operacji 
         ;najpierw dziele 0x100/liczba_przez_ktora_dzielel
         
         movlw    0x01
         movwf    dzielonah
         movlw    0x00
         movwf    number_l
         clrf	ulamekh
	clrf	ulamekl
         
dzielenie_ulamek_petla
         movf	number_l,w
	;movwf	wynik001
	movf	operandl,w
	subwf	number_l,f
	btfss 	STATUS,C
	goto	dzielenie_ulamek_end
         
         incf     ulamekl,f
         
         goto     dzielenie_ulamek_petla
         
dzielenie_ulamek_end         
         movf		dzielonah,w

	btfsc		STATUS,Z
	goto     mnoze_przez_wynik01
	decf		dzielonah,f
	incf     ulamekl,f		
	goto	dzielenie_ulamek_petla
 
mnoze_przez_wynik01
         ;mnoze ulamekl przez to co jest w result_01
         movf     result_01,w
         movwf    operandl
         
         movf     ulamekl,w
         movwf    mnozonal
         
         clrf     result_01
mnoze_przez_wynik01_LOOP
         movf     mnozonal,w
         addwf    result_01,f
         
         decf     operandl,f
         
         btfss    STATUS,Z
         goto     mnoze_przez_wynik01_LOOP

         return