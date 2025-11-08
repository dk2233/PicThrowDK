;to jest dzieleni max 2-bajtowe i z ulamkiem w jednym bajcie
;wynikh
;wynik
;wynik01      trzy bajty wyniku  -> wynik01 to ulamek
 



dzielenie
	clrf	wynik
	clrf	wynikh
	
	movwf	operandl
;jeeli probuje przez 0 to wroc	
	movf	operandl,w
	btfsc	STATUS,Z
	return
	
dzielenie2
	movf	dzielona,w
	movwf	wynik01
	movf	operandl,w
	subwf	dzielona,f
	btfss 	STATUS,C
	goto	dzielenie_end;je?eli koniec

dzielenie22	
	incf	wynik,f
	
	btfsc	STATUS,Z
	incf	wynikh,f
	
	goto	dzielenie2
dzielenie_end
	movf		dzielonah,w

	btfsc		STATUS,Z
	;goto	dzielenie_ulamek
	return
	decf		dzielonah,f
			
	goto	dzielenie22
	return
	
