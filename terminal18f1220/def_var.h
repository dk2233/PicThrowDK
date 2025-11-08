

         



         cblock   80h
         w_temp
         status_temp
         pclath_temp
         bsr_temp
         fsrl_temp
         fsrh_temp
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
         liczba3
         tmp                       ; uzywany w odbiorze danych i procedurach poleceń
         tmp_hex                    ;uzywany w procedurze hex2dec
         tmp_hex_H                  ;starszy bajt 
         tmp6                       ; uzywany w poprawce temp
         tmp7                        ; uzywany do odbioru danych z rs232
         dec100
         dec10
         dec1
         stan_key
         stan2_key
         wynikh
         wynik
         wynik01
         znaczniki ;0x09a
         markers
         markers2
         markers3
         dane_lcd
         tmp_lcd              ; używany w procedurach lcd
         rcsta_temp
         ile_kanalow ;0x09f
           ktory_kanal_mierze ; 0x0a0
         odstep_pomiarowy
         aktualny_odstep
          ktory_rejestr_zapisuje
          pomiarH
          pomiarL
          pomiar_ulamek
           
          jaka_wartosc_regulujeH
          jaka_wartosc_regulujeL
          jak_duzo_probek ; 0x0a9
          
          ktora_probka
          ktory_kanal
          usrednianie_przez_co_mnoze
          znaczniki_ds
          polecenie_wysylane
         jak_duzo_bajtow_odbieram_z_ds
         
         pomiar0H
         pomiar0L
         pomiar1H
         pomiar1L
         pomiar2H
         pomiar2L
         pomiar3H
         pomiar3L
         pomiar4H
         pomiar4L
         pomiar5H
         pomiar5L
         pomiar6H
         pomiar6L
         pomiar7H
         pomiar7L
         pomiar_prad1H
         pomiar_prad1L
         pomiar_prad2H
         pomiar_prad2L
         bajt_ds
         poprawka0
         poprawka1
         poprawka2
         poprawka3
         poprawka4
         poprawka5
         poprawka6
         poprawka7
         poprawka_prad1
         poprawka_prad2
         jak_duzo_kanalow_pradu
         ktory_aktualnie_kanal_pradu
         
         dzien_10
         dzien_1
         godziny_10
         godziny_1
         minuty_10
         minuty_1
         sekundy_10
         sekundy_1
         
         do_sekundy
         pozycja_menu    
         numer_opcji
         polozenie_gwiazdki
         szybka_zmiana_wartosci
         
         fsrl1_temp
         fsrh1_temp
         histereza
         
         ustawianie_czasu_co_wyswietlam
         
         endc
;0xbe                           
        
         
;        cblock 100h
                  
;        endc

;eeprom                  
         cblock   0
         poprawka0_ee
         poprawka1_ee
         poprawka2_ee
         poprawka3_ee
         poprawka4_ee
         poprawka5_ee
         poprawka6_ee
         poprawka7_ee
         poprawka_prad1_ee
         poprawka_prad2_ee
         
         endc
;rejestry nieuzywane wykorzystuje jako dane

;        equ      TMR1L

;        equ      TMR1H

;                 equ      CCPR1H
;linia            equ      CCPR1L
                  
         
lampka            equ      4
lampka2           equ      4

czujnik_ds1820    equ      5                  

portlampka2       equ      PORTB
port_ds1820       equ      PORTC
port_CTS      equ      PORTC                  
port_RTS      equ          PORTC 
         
znacznik_CTS      equ      4
znacznik_RTS      equ      5
;klawisze


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;markers
;/*wyswietl */     
czy_usrednianie   equ      0
czy_wysylanie     equ      1
pomiary_zrobione  equ      2  ;znacznik tego czy pomiary zostaly skonczone
inicjuj_pomiary   equ         3
czy_wysylac_pomiary_serial    equ       4
czy_wyswietlam_temp     equ   5  
czy_wlaczyc_ponownie_temp    equ    6
trzymanie_klawisza            equ   7
             
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;markers2

