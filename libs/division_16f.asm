;to jest dzieleni max 2-bajtowe i z ulamkiem w jednym bajcie
;wynik1
;wynik
;wynik01      trzy bajty wyniku  -> wynik01 to ulamek
;wersja dla pic18fxxxx


;reszta_z_dzielenia
 
;liczba_przez_ktora_dziele


dzielenie
	clrf	wynik
	clrf	wynik1
	clrf     reszta_operacji
	movwf	liczba_przez_ktora_dziele
;jeeli probuje przez 0 to wroc	
	movf	liczba_przez_ktora_dziele,w
	btfsc	STATUS,Z
	return
	
dzielenie2
	movf	dzielona,w
	movwf	wynik01
	movf	liczba_przez_ktora_dziele,w
	subwf	dzielona,f
	btfss 	STATUS,C
	goto	dzielenie_end;je?eli koniec

dzielenie22	
	incf	wynik,f
	
	btfsc	STATUS,Z
	incf	wynik1,f
	
	goto	dzielenie2
dzielenie_end
	movf		dzielonah,w

	btfsc		STATUS,Z
	goto	dzielenie_ulamek
	;return
	decf		dzielonah,f
			
	goto	dzielenie22
	
	
dzielenie_ulamek
         ;jak obliczyc ulamek tzn jaka czesc liczby przez ktora dziele stanowi liczba w wynik01
         ;ulamek   =   wynik01/liczba_przez_ktora_dziele*256
         ;jezeli nie ma ulamka - nic nie zostalo to nie licz ulamka
         movf     wynik01,w
         btfsc    STATUS,Z
         return
         
         movwf    reszta_operacji 
         ;najpierw dziele 0x100/liczba_przez_ktora_dzielel
         
         movlw    0x01
         movwf    dzielonah
         movlw    0x00
         movwf    dzielona
         clrf	ulamekh
	clrf	ulamekl
         
dzielenie_ulamek_petla
         movf	dzielona,w
	;movwf	wynik001
	movf	liczba_przez_ktora_dziele,w
	subwf	dzielona,f
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
         ;mnoze ulamekl przez to co jest w wynik01
         movf     wynik01,w
         movwf    liczba_przez_ktora_dziele
         
         movf     ulamekl,w
         movwf    mnozonal
         
         clrf     wynik01
mnoze_przez_wynik01_LOOP
         movf     mnozonal,w
         addwf    wynik01,f
         
         decf     liczba_przez_ktora_dziele,f
         
         btfss    STATUS,Z
         goto     mnoze_przez_wynik01_LOOP

         return