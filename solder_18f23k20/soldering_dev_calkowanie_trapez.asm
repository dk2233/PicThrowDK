

        cblock  0x60
        
        
        W_TEMP
        status_temp
        bsr_temp
        ilosc_zliczen_tmr1
        ilosc_zliczen_tmr2
        ilosc_zliczen_tmr3
         
         
         tmp
         n
         dane_lcd
         tmp_lcd
         
        zliczenia_przerwania_TMR0
        ilosc_zliczen_tmr1_pomiar_ds
        stan_key
        
         markers
         ; markers2
         markers_pomiary
         markers_regulacja
	    
	markers_klawisze
         liczba1
;menu
         opcja_menu     ; zmienna przechowuj¹ca opcjê przy której jest gwiazdka
         
         polozenie_gwiazdka
         
         znaczniki_klawiszy_menu
         
         stan_menu

        wartosc_temp_set_h
        
        wartosc_temp_set
         wartosc_opcji2
         wartosc_opcji3
         wartosc_opcji_regulator
         wartosc_opcji_PWM
         KP
         Ki
        nastawa_Ti 
         wartosc_opcji_serial

        
       	dec100
	dec10
	dec1

        dzielonah
         dzielona
         
         liczba_przez_ktora_dziele
         
         ulamekh
         ulamekl
         
         operandh
         operandl
         
         reszta_H
        reszta_L
        
         mnozonah
         mnozonal
         
         liczba_przez_ktora_dziele_H
         liczba_przez_ktora_dziele_L
         
         
         
         mnozona1
        mnozona2
        mnozona3
        mnozona4
        
        liczba_przez_ktora_mnoze1
        liczba_przez_ktora_mnoze2
        liczba_przez_ktora_mnoze3
        liczba_przez_ktora_mnoze4
        
        
        wynik8
        wynik7
        wynik6
        wynik5
        wynik4
        wynik3
        wynik2
        wynik1
        wynik
        wynik01
        wynik001
        
         markers_dzielona
         dzielona4
         dzielona3
         dzielona2
         dzielona1
         
         liczba_przez_ktora_dziele_4
         liczba_przez_ktora_dziele_3
         liczba_przez_ktora_dziele_2
         liczba_przez_ktora_dziele_1
         
         reszta4
         reszta3
         reszta2
         reszta1
        
         
         
         
        
         tmp_hex_H
        tmp_hex
         tmp7
         
         lcd_adres_temeratur_position
         lcd_adres_temp_ds_position
         
        liczba_thermo_H 
        liczba_thermo 
         
        temp_thermo_H 
        temp_thermo
        temp_thermo_ulamek
        
        pomiarH
        pomiarL
        pomiar_ulamek
        
        liczba_thermo_H_1pomiar 
        liczba_thermo_1pomiar

        
        ktora_probka
        
        temp_ds
        temp_ulamek_ds
         
        temp_100
         temp_10
         temp_1
         
         
          jak_duzo_bajtow_odbieram_z_ds
         polecenie_wysylane
         n_ds
         bajt_CRC
         
         ilosc_procentow_On
         ilosc_procentow_100
        
        liczba_nastawy_h
        liczba_nastawy

        histereza
        
        
        wartosc_zadanego_PWM
        wartosc_zadanego_PWM_tmp
        
        
        Ki_ulamek
        obliczona_korekta_I
        aktul_itera_obl_korek_I
        
        a_obliczana_korekta_I
        a_obliczana_korekta_I_fraction
        
        obliczony_uchyb1
        obliczony_uchyb2
        
        obliczony_uchyb1_prev
        obliczony_uchyb2_prev
        
        endc
        

         cblock    0x200
         dane_odebrane
         
         endc
         
         
         
         
         cblock   0x300
         dane_odebrane_z_ds
         endc 
         
         cblock   0x330
         id_czujnika_ds
         
         endc







	list p=18f46k80
	include  "p18f46k80.inc"

	CONFIG RETEN=OFF , XINST=OFF,SOSCSEL=DIG,  FOSC = INTIO2, PLLCFG = OFF , FCMEN = OFF , IESO = OFF , PWRTEN = ON , BOREN=OFF , WDTEN= OFF , CANMX=PORTB , MSSPMSK = MSK7 , MCLRE=ON , STVREN = ON 

;definicje 

	
      include "libs/lcd.h"

czestotliwosc     equ      16000000

port_lampka  equ     PORTB
latch_lampka   equ     LATB
pin_lampka      equ     5

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;						ustawienie LCD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;definicja bitow uzywanych w 4 bitowym przesylaniu 0 - uzywany 1 - nieuzywany
;zwiazane z opcja kasowania
ktore_bity_uzywane_na_lcd     equ   0xf0

ktore_bity_lcd_tris           equ   0x0f
normalne_ustawienie_tris_lcd  equ   b'11110000'

;jaka inicjalizacja ekranu

;;                                1, DL (1 - 8 bit, 0 -4 bit), N - ilosc linii (1 - 2 linie), F = font   
; set_4bit		  equ      b'00101000' ;  4bit, 2 linie,font 5x8
set_4bit		  equ      b'00101000' ;  4bit, 2 linie,font 5x8
;;;                                 DCB  D = display 0 -wylacz, Cursor = 1/0 Blinking=1/0 
display_set         equ      b'00001100' ;ustawia blinking,cursor,
; display_set         equ      b'00001111' ;ustawia blinking,cursor,

;;;ustawiam entry                           I,S 
set_entry           equ             b'00000110' ;increment I=1, Shift = 1/0
; init_4bit          equ      b'00100010' ;ustawia 2 linie i 5x8 font
init_4bit          equ      b'00101010' ;ustawia 2 linie i 5x8 font
init_4bit_start          equ      b'00000011' ;ustawia 2 linie i 5x8 font
init_4bit_start2          equ      b'00000010' ;ustawia 2 linie i 5x8 font

port_lcd          equ      PORTC
latch_lcd          equ     LATC
tris_lcd          equ      TRISC

port_lcd_e        equ      PORTD
latch_lcd_e        equ      LATD
port_lcd_rw       equ      PORTD
latch_lcd_rw       equ      LATD
port_lcd_rs       equ      PORTA
latch_lcd_rs       equ     LATA


linia_1	equ	0x80
linia_2	equ	0xc0



enable            equ      6
rs                equ      5
rw                equ      5


ile_znakow        equ      16
jak_duzo_taktow_czekac_LCD    equ     0x2

; jezeli 4 bity lcd znajduja sie obok siebie w rejestrze
;w dolnych 4 bitach to tu ma byc 0
polozenie_danych_lcd  equ    0

jak_duzo_zliczen_TMR0   equ     3
jak_duzo_zliczen_TMR1_pomiar   equ     1
jak_duzo_zliczen_TMR1_pomiar_ds   equ     0x10
; jak_duzo_zliczen_TMR2   equ     0x4c
jak_duzo_zliczen_TMR2   equ     0x1
ile_zliczen_TMR3_do_pomiaru        equ   0x02

;znaczniki klawiszy MENU

opcje_po_przycisku_dol     equ      0
opcje_po_przycisku_gora     equ      1
opcja_bez_przycisku        equ       2
                


;stan MENU
menu_glowne       equ      0
wybor_opcji       equ     1      

opcja_set_temp          equ     0          
opcja_wysw_temp         equ     1
opcja_wysw_temp_ds         equ     2
opcja_typ_kontroler        equ     3
opcja_PWM                  equ    4
opcja_KP                  equ    5
opcja_Ki                  equ    6
opcja_Ti                  equ    7
opcja_o_czy_serial                  equ    8
  
; 4 opcje od 0 do 3 - tu trzeba wpisaæ jak du¿o opcji
; 5 opcje od 0 do 4 - tu trzeba wpisaæ jak du¿o opcji
; 6 opcje od 0 do 5 - tu trzeba wpisaæ jak du¿o opcji

koncowa_opcja_menu   equ            8

o_ile_zmieniam_nastawe_temp   equ          0x05
max_temp_set2           equ     0x1
max_temp_set1              equ     0xae
min_temp_set               equ    0x1e

o_ile_zmieniam_serial   equ          0x01
max_serial      equ     1
min_serial      equ     0

o_ile_zmieniam_typ_regul   equ          0x01
max_typ_regul      equ     2
min_typ_regul      equ     0

o_ile_zmieniam_KP   equ          0x01
max_KP      equ     0x5
min_KP      equ     1

o_ile_zmieniam_PWM   equ          0x01
max_PWM      equ     0x64
min_PWM     equ     0
o_ile_zmieniam_Ti   equ          0x01
max_Ti      equ    0x14 
min_Ti     equ     1

o_ile_zmieniam_Ki   equ          0x01
max_Ki      equ    0x0a

min_Ki_01       equ     0xa


polozenie_wartosci    equ      0x0a






;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; OPCJE KLAWISZY
;;;;;


;definicje klawiszy - port przypisany do kazdego z klawiszy moze byc tym samym portem 
port_klawisz_dol  	equ		PORTE
port_klawisz_gora	  	equ		PORTE
port_klawisz_enter 		equ		PORTE

pin_klawisz_dol		equ		2
pin_klawisz_gora		equ		0
pin_klawisz_enter		equ		1






;stan_key
;w tym rejestrze przechowuje ktore klawisze zostaly wcisniete
;sens tego jest taki, ze musi byc sprawdzone co jakis czas czy ten sam klawisz jest wciaz wcisniety
;wszystkie bity te same co w port_key

wcisniety_jest_klawisz_dol  	equ	0
wcisniety_jest_klawisz_gora  	equ	1
wcisniety_jest_klawisz_enter  	equ	2


kb_wcisnieto      equ      6
kb_sprawdz        equ      7


  

marker_opcji      equ      0x2a

;markers_klawisze

wcisnieto_klawisz		equ		0
minal_czas_zliczania_po_wcisnie		equ	 	1
wciaz_naciskam_klawisz_zmiany           equ        2

;16 probek
usrednianie_przez_co_mnoze      equ     0x10
jak_duzo_probek                 equ     0x10


;markers 
wyswietlam_temper_menu            equ     0
odswiez_wyswietlanie_temp         equ    1
odswiez_menu                      equ     2
czy_usrednianie                      equ     3
oblicz_srednia                       equ        4
wyswietlam_temp_menu_ds              equ        5
odswiez_wyswietlanie_temp_ds              equ        6
wyswietlam_opcje_PWM              equ        7




;;;;;;;;;;;;;;;;;;;;;;;;;;markers2
czy_wysylam_dane_serial         equ     0



;;;;;;;;;;;;;;;;;;;;;;;;;;markers_pomiary     

czy_wykonuje_pomiar_DS1                equ      0
czy_jestem_po_spr_triak         equ     1

czekam_na_odczyt_DS1          equ   3        
odczytaj_pomiar_DS1           equ   4

;;;;;;;;;;;;;;;;;;;;;;;;;;markers_regulacja
czy_mam_regulowac               equ     0
error_uchyb_ujemny              equ     1
error_korekta_czast_ujemna              equ     2
error_korekta_ujemna                    equ     3

latch_ds1820      equ      LATD
port_ds1820      equ      PORTD

Tris_ds1820       equ      TRISD
czujnik_ds1820  equ      2
;zalezne od czestotliwosci zegara
;zeby miec 60us dla


;dla 16MHz
;*4
t2con_dla_60us           equ   b'00011100'
;*10
t2con_dla_480us          equ   b'001111100'

;0x3f - dla 4 MHz
;
;movlw   
;movwf    T2CON
czas_oczekiwania_60us         equ   0x3c
czas_oczekiwania_45us         equ   0x2d
czas_oczekiwania_15us         equ   0x0f
czas_oczekiwania_480us        equ   0xf0


port_triak   equ     PORTD
latch_triak   equ     LATD
pin_triak     equ     3


;2014.05.20
;wersja dla procesora Pic18F46K80

;miganie dioda

;tylko zeby sprawdzic ze wszystko dobrze dziala

;PORTB -7 - 
;PORTB -6 - 
;PORTB -5 - 
;PORTB -4 - 
;PORTB -3 - 
;PORTB -2 - 
;PORTB -1 - 
;PORTB -0 - 

         
;POrtc - 0 - 
;POrtc - 1 - 
;PORTC - 2 - 
;POrtc - 3 - 
;POrtc - 4 - 
;POrtc - 5 - 
;POrtc - 6 - 
;POrtc - 7 - 

;PORTA - 0 - 
;PORTA - 1 - 
;PORTA - 2 - 
;PORTA - 3 - 
;PORTA - 4 - klawisz 1
;PORTA - 5 - 


;PORTD6 = 
;PORTD5 = 


;timery
;TMR0  -  uzywany na poczatku do LCD a pozniej do wykrywania klawiszy


;TMR1 - uzywany do odliczania czasu do pomiaru temp analogowo

;TMR2  - uzywany do Ds18b20

;TMR3  - czekanie na pomiar ds18b20

         org      0000h
BEGIN

         goto     inicjacja
                  
         
         org      0008h
         
przerwanie        
;zachowuje rejestr W
        MOVWF W_TEMP ; W_TEMP is in virtual bank
        MOVFF STATUS, status_temp ; STATUS_TEMP located anywhere
        MOVFF BSR, bsr_temp ; BSR_TMEP located anywhere
        
        
;po to by wszystkie ustawienia banki itd byly na 0    
         ;bcf      STATUS,RP0

         ;btfss    INTCON,RBIE
         ;goto     przerwanie_0
         ;btfss    INTCON,RBIF
         ;goto     przerwanie_0
         
         ;bsf      markers,przerwanie_rb
         
         ;goto     wyjscie_przerwanie
         
         
         btfss     PIE4,TMR4IE
         goto      przerwanie_0

         
         btfsc    PIR4,TMR4IF
         goto     wykryto_t4 
         
przerwanie_0         
         btfss    PIE1,ADIE
         goto     przerwanie_1
         
         ;bcf      STATUS,RP0
         btfsc    PIR1,ADIF
         goto     przerwanie_pomiaru

przerwanie_1
       ;  bsf      STATUS,RP0
       ;  btfss    PIE1,TMR2IE
       ;  goto     przerwanie_1
       ;  
       ;  btfsc    PIR1,TMR2IF
       ;  goto     wykryto_t2      

przerwanie_1      
         
         btfss    PIE1,TMR1IE
         goto     przerwanie_2
        
         btfsc    PIR1,TMR1IF
         goto     wykryto_t1

przerwanie_2  
        
         btfss     INTCON,T0IE
         goto      przerwanie_3

         
         btfsc    INTCON,T0IF
         goto     wykryto_t0 
przerwanie_3      
        btfss     PIE2,TMR3IE
         goto      przerwanie_4

         
         btfsc    PIR2,TMR3IF
         goto     wykryto_t3 
         
przerwanie_4
         
         btfss    PIE1,TMR2IE
         goto     przerwanie_5
         
        
         btfsc    PIR1,TMR2IF
         goto     wykryto_t2
przerwanie_5
         
         
        
         
;        jezeli nic nie wykryto
         
