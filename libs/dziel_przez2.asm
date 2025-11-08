dzielenie_przez_przesuwanie
;dziele przez 2 wynikh i 2 kolejne bajty
;najlepsza procedurka do dzielenia przez 2,4,8, i wielokrotnosci 2
        rrf     wynikh,f
        rrf     wynik,f
        rrf     wynik01,f
;zasada dzialania jest oczywista ale i trudna do zrozumienia
;1. przesuwanie w prawo to dzielenie przez 2
;2. przesuwanie w prawo drugiego bajtu to dzielenie przez dwa ulamka
;3. jezeli przy dzieleniu przez 2 (rrf) powstanie nadmiar (bit C  w STATUS)
;       oznacza to ulamek. przy przesuwaniu liczby ulamka pojawia sie w nim 10000000, jezeli byl ;wczesiej pusty. oznacza to 0,5. jezeli dalej bedziemy dzielic przez 2 ulamek powstanie w nim
;01000000 tzn 0,25 (0x40/0xff = 0,25 w przyblizeniu )

         bcf   STATUS,C
         
        return                   