przerwanie_t0     equ      0
przerwanie_t1     equ      1
pomiary           equ      2
sprawdz_odebrane  equ      3
wyslij_pomiar     equ      4
zalacz_moc        equ      5
reguluj           equ      6
wylacz_moc        equ      7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;markers3

pomiary_pradu           equ   0
znacznik_pomiaru_pradu  equ   1
czy_zegar_wyswietlac    equ   2
odswiezanie_zegara      equ   3
wcisnieto_klawisz       equ   4
dzialanie_po_klawiszu   equ    5
napisz_minus            equ   6
pokazuje_temperatury_47       equ   7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;znaczniki
czy_ponownie_wlaczyc_temp     equ   0
czy_ponownie_wlaczyc_zegar    equ   1
czy_moge_juz_zmieniac         equ   2 ; dotyczy momentu w którym trzymanie klawisza trwa 1 s -> zmiana wartości


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;pozycja_menu
;jezeli jest 0 to ekran główny
;ekran_glowny      equ   0
menu_opcje1       equ   0
menu_opcje2       equ   1
menu_opcje3       equ   2
menu_opcje4       equ   3

zmiana_opcji      equ   7
menu_opcje_end    equ   4
numer_opcji_koncowej    equ   0x10

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;numery opcji
opcja_czujniki            equ        1
opcja_odstep            equ         2
opcja_srednia                  equ       3
opcja_regulacja                equ        4
opcja_ustaw_temp              equ   5
;;;
opcja_pomiar_i             equ   6
opcja_wlacz_1                 equ   7
opcja_wlacz_2                 equ   8
opcja_histereza               equ   9
opcja_ustaw_moc               equ  0xa
opcja_ustaw_zegar                   equ   0xb
opcja_ustaw_serial                   equ   0xc
opcja_wyswietl_zegar          equ   0xd
opcja_wyswietl_temp           equ   0xe
opcja_podswietlenie           equ   0xf
;;
;poprawki_czuj           equ   

polozenie_liczby_menu         equ   0xc

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
kb_enter    equ      6
kb_minus    equ      7

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;klawisze
dlugosc_oczekiwania_na_zmiane       equ   4
latch_keys        equ      PORTD
port_keys         equ      PORTD
latch_back        equ   0
latch_down        equ   1
latch_up          equ   2
latch_enter       equ   3

;stan_key
mamy_back    equ   0
mamy_down   equ   1
mamy_up     equ   2
mamy_enter  equ   3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;LCD

set_4bit          equ   b'00101000'
display_on        equ   b'00001100'
latch_lcd          equ      LATD
latch_lcd_e        equ      LATC
latch_lcd_rw       equ      LATB
latch_lcd_rs       equ      LATB

;definicja bitow uzywanych w 4 bitowym przesylaniu 0 - uzywany 1 - nieuzywany
;zwiazane z opcja kasowania
ktore_bity_uzywane_na_lcd     equ   0x0f
ktore_bity_lcd_tris           equ   0xf0
normalne_ustawienie_tris_lcd  equ   0x0f


port_lcd          equ      PORTD

port_lcd_e	equ	PORTC
port_lcd_rw	equ	PORTB
port_lcd_rs	equ	PORTB

tris_lcd          equ      TRISD
;0 to pomiar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pin_e_4724        equ      1

;3 to ref+


enable		equ	3
rs		equ	3
rw		equ	2

;znaki transmisyjne
znak_cr           equ      0dh
znak_lf           equ      0ah
znak_I            equ      0cch

;znaczniki_ds
                  ;inicjacja         equ      0
                  ;skip_rom          equ      1             
dane_odebraneH    equ      1
dane_odebraneL    equ      0   

 

port_triak        equ      PORTB
latch_moc         equ       LATB

triak1            equ      0
triak2            equ      1

pomiar_prad1      equ      2
pomiar_prad2      equ      4

;histereza         equ   4
port_multiplekser equ   PORTC
latch_multiplekser equ   LATC
pin_A                  equ    0
pin_B                   equ   1
pin_C                   equ   2