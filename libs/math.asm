
         
zrob_ulamek
;dziele 256 przez dzielnik z dzielenia i mnoze przez reszte
         movf     operandl,w
         movwf    temp_10000
         clrf     mnozona
         movlw    1
         movwf    mnozonah
                  
         clrf     ulamekh
         clrf     ulamekl
         
         movf     wynik01,w

         call     mnozenie
         
         movf     wynik,w
         movwf    dzielona
         
         movf     wynikh,w
         movwf    dzielonah
         
         movf     temp_10000,w
         call     dzielenie
;jezeli w reszcie cos jest to +1
         movf     wynik01,w
         btfss    STATUS,Z
         incf     wynik,f
         
         movf     wynik,w
         
         movwf    ulamekh

         ;incf    
         return
         

         
         
         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                
sprawdz_przekroczenie
         movlw    temp_1
         movwf    FSR
         movlw    5
         movwf    tmp
sprawdz_przekroczenie2

         movf     INDF,w ;to do w
         movwf    dzielona
         movlw    0ah
         call     dzielenie

         movf     wynik01,w
         movwf    INDF
         movf     wynik,w
         decf     FSR,f
         addwf    INDF,f
         
         decfsz   tmp,f
         goto     sprawdz_przekroczenie2

         return
         
;        return
         
;jezeli tylko wyswietlam zapisane w rejestrach temperatury to nie musze ich dzielic przez 10(to zwiazane jest z pomiarem)


         
tab_cyfr
         ;bsf     PCLATH,0
         addwf    PCL,f
         retlw    2
         retlw    5
         retlw    6
         retlw    0
                           
wyswietlanie_liczby2
         movlw    liczba2
         movwf    FSR
         call     hex2dec
         
         movlw    temp_10000
         movwf    tmp5
;nawrót 2 razy przy kazdym nawrocie
         movlw    3
         movwf    tmp
         movwf    tmp2
         
         movlw    dec100
         movwf    tmp6
         clrf     n
         
wyswietlanie_liczby22
;w tmp6 jest adres zmiennej liczby do mnozenia        
         movf     tmp6,w
         movwf    FSR
         movf     INDF,w
         movwf    mnozona
;po kolei pokazuje 2,5,6   
         movf     n,w
         call     tab_cyfr
         
         call     mnozenie
         
;w tmp5 jest adres zmiennej gdzie dodajemy wynik      
         movf     tmp5,w
         movwf    FSR
         movf     wynik,w
         addwf    INDF,f
         
         incf     tmp5,f
         incf     n,f
         ;movf    dec100,w
         
         
         decfsz   tmp,f
         goto     wyswietlanie_liczby22
         
         movlw    3
         movwf    tmp
         decf     tmp5,f
         decf     tmp5,f
         incf     tmp6,f
         clrf     n
         
         decfsz   tmp2,f
         goto     wyswietlanie_liczby22
         ;movlw   dec10
         ;addwf   temp_1000
         ;movlw   dec1
         ;addwf   temp_100
         return

wyswietlanie_liczby01
         clrf     mnozonah
         clrf     ulamekh
         clrf     ulamekl
         movf     liczba01,w
         movwf    mnozona
         movlw    0x64
         call     mnozenie
         movf     wynikh,w
         movwf    dzielonah
         movf     wynik,w
         movwf    dzielona
;teraz dziele przez 255
         movlw    0xff
         call     dzielenie
         movlw    wynik
;tu zamieniam spowrotem na ułamek 
;najpierw mnoze przez 100
                  
         movwf    FSR
         call     hex2dec
         movf     dec10,w
         addwf    temp_01,f
         movf     dec1,w
         addwf    temp_001,f
         ;movf    dec1,w
         ;addwf   temp_0001,f
         return
         
zrob_ujemna
;jezeli bit 7 to zrob minus
         btfss    liczba1,7
         return
         comf     liczba1,f
         incf     liczba1,f
         bsf      znaczniki,see_minus
         return
         
wyswietlanie_liczby
         clrf     ulamekh
         clrf     ulamekl
         clrf     mnozonah
         btfsc    znaczniki,licz_czy
         call     zrob_ujemna
         
         
         movf     liczba2,w
         btfss    STATUS,Z
         call     wyswietlanie_liczby2
         
         ;movlw   ffh
         ;xorwf   liczba2,w
         ;btfsc   STATUS,Z
         ;call    wyswietlanie_liczby1
         
         movlw    0h
         xorwf    liczba01,w
         btfss    STATUS,Z
         call     wyswietlanie_liczby01
         
         movlw    liczba1
         movwf    FSR
         call     hex2dec
         movf     dec100,w
         addlw    b'00110000'
         call     write_lcd
         call     check_busy
         
;        addwf    temp_100,f
         movf     dec10,w
         addlw    b'00110000'
         call     write_lcd
         call     check_busy
;        addwf    temp_10,f
         movf     dec1,w
         addlw    b'00110000'
         call     write_lcd
         call     check_busy
;        addwf    temp_1,f
         
         return
                  