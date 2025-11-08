

         



         cblock   20h
         w_temp
         status_temp
         pclath_temp
         linia1
         linia2
         linia3
         linia4
         letter
         n
         bit
         odebrano_liter
         liczba1
         liczba2
         tmp
         
         tmp7
                  
         dec100
         dec10
         dec1
         
         stan_key
         stan2_key
         
         wynikh
         wynik
         wynik01
         
       
         
         znaczniki
         markers
;dla przerwan     
         markers2
         dane_lcd
         rcsta_temp
         fsr_temp
         ile_kanalow 
           ktory_kanal_mierze
         odstep_pomiarowy
         aktualny_odstep
          ktory_rejestr_zapisuje
          pomiar0H
          pomiar0L
          pomiar0_ulamek
           
          jaka_wartosc_regulujeH
          jaka_wartosc_regulujeL
          jak_duzo_probek
          ktora_probka
          ktore_dzielenie_przez2
          
         endc
                  
         cblock   0a0h
                  
         endc
         
;        cblock 110h
                  
;        endc

                  
         cblock   0

         endc
;rejestry nieuzywane wykorzystuje jako dane

;        equ      TMR1L

;        equ      TMR1H

;                 equ      CCPR1H
;linia            equ      CCPR1L
                  
         
lampka            equ      3
lampka2           equ      0

portlampka        equ      PORTB
portlampka2       equ      PORTC
         
;klawisze


;markers
;/*wyswietl */     
czy_usrednianie   equ      0

             
;markers2

przerwanie_t0     equ      0
przerwanie_t1     equ      1
pomiary           equ      2
sprawdz_odebrane  equ      3
wyslij_pomiar     equ      4
zalacz_moc        equ      5
reguluj           equ      6
wylacz_moc        equ      7

;znaczniki
set_1    equ      0
set_10   equ      1
migaj    equ      2
;minus
licz_czy equ      3
see_minus         equ      4

;minus
odejmuj  equ      5
;ch_kf   equ      6


;;;
nie      equ      1
ile_znakow        equ      10h






;znaczniki
kalibracja        equ 0


port_serial       equ      PORTB
RXD               equ      7


;
ma       equ      2
mb       equ      1
mc       equ      0
dana     equ      3        
kb_change         equ      4
kb_cofnij         equ      5
kb_enter equ      6
kb_minus equ      7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;LCD
port_lcd equ      PORTD
port_lcd_e        equ      PORTB
port_lcd_rw       equ      PORTB
port_lcd_rs       equ      PORTB
tris_lcd equ      TRISD
;0 to pomiar

pin_e_4724        equ      1

;3 to ref+

enable            equ      0
rs                equ      1
rw                equ      2

;znaki transmisyjne
znak_cr           equ      0dh
znak_lf           equ      0ah
znak_I            equ      0cch