wyjscie_przerwanie
        MOVFF bsr_temp, BSR ; Restore BSR
        MOVF W_TEMP, W ; Restore WREG
        MOVFF status_temp, STATUS ; Restore STATUS
        retfie


         
wykryto_t0
         bcf      INTCON,TMR0IF
         

;wylacz przerwanie tmr0
         bcf      INTCON,TMR0IF
         bcf      INTCON,TMR0IE         

;wlacz znacznik ktory oznacza ze nalezy przejsc do procedury przycisku
         bsf     markers_klawisze,minal_czas_zliczania_po_wcisnie
         goto     wyjscie_przerwanie                  
                                   
wykryto_t1
         bcf      PIR1,TMR1IF
        
        decfsz   ilosc_zliczen_tmr1,f
         goto    wyjscie_przerwanie

        movlw   jak_duzo_zliczen_TMR1_pomiar
         movwf   ilosc_zliczen_tmr1
         
         
         ;zmierz ds18b20
         ;jezeli mam ustawiony bit ze wykonuje pomiary to
         
         
         bsf    ADCON0,GO
         
         
         decfsz   ilosc_zliczen_tmr1_pomiar_ds,f
         goto    wyjscie_przerwanie
         
         
         movlw   jak_duzo_zliczen_TMR1_pomiar_ds
         movwf   ilosc_zliczen_tmr1_pomiar_ds
         
         ;jezeli mam ustawiony bit ze wykonuje pomiary to
         ; btfss    markers_pomiary,czy_wykonuje_pomiar_DS1
         ; bsf      markers_pomiary,czy_czytam_ID_DS1
         
         btfsc    markers_pomiary,czekam_na_odczyt_DS1
         goto     rozkaz_odczytania_pomiaru
         
         bsf      markers_pomiary,czy_wykonuje_pomiar_DS1
         
         goto     wyjscie_przerwanie                  
         
rozkaz_odczytania_pomiaru
         bsf      markers_pomiary,odczytaj_pomiar_DS1
         goto     wyjscie_przerwanie                  
        

                           

         

         
wykryto_t2

         bcf      PIR1,TMR2IF
               
        decfsz   ilosc_zliczen_tmr2,f
         goto    wyjscie_przerwanie

        movlw   jak_duzo_zliczen_TMR2
         movwf   ilosc_zliczen_tmr2
         
        ; btfsc       latch_lampki,pin_lampki
        ; goto       wylacz_lampke
        
        
        ; bsf     port_lampki,pin_lampki
        ; goto     wyjscie_przerwanie
        
; wylacz_lampke        
        ; bcf     port_lampki,pin_lampki
        goto     wyjscie_przerwanie



         
wykryto_t3
;uzywam do wykrywania czy juz wylaczyc triaka
         bcf      PIR2,TMR3IF
               
         decfsz   ilosc_zliczen_tmr3,f
         goto    wyjscie_przerwanie
         
         movlw   0x13
         movwf   ilosc_zliczen_tmr3
         
        
        goto     wyjscie_przerwanie
       

wykryto_t4
;uzywam do wykrywania czy juz wylaczyc triaka
         bcf      PIR4,TMR4IF
         
         
         btfss  port_klawisz_gora,pin_klawisz_gora
         goto   wykryto_t4_wcisniety_klawisz
         
         btfss  port_klawisz_dol,pin_klawisz_dol
         goto   wykryto_t4_wcisniety_klawisz
         
         decfsz   ilosc_procentow_On,f
         goto    wykryto_t4_2  
         
         bcf        latch_triak,pin_triak
         bcf     latch_lampka,pin_lampka
 
wykryto_t4_2 
         decfsz  ilosc_procentow_100
         goto    koncz_triak
         
         movlw   0x64
         movwf   ilosc_procentow_100
         
         
         movf   wartosc_zadanego_PWM,w
         movwf   ilosc_procentow_On
         ;jesli to nie jest 0 to wlacz triak
         
         btfsc     STATUS,Z
         goto     koncz_triak
         bsf        latch_triak,pin_triak
         bsf     latch_lampka,pin_lampka
          
koncz_triak        
        btfsc       markers_pomiary,odczytaj_pomiar_DS1
         bsf      markers_pomiary,czy_jestem_po_spr_triak
 
        btfsc      markers_pomiary,czy_wykonuje_pomiar_DS1
         bsf      markers_pomiary,czy_jestem_po_spr_triak
         
        goto     wyjscie_przerwanie
        
wykryto_t4_wcisniety_klawisz
        bcf        latch_triak,pin_triak
        bcf     latch_lampka,pin_lampka
        goto     wyjscie_przerwanie
       
przerwanie_pomiaru
         bcf      PIR1,ADIF
;kopiuje pomiar do rejestru
;sprawdz czy ustawiono 1 lub 0 - wtedy nic nie dziele 
         
         movf     ADRESH,w
         movwf    liczba_thermo_H_1pomiar
         
         btfss  liczba_thermo_H_1pomiar,7
         goto   przerwanie_pomiaru_1
         
         ;jesli liczba ujemna
         clrf   liczba_thermo_H_1pomiar
         
przerwanie_pomiaru_1         
         

         movff     ADRESL,liczba_thermo_1pomiar
         btfsc  liczba_thermo_H_1pomiar,7
         clrf   liczba_thermo_1pomiar
        
        bsf     markers,oblicz_srednia

       goto     wyjscie_przerwanie
       
       
       

wait_kilka_sekund
        bcf     PIE2,TMR3IE
        ; movlw       b'11011001'
        ; movwf       T3CON
        movlw    0xa
        movwf    n
        bcf     PIR2,TMR3IF
czekaj05sek
        btfss  PIR2,TMR3IF
        goto     czekaj05sek
        bcf     PIR2,TMR3IF
        decfsz   n,f
        goto     czekaj05sek
        return


        
       

;;;;;;;;;;;;;;;;;;;;;;;;
;;;PROGRAM
;;;;;;;;;;;;;;;;;;;;;;;;;
      




      include "libs/lcd4bit18_raystar.asm"

      INCLUDE  "libs\mnozenie_2bajty.asm"
      include "libs/dzielenie18_2bajt.asm"
      include "libs/dzielenie18_4bajt.asm"
      include "libs/hex2dec18_2bajty.asm"
      include "libs/hex2dec18.asm"
      INCLUDE  "libs/zamien_na_hex.asm"
      INCLUDE  "libs/mnozenie_32bity_4bajty.asm"

        
Start
        
        ;wywolanie lcd inicjacji
       
        call     lcd_init
        
        
        
        movlw   3
        movwf   KP
        movlw   0x5
        movwf   nastawa_Ti
        movff    nastawa_Ti, aktul_itera_obl_korek_I

        movlw   0
        movwf   Ki
        movlw   0x5
        movwf   Ki_ulamek
        ;test opcji w menu
         movlw   0xa
         movwf  histereza
         movlw    min_temp_set
         movwf    wartosc_temp_set
         clrf     wartosc_temp_set_h
         movlw    0x00
         movwf    wartosc_opcji2
         
         movlw    0x00
         movwf    wartosc_opcji3
         
         movlw    0x01
         movwf    wartosc_opcji_regulator
         
         
        
	bsf      INTCON,GIE
        bsf      INTCON,PEIE

        
        
        
        movlw   b'00010000'
        movwf   ADCON1
        
        movlw   b'10111101'
        movwf   ADCON2
        ;uruchamiam A/D
        movlw   b'00000001'
        movwf   ADCON0
         movlw   jak_duzo_zliczen_TMR1_pomiar
         movwf   ilosc_zliczen_tmr1 
 
        bsf     markers,czy_usrednianie

         movlw  1
         lfsr  FSR0,ANCON0         
         movwf   INDF0
         lfsr  FSR0,ANCON1
         clrf   INDF0
        
        movlw     jak_duzo_probek
         movwf    ktora_probka

        movlw    8
         movwf    jak_duzo_bajtow_odbieram_z_ds



        movlw   jak_duzo_zliczen_TMR1_pomiar_ds
         movwf   ilosc_zliczen_tmr1_pomiar_ds
        
        movlw   jak_duzo_zliczen_TMR2
         movwf   ilosc_zliczen_tmr2
        
        ; movlw   0x4c
        ; movwf   PR2
        movlw   b'10000010'
        movwf    T0CON
        
        movlw    b'00100011'       
        movwf    T1CON
        bsf     PIE1,TMR1IE
        bsf      PIE1,ADIE
        ; movlw   0xff
        movlw   0x6e
        movwf   PR2
        
        ;ustawienia 13 ms T2con
        
        movlw   b'01111111'
        movwf   T2CON
        bcf     PIE1,TMR2IE
        
        movlw   b'00110001'
        movwf   T3CON
        movlw   0x13
        movwf   ilosc_zliczen_tmr3
        bcf     PIE2,TMR3IE
        
        movlw   b'01001110'
        movwf   T4CON
        bcf     PIE4,TMR4IE
        movlw   0x97
        movwf   PR4
        
        movlw    b'10010000'
         movwf    RCSTA1
         
         clrf     RCSTA2
         
         clrf     SPBRGH2

         clrf     SPBRG2
         
         ;9600 baudow dla 16 MHz
         clrf     TXSTA1
         clrf     TXSTA2
         movlw    0xa0
         movwf    SPBRG1
         movlw    0x01
         movwf     SPBRGH1
         bsf      TXSTA1,BRGH
         bsf      TXSTA1,TXEN
         ;bsf      TXSTA2,TXEN
         movlw    b'00001000'
         movwf    BAUDCON1
         ; clrf     PIE1
         bcf      PIE1,RC1IE
        
        
        call     check_busy4bit
        movlw   linia_1
        call    send

       movlw       HIGH napis_start
      movwf       TBLPTRH
      
      movlw       LOW napis_start
      movwf       TBLPTRL
      
napis_start_petla        
        call     check_busy4bit
        TBLRD *+
         movf        TABLAT,w

         
         btfsc    STATUS,Z
         goto     napis_start_2
         
         
         call     write_lcd
         

        
        goto    napis_start_petla
        
napis_start_2
        call     check_busy4bit
        movlw   linia_2
        call    send

       movlw       HIGH napis_start2
      movwf       TBLPTRH
      
      movlw       LOW napis_start2
      movwf       TBLPTRL
       
napis_start_petla2
        call     check_busy4bit
        TBLRD *+
         movf        TABLAT,w

         
         btfsc    STATUS,Z
         goto     inicjuj_napis
         
         
         call     write_lcd
         

        
        goto    napis_start_petla2
        
        
inicjuj_napis
       call wait_kilka_sekund
        call wait_kilka_sekund
        call wait_kilka_sekund
      
      movlw     display_clear
      call      send
      call     check_busy4bit
      
      
        movlw   linia_1
        call    send
        call     check_busy4bit
        
        
        
        movlw    0
         movwf    opcja_menu

         
         bsf znaczniki_klawiszy_menu,opcja_bez_przycisku
         
         bsf  stan_menu,menu_glowne
         
           
          
         ; clrf     znak_linia
         ;clrf     znak_linia2

         movlw    linia_1
         movwf    polozenie_gwiazdka
         
;druga strona pamieci tAM umieszczam wszystkie slowa menu

         call       Wyswietlanie_Menu   

        
       goto LOOP



napis_start
        ; db "Que pasa amigo?",0
        db "David R. Lobato",0
napis_start2
        ; db "Que pasa amigo?",0
        db "Vict.A.Caballero",0
       
       
 
opcja0 
         db "t.set    ",0
         
opcja1  
        
        db     "t.act.   ",0
        
         
      
opcja2
        db     "ref.temp ",0
         
         

opcja3
         db     "typ.cont.",0
         
         

opcja4
        db     "- PWM -  ",0
        
opcja5
        db     "KP of P  ",0
opcja6
        db     "Ki of Pi  ",0
opcja7
        db     "Ti of P  ",0
opcja8

         db     "serial ? ",0

       
       










;;;;;;;;;;;;;;;;;;;;;MENU


Znajdz_wartosc_opcji
;
;tu wybieram opcje do wyswietlenia obok opcji w menu
;
         
         lfsr     FSR0, wartosc_temp_set
         
         movlw    opcja_set_temp
         xorwf      tmp,w
         btfsc     STATUS,Z
         goto      Wyswietl_temp_nastawy
         
         
         movlw    opcja_wysw_temp
         xorwf      tmp,w
         btfsc     STATUS,Z
         goto      Wyswietl_temp_liczba_dig
         
         movlw    opcja_wysw_temp_ds
         xorwf      tmp,w
         btfsc     STATUS,Z
         goto      Wyswietl_temp_liczba_ds
         
         movlw    opcja_Ki
         xorwf      tmp,w
         btfsc     STATUS,Z
         goto      Wyswietl_opcje_Ki
         
         
         movlw    opcja_typ_kontroler
         xorwf      tmp,w
         btfsc     STATUS,Z
         goto      Wyswietl_typ_kontroler
         
         
wyswietlam_opcje_1bajtowe       
         movf     tmp,w         
         
         addwf    FSR0L,f
         
         
         
wyswietlam_opcje_1bajtowe2         
         movff    INDF0,tmp_hex
         clrf   tmp_hex_H
         call     hex2dec18

                 
         
         call     check_busy4bit
         
         movf     dec100,w
         btfss  STATUS,Z
         goto   wyswietlam_opcje_1bajtowe_100
         movlw  _puste
         call     write_lcd
         goto   wyswietlam_opcje_1bajtowe_10
wyswietlam_opcje_1bajtowe_100
         
         addlw    0x30
         
         call     write_lcd
         
wyswietlam_opcje_1bajtowe_10
         call     check_busy4bit

         
         movf     dec10,w
         btfss  STATUS,Z
         goto   wyswietlam_opcje_1bajtowe_10_2
         
         movf     dec100,w
         btfss  STATUS,Z
         goto   wyswietlam_opcje_1bajtowe_10_2
         
         movlw  _puste
         call     write_lcd
         goto   wyswietlam_opcje_1bajtowe_1
         
wyswietlam_opcje_1bajtowe_10_2
        call     check_busy4bit    
        movf     dec10,w
         addlw    0x30
         
         call     write_lcd
wyswietlam_opcje_1bajtowe_1         
         call     check_busy4bit
         
         movf     dec1,w
         addlw    0x30
         call     write_lcd
         call     check_busy4bit
         
         
         
         ;jesli opcja wyswietlana jest PWM 
         ;dopisz %
         movlw    opcja_PWM
         xorwf      tmp,w
         btfsc     STATUS,Z
         call      opcja_PWM_wyswietl_procent
         
         call    check_busy4bit
         movlw  _puste
         call     write_lcd
         
         call     check_busy4bit
         movlw  _puste
         call     write_lcd
         
         call     check_busy4bit
         movlw  _puste
         call     write_lcd
         
          ; 
         ; movlw  _stopni
         ; movf   wartosc_opcji6,w  
         ; call   write_lcd
         
         return
