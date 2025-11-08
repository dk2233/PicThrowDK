         
procedura_regul_P_old

        ;kontroluje to w odniesieniu do liczby z AD
        ;wiec temp nastawiona rowniez w postaci liczby z AD 
        ; ilosc PWM = KP * ( Temp_set - Temp_act)
        
        ;temp nastawiona - temp  aktualna
        
        
        movf     liczba_thermo_H,w
         ;pomiarh - jaka_wartosc_regulujeH
        subwf    liczba_nastawy_h ,w
        ;jesli w wyniku mamy liczbe ujemna
        btfss   STATUS,C
        goto    regul_P_roznica_temp_ujemna
        movwf    liczba_przez_ktora_mnoze2
        
        ;jesli sa rowne sprawdz czy mlodszy bajt nie przekracza wartosci nastawy
        btfss   STATUS,Z
        goto    regulP_odejmij_mlodsze
        
        movf    liczba_thermo ,w
        subwf   liczba_nastawy,w  
        btfss   STATUS,C
        goto    regul_P_roznica_temp_ujemna
        
regulP_odejmij_mlodsze
        movf    liczba_thermo ,w
        subwf   liczba_nastawy,w  
        btfss   STATUS,C
        decf    liczba_przez_ktora_mnoze2,f

        movwf   liczba_przez_ktora_mnoze1
        ;roznice miedzy temperaturami w postaci liczby z A/D
        ;zamieniam na wartosc roznicy temp
        
        call    oblicz_wartosc_temperatury
        
        movff   wynik1,mnozona1
        movff   wynik2,mnozona2
        clrf   mnozona3
        clrf   mnozona4
        
        ;mnoze roznice temperatur razy wzmocnienie
        clrf    liczba_przez_ktora_mnoze4
        
        clrf   liczba_przez_ktora_mnoze3
        clrf   liczba_przez_ktora_mnoze2
        movf    KP,w
        movwf   liczba_przez_ktora_mnoze1
        
        call    mnozenie
        
        
        
        
        movf    wynik4,w
        bnz      regul_P_roznica_temp_powyzej100
        movf    wynik3,w
        bnz      regul_P_roznica_temp_powyzej100
        movf    wynik2,w
        bnz      regul_P_roznica_temp_powyzej100
        
        ;if the value is lower then 100
        ;ustaw PWM 
        ;if not ustaw 100%
        movlw   0x64
        cpfslt  wynik1
        goto    regul_P_roznica_temp_powyzej100
        
        
        movf    wynik1,w
        movwf   obliczona_Error_temp
        movwf    wartosc_zadanego_PWM
        
        movlw   2
        xorwf   wartosc_opcji_regulator,w
        btfss   STATUS,Z
        return 

        
        
        addwf   obliczona_korekta_I,w
        btfsc   STATUS,C
        goto    regul_P_roznica_temp_ujemna
        
        movwf    wartosc_zadanego_PWM
        
        ;if the value is lower then 100
        ;ustaw PWM 
        ;if not ustaw 100%
        movlw   0x64
        cpfslt  wartosc_zadanego_PWM
        goto    regul_P_roznica_temp_powyzej100
        
        return


        
