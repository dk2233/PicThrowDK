usrednianie
;dziele przez 2 0x20
;najlepsza procedurka do dzielenia przez 2,4,8, i wielokrotnosci 2
        rrf     0x20,f
        rrf     0x21,f
;zasada dzialania jest oczywista ale i trudna do zrozumienia
;1. przesuwanie w prawo to dzielenie przez 2
;2. przesuwanie w prawo drugiego bajtu to dzielenie przez dwa ulamka
;3. jezeli przy dzieleniu przez 2 (rrf) powstanie nadmiar (bit C  w STATUS)
;       oznacza to ulamek. przy przesuwaniu liczby ulamka pojawia sie w nim 10000000, jezeli byl ;wczesiej pusty. oznacza to 0,5. jezeli dalej bedziemy dzielic przez 2 ulamek powstanie w nim
;01000000 tzn 0,25 (0x40/0xff = 0,25 w przyblizeniu )

         bcf   STATUS,C
         
        return                   
mnoze   
        rlf     0x21,f
        rlf     0x20,f
        return
        
        
        
        ;proby dzielenia
        movlw   0xfa
        movwf   0x20
        
        call    usrednianie
        call    usrednianie
        call    usrednianie
        call    usrednianie
        
        call    mnoze
        call    mnoze
        call    mnoze
        call    mnoze