opcja_PWM_wyswietl_procent
        movlw   _procent
        call     write_lcd
        return
         


         
         
         
         
Wyswietl_opcje_Ki
        movf    Ki,w
        btfss   STATUS,Z
        goto    Wyswietl_opcje_Ki_jednosci
        
        call     check_busy4bit    
        movlw   "1"
        call    write_lcd
        
        call     check_busy4bit    
        movlw   "/"
        call    write_lcd

        movff   Ki_ulamek,tmp_hex
        goto    Wyswietl_opcje_Ki_ogolne
        
        
Wyswietl_opcje_Ki_jednosci
        call    check_busy4bit
         movlw  _puste
         call     write_lcd
         
         call     check_busy4bit
         movlw  _puste
         call     write_lcd
         
        movff   Ki,tmp_hex
        
Wyswietl_opcje_Ki_ogolne        
         clrf   tmp_hex_H
         call     hex2dec18

                 
         call     check_busy4bit

         
         movf     dec10,w
         btfss  STATUS,Z
         goto   Wyswietl_opcje_Ki_ogolne10
         
         movf     dec100,w
         btfss  STATUS,Z
         goto   Wyswietl_opcje_Ki_ogolne10
         
        
         goto   Wyswietl_opcje_Ki_ogolne1
         
Wyswietl_opcje_Ki_ogolne10
        call     check_busy4bit    
        movf     dec10,w
         addlw    0x30
         call     write_lcd
         
Wyswietl_opcje_Ki_ogolne1         
         call     check_busy4bit
         movf     dec1,w
         addlw    0x30
         call     write_lcd
         call     check_busy4bit
         
         
         call    check_busy4bit
         movlw  _puste
         call     write_lcd
         
         call     check_busy4bit
         movlw  _puste
         call     write_lcd
         
         call     check_busy4bit
         movlw  _puste
         call     write_lcd
         
         
         
         return

        
        
        
        
        
        
        
        
tab_reg_on_off
        db      "on/off",0
        
tab_reg_P
        db      "reg P ",0
tab_reg_PI
        db      "reg PI",0


Wyswietl_typ_kontroler
        movlw   0
        cpfseq  wartosc_opcji_regulator
        goto    Wyswietl_typ_kontroler2
        
        
        movlw       HIGH tab_reg_on_off
      movwf       TBLPTRH
      
      movlw       LOW tab_reg_on_off
      movwf       TBLPTRL
      
      
      goto       napis_petla_typ_regulacji
      

Wyswietl_typ_kontroler2      
      movlw   1
        cpfseq   wartosc_opcji_regulator
        goto     Wyswietl_typ_kontroler3
        
        
        movlw       HIGH tab_reg_P
      movwf       TBLPTRH
      
      movlw       LOW tab_reg_P
      movwf       TBLPTRL
      
      
      goto       napis_petla_typ_regulacji
      
Wyswietl_typ_kontroler3
      
        
        
        movlw       HIGH tab_reg_PI
      movwf       TBLPTRH
      
      movlw       LOW tab_reg_PI
      movwf       TBLPTRL
      
      
      
      
napis_petla_typ_regulacji
        call     check_busy4bit
        TBLRD *+
         movf        TABLAT,w

         
         btfsc    STATUS,Z
         return
         
         
         call     write_lcd
         

        
        goto    napis_petla_typ_regulacji
         
        
        




         
Wyswietl_temp_nastawy
        movff   wartosc_temp_set_h,dzielonah
        movff   wartosc_temp_set,dzielona


        call    zamien_hex_na_dec_2_bajty   
         call    check_busy4bit
         movlw  _stopni
         ; movf   wartosc_opcji6,w  
         call   write_lcd
         call     check_busy4bit
         movlw  _puste
         call     write_lcd
        return


        

        
Wyswietl_temp_liczba_dig
        
        bsf     markers,wyswietlam_temper_menu
        ;zeby odczytac adres aktualny musze wywolac check_busy
        
        call    check_busy4bit
        ;adres jest w tmp_lcd
        movff   tmp_lcd,lcd_adres_temeratur_position
        bsf     lcd_adres_temeratur_position,7
        
Wyswietl_temp_liczba_dig2
        movff   liczba_thermo_H,liczba_przez_ktora_mnoze2
        movff   liczba_thermo,liczba_przez_ktora_mnoze1
        call    oblicz_wartosc_temperatury
        
        movff   wynik2,dzielonah
        movff   wynik1,dzielona
        
        
        btfss   dzielonah,7
        goto    Wyswietl_temp_liczba_dig_plus
        
        
        ;jesli liczba ujemna
        
        movlw   1
        subwf    lcd_adres_temeratur_position,w
        call    send
        call    check_busy4bit
        movlw   _minus
        call    write_lcd
        call    check_busy4bit
        comf    dzielonah
        comf    dzielona
        
Wyswietl_temp_liczba_dig_plus        
        call    zamien_hex_na_dec_2_bajty   
         call    check_busy4bit
         movlw  _stopni
         ; movf   wartosc_opcji6,w  
         call   write_lcd
         call     check_busy4bit
         movlw  _puste
         call     write_lcd
        return

         
Wyswietl_temp_liczba_dig_z_LOOP   
        bcf     markers,odswiez_wyswietlanie_temp
        movf    lcd_adres_temeratur_position,w
        call    send

        call    check_busy4bit
        goto    Wyswietl_temp_liczba_dig2
        


 
 
 
 
 
 
Wyswietl_temp_ds_z_LOOP   
        bcf     markers,odswiez_wyswietlanie_temp_ds
        movf    lcd_adres_temp_ds_position,w
        call    send
        
        
        call    check_busy4bit
        goto    Wyswietl_temp_liczba_ds2       



Wyswietl_temp_liczba_ds
        bsf     markers,wyswietlam_temp_menu_ds
        ;zeby odczytac adres aktualny musze wywolac check_busy
        
        call    check_busy4bit
        ;adres jest w tmp_lcd
        movff   tmp_lcd,lcd_adres_temp_ds_position
        bsf     lcd_adres_temp_ds_position,7
        
Wyswietl_temp_liczba_ds2        
        movff    temp_ds,tmp_hex
         clrf   tmp_hex_H
        call     hex2dec18
         
         
         call        check_busy4bit 
          
         movf     dec100,w
         bz       zamien_dane_na_temp_send10
         call     zamien_na_hex
         
         call     write_lcd

  
        
         
zamien_dane_na_temp_send10         
        call        check_busy4bit 
         movf     dec10,w
         bz       zamien_dane_na_temp_send1
         
         
         
        
         call     zamien_na_hex
         
         call     write_lcd
         
         
zamien_dane_na_temp_send1   
      call        check_busy4bit 
      
            movf     dec1,w
         call     zamien_na_hex         
         
           call     write_lcd
         
         call        check_busy4bit 
               
         movlw    "."
         call       write_lcd
        
         movf     temp_ulamek_ds,w
       
zamien_ulamek_dziesietnie
        ;zasada jest bardzo prosta
        ;trzeba pomno¿yæ wartoœæ 625 przez liczbe w ulamku i zamienic na dziesietna wartosc
        
        movwf   operandl
        clrf    operandh
        
        movlw   0x2
        movwf   mnozonah
        movlw   0x71
        movwf   mnozonal
        
        
        movf    operandl,w
        
        call    mnozenie_2bajty
        
        
        
        ;dziele przez  100
        ;wtedy otrzymuje ilosc setek i to dalej przerabiam przez hex2dec
        movff    wynik1,dzielonah
        movff    wynik1,dec10
        movff   wynik, dzielona
        movff   wynik, dec1
        movlw    0x64
        movwf   liczba_przez_ktora_dziele_L
        clrf    liczba_przez_ktora_dziele_H
        call    dzielenie_2bajt
        ;na razie przechowuje w dec10 i dec1 wynik ulamka
        
        movf    reszta_L,w
        movwf   temp_100
        
        movff    wynik1,dzielonah
        movf    wynik,w
        movwf    tmp_hex
        clrf     tmp_hex_H
        call    hex2dec18
        
        
        
        ; call        check_busy4bit 
          
        movff     dec10, dec100
         
        movff     dec1,dec10

        
         
        
         
zamien_ulamek_na_temp_send10         
        
        
        call        check_busy4bit 
        movf     dec100,w
        
         call     zamien_na_hex
         
         call     write_lcd
         
         
zamien_ulamek_na_temp_send1   
      call        check_busy4bit 
      
            movf     dec10,w
         call     zamien_na_hex         
         
         
           call     write_lcd
        
        
        call        check_busy4bit 
        movlw   _stopni
          call     write_lcd
         call     check_busy4bit
         movlw  _puste
         call     write_lcd
        return


        
         
         
Znajdz_wyraz_opcji_dla_linii

      movlw     0  
      cpfseq    tmp
      goto      Znajdz_wyraz_opcji_dla_linii1
      
      
      movlw       HIGH opcja0
      movwf       TBLPTRH
      
      movlw       LOW opcja0
      movwf       TBLPTRL
      return
               
Znajdz_wyraz_opcji_dla_linii1
        movlw     1
      cpfseq    tmp
      goto      Znajdz_wyraz_opcji_dla_linii2

         movlw       HIGH opcja1
      movwf       TBLPTRH
      
      movlw       LOW opcja1
      movwf       TBLPTRL
      return
      
      
               
Znajdz_wyraz_opcji_dla_linii2
        movlw     2
      cpfseq    tmp
      goto      Znajdz_wyraz_opcji_dla_linii3

         movlw       HIGH opcja2
      movwf       TBLPTRH
      
      movlw       LOW opcja2
      movwf       TBLPTRL
      return
               
Znajdz_wyraz_opcji_dla_linii3
        movlw     3
      cpfseq    tmp
      goto      Znajdz_wyraz_opcji_dla_linii4

         movlw       HIGH opcja3
      movwf       TBLPTRH
      
      movlw       LOW opcja3
      movwf       TBLPTRL
      return
      
               
Znajdz_wyraz_opcji_dla_linii4
        movlw     4
      cpfseq    tmp
      goto      Znajdz_wyraz_opcji_dla_linii5

         movlw       HIGH opcja4
      movwf       TBLPTRH
      
      movlw       LOW opcja4
      movwf       TBLPTRL
      return



Znajdz_wyraz_opcji_dla_linii5      
        movlw     5
      cpfseq    tmp
      goto      Znajdz_wyraz_opcji_dla_linii6

         movlw       HIGH opcja5
      movwf       TBLPTRH
      
      movlw       LOW opcja5
      movwf       TBLPTRL

      
         return
         
         
         
Znajdz_wyraz_opcji_dla_linii6
        movlw     6
      cpfseq    tmp
      goto      Znajdz_wyraz_opcji_dla_linii7

         movlw       HIGH opcja6
      movwf       TBLPTRH
      
      movlw       LOW opcja6
      movwf       TBLPTRL

      
         return
         
Znajdz_wyraz_opcji_dla_linii7        
        movlw     7
      cpfseq    tmp
      goto      Znajdz_wyraz_opcji_dla_linii8

         movlw       HIGH opcja7
      movwf       TBLPTRH
      
      movlw       LOW opcja7
      movwf       TBLPTRL

        return
        
Znajdz_wyraz_opcji_dla_linii8
        movlw     8
      cpfseq    tmp
      goto      Znajdz_wyraz_opcji_dla_linii9

         movlw       HIGH opcja8
      movwf       TBLPTRH
      
      movlw       LOW opcja8
      movwf       TBLPTRL

Znajdz_wyraz_opcji_dla_linii9
        return
         
         
Wyswietlanie_Menu

        ;wylaczam odswiezanie chyba ze znow bedzie opcja 
        ;wyswietlania temp zmierzonej
        
        bcf     markers,wyswietlam_temper_menu
        bcf     markers,wyswietlam_temp_menu_ds
         ;opcja_menu   - tu przechowywana jest wartoœæ wskazywanej opcji
         
         ;np 0 - opcja 0
         ;np 1 - opcja 1
         
         ; movlw     display_clear
      ; call      send
      call     check_busy4bit
         
         ;numer opcji jest wartoœci¹ rejestru wq którym jest przechowywana tablica z adresami tablic z opcjami ekranu
         
         
         ; clrf     znak_linia
         ;clrf     znak_linia2
         
         movlw   linia_pierwsza
         addlw    0x01
         call    send
         
         
         
        movf     opcja_menu,w
         movwf    tmp
                
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_dol
         decf     tmp,f
         
         ;ale jezeli jest 0
         
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_gora
         nop
         
         btfsc    znaczniki_klawiszy_menu,opcja_bez_przycisku
         nop
           
        call     Znajdz_wyraz_opcji_dla_linii
         
Wyswietlanie_Menu_linia_1   


         call     check_busy4bit
              
        
         
         
         
         
         
         ;movf     znak_linia1,w
         ;jezeli jest wyswietlana opcja 0 i przycisk nie byl wcisniety to wyswietl tu opcja0
         
         
        
         
         ;jezeli opcja_menu == 0 wyswietl t¹ opcje:
         
         TBLRD *+
         movf        TABLAT,w

         
         btfsc    STATUS,Z
         goto     Wyswietlanie_Menu_linia_1_Value
         
         
         call     write_lcd

         goto    Wyswietlanie_Menu_linia_1

Wyswietlanie_Menu_linia_1_Value
         
         call     check_busy4bit
         movlw    linia_gorna
         addlw    polozenie_wartosci
         
         call     send

         call     Znajdz_wartosc_opcji


         
Wyswietl_Menu_linia_2_poczatek
      call     check_busy4bit

         movlw   linia_druga
         addlw    0x01
         call    send
 
         
         movf     opcja_menu,w
         movwf    tmp
            

         ;na drugiej linii po nacisnieciu przycisku w dol jest wyswietlana wybrana opcja   
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_dol
         nop
         ;na drugiej linii po nacisnieciu przycisku w gore jest wyswietlana opcja nastepna - nie wybrana   
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_gora
         incf     tmp,f
         
         btfsc    znaczniki_klawiszy_menu,opcja_bez_przycisku
         incf     tmp,f
          
         
         call     Znajdz_wyraz_opcji_dla_linii
         
Wyswietlanie_Menu_linia_2      
         
         call     check_busy4bit

         TBLRD *+
         movf        TABLAT,w

         btfsc    STATUS,Z
         goto     Wyswietlanie_Menu_linia_2_Value


         
         call     write_lcd

         goto    Wyswietlanie_Menu_linia_2

Wyswietlanie_Menu_linia_2_Value
         
         call     check_busy4bit
         movlw    linia_dolna
         addlw    polozenie_wartosci
         
         call     send

         call     Znajdz_wartosc_opcji
         
          
Wyswietlanie_Menu_gwiazdka


         ;czyszczenie gwiazdek
         call     check_busy4bit
         movlw    linia_gorna
         call send
         
         
         call     check_busy4bit
         movlw    _puste
         call   write_lcd
         
         call     check_busy4bit
         movlw    linia_dolna
         call send
         
         
         call     check_busy4bit
         movlw    _puste
         call   write_lcd
         
         
         call     check_busy4bit
         
         
         movlw    linia_gorna
         
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_dol
         movlw    linia_dolna
         
         btfsc    znaczniki_klawiszy_menu,opcje_po_przycisku_gora
         movlw    linia_gorna
         
         ;jezeli ustawiono zmiane opcji to dodaj jeszcze przesuniecie do opcji -1
         btfsc    stan_menu,wybor_opcji
         addlw    polozenie_wartosci-1
         
         ;movf     polozenie_gwiazdka,w
         call     send
         
         call     check_busy4bit
         
         movlw    marker_opcji
         call     write_lcd
         
         
         return
         
         
         
         
         
         
         
Ekran_PWM

        movf     opcja_menu,w
         movwf    tmp
         
         bsf     markers,wyswietlam_temp_menu_ds
         bsf     markers,wyswietlam_temper_menu
         
         
         movlw     display_clear

      call      send
      call     check_busy4bit
         
         ;numer opcji jest wartoœci¹ rejestru wq którym jest przechowywana tablica z adresami tablic z opcjami ekranu
         
         
         ; clrf     znak_linia
         ;clrf     znak_linia2
         
         movlw   linia_pierwsza
         addlw    0x01
         call    send
        call    check_busy4bit
        ;adres jest w tmp_lcd
        movff   tmp_lcd,lcd_adres_temp_ds_position
        bsf     lcd_adres_temp_ds_position,7
        
        call    Wyswietl_temp_liczba_ds2
        
        call    check_busy4bit
        movlw   _puste
        call    write_lcd
        call    check_busy4bit
        ;adres jest w tmp_lcd
        movff   tmp_lcd,lcd_adres_temeratur_position
        bsf     lcd_adres_temeratur_position,7
        call    Wyswietl_temp_liczba_dig2

        call    check_busy4bit
        movlw   linia_druga
         addlw    0x01
         call    send

        movlw       HIGH opcja4
      movwf       TBLPTRH
      
      movlw       LOW opcja4
      movwf       TBLPTRL
Wyswietlanie_pwm_linia_2      
         
         call     check_busy4bit

         TBLRD *+
         movf        TABLAT,w

         btfsc    STATUS,Z
         goto     Wyswietlanie_pwm_linia_2_Value


         
         call     write_lcd

         goto    Wyswietlanie_pwm_linia_2

Wyswietlanie_pwm_linia_2_Value
         
         

         call     Znajdz_wartosc_opcji
         
          return
























         








       
         


         
         
         
         
         
         


         
         


wlacz_przerwanie_tmr0
;tu wlaczane jest przerwanie jednego z zegara
; w tym wypadku zegar TMR0
;mo¿na u¿yc innego dostepnego dla okreslonego procesora
;ustawienia dowolne - minimum oko³o 0,1 sekundy oczekiwania po nacisnieciu klawisza

;ustawienia timera0
; w procedurze inicjacyjnej
; procesor ma czestotliwosc 16 Mhz
;wtedy jedno zliczenie to 1/4000000s
; a wiec przelicznik 8:256 (czyli przerwanie wystepuje po 256*256*8/5000000)
;czyli oko³o 131 ms

      movlw   b'10000010'
      movwf    T0CON

      clrf  TMR0

      bcf   INTCON,TMR0IF
      bsf   INTCON,TMR0IE
     
     
      return

      
wlacz_przerwanie_tmr0_wcisniecie
;tu wlaczane jest przerwanie jednego z zegara
; ktore bedzie dzialac w przypadku gdy wciaz jest wcisniety 
;przycisk

; procesor ma czestotliwosc 16 Mhz
;wtedy jedno zliczenie to 1/4000000s
; a wiec przelicznik 1:256 (czyli przerwanie wystepuje po 256*256*8/5000000)
;czyli oko³o 104 ms

      movlw   b'10000010'
      movwf    T0CON

      clrf  TMR0

      bcf   INTCON,TMR0IF
      bsf   INTCON,TMR0IE
     
     
      return
      
      
      
      
      
      






;procedura rejstracji wcisniecia klawisza 1

;tzn tu trzeba wstawiæ procedury uruchamiane po wcisnieciu i puszczeniu przycisku
; jeden "1"

zarejestrowano_klawisz_dol
;moze byc tak ze po zarejstrowaniu przycisku 1 i po czasie oczekiwania, wciaz jest on wcisniety
;wtedy ponownie uruchom odliczanie TMR0

      btfsc   port_klawisz_dol,pin_klawisz_dol   
      goto       procedura_po_wci_pusz_dol
;to wykonuje jezeli wciaz jest wcisniety przycisk
; czyli normalnie ponownie uruchamiam TMR0
      
      
      call  wlacz_przerwanie_tmr0_wcisniecie      
      btfsc       stan_menu,wybor_opcji
      goto        klawisz_dol_zmiana_wartosci
      
      btfsc       stan_menu,menu_glowne
      goto        klawisz_dol_zmiana_menu
      
      goto LOOP


procedura_po_wci_pusz_dol
;procedura uruchamiana po zarejestrowano wcisniecia i puszczenia przycisku   
   
   
      clrf  stan_key
      clrf  markers_klawisze

      
      
       
      
      

       

          
      ; btfsc       stan_menu,wybor_opcji
      ; goto        klawisz_dol_zmiana_wartosci

      goto  LOOP
      
klawisz_dol_zmiana_menu      
      ;jezeli byla teraz ustawiona opcja koncowa to nic nie rob w menu
      
      movf        opcja_menu,w
      xorlw       koncowa_opcja_menu
      btfsc       STATUS,Z
      goto        procedura_po_wci_pusz_dol_nic
      
      
      ;zwiekszam o jeden  zmienna opcja_menu  - opcja powinna byc wskazywac kolejna opcje
      
      
      incf        opcja_menu,f
      
      ;zaznaczam ze wlaczam przycisk  dol dla wyswietlania menu
      
      clrf        znaczniki_klawiszy_menu
      
      bsf         znaczniki_klawiszy_menu,opcje_po_przycisku_dol
      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
      
procedura_po_wci_pusz_dol_nic      
      
      goto  LOOP


      
  
      
klawisz_dol_zmiana_wartosci
        lfsr     FSR0, wartosc_temp_set
         
         movf     opcja_menu,w         
         
         addwf    FSR0L,f

        
        movf   opcja_menu,w
         xorlw    opcja_set_temp
         btfsc    STATUS,Z
         goto     klawisz_dol_zmiana_set_temp
         
         
         movf   opcja_menu,w
         xorlw    opcja_typ_kontroler
         btfsc    STATUS,Z
         goto     klawisz_dol_zmiana_typ_control
         
         movf   opcja_menu,w
         xorlw    opcja_KP
         btfsc    STATUS,Z
         goto     klawisz_dol_zmiana_KP
         
         movf   opcja_menu,w
         xorlw    opcja_o_czy_serial
         btfsc    STATUS,Z
         goto     klawisz_dol_zmiana_serial
         
         movf   opcja_menu,w
         xorlw    opcja_PWM
         btfsc    STATUS,Z
         goto     klawisz_dol_zmiana_PWM
         
         movf   opcja_menu,w
         xorlw    opcja_Ti
         btfsc    STATUS,Z
         goto     klawisz_dol_zmiana_Ti
         
         movf   opcja_menu,w
         xorlw    opcja_Ki
         btfsc    STATUS,Z
         goto     klawisz_dol_zmiana_Ki
          ;clrf        znaczniki_klawiszy_menu
      
      ;bsf         znaczniki_klawiszy_menu,opcja_bez_przycisku
      btfsc     markers,wyswietlam_opcje_PWM
      goto      klawisz_dol_zmiana_wartosci_pwm
      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
      
      
      goto  LOOP      
      
klawisz_dol_zmiana_wartosci_pwm      
      call      Ekran_PWM
      goto  LOOP   
      
      
      
      
klawisz_dol_zmiana_set_temp
        movlw    min_temp_set
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     klawisz_dol_zmiana_set_temp1
         
         movlw    max_temp_set2
         movwf    wartosc_temp_set_h
         movlw    max_temp_set1
         movwf    wartosc_temp_set
         
         
         
         
         goto     klawisz_gora_zmiana_set_temp2
         
klawisz_dol_zmiana_set_temp1
         ; movlw    o_ile_zmieniam_temp
         ; addwf    INDF,f
         
         movlw          o_ile_zmieniam_nastawe_temp
         ; subwf          nastawa_temp_01,f
         subwf          INDF0,f
         btfss          STATUS,C
         decf           wartosc_temp_set_h,f
         
               
         goto     klawisz_gora_zmiana_set_temp2
      
      
      





klawisz_dol_zmiana_typ_control
      

        movlw    min_typ_regul
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     klawisz_dol_zmiana_typ_control1
         
         movlw    max_typ_regul
         movwf    INDF0
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_dol_zmiana_typ_control1
         movlw    o_ile_zmieniam_typ_regul
         subwf    INDF0,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         
         
         
         goto     klawisz_up_zmiana_wartosci_end


klawisz_dol_zmiana_KP
        movlw    min_KP
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     klawisz_dol_zmiana_KP1
         
         movlw    max_KP
         movwf    INDF0
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_dol_zmiana_KP1
         movlw    o_ile_zmieniam_KP
         subwf    INDF0,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         
         
         
         goto     klawisz_up_zmiana_wartosci_end


         
         
         
         
         
klawisz_dol_zmiana_Ki
        
        movlw    0
         xorwf    Ki,w
         btfss    STATUS,Z
         goto     klawisz_dol_zmiana_Ki1
         
        movlw    min_Ki_01
         xorwf    Ki_ulamek,w
         btfss    STATUS,Z
         goto     klawisz_dol_zmiana_Ki1
         
         
         movlw    max_Ki
         movwf     Ki
         clrf    Ki_ulamek
         
         
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_dol_zmiana_Ki1
        movf    Ki,w
        btfsc   STATUS,Z
        goto    klawisz_dol_zmiana_Ki1_0
        
        movlw   1
        xorwf   Ki,w
        btfsc   STATUS,Z
        goto    klawisz_dol_zmiana_Ki1_01
        
        
         movlw    o_ile_zmieniam_Ki
         subwf    Ki,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         goto     klawisz_up_zmiana_wartosci_end

klawisz_dol_zmiana_Ki1_0
        
        
         movlw    o_ile_zmieniam_Ki
         addwf    Ki_ulamek,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         goto     klawisz_up_zmiana_wartosci_end

klawisz_dol_zmiana_Ki1_01
        movlw   2
        movwf   Ki_ulamek
        clrf    Ki
        
         goto     klawisz_up_zmiana_wartosci_end

 
         
         

         
klawisz_dol_zmiana_Ti
        movlw    min_Ti
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     klawisz_dol_zmiana_Ti1
         
         movlw    max_Ti
         movwf    INDF0
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_dol_zmiana_Ti1
         movlw    o_ile_zmieniam_Ti
         subwf    INDF0,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         
         
         
         goto     klawisz_up_zmiana_wartosci_end
         
         
         
         

klawisz_dol_zmiana_serial
      

        movlw    min_serial
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     klawisz_dol_zmiana_serial1
         
         movlw    max_serial
         movwf    INDF0
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_dol_zmiana_serial1
         movlw    o_ile_zmieniam_serial
         subwf    INDF0,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         
         
         
         goto     klawisz_up_zmiana_wartosci_end


klawisz_dol_zmiana_PWM
        movlw    min_PWM
         xorwf    wartosc_opcji_PWM,w
         btfss    STATUS,Z
         goto     klawisz_dol_zmiana_PWM1
         
         movlw    max_PWM
         movwf    wartosc_opcji_PWM
         
         movf   wartosc_opcji_PWM,w
         movwf  wartosc_zadanego_PWM
         
         goto     klawisz_gora_zmiana_PWM2
         
klawisz_dol_zmiana_PWM1
         movlw    o_ile_zmieniam_PWM
         subwf    wartosc_opcji_PWM,f
         
         movf   wartosc_opcji_PWM,w
         movwf  wartosc_zadanego_PWM
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         goto     klawisz_gora_zmiana_PWM2
      
      
      
      
      
      
      
      
      

zarejestrowano_klawisz_gora
;moze byc tak ze po zarejstrowaniu przycisku 1 i po czasie oczekiwania, wciaz jest on wcisniety
;wtedy ponownie uruchom odliczanie TMR0

      btfsc   port_klawisz_gora,pin_klawisz_gora
      goto      procedura_po_wci_pusz_gora
;to wykonuje jezeli wciaz jest wcisniety przycisk
; czyli normalnie ponownie uruchamiam TMR0

      

      call  wlacz_przerwanie_tmr0_wcisniecie   
      ;jezeli mam wcisniety przycisk wczasie bycia w zmianie opcji  to wywolaj normalna procedure
      
      btfsc       stan_menu,wybor_opcji
      goto        klawisz_gora_zmiana_wartosci
      
      btfsc       stan_menu,menu_glowne
      goto        klawisz_gora_zmiana_menu
      
      
      goto LOOP

procedura_po_wci_pusz_gora
      ;np zapisuje na linii 2 ekranu numer 2
;bcf		portlampki,pin_lampki	
      clrf  stan_key
      clrf  markers_klawisze

      
      
      

       

          
      ; btfsc       stan_menu,wybor_opcji
      ; goto        klawisz_gora_zmiana_wartosci

       goto  LOOP
       
       
klawisz_gora_zmiana_menu   


      ;jezeli byla teraz ustawiona opcja koncowa to nic nie rob w menu  
      movf        opcja_menu,w
      xorlw       0
      btfsc       STATUS,Z
      goto        procedura_po_wci_pusz_gora_nic
      
      
      ;zwiekszam o jeden  zmienna opcja_menu  - opcja powinna byc wskazywac kolejna opcje
      
      
      decf        opcja_menu,f
      
      ;zaznaczam ze wlaczam przycisk  dol dla wyswietlania menu
      
      clrf        znaczniki_klawiszy_menu
      
     bsf         znaczniki_klawiszy_menu,opcje_po_przycisku_gora
      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
      
procedura_po_wci_pusz_gora_nic      
      
      goto  LOOP

      
      
      
