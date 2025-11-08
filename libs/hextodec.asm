;zamiana liczb 16 na postac 10 do wyswietlenia

hex2dec
         clrf     dzielonah
         movf     INDF,w
         movwf    dzielona
         movlw    064h ;dzielenie przez 100

         call     dzielenie
         movf     wynik,w
;dodaje wynik dzielenia przez 100 do ilosci 100-etek w dec100
         movwf    dec100
         ;
dziesiatki
         movf     wynik01,w
         movwf    dzielona
;dzielenie przez 10 reszty która została z dzielenia przez 100
         movlw    0ah 
         call     dzielenie

         movf     wynik,w
         movwf    dec10
jednosci
         movf     wynik01,w
;tu są jedności
         movwf    dec1
         return