klawisz_gora_zmiana_wartosci
             
         
         lfsr     FSR0, wartosc_temp_set
         
         movf     opcja_menu,w         
         
         addwf    FSR0L,f

         movf   opcja_menu,w
         xorlw    opcja_set_temp
         btfsc    STATUS,Z
         goto     klawisz_gora_zmiana_set_temp
         
         movf   opcja_menu,w
         xorlw    opcja_typ_kontroler
         btfsc    STATUS,Z
         goto     klawisz_gora_zmiana_typ_control
         
         movf   opcja_menu,w
         xorlw    opcja_KP
         btfsc    STATUS,Z
         goto     klawisz_gora_zmiana_KP
         
         movf   opcja_menu,w
         xorlw    opcja_o_czy_serial
         btfsc    STATUS,Z
         goto     klawisz_gora_zmiana_serial
         
         
         movf   opcja_menu,w
         xorlw    opcja_PWM
         btfsc    STATUS,Z
         goto     klawisz_gora_zmiana_PWM
         
         movf   opcja_menu,w
         xorlw    opcja_Ti
         btfsc    STATUS,Z
         goto     klawisz_gora_zmiana_Ti
         
         movf   opcja_menu,w
         xorlw    opcja_Ki
         btfsc    STATUS,Z
         goto     klawisz_gora_zmiana_Ki
         
         ; incf     INDF0,f
         
        ;  clrf        znaczniki_klawiszy_menu
      
     ; bsf         znaczniki_klawiszy_menu,opcja_bez_przycisku
      ; btfsc     markers,wyswietlam_opcje_PWM
      ; goto      klawisz_up_zmiana_wartosci_pwm
      ;jezeli jest wieksza od zmiennej 
      ; call       Wyswietlanie_Menu 
      
      
      goto  LOOP
      
      
    
; klawisz_up_zmiana_wartosci_pwm      
    
      ; goto  LOOP         
      
      
      
klawisz_gora_zmiana_set_temp
        movlw    max_temp_set1
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     klawisz_gora_zmiana_set_temp1
         
         movlw    max_temp_set2
         xorwf    wartosc_temp_set_h,w
         btfss    STATUS,Z
         goto     klawisz_gora_zmiana_set_temp1
         
         movlw    min_temp_set
         movwf    wartosc_temp_set
         
         clrf     wartosc_temp_set_h
         
         goto     klawisz_gora_zmiana_set_temp2
         
klawisz_gora_zmiana_set_temp1
         ; movlw    o_ile_zmieniam_temp
         ; addwf    INDF,f
         
         movlw          o_ile_zmieniam_nastawe_temp
         ; subwf          nastawa_temp_01,f
         addwf          wartosc_temp_set,f
         btfsc          STATUS,C
         incf           wartosc_temp_set_h,f
         
         
klawisz_gora_zmiana_set_temp2  

        movff     wartosc_temp_set,  liczba_przez_ktora_mnoze1
        movff     wartosc_temp_set_h,  liczba_przez_ktora_mnoze2
        
         call   zamien_temp_na_liczbe_AD
         
         movff   wynik2,liczba_nastawy_h
         movff   wynik1,liczba_nastawy
         
         goto     klawisz_up_zmiana_wartosci_end
         
      


klawisz_gora_zmiana_typ_control
      

        movlw    max_typ_regul
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     klawisz_gora_zmiana_typ_control1
         
         movlw    min_typ_regul
         movwf    INDF0
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_gora_zmiana_typ_control1
         movlw    o_ile_zmieniam_typ_regul
         addwf    INDF0,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         
         
         
         goto     klawisz_up_zmiana_wartosci_end

         
         

klawisz_gora_zmiana_Ti
        movlw    max_Ti
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     klawisz_gora_zmiana_Ti1
         
         movlw    min_Ti
         movwf    INDF0
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_gora_zmiana_Ti1
         movlw    o_ile_zmieniam_Ti
         addwf    INDF0,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         
         
         
         goto     klawisz_up_zmiana_wartosci_end



         
         
         
         
klawisz_gora_zmiana_KP
        movlw    max_KP
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     klawisz_gora_zmiana_KP1
         
         movlw    min_KP
         movwf    INDF0
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_gora_zmiana_KP1
         movlw    o_ile_zmieniam_KP
         addwf    INDF0,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         
         
         
         goto     klawisz_up_zmiana_wartosci_end
         


klawisz_gora_zmiana_serial
      

        movlw    max_serial
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     klawisz_gora_zmiana_serial1
         
         movlw    min_serial
         movwf    INDF0
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_gora_zmiana_serial1
         movlw    o_ile_zmieniam_serial
         addwf    INDF0,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         goto     klawisz_up_zmiana_wartosci_end


         
         
klawisz_gora_zmiana_Ki
        
        movlw    max_Ki
         xorwf    Ki,w
         btfss    STATUS,Z
         goto     klawisz_gora_zmiana_Ki1
         
         movlw    min_Ki_01
         movwf    Ki_ulamek
         
         clrf     Ki
         
         goto     klawisz_up_zmiana_wartosci_end
         
klawisz_gora_zmiana_Ki1
        movf    Ki,w
        btfsc   STATUS,Z
        goto    klawisz_gora_zmiana_Ki1_0
         movlw    o_ile_zmieniam_Ki
         addwf    Ki,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         goto     klawisz_up_zmiana_wartosci_end

klawisz_gora_zmiana_Ki1_0
        movlw   2
        xorwf   Ki_ulamek,w
        btfsc   STATUS,Z
        goto    klawisz_gora_zmiana_Ki1_01
        
        
         movlw    o_ile_zmieniam_serial
         subwf    Ki_ulamek,f
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         goto     klawisz_up_zmiana_wartosci_end

klawisz_gora_zmiana_Ki1_01
        movlw   1
        movwf   Ki
        clrf    Ki_ulamek
         goto     klawisz_up_zmiana_wartosci_end


         
klawisz_gora_zmiana_PWM
        movlw    max_PWM
         xorwf    wartosc_opcji_PWM,w
         btfss    STATUS,Z
         goto     klawisz_gora_zmiana_PWM1
         
         movlw    min_PWM
         movwf    wartosc_opcji_PWM
         
         movf   wartosc_opcji_PWM,w
         movwf  wartosc_zadanego_PWM
         
         goto     klawisz_gora_zmiana_PWM2
         
klawisz_gora_zmiana_PWM1
         movlw    o_ile_zmieniam_PWM
         addwf    wartosc_opcji_PWM,f
         
         movf   wartosc_opcji_PWM,w
         movwf  wartosc_zadanego_PWM
         ;ten pin jesli ustawiony swiadczy o koniecznosci regulacji
         
klawisz_gora_zmiana_PWM2
           call      Ekran_PWM
         goto   LOOP
      
klawisz_up_zmiana_wartosci_end      
      call       Wyswietlanie_Menu 
      
      
      goto  LOOP
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
zarejestrowano_klawisz_enter
;moze byc tak ze po zarejstrowaniu przycisku 1 i po czasie oczekiwania, wciaz jest on wcisniety
;wtedy ponownie uruchom odliczanie TMR0

      btfsc   port_klawisz_enter,pin_klawisz_enter
      goto        procedura_po_wci_pusz_enter
;to wykonuje jezeli wciaz jest wcisniety przycisk
; czyli normalnie ponownie uruchamiam TMR0
      
      
      call  wlacz_przerwanie_tmr0   
      goto LOOP


procedura_po_wci_pusz_enter
      ;np zapisuje na linii 2 ekranu numer 3


      clrf  stan_key
      clrf  markers_klawisze
      
;jezeli opcja 1 - wyswietlam temp to nic nie zmieniaj - nie wchodz do opcji
      movlw     opcja_wysw_temp
      xorwf     opcja_menu,w
      btfsc     STATUS,Z
      goto    LOOP
      
      movlw     opcja_wysw_temp_ds
      xorwf     opcja_menu,w
      btfsc     STATUS,Z
      goto    LOOP
      
      
      
        

procedura_po_wci_pusz_enter1      
      btfsc       stan_menu,menu_glowne
      goto        wybrano_zmiane_opcji
      
      
      btfsc       stan_menu,wybor_opcji
      goto        wybrano_menu_glowne
      
wybrano_zmiane_opcji
         bcf     stan_menu,menu_glowne
         bsf     stan_menu,wybor_opcji
         
         
          ;clrf        znaczniki_klawiszy_menu
      movlw     opcja_PWM
      xorwf     opcja_menu,w
      btfsc     STATUS,Z
      goto    wybrano_zmiane_PWM
      ;bsf         znaczniki_klawiszy_menu,opcja_bez_przycisku
      
      movlw  opcja_set_temp   
      xorwf     opcja_menu,w
      btfsc     STATUS,Z
      goto      wybrano_wlaczenie_regulacji
      
      
      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
         
      goto  LOOP



wybrano_wlaczenie_regulacji
       bsf       markers_regulacja,czy_mam_regulowac
      
      
      movlw     1
      xorwf     wartosc_opcji_regulator,w
      btfsc     STATUS,Z
      goto      wybrano_wlaczenie_regulacji_P
      
      movlw     2
      xorwf     wartosc_opcji_regulator,w
      btfsc     STATUS,Z
      goto      wybrano_wlaczenie_regulacji_P
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
         
      goto  LOOP
      
wybrano_wlaczenie_regulacji_P
      
      
      bsf     PIE4,TMR4IE
      movlw   0x64
         movwf   ilosc_procentow_100
         
         
         
         clrf   ilosc_procentow_On
         
        call       Wyswietlanie_Menu 
      goto      LOOP
      
      
      
wybrano_zmiane_PWM      
      ;czyszcze caly ekran i pisze tylko wartosc PWM
      bsf       markers,wyswietlam_opcje_PWM
      
      
      call      Ekran_PWM

wlacz_dzialanie_PWM
        
      
      movlw   0x64
         movwf   ilosc_procentow_100
         
         
         movf   wartosc_opcji_PWM,w
         movwf  wartosc_zadanego_PWM
         movwf   ilosc_procentow_On
      bcf     PIR4,TMR4IF
      bsf     PIE4,TMR4IE
      goto      LOOP
      
      
      
      
wybrano_menu_glowne
         bsf     stan_menu,menu_glowne
         bcf     stan_menu,wybor_opcji
         bcf    markers,wyswietlam_opcje_PWM
         bcf    latch_triak,pin_triak
         bcf    latch_lampka,pin_lampka
         bcf     PIE4,TMR4IE
         bcf    markers_regulacja,czy_mam_regulowac
         clrf   obliczony_uchyb1
         clrf   obliczony_uchyb1_prev
         clrf   obliczony_uchyb2
         clrf   obliczony_uchyb2_prev
         clrf   wartosc_zadanego_PWM
         clrf   wartosc_zadanego_PWM_tmp
         clrf    a_obliczana_korekta_I
         clrf    a_obliczana_korekta_I_fraction
         clrf   obliczona_korekta_I
         
         ; clrf        znaczniki_klawiszy_menu
      
     ; bsf         znaczniki_klawiszy_menu,opcja_bez_przycisku
      
      
         call     check_busy4bit
         movlw    linia_gorna
         addlw    polozenie_wartosci-1
         call send
         
         
         call     check_busy4bit
         movlw    _puste
         call   write_lcd
         
         call     check_busy4bit
         movlw    linia_dolna
         addlw    polozenie_wartosci-1
         call send
         
         
         call     check_busy4bit
         movlw    _puste
         call   write_lcd
      
      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
      
         
      goto  LOOP
      
            
      
      
      
      
            
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
wcisnieto_klawisz_dol

           
            
      btfsc   markers_klawisze,wcisnieto_klawisz
      return

      
      bsf   markers_klawisze,wcisnieto_klawisz

      clrf  stan_key

      bsf   stan_key,wcisniety_jest_klawisz_dol

	;wlaczam przerwanie zeby sprawdzic czas po ktorym ma byc zarejestrowany klawisz
      
      goto  wlacz_przerwanie_tmr0      


wcisnieto_klawisz_gora

           
            
      btfsc   markers_klawisze,wcisnieto_klawisz
      return

      
      bsf   markers_klawisze,wcisnieto_klawisz

      clrf  stan_key

      bsf   stan_key,wcisniety_jest_klawisz_gora

	;wlaczam przerwanie zeby sprawdzic czas po ktorym ma byc zarejestrowany klawisz
      
      goto  wlacz_przerwanie_tmr0      












         
         
         
         
         

wcisnieto_klawisz_enter
     
      
            
      btfsc   markers_klawisze,wcisnieto_klawisz
      return

      
      bsf   markers_klawisze,wcisnieto_klawisz

      clrf  stan_key

      bsf   stan_key,wcisniety_jest_klawisz_enter

	;wlaczam przerwanie zeby sprawdzic czas po ktorym ma byc zarejestrowany klawisz
      
      goto  wlacz_przerwanie_tmr0      

         
         
         
         
         
         
















;

PIN_HI_1
        ;input
        BSF     Tris_ds1820, czujnik_ds1820           ; high impedance
        
        
        RETURN

PIN_LO_1
         ;output
         BCF     Tris_ds1820, czujnik_ds1820          ; low impedance zero
         
        BCF     latch_ds1820,czujnik_ds1820
        ;bcf       latch_ds1820,czujnik_ds1820_1
        
        
        
        
        RETURN
        
send_one_1
         clrf     TMR2
         bcf      PIR1,TMR2IF
         call     PIN_LO_1
         nop
         call     PIN_HI_1
        
petla_send_one_1
         btfss    PIR1,TMR2IF        
         goto     petla_send_one_1
         
         return

send_zero_1
        
         call     PIN_LO_1
         clrf     TMR2
         nop
         
         bcf      PIR1,TMR2IF
         
         bcf      latch_ds1820,czujnik_ds1820
petla_send_zero_1
         btfss    PIR1,TMR2IF        
         goto     petla_send_zero_1
         call     PIN_HI_1
         
         return

         
      
inicjacja_ds1820_1

 
         ;bcf      RCSTA1,CREN
         
         
         
         bcf      Tris_ds1820,czujnik_ds1820
       
         
;ustawiam tmr2 na zliczanie 2 
         movlw    czas_oczekiwania_480us
         
         movwf    PR2
         
;ustawiam 480us         
         movlw    t2con_dla_480us
         movwf    T2CON
         
         bcf      PIR1,TMR2IF
;wlaczam przerwanie Tmr2
         ;bsf      STATUS,RP0
         ;bsf      PIE1,TMR2IE2
         ;bcf      STATUS,RP0
         call     PIN_HI_1
         call     PIN_LO_1
;daje znacznik ze dotyczy to inicjacji ds1820
         ;bsf      znaczniki_ds,inicjacja
;petla czekania na koniec inicjacji
petla_inicjacji1_1
         
         btfss    PIR1,TMR2IF
         goto     petla_inicjacji1_1
;teraz przelaczam sie na odbior danych z ds1820
         
         bsf      Tris_ds1820,czujnik_ds1820
         
         nop
         bcf      PIR1,TMR2IF
;sprawdzam czy w ciagu 480us pojawilo sie 0 na porcie czujnika
petla_inicjacji2_1

         btfss    port_ds1820,czujnik_ds1820
         goto     petla_inicjacji3_1
         
         btfss    PIR1,TMR2IF         
         goto     petla_inicjacji2_1
         
         goto     blad_inicjacji_ds
         
         
petla_inicjacji3_1
         btfsc    port_ds1820,czujnik_ds1820
         goto     inicjacja_ok_1
         btfss    PIR1,TMR2IF
         goto     petla_inicjacji3_1
         
inicjacja_ok_1
        nop
         ;btfsc    markers_pomiary,czy_wywoluje_inicjacje_ds_call
         ;return
         
         ;btfsc    markers,czy_rozkaz
         ;goto     wysylanie_danych_rozkaz_1

         ;btfsc    markers,czy_wysylanie_OK
         ;goto     napisz_ok
         
         
         return
         
         
blad_inicjacji_ds
        movlw   0x14
        movwf   temp_ds
        
        clrf     markers_pomiary
        
        return











         
         
;DS18B20
petla_wysylania_rozkazu_1
         TBLRD       *+
      
         movf        TABLAT,w
         btfsc    STATUS,Z
         return                     
         
         ;jezeli 0 to skocz do wyswietlania slowa z linii 2
         movwf     polecenie_wysylane
         
         movlw     czas_oczekiwania_60us      
         ;ustawiam TMR2 na odbieranie
         movwf    PR2
         
;ustawiam 60us         
         movlw    t2con_dla_60us
         movwf    T2CON
         bcf      PIR1,TMR2IF
         clrf      TMR2
         movlw     8
         movwf     n_ds
         
petla_sending_pomiar_1

        btfss     polecenie_wysylane,0
        call      send_zero_1
        btfsc     polecenie_wysylane,0
        call      send_one_1
        bsf       latch_ds1820,czujnik_ds1820
        
        bcf       STATUS,C
        rrcf       polecenie_wysylane,f
        
        decfsz    n_ds,f
        goto      petla_sending_pomiar_1
         
        goto       petla_wysylania_rozkazu_1


        
        
        

        
        
        


      
      
      
      
      
      
      
      
      
      
      
      
      




      
    
        
petla_odbioru_rozkazu_1
         movf     jak_duzo_bajtow_odbieram_z_ds,w
         movwf    liczba1
            
         movlw     czas_oczekiwania_60us
         movwf    PR2
         movlw    t2con_dla_60us
         movwf    T2CON
         ; clrf     TMR2
         ; bcf      PIR1,TMR2IF   
        
;procedura sprawdza czy ds1820 cos wysyla jezeli tak to sprawdza przez 60 us czy jest choc na chwile 0
;normalnie jezeli ds1820 nic nie wysyla to jest caly czas 1 bez rzadnych zmian
petla_odbioru_z_ds1820_1
        movlw     8
        movwf     n_ds
        
        clrf      INDF1
        
        
petla_stan_odebranego_bitu_1
        
        call     PIN_LO_1
        movlw     czas_oczekiwania_15us
         movwf    PR2
        clrf      TMR2
        bcf       PIR1,TMR2IF  
        
        
         ; nop 
         ; nop
         
         
        
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         
         call     PIN_HI_1
         
        ;musze czekac 15 us 
        
        
        ;albo nopy
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         
         ; nop
         ; nop
         ; nop
         ; nop
         ; nop
         
         ; nie moge tego przeniesc do petli
         ;bo ds18b20 po puszczebniu linii transmisyjnej przez master
         ; przez oko³o 15 us - 30 us trzyma w gorze linie a pozniej ja puszcza
         
         ;chyba ze bede sprawdzal czy skoczy w dol a pozniej w gore
         ;a po skoku w dol moge konczyc petle
         
         
;petla 1

czekam_na_kolejny_bit_DS1
        
        btfss    PIR1,TMR2IF
        goto      czekam_na_kolejny_bit_DS1
        
        bcf       PIR1,TMR2IF
 
        btfss    port_ds1820,czujnik_ds1820
         bcf      STATUS,C
         
         btfsc    port_ds1820,czujnik_ds1820
         bsf      STATUS,C
        rrcf     INDF1,f 
        
;petla 2
;czekam 45 us
        movlw     czas_oczekiwania_45us
         movwf    PR2
         clrf      TMR2
        bcf       PIR1,TMR2IF
czekam_na_kolejny_bit_DS2
        ;tutaj sprawdzam stan danych ds18b20
         
        btfss    PIR1,TMR2IF
        goto      czekam_na_kolejny_bit_DS2
        bcf       PIR1,TMR2IF
        
         
; czekam_na_kolejny_bit_DS3
        
        
         
        ; btfss    PIR1,TMR2IF
        ; goto      czekam_na_kolejny_bit_DS3
        
        ; bcf       PIR1,TMR2IF
        
        decfsz    n_ds,f
        goto      petla_stan_odebranego_bitu_1
        
        incf      FSR1L,f
        
;czy juz przeszly wszystkie bajty z DS
        decfsz    liczba1,f
        goto      petla_odbioru_z_ds1820_1

        
         return      



 
         






        
wykonaj_pomiar_czujnikiem_DS
;jesli steruje moca to wtedy nalezy sprawdzic czy jestem aktualnie po sprawdzaniu okresu
;mam wtedy 10 ms spokoju i moge spokojnie odebrac lub wyslac rozkazy ds18
        btfss     markers,wyswietlam_opcje_PWM
        goto    wykonaj_pomiar_DS_normalnie

        btfss     markers_pomiary,czy_jestem_po_spr_triak
        return
        
        
wykonaj_pomiar_DS_normalnie
        bcf     markers_pomiary,czy_jestem_po_spr_triak
        
        
        
        bcf  markers_pomiary,czy_wykonuje_pomiar_DS1
        
       
       bcf     INTCON,GIE
        bcf     INTCON,GIE
         
         movlw       HIGH rozkaz_pomiaru
         movwf       TBLPTRH
      
         movlw       LOW rozkaz_pomiaru
         movwf       TBLPTRL
         
         ;najpierw wyœlij rozkaz pomiaru
         ;wykorzystuje procedury które dzia³aj¹ po wybraniu wysy³ania danych przez polecenie
         ;
         ;        "0xcc44"
         
         ; bcf    markers,czy_rozkaz
         
         
         call     inicjacja_ds1820_1
         
         call     petla_wysylania_rozkazu_1

         
         ;pozniej czekaj 1 s
         
         bsf      markers_pomiary,czekam_na_odczyt_DS1
         
       
       bsf     INTCON,GIE
        bsf     INTCON,GIE
         return

         
         
         
         

odbierz_pomiary_temp
;jesli steruje moca to wtedy nalezy sprawdzic czy jestem aktualnie po sprawdzaniu okresu
;mam wtedy 10 ms spokoju i moge spokojnie odebrac lub wyslac rozkazy ds18
        btfss     markers,wyswietlam_opcje_PWM
        goto    odbierz_pomiary_temp_normalnie

        btfss     markers_pomiary,czy_jestem_po_spr_triak
        return
        
        
odbierz_pomiary_temp_normalnie
        bcf     markers_pomiary,czy_jestem_po_spr_triak
       bcf  markers_pomiary,odczytaj_pomiar_DS1
       bcf  markers_pomiary,czekam_na_odczyt_DS1
       
        movlw    9
         movwf    jak_duzo_bajtow_odbieram_z_ds
        
       
       bcf     INTCON,GIE
        bcf     INTCON,GIE
        
         movlw       HIGH rozkaz_odczytu
         movwf       TBLPTRH
      
         movlw       LOW rozkaz_odczytu
         movwf       TBLPTRL
         
         
         
         
         ;najpierw wyœlij rozkaz pomiaru
         ;wykorzystuje procedury które dzia³aj¹ po wybraniu wysy³ania danych przez polecenie
         ;
         ;        "*D1sccbe"
         ; bcf    markers,czy_rozkaz
         
         
         call     inicjacja_ds1820_1
         
         
         ;LFSR     FSR0, dane_odebrane_z_ds
         
         call     petla_wysylania_rozkazu_1
         
         LFSR     FSR1,dane_odebrane_z_ds
        
         
         call     petla_odbioru_rozkazu_1
         
        bsf     INTCON,GIE
        bsf     INTCON,GIE
         
         ;sprawdz CRC
         LFSR     FSR2, dane_odebrane_z_ds
         
         ;9 bajt to CRC
         movlw    9
         movwf     n_ds
         
         call     check_CRC_DS
         
         movf     bajt_CRC,w
         ;jezeli 0 to jest ok
         bz      odbierz_pomiary_temp_show_data
         
         
         goto    blad_inicjacji_ds
        
         
                  
      
       
odbierz_pomiary_temp_show_data            
         LFSR     FSR2, dane_odebrane_z_ds
         call     zamien_dane_na_temp
        
        btfsc   markers,wyswietlam_temp_menu_ds
        bsf     markers,odswiez_wyswietlanie_temp_ds
         return





         
         
         
        

check_CRC_DS 
         clrf  bajt_CRC
         ;movlw    
   
;tablica danych DS18b20 musi byc w FSR2
check_CRC_DS_loop
         movf POSTINC2,w   
         xorwf bajt_CRC,f       
         movlw 0     
         
         btfsc bajt_CRC,0 
         xorlw 0x5e       
         
         btfsc bajt_CRC,1 
         xorlw 0xbc 
         
         btfsc bajt_CRC,2 
         xorlw 0x61 
         
         btfsc bajt_CRC,3 
         xorlw 0xc2 
         
         btfsc bajt_CRC,4 
         xorlw 0x9d 
         
         btfsc bajt_CRC,5 
         xorlw 0x23 
         
         btfsc bajt_CRC,6 
         xorlw 0x46 
         
         btfsc bajt_CRC,7 
         xorlw 0x8c 
         
         movwf bajt_CRC   
         
         decfsz n_ds,f 
         goto check_CRC_DS_loop         
                     

         ;movwf bajt_CRC         
 

         return         




         
         
         
         
         
         
         
       
       
       
       
       
       
       
       
       
       
       
       
       
       
    
zamien_dane_na_temp
         ;bajt m³odszy
         
         movff    INDF2,wynik01
         ;zapisuje w temp_ulamek sam mlodsz¹ po³ówkê pierwszego bajtu
         ;temperatury
         movlw    0x0f
         andwf    wynik01,w
         movwf    temp_ulamek_ds
         
         swapf    POSTINC2,w
         andlw    0x0f
         movwf    temp_1
         
         movlw    0x0f
         andwf    INDF2,w
         movwf    temp_10
         swapf    temp_10,w
         addwf    temp_1,f
         
         ;w bajcie temp_1 jest liczba okreœlaj¹ca szesnastkowo temp
         movff     temp_1, temp_ds
         
         
         
         
        return



        
        
        
        
        
         
usrednianie_wartosci_temp
;oblicz srednia dzielac za pomoca ilosc probek pobieranych
               
        bcf     markers,oblicz_srednia

        clrf      wynik01
        clrf      wynik1
        
      movlw     usrednianie_przez_co_mnoze
      mulwf     liczba_thermo_1pomiar
      
      ;w PRODH jest wartoœæ do wynik, a w ProdL do wynik01
      movf        PRODH,w
      movwf       wynik
      movf        PRODL,w
      movwf       wynik01
      
      movf        liczba_thermo_H_1pomiar,w
      bz          procedura_sumowania_wyniku
      
      movlw     usrednianie_przez_co_mnoze
      mulwf     liczba_thermo_H_1pomiar
      
      movf        PRODH,w
      movwf       wynik1
      movf        PRODL,w
      addwf       wynik,f
      ;je¿eli przekroczy³em bajt to zwiêksz o 1
      
      btfsc       STATUS,C
      incf        wynik1,f
         
procedura_sumowania_wyniku
         movf     wynik01,w
         addwf    pomiar_ulamek,f
;jezeli przekroczono pomiarL
         btfss    STATUS,C
         goto     nie_przekroczono_bajtu_ulamka
         movlw    1
         addwf    pomiarL,f

         
         btfsc    STATUS,C
         incf     pomiarH,f
         
nie_przekroczono_bajtu_ulamka         
         movf     wynik,w
         addwf    pomiarL,f
         btfsc    STATUS,C
         incf     pomiarH,f
        
         movf     wynik1,w
         addwf    pomiarH,f
         
         decfsz   ktora_probka,f
         return
         
         movlw     jak_duzo_probek
         movwf    ktora_probka
         
         movff  pomiarH,liczba_thermo_H
         movff  pomiarL,liczba_thermo
         
         
         
         btfsc   markers,wyswietlam_temper_menu
        bsf     markers,odswiez_wyswietlanie_temp
        
        
        movff   temp_ds,liczba_przez_ktora_mnoze1
        ;jezeli ulamek ds jest >.50
        ;to zwieksz o jeden temp temp_ds
        movlw   0x8
        cpfslt   temp_ulamek_ds
        incf    liczba_przez_ktora_mnoze1,f
        
        ; movff   temp,liczba_przez_ktora_mnoze2
        
        clrf    liczba_przez_ktora_mnoze2
        
         call   zamien_temp_na_liczbe_AD
        
        movf   wynik2,w
        addwf   liczba_thermo_H,f
        movf   wynik1,w
        addwf   liczba_thermo,f
        btfsc   STATUS,C
        incf    liczba_thermo_H,f
        
        
         
         
         btfsc  markers_regulacja,czy_mam_regulowac
         call   procedura_regulacja
        
        movf    wartosc_opcji_serial,w
        btfss   STATUS,Z
        call   wysylaj_wszystkie_dane 
        
        clrf   pomiarH
         clrf   pomiarL
         clrf   pomiar_ulamek
        
        ; movlw   2
        ; xorwf   wartosc_opcji_regulator,w
        ; btfsc   STATUS,Z
        ; goto    proc_obliczania_korektora_I
        
        
         return
         
         
procedura_regulacja


        movlw   0
        xorwf   wartosc_opcji_regulator,w
        btfsc   STATUS,Z
        goto    procedura_regulacji_dwustawnej
         
         
        movlw   1
        xorwf   wartosc_opcji_regulator,w
        btfsc   STATUS,Z
        goto    procedura_regul_P 
        
        movlw   2
        xorwf   wartosc_opcji_regulator,w
        btfsc   STATUS,Z
        goto    procedura_regul_PI 

        return
        
        
        
obliczenie_uchybu_temp_P
        bcf     markers_regulacja,error_uchyb_ujemny
        movf     liczba_thermo_H,w
         ;pomiarh - jaka_wartosc_regulujeH
        subwf    liczba_nastawy_h ,w
        ;jesli w wyniku mamy liczbe ujemna
        btfss   STATUS,C
        goto    obliczenie_uchybu_ujemny
        movwf    liczba_przez_ktora_mnoze2
        
        ;jesli sa rowne sprawdz czy mlodszy bajt nie przekracza wartosci nastawy
        btfss   STATUS,Z
        goto    obliczenie_uchybu_mlodszy_bajt
        
        movf    liczba_thermo ,w
        subwf   liczba_nastawy,w  
        btfss   STATUS,C
        goto    obliczenie_uchybu_ujemny

obliczenie_uchybu_mlodszy_bajt
        movf    liczba_thermo ,w
        subwf   liczba_nastawy,w  
        btfss   STATUS,C
        decf    liczba_przez_ktora_mnoze2,f

        movwf   liczba_przez_ktora_mnoze1
        
        goto     obliczenie_uchybu_na_temp       
        
obliczenie_uchybu_ujemny        
;poniewaz liczba jest ujemna to musze ja odwrocic zeby miec liczbe dodatnia
        ;dla funkcji zamieniajacej na wartosc temperatury
        bsf     markers_regulacja,error_uchyb_ujemny
        movwf   liczba_przez_ktora_mnoze2
        movf    liczba_thermo ,w
        subwf   liczba_nastawy,w
        movwf   liczba_przez_ktora_mnoze1
        
        comf    liczba_przez_ktora_mnoze2,f
        ; incf    liczba_przez_ktora_mnoze2,f
        comf    liczba_przez_ktora_mnoze1,f
        incf    liczba_przez_ktora_mnoze1,f
        btfsc   STATUS,C
        incf    liczba_przez_ktora_mnoze2,f
        
        
        
        
obliczenie_uchybu_na_temp        
        ;roznice miedzy temperaturami w postaci liczby z A/D
        ;zamieniam na wartosc roznicy temp
        
        call    oblicz_wartosc_temperatury
        
        movff   obliczony_uchyb1,obliczony_uchyb1_prev
        movff   obliczony_uchyb2,obliczony_uchyb2_prev
        
        movff   wynik1,obliczony_uchyb1
        movff   wynik2,obliczony_uchyb2
        
        
        return
        



procedura_regul_P
;mnoze roznice temperatur razy wzmocnienie
        call    obliczenie_uchybu_temp_P
        
        
        btfsc   markers_regulacja,error_uchyb_ujemny
        goto    regul_P_roznica_temp_ujemna
        
        movff   obliczony_uchyb1,mnozona1
        movff   obliczony_uchyb2,mnozona2
        
        clrf   mnozona3
        clrf   mnozona4
        
        
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
        movwf    wartosc_zadanego_PWM
        
        
        return
        
regul_P_roznica_temp_powyzej100
        movlw   0x64
        movwf   wartosc_zadanego_PWM
        
        return

regul_P_roznica_temp_ujemna        
        clrf   wartosc_zadanego_PWM
        
        return

        
        

procedura_regul_PI
        call    procedura_regul_P
        movff   wartosc_zadanego_PWM,wartosc_zadanego_PWM_tmp
        call    proc_obliczania_korektora_I
        
        
        
        movf   obliczona_korekta_I,w
        ; btfsc   STATUS,C
        ; goto    regul_P_roznica_temp_ujemna
        
        
        btfss     markers_regulacja,error_korekta_ujemna
        goto     procedura_regul_PI_dodaj_korekte
        ;jesli obliczona wartosc PWM jest 0 to nie odejmuje
        movf   wartosc_zadanego_PWM,w
        btfsc   STATUS,Z
        return
        
        movf    obliczona_korekta_I,w
        subwf   wartosc_zadanego_PWM,f
        
        btfsc   STATUS,C
        return
        
        clrf    wartosc_zadanego_PWM
        
        ;jesli wieksza od 
        return
        
procedura_regul_PI_dodaj_korekte        
        addwf    wartosc_zadanego_PWM,f
        
        btfsc   STATUS,C
        goto    regul_P_roznica_temp_ujemna
        
        ;if the value is lower then 100
        ;ustaw PWM 
        ;if not ustaw 100%
        movlw   0x64
        cpfslt  wartosc_zadanego_PWM
        goto    regul_P_roznica_temp_powyzej100
        
        
        

        return
        
        
        
        
proc_obliczania_korektora_I
        ;        / 
        ; 1/Ti * | error(tau) dtau
        ;        /
        ;error(tau) = SP-PV
        
        ;Ti - to ilosc pomiarow temperatury - skoro sa co 1 sekunde tzn ze 
        ;kazdy pomiar dziele przez Ti i sumuje z pozostalymi Ti-oma wynikami
        ;tworze w ten sposob srednia zmian uchybu Delta 
        ;
        
        
        ;w tej wersji uzywam procedury calkowania 
        ; w oparciu o metode trapezowa
        
        movff   obliczony_uchyb1,dzielona1
        movff   obliczony_uchyb2, dzielona2        
        
        movf    obliczony_uchyb2_prev,w
        addwf   dzielona2,f
        movf    obliczony_uchyb1_prev,w
        addwf   dzielona1,f
        btfsc   STATUS,C
        incf    dzielona2,f
        
        clrf    dzielona3
        clrf    dzielona4
        
        movlw   2
        movwf   liczba_przez_ktora_dziele_1
        clrf    liczba_przez_ktora_dziele_2
        clrf    liczba_przez_ktora_dziele_3
        clrf    liczba_przez_ktora_dziele_4
        
        call    dzielenie_4bajt
        
        movff   wynik1,dzielona1
        movff   wynik2, dzielona2        
        clrf    dzielona3
        clrf    dzielona4
        
        

        movf    nastawa_Ti,w
        movwf   liczba_przez_ktora_dziele_1
        clrf    liczba_przez_ktora_dziele_2
        clrf    liczba_przez_ktora_dziele_3
        clrf    liczba_przez_ktora_dziele_4
        
        call    dzielenie_4bajt
        
        movf    wynik3,w
        bnz      wynik_wiekszy_100
        movf    wynik2,w
        bnz      wynik_wiekszy_100
        movlw   0x64
        cpfsgt  wynik1
        goto     proc_korektora_I_spr_czy_dodaje
        
wynik_wiekszy_100
        movlw   0x64
        movwf   wynik1
        
        
proc_korektora_I_spr_czy_dodaje
        btfsc   markers_regulacja,error_uchyb_ujemny
        goto    proc_korektora_I_odejmuje
        
        movf    wynik1,w
        addwf    a_obliczana_korekta_I,f
        ;jesli przekroczylem zakres i C jest on to wylacz znacznik liczby ujemnej
        btfsc   STATUS,C
        bcf     markers_regulacja,error_korekta_czast_ujemna
        
        ; goto    proc_obliczania_korektora_I1
        
        
        movf    reszta1,w
        addwf   a_obliczana_korekta_I_fraction,f
        movf    nastawa_Ti,w
        subwf   a_obliczana_korekta_I_fraction,w
        ;obl_korek- Ti >0 to C jest on
        btfss   STATUS,C
        goto    proc_obliczania_korektora_I1
        
        movwf   a_obliczana_korekta_I_fraction
        incf    a_obliczana_korekta_I,f
        btfsc   STATUS,C
        bcf     markers_regulacja,error_korekta_czast_ujemna
        goto    proc_obliczania_korektora_I1
        
proc_korektora_I_odejmuje        
        movf    wynik1,w
        subwf    a_obliczana_korekta_I,f
        ; a_obliczana_korekta_I - wynik1 jesli wieksze to C on
        btfss   STATUS,C
        bsf     markers_regulacja,error_korekta_czast_ujemna
        
        movf    reszta1,w
        subwf   a_obliczana_korekta_I_fraction,f
        ;jesli przekroczylem 0 - wynik ujemny - C off
        btfsc   STATUS,C
        goto    proc_obliczania_korektora_I1
        
        decf    a_obliczana_korekta_I,f
        btfss   STATUS,C
        bsf     markers_regulacja,error_korekta_czast_ujemna
        
        ; comf   a_obliczana_korekta_I_fraction,f
        ; incf    a_obliczana_korekta_I_fraction,f
        movf    nastawa_Ti,w
        addwf   a_obliczana_korekta_I_fraction,f
        
        goto    proc_obliczania_korektora_I1
        
; wartosc_I_ujemna
        
        
        
        
proc_obliczania_korektora_I1
        
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   "t"
        ; movwf   TXREG1
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _przecinek
        ; movwf   TXREG1
     
        ; LFSR    FSR1,aktul_itera_obl_korek_I
        ; call    zamien_hex_na_znak
        
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _przecinek
        ; movwf   TXREG1
        
        ; btfss     markers_regulacja,error_uchyb_ujemny
        ; goto    bez_minusa
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   "-"
        ; movwf   TXREG1
        
bez_minusa
        
        ; LFSR    FSR1,obliczony_uchyb2
        ; call    zamien_hex_na_znak
        ; LFSR    FSR1,obliczony_uchyb1
        ; call    zamien_hex_na_znak
        
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _przecinek
        ; movwf   TXREG1
        
        
        ; btfss     markers_regulacja,error_korekta_czast_ujemna
        ; goto    bez_minusa2
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   "-"
        ; movwf   TXREG1
        
bez_minusa2
        ; LFSR    FSR1,a_obliczana_korekta_I
        ; call    zamien_hex_na_znak
        
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _przecinek
        ; movwf   TXREG1
        
        ; LFSR    FSR1,a_obliczana_korekta_I_fraction
        ; call    zamien_hex_na_znak
        
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _przecinek
        ; movwf   TXREG1
        
        ; call    koncz_wysylanie
                
        
        decf    aktul_itera_obl_korek_I,f
        btfss   STATUS,Z
        return
        
;teraz mnoze jeszcze wynik sredniej przez Ki
;albo dziele jesli Ki jest ulamkiem        
        ;mnoze wynik przez Ki
        ;jesli Ki jest == 0 to znaczy ze dziele przez wartosc w Ki
        ;jesli K=<> 0 to po prostu mnoze przez ta wartosc
        
        movf    Ki,w
        bz      Ki_obl_ulamkowe
        
        
        movwf   mnozona1
        clrf    mnozona2
        clrf    mnozona3
        clrf    mnozona4
        
        btfss   markers_regulacja,error_korekta_czast_ujemna
        goto    obliczanie_I_dodatnie
        
        comf    a_obliczana_korekta_I,f
        incf    a_obliczana_korekta_I,f
        
        
        
obliczanie_I_dodatnie        
        movf    a_obliczana_korekta_I,w
        movwf   liczba_przez_ktora_mnoze1
        clrf    liczba_przez_ktora_mnoze2
        clrf    liczba_przez_ktora_mnoze3
        clrf    liczba_przez_ktora_mnoze4
        
        call    mnozenie
        
spr_wynik_po_operacji        
        btfss   markers_regulacja,error_korekta_czast_ujemna
        goto    spr_wynik_po_operacji_dodatni

        ; comf    wynik4,f
        ; comf    wynik3,f
        ; comf    wynik2,f
       
        ; comf    wynik1,f
        ; incf    wynik1,f
        ; incf    wynik2,f
        ; incf    wynik3,f
        ; incf    wynik4,f
        
        movf    wynik3,w
        bnz      regul_I_minus100
        movf    wynik2,w
        bnz      regul_I_minus100
        
        movlw   0x64
        cpfsgt  wynik1
        goto    przepisz_obl_korekteI
        
regul_I_minus100
        movlw   0x64
        movwf   wynik1
        goto    przepisz_obl_korekteI
        
spr_wynik_po_operacji_dodatni        
        movf    wynik3,w
        bnz      regul_I_powyzej100
        movf    wynik2,w
        bnz      regul_I_powyzej100
        
        movlw   0x64
        cpfsgt  wynik1
        goto    przepisz_obl_korekteI
        
regul_I_powyzej100
        movlw   0x64
        movwf   wynik1

przepisz_obl_korekteI
        bcf     markers_regulacja,error_korekta_ujemna
        ; btfsc   markers_regulacja,error_korekta_czast_ujemna
        ; comf    wynik1,f
        ; btfsc   markers_regulacja,error_korekta_czast_ujemna
        ; incf    wynik1,f
        btfsc   markers_regulacja,error_korekta_czast_ujemna
        bsf     markers_regulacja,error_korekta_ujemna
        
        movff   wynik1,obliczona_korekta_I
        movff    nastawa_Ti, aktul_itera_obl_korek_I
        
        clrf    a_obliczana_korekta_I
        clrf    a_obliczana_korekta_I_fraction
        
        bcf     markers_regulacja,error_korekta_czast_ujemna
        
        return
        
        
        

        
Ki_obl_ulamkowe
        btfss   markers_regulacja,error_korekta_czast_ujemna
        goto    obliczanie_I_dodatnie_Ki_ulamk

        comf    a_obliczana_korekta_I,f
        incf    a_obliczana_korekta_I,f
        

obliczanie_I_dodatnie_Ki_ulamk        

        movff   a_obliczana_korekta_I,   dzielona1        
        clrf    dzielona2
        clrf    dzielona3
        clrf    dzielona4        
        movf    Ki_ulamek,w
        movwf   liczba_przez_ktora_dziele_1
        clrf    liczba_przez_ktora_mnoze2
        clrf    liczba_przez_ktora_mnoze3
        clrf    liczba_przez_ktora_mnoze4
        call    dzielenie_4bajt
        
        goto    spr_wynik_po_operacji
        
        

        
        
procedura_regulacji_dwustawnej         
      
       
;porownaj wartosc pomierzona z zadana
                  
         
         ;chodzi o to zeby wlaczal moc kiedy temperatura spadnie ponizej temperatury zadanej - histereza
         
         
         ;tzn jezeli moc jest wylaczona
         
         ;to wlacz dopiero kiedy temperatura osiagnie wartosc t min
         
         
         ; czy moc jest teraz wlaczona?
         
         
         movf     liczba_nastawy_h,w
         ;pomiarh - jaka_wartosc_regulujeH
         subwf    liczba_thermo_H,w
;sprawdz czy to samo czy wieksze
         btfsc    STATUS,Z
         goto     sa_rowne_sprawdz_Lbajt
         btfss    STATUS,C 
         goto     zalacz_grzanie
;tzn reguluj<pomiaru w starszym bajcie wiec wylacz grzanie
         goto    wylacz_grzanie
         return


         
zalacz_grzanie    
;jezeli jakikolwiek pomiar wykazal ze trzeba wylaczyc to nie wlaczaj grzania
         bsf        latch_triak,pin_triak
         
         movlw      0x64
         movwf       wartosc_zadanego_PWM
         bsf     latch_lampka,pin_lampka
         return
wylacz_grzanie    
;jezeli jakikolwiek pomiar wykazal ze trzeba wylaczyc to nie wlaczaj grzania
         bcf        latch_triak,pin_triak
         movlw      0
         movwf       wartosc_zadanego_PWM
         bcf     latch_lampka,pin_lampka
         return

                           
sa_rowne_sprawdz_Lbajt
;tak samo
         ;movf     histereza,w
         ;sprawdz czy moc wylaczona - jezeli tak to wlacz 1  stopien nizej czyli 4 nizej
;jezeli jest wlaczona energia to dodaj wartosc histerezy tj wylacza pozniej
         
         btfsc    latch_triak,pin_triak
         goto     regulacja_dwu_moc_ON
         
         
regulacja_dwu_moc_OFF         
         ;je¿eli moc jest wy³¹czona w tej chwili to w³¹cz j¹ dopiero gdy 
         ;pomiar bêdzie mniejszy ni¿ temperatura zadana 
         
         ;histereza dolna
         movf     histereza,w
         subwf     liczba_nastawy,w
             
         
         subwf    liczba_thermo,w
;sprawdz czy to samo czy wieksze
         btfsc    STATUS,Z
         goto     zalacz_grzanie
         
         
; je¿eli po odjêciu nie ma C w Statusie, tzn ¿e pomiarL < pomiaru-histerezy
         
         btfss    STATUS,C 
         goto     zalacz_grzanie
;tzn reguluj>pomiaru w mlodszym bajcie wiec wlacz grzanie
         goto   wylacz_grzanie
         return
         
         
regulacja_dwu_moc_ON
         ;je¿eli moc jest w³¹czona w tej chwili to wy³¹cz j¹ dopiero gdy 
         ;pomiar bêdzie wiêkszy ni¿ temperatura zadana + histereza zadana
         
         ;histereza górna
         movf     histereza,w
         addwf    liczba_nastawy,w
         
         ; w WREG jest wartosc  histereza + ustawienie wartosci regulacji
         
       
         subwf    liczba_thermo,w  
         ;w WREG  jest wartosc   pomiarL  -  (histereza + ustawienie wartosci )
;sprawdz czy to samo czy wieksze
         btfsc    STATUS,Z
         goto   wylacz_grzanie

         
         
         ;C pojawia sie tylko gdy pomiarL > (histereza + ustawienie wartosci )
         
         btfss    STATUS,C 
         goto     zalacz_grzanie
;tzn reguluj<pomiaru w mlodszym bajcie wiec wylacz grzanie
         goto   wylacz_grzanie

         

         
         
; dodaj_napiecie_temp_referencyjne


zamien_temp_na_liczbe_AD
;tu obliczam wartosc liczby odpowiadajacej napieciu
        ;termopary dla temperatury referencyjnej
        ;dla k =134
        ;liczba(t) := 4592581.342062194*t-572669.0671031097
        ;dla k=160
        ;liczba(t) := 5470249.795918368*t-682109.3877551021
        
        
        ;wynik musze pozniej podzielic przez 5e5
        ;najpierw mnoze liczbe przez 0x53782a
        movlw   0x2a
        movwf   mnozona1        
        movlw   0x78
        movwf   mnozona2        
        movlw   0x53
        movwf   mnozona3
        clrf   mnozona4
        
        
        clrf    liczba_przez_ktora_mnoze3
        clrf     liczba_przez_ktora_mnoze4
        
        call mnozenie
        
        
        ;od wyniku odejmuje 0xa687d
        movlw   0xa
        subwf   wynik3,f
        btfss   STATUS,C
        decf    wynik4,f
                
        movlw   0x68
        subwf   wynik2,f
        btfss   STATUS,C
        decf    wynik3,f
        btfss   STATUS,C
        decf    wynik4,f
        
        movlw   0x7d
        subwf   wynik1,f
        btfss   STATUS,C
        decf    wynik2,f
        btfss   STATUS,C
        decf    wynik3,f
        btfss   STATUS,C
        decf    wynik4,f
        
        ;to co otrzymalem dziele przez 5e5
        ;teraz dziele przez 5e5
        ;czyli odejmuje wielokrotnie od wyniku 
        ;szesnastkowo
        ;0x7a120
        clrf    liczba_przez_ktora_dziele_4
        movlw   0x07
        movwf   liczba_przez_ktora_dziele_3
        movlw   0xa1
        movwf   liczba_przez_ktora_dziele_2
        movlw   0x20
        movwf   liczba_przez_ktora_dziele_1
        
        movff   wynik4,dzielona4
        movff   wynik3,dzielona3
        movff   wynik2,dzielona2
        movff   wynik1,dzielona1
        
        call    dzielenie_4bajt
        
        movlw   0x03
        subwf    reszta3,w
        ;jesli mniejsze koncz od razu
        ;jesli reszta1>3
        ; C jest zaznaczone
        btfsc   STATUS,C
        goto    zamien_temp_na_liczbe_AD_inc1
        
        btfss   STATUS,Z
        return
        ;jesli sa rowne to sprawdz czy pozostalej bajty nie sa wieksze
        
        movlw   0xd0
        subwf    reszta2,w
        btfsc   STATUS,C
        goto    zamien_temp_na_liczbe_AD_inc1
        
        btfss   STATUS,Z
        return
        
        movlw   0x90
        subwf    reszta1,w
        btfsc   STATUS,C
        goto    zamien_temp_na_liczbe_AD_inc1
        
        return
        
zamien_temp_na_liczbe_AD_inc1
        incf    wynik1,f
        btfsc   STATUS,C
        incf    wynik2,f
        btfsc   STATUS,C
        incf    wynik3,f
        return
        
        
        return
        
        
        
        
        



oblicz_wartosc_temperatury
        
        
zamiana_liczby_natemp
        
        ;wszystkie stale rownania mnoze przez 50000
        ;tak aby wynik miescil sie w zakresie 4 bajtow
        ;dla k =134
        ;t(liczby) := 54485*liczba + 297
        ;wynik musze pozniej podzielic przez 5e5
        ;dla k =160
        ;t(liczby) :=  45743.10302734375*liczba+249.1645812988281
        
        ;najpierw mnoze liczbe przez 45743
        movlw   0xaf
        movwf   mnozona1        
        movlw   0xb2
        movwf   mnozona2        
        clrf   mnozona3
        clrf   mnozona4
        ;mnoze to przez liczbe uzyskana z sht11
        
        
        
        clrf    liczba_przez_ktora_mnoze3
        clrf     liczba_przez_ktora_mnoze4
        
        call mnozenie
        
        
        ;do wyniku dodaje 249
        
        ;0xf9
        ; movlw   0x01
        ; addwf   wynik2,f
        ; btfsc   STATUS,C
        ; incf    wynik3,f        
        ; btfsc   STATUS,C
        ; incf    wynik4,f
        
        
        movlw   0xf9
        addwf   wynik1,f
        btfsc   STATUS,C
        incf   wynik2,f
        btfsc   STATUS,C
        incf    wynik3,f        
        btfsc   STATUS,C
        incf    wynik4,f
        
         
        ;mam wynik temperatury ktory teraz dziele przez 5e5
        ;teraz dziele przez 5e5
        ;czyli odejmuje wielokrotnie od wyniku 
        ;szesnastkowo
        ;0x7a120
        
        clrf    liczba_przez_ktora_dziele_4
        movlw   0x07
        movwf   liczba_przez_ktora_dziele_3
        movlw   0xa1
        movwf   liczba_przez_ktora_dziele_2
        movlw   0x20
        movwf   liczba_przez_ktora_dziele_1
        
        movff   wynik4,dzielona4
        movff   wynik3,dzielona3
        movff   wynik2,dzielona2
        movff   wynik1,dzielona1
        
        call    dzielenie_4bajt
        
        ;jesli ulamek wiekszy niz polowa 50000 to zwieksz o 1
        
        movlw   0x03
        subwf    reszta3,w
        ;jesli mniejsze koncz od razu
        ;jesli reszta1>3
        ; C jest zaznaczone
        btfsc   STATUS,C
        goto    oblicz_wartosc_temperatury_inc1
        
        btfss   STATUS,Z
        return
        ;jesli sa rowne to sprawdz czy pozostalej bajty nie sa wieksze
        
        movlw   0xd0
        subwf    reszta2,w
        btfsc   STATUS,C
        goto    oblicz_wartosc_temperatury_inc1
        
        btfss   STATUS,Z
        return
        
        movlw   0x90
        subwf    reszta1,w
        btfsc   STATUS,C
        goto    oblicz_wartosc_temperatury_inc1
        
        return
        
oblicz_wartosc_temperatury_inc1
        incf    wynik1,f
        btfsc   STATUS,C
        incf    wynik2,f
        btfsc   STATUS,C
        incf    wynik3,f
        return
        
rozkaz_pomiaru         
         db   0xcc,0x44,0x00

rozkaz_odczytu
         db   0xcc,0xbe,0x00
         
rozkac_id
         db       0x33,0x00
         
         
         
         

















zamien_hex_na_znak
        call    sprawdz_czy_mozna_wysylac
         
         swapf    INDF1,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG1
         
         call    sprawdz_czy_mozna_wysylac
         movf     INDF1,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG1  
         
         
         return
 
 
 
 
 
 
 
wysylaj_wszystkie_dane
        ;wyslam przez port szeregowy po kolei
        ;temp szesnastkowo
        ;rh szesnastkowo
        ;temp wyliczona
        ;rh wyliczone
        ;rh z poprawka
        ; bcf      markers,czy_wysylac_dane_serial
        
        
        ; call      sprawdz_czy_mozna_wysylac 
        
        ; LFSR    FSR1,pomiarH
        ; call    zamien_hex_na_znak
        
        ; LFSR    FSR1,pomiarL
        ; call    zamien_hex_na_znak
        
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _przecinek
        ; movwf   TXREG1

;wysylam bajt rh w postaci hex        
        LFSR    FSR1,liczba_thermo_H
        call    zamien_hex_na_znak
        
        LFSR    FSR1,liczba_thermo
        call    zamien_hex_na_znak
        
        call      sprawdz_czy_mozna_wysylac 
        movlw   _przecinek
        movwf   TXREG1

        
        ; LFSR    FSR1,temp_ds
        ; call    zamien_hex_na_znak
        
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _kropka
        ; movwf   TXREG1
        
        ; LFSR    FSR1,temp_ulamek_ds
        ; call    zamien_hex_na_znak
        
        
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _przecinek
        ; movwf   TXREG1

        
        ; LFSR    FSR1,wartosc_zadanego_PWM_tmp
        ; call    zamien_hex_na_znak
        
        
        
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _przecinek
        ; movwf   TXREG1
        
        
        LFSR    FSR1,wartosc_zadanego_PWM
        call    zamien_hex_na_znak
        
        
        
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _przecinek
        ; movwf   TXREG1
        
        
        ; btfss     markers_regulacja,error_korekta_ujemna
        ; goto    wysylaj_bez_minusa
        ; call      sprawdz_czy_mozna_wysylac 
        ; movlw   _minus
        ; movwf   TXREG1
        
; wysylaj_bez_minusa        
        ; LFSR    FSR1,obliczona_korekta_I
        ; call    zamien_hex_na_znak
koncz_wysylanie        
        
        call      sprawdz_czy_mozna_wysylac 
         movlw  0xa
         movwf       TXREG1
        return


        
sprawdz_czy_mozna_wysylac

TMR_nie_pusty     
         btfss    TXSTA1,TRMT
         goto     TMR_nie_pusty     

TXREG_nie_pusty   
         btfss    PIR1,TXIF
         goto     TXREG_nie_pusty
         return   


         
         
         
         
         
         
         
         
         
         
         
         
         
         
         
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
LOOP

         
         ;jesli wyswietlam opcje menu to nie moge przejsc do pomiarow ds dopoki nie dalem markera
      
      
      
      btfsc       markers_pomiary,odczytaj_pomiar_DS1
      call      odbierz_pomiary_temp
 
        btfsc      markers_pomiary,czy_wykonuje_pomiar_DS1
         call     wykonaj_pomiar_czujnikiem_DS


LOOP_thermo         
        btfsc   markers,oblicz_srednia
        call    usrednianie_wartosci_temp

        btfsc   markers,odswiez_wyswietlanie_temp
        call     Wyswietl_temp_liczba_dig_z_LOOP    

        
        btfsc   markers,odswiez_wyswietlanie_temp_ds
        call     Wyswietl_temp_ds_z_LOOP    

        
        
             
       btfss       markers_klawisze,minal_czas_zliczania_po_wcisnie
      goto        LOOP_sprawdz_wcisniecie_klawisz


      bcf       markers_klawisze,minal_czas_zliczania_po_wcisnie


LOOP_sprawdz_ktory_wcisnieto
;ta procedura jest uruchamiana po tym jak zostanie zliczony pewien czas przez jeden z timerow
; i w tym czasie wciaz byl wcisniety przycisk
;czyli to jest rzeczywista procedura uruchamiania opcji menu


      btfsc   stan_key,wcisniety_jest_klawisz_dol
      goto    zarejestrowano_klawisz_dol
                  
      btfsc    stan_key,wcisniety_jest_klawisz_gora
      goto     zarejestrowano_klawisz_gora
                           
      btfsc    stan_key,wcisniety_jest_klawisz_enter
      goto     zarejestrowano_klawisz_enter
         
         
                  
         
         
         
LOOP_sprawdz_wcisniecie_klawisz
;jezeli juz zarejestrowano klawisz to nie sprawdzaj klawiszy
         btfsc   markers_klawisze,wcisnieto_klawisz
         goto     LOOP2

      btfss   port_klawisz_dol,pin_klawisz_dol
      call    wcisnieto_klawisz_dol
                  
      btfss    port_klawisz_gora,pin_klawisz_gora
      call     wcisnieto_klawisz_gora
                           
      btfss    port_klawisz_enter,pin_klawisz_enter
      call     wcisnieto_klawisz_enter
         


LOOP2                            
       
    
         

         

         goto     LOOP
      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;POCZATEK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       
         org      2000h    


                
inicjacja
         clrf    STATUS ;czyszcze status
         
         ;clrf    czas;
         clrf     PORTA
         clrf     PORTB
         clrf     PORTC
         clrf     PORTD
         clrf      PORTE
         
         
         ; clrf   MDCON
         clrf ADCON0
         clrf CTMUCONH
         clrf   CCP1CON
         clrf   CCP2CON
         clrf   SSPCON1
         clrf   SSPCON2
         clrf   RCSTA1
         clrf   RCSTA2
         clrf   CM1CON
         clrf   CM2CON
         clrf   CVRCON
         clrf   HLVDCON
         clrf   OSCCON2
         movlw    b'01111110'
         movwf    OSCCON
                  
         ;ustawienie czestotliwosci 2         
         movlw b'01011011'
         movwf OSCCON2         
         
        movlw   b'00000000'         
        movwf   OSCTUNE
;ustawiam TMR1
         
;przerwania
         clrf     INTCON
         
         

         clrf     PIE1
         clrf     PIE2
         clrf     PIE3
         clrf     PIE4
         clrf     PIE5
         
     ;ustawiam na wyjscia 1 -wejscie
        ;movlw   b'11111111'
         
         movlw    b'11011111'
         movwf    TRISA
         
         movlw   b'11011111'
         movwf    TRISB
                  
        movlw   b'11110000'
         movwf    TRISC
         
;tu sie zminienia dla kabli
        movlw   b'10010111'
         movwf    TRISD
         
         movlw   b'00000111'
         movwf    TRISE
         
         
       
;90  czyli 5a
;50      32
;210(200us) d2
;196(190us) c4    
;        movlw    b'11010010'
        
         
;bank 0
       

         movlw    0x1a
         movwf    SPBRG1
         clrf     TXSTA1
                 
;wylaczam przerwanie szeregu
         bcf      PIE1,RCIE
;        bsf      PIE1,TXIE
        
         clrf     RCSTA1
         clrf     RCSTA2
;wyczyscic trzeba pamiec na zmienne
;jezeli tego nie zrobie to
;po wlaczeniu zasilani moga pojawic
; sie problemy bo moga tam byc losowe dane

         LFSR    FSR0,060h 
clear_next
         ;movlw   0
         clrf     POSTINC0
         
         
         movlw    03h
         xorwf    FSR0H,w
         BTFSS    STATUS,Z
         goto     clear_next
         
       

         
         goto    Start
                  



         end
