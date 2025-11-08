;program dopasowany do wspolpracy z ukladem 
;z pracy statutowej2007
;tzn tylko rejestracja danych

;procek = 18f4320

;procek = 18f442


;dodano  prezentacja  

jak_duzo_zliczen_tmr1_na_sekunde    equ   0x10

procek = 18f1220

IF (procek == 18f442)
list p=18f442
include  "p18f442.inc"

         __CONFIG _CONFIG1H, _OSCS_OFF_1H & _XT_OSC_1H 
         __CONFIG _CONFIG2L, _BOR_OFF_2L & _PWRT_ON_2L
         __CONFIG _CONFIG2H, _WDT_OFF_2H
         
         __CONFIG _CONFIG4L, _DEBUG_OFF_4L & _LVP_OFF_4L & _STVR_OFF_4L
        
ENDIF

IF (procek==18f4320)
list p=18f4320
include  "p18f4320.inc"

         __CONFIG _CONFIG1H, _IESO_OFF_1H & _XT_OSC_1H 
         __CONFIG _CONFIG2L, _BOR_ON_2L & _BORV_45_2L & _PWRT_ON_2L
         __CONFIG _CONFIG2H, _WDT_OFF_2H
         __CONFIG _CONFIG3H, _PBAD_DIG_3H & _MCLRE_ON_3H
         __CONFIG _CONFIG4L, _DEBUG_ON_4L & _LVP_OFF_4L & _STVR_OFF_4L
ENDIF
         
         ;__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF & _DEBUG_OFF

;definicje są w odzielnym pliku

include "def_var.h"

czy_ekran         equ      1
czy_pomiary_na_ekran       equ      1
polozenie_danych_lcd equ 1
;2007-06-07
;
;dodano obsluge ds1820
;poprawiono bledy
;ten program odbiera dane korzystajac z modulu obslugi USART
;w procesorze

;jest to "karta" zbioru danych z 2 czujników temp
;LM35 i
;
;
;PORTD -0 -Klawisz Back
;PORTD -1 -Klawisz down
;PORTD -2 - klawisz up
;PORTD -3 -Klawisz enter
;PORTD -4 - LCD Data
;PORTD -5 - Lcd Data
;PORTD -6 - Lcd Data
;PORTD -7 - Lcd Data

;PORTB -0 -Triak 1 
;PORTB -1 -Triak 2
;PORTB -2 -R/W
;PORTB -3 - RS
;PORTB -4 -
;PORTB -5 -
;PORTB -6 - 
;PORTB -7 -
         
;PORTC - 0 -  A 4051
;PORTC - 1 -   B 4051
;PORTC-  2 -  C 4051
;POrtc - 3 -   Enable
;POrtc - 4 -  CTS (czyli ze procek wysyla) (dane z procka)
;POrtc - 5 - RTS (czyli znacznik ze komputer cos wysyla) (dane do procka)
;POrtc - 6 - transmit
;POrtc - 7 - receive

;PORTA - 0 - Anlog - 8 wejsc lm35 przez mulitplesker
;PORTA - 1 - 
;PORTA - 2 - pomiar pradu 1
;PORTA - 3 - REferencyjne+2,560 V
;PORTA - 4 - 
;PORTA - 5 - pomiar pradu 2 
;PORTE - 0 - 
;PORTE - 1 - 
;PORTE - 2 - 

;TMR0L - czekanie miedzy kanalami analoga na pomiar
;tmr1  - odliczanie sekund pomiaru
;tmr2  - ewentualnie ds1820
;tmr3  -zegar systemowy (przyciski systemu)

;bledy przy pomiarach - tzn gdzies sie wiesza gdy wylaczy sie pomiary
;zaczyna wyrzucac na ekran wszystkie pomiary nie usredniajac  
;to wynika z faktu ze przy wysylaniu danych pojawia sie powrotne wysylania

;okazuje sie ze wlaczenie odbioru "cat /dev/ttyS0" powoduje przeskok RTS w stan 0 (tzn informacja o nadawaniu)

;trzeba zrobic tak by odczyt przez komputer byl tylko w czasie wysylania danych tzn 
;gdy CTS jest na wysoko poza tym powinien byc brak odczytu

;INDF0 (FSR0L i FSR0H) - uzywane tylko w odbiorze danych, tzn w komunikacji z portem szeregowym, oraz w poleceniach 
;INDF1   - uzywane w operacjach Analog oraz w procedurze obróbki danej zmierzonej przez A/D
;INDF2  - używany w procedurach czasu, oraz w 


;2008.03.01
;dodano obsluge zegara i jego wyswietlanie
;brak procedury miganie :zamieniona na procedura_obslugi_zegara

;program działa zupełnie nieźle, jednak wiesza się przy większej liczbie czujników

;2008.03.31



;2008.04.14

;wciąż się wiesza podczas pomiarów temperatury  - próba wyłączania wskazania zegara w trakcie pomiarów nie wpłynęła na poprawę pracy
;wyłączanie wskazywania temperatur również nie wpłynęło na stabilność pracy

;poprawa czyszczenia ekranu kiedy zmieniam wskazania temp na ekranie głównym

;poprawa pracy pokazywania zawartości rejestru
;
;obsługa  wpisywania histerezy, temperatury regulowanej, średniej, ilości próbek,
                                                                                                                                                                                                                                              
;2008.04.15
;wieszanie programu w trakcie pomiarów wynikają z błędów w algorytmie uśredniania wyników
;po zmniejszeniu średniej do 32 próbek nie następuje wieszanie
;wyraźnie na błędy wpływa ilość próbek 64 i 128

;próba zmiany algorytmu uśredniania uzyskanego wyniku
;uśrednianie liczb:
;0x80 (128 próbek) to mnożenie przez 0x02 (2/256)
;0x40 (64 próbki) 0x04
;0x20 (32)  0x08
;0x10 (16)   0x10
;0x08 (8)    0x20 
;0x04 (4 próbki) 0x64
;0x02 (2 próbki) 0x80 (128/256 czyli 0.5) 

;usunięcie procedury przesuwania
;2008.04.16
;poprawiony algorytm usredniania pomiarow
;
;dodano możliwość zmiany wartości przez trzymanie przycisku
;ustaw temp, odstep, 

;2008.04.17
;ostatecznie poprawiłem wieszanie układu, poprawiłem błędy podczas wyświetlania danych na ekranie -> błędy były przy powrocie z
;procedur przerwań, tzn W z W_temp wracał najpierw, a potem jeszcze do W zapisywane były inne wartości
;poza tym błędy były przy wywoływaniu procedur klawisza. Otóż każde naciśnięcie klawisza wywoływało przeskok do procedury
;w przypadku gdy trzymany był klawisz i procedury wykryły że należy zmieniać wskazanie liczby, następował przekok do procedur wykrycia klawisza up lub down,
;jednak powrót następował za pomocą procedury "goto". Stąd problem, bowiem wywołanie funkcji trzymania klawisza są za pomocą call. To powodowało brak
;powrotu z funkcji call, i w końcu zapchanie stosu.
;układowi brakuje wciąż:
;           - zmiany ustawień zegara
;           - wybór wartości mocy dostarczanej do układu
;           - błędy - przy wyświetlaniu prądu triaka 2 jego wartosć jest dodawana do wskazania temperatury 1, 
;           - dodać wybór wskazania który czujnik temperatury jest czujnikiem regulatora
;           - dodać  procedurę regulatora P
;           - regulator PID
;           - dodać przeliczanie wartości zmierzonej prądu na wskazanie amperów
;Poprawić procedurę liczenia średniej wartości pomiarów z pewnego czasu - mieszać ze sobą pomiary w postaci
; pomiar czujnika 1,2,3,4,5 - dłuższa przerwa, 1,2,3,4,5, dłuższa przerwa, etc

;2008.04.26
;błędne działanie procedur pomiaru temperatury - zły pomiar temperatur ujemnych 
;zamiast poprawnej wartości ujemnych po osiągnięciu 0 oC wyświetlana jest wartość -64 oC.
;poza tym zamiast 0 wyświetlane były temperatury na poziomie 1.25 - 1.5 oC. 
;Zważywszy że czujnik był wyskalowany dla temperatur 23 - 20 C, wskazuje to na nierównomierną
;skalę błędu - zmiana być może liniowa - należy to sprawdzić

;2008.04.27
;dodano ustawianie wartości zegara


         org      0000h
BEGIN
         ;bsf      PCLATH,3
         ;bcf      PCLATH,4
         
         goto     inicjacja
                  
         
         org      0008h
         
przerwanie
;zachowuje rejestr W
      movff    STATUS,status_temp
         movwf    w_temp
;zachowuje rejestr STATUS
         
         movff    BSR,bsr_temp
         
         movf     FSR0L,w
         movwf    fsrl_temp
         movf     FSR0H,w
         movwf    fsrh_temp
         
         movf     FSR1L,w
         movwf    fsrl1_temp
         movf     FSR1H,w
         movwf    fsrh1_temp
         
;po to by wszystkie ustawienia banki itd byly na 0    
         ;bsf      STATUS,RP0
         btfss    PIE1,RCIE
         goto     przerwanie_1
         
         ;bcf      STATUS,RP0
         btfsc    PIR1,RCIF
         goto     wykryto_odbior    

przerwanie_1
         ;bsf      STATUS,RP0
         
         btfss    PIE1,TMR1IE
         goto     przerwanie_2
         
         ;bcf      STATUS,RP0
         btfsc    PIR1,TMR1IF
         goto     wykryto_t1

przerwanie_2      
        
         
         btfss    PIE1,TXIE
         goto     przerwanie_3
         
         ;bcf      STATUS,RP0
         btfsc    PIR1,TXIF
         goto     przerwanie_wysylania
         
przerwanie_3      
         
         
         btfss    PIE1,ADIE
         goto     przerwanie_4
         
         ;bcf      STATUS,RP0
         btfsc    PIR1,ADIF
         goto     przerwanie_pomiaru
         
przerwanie_4
         
         
         btfss    PIE1,TMR2IE
         goto     przerwanie_5
         
         ;bcf      STATUS,RP0
         btfsc    PIR1,TMR2IF
         goto     wykryto_t2
przerwanie_5
         
;        goto     wykryto_rb
        
        
        btfsc    INTCON,TMR0IF
        goto     wykryto_t0

przerwanie_6
        btfss    PIE2,TMR3IE
        goto     przerwanie_7
         
        
        btfsc    PIR2,TMR3IF
        goto     wykryto_t3   
        
przerwanie_7        
;        btfsc    PIR1,TMR2IF
;        goto     wykryto_t2
         
;        btfsc    PIR1,TMR2IF
;        goto     wykryto_t2
         
wyjscie_przerwanie

         movff    bsr_temp,BSR
         
         
         movf     fsrl_temp,w
         movwf    FSR0L
         movf     fsrh_temp,w
         movwf    FSR0H
         
         movf     fsrl1_temp,w
         movwf    FSR1L
         movf     fsrh1_temp,w
         movwf    FSR1H
         
         movf     w_temp,w
         movff    status_temp,STATUS

         retfie
         
         
         
wykryto_t1

                                                      ;Procedury obslugi czasu
      bcf      PIR1,TMR1IF
      
      
         ;czy minelo 16 sekund
      bsf      markers2,przerwanie_t1   
         
      movlw jak_duzo_zliczen_tmr1_na_sekunde
      xorwf do_sekundy,w
;jezeli    nie  0 w wyniku to skok do procedury 
      bnz   wykryto_t1_wyjscie      
;jezeli 0 to zwiększ sekunda o 1      
      
      clrf  do_sekundy
      incf  sekundy_1,f
           
;sprawdz czy cyfra jednosci nie przekroczyla 9 sekund
      movlw 0x3a
      xorwf sekundy_1,w
      bnz   ustaw_wyswietlanie_czasu_na_lcd
;czyszcze    liczbe jednosci i zwiekszam o jeden liczbe 
      movlw 0x30
      movwf  sekundy_1
      incf  sekundy_10,f
      
      movlw 0x36
      xorwf sekundy_10,w
      bnz   ustaw_wyswietlanie_czasu_na_lcd
      movlw 0x30
      movwf  sekundy_10
      
      incf  minuty_1,f
;sprawdzam czy nie przekroczylem  
      
      movlw 0x3a
      xorwf minuty_1,w
      
      bnz   ustaw_wyswietlanie_czasu_na_lcd
      movlw 0x30
      movwf minuty_1
      incf  minuty_10,f
      
      movlw 0x36
      xorwf minuty_10,w
      bnz   ustaw_wyswietlanie_czasu_na_lcd
      movlw 0x30
      movwf minuty_10
                                          ;godziny      
      incf  godziny_1,f
;sprawdz czy jezeli jest 4 czy nie ma 2 na godziny_10
      movlw       0x34
      cpfseq      godziny_1
      goto        sprawdz_godziny
      movlw       0x32
      cpfseq      godziny_10
      goto        sprawdz_godziny
      movlw       0x30
      movwf godziny_10
      movwf godziny_1
      incf  dzien_1,f
      
            
sprawdz_dzien
      movlw 0x3a
      xorwf dzien_1,w
      bnz   ustaw_wyswietlanie_czasu_na_lcd
      movlw 0x30
      movwf  dzien_1
      incf  dzien_10,f
      
      movlw 0x3a
      xorwf godziny_10,w
      bnz   ustaw_wyswietlanie_czasu_na_lcd
      movlw 0x30
      movwf dzien_10
      
      goto  ustaw_wyswietlanie_czasu_na_lcd
sprawdz_godziny      
      movlw 0x3a
      xorwf godziny_1,w
      bnz   ustaw_wyswietlanie_czasu_na_lcd
      movlw 0x30
      movwf godziny_1
      incf  godziny_10,f
      
      
      


ustaw_wyswietlanie_czasu_na_lcd
      ;czy system obsluguje zegar, bo nie musi i nie powinien przy bardzo częstym pomiarze i wysyłaniu danych
      ;czyli co 1/16
      
      btfss markers3,czy_zegar_wyswietlac
      goto  wykryto_t1_wyjscie 
      
      ;a jezeli ma odswiezyc wszystkie znaki:
      bsf   markers3,odswiezanie_zegara
      
      ;jezeli mam odswiezyc zegar to wylaczam na chwilke pomiary i dopiero po wyswietleniu 
      ;sprawdz czy byly wlaczone pomiary
      ;btfss       markers2,pomiary
      ;goto        wykryto_t1_wyjscie 
      
      
      ;bsf   markers,pomiary_zrobione
      ;i zaznacz zeby je jeszcze raz wlaczyl po wyswietleniu czasu
      ;bsf   markers,czy_wlaczyc_ponownie_temp
      
      
      
wykryto_t1_wyjscie  
      incf     do_sekundy,f
      
      goto     wyjscie_przerwanie                  
         
wykryto_rb
;wlaczam przerwanie tmr2 i ustawiam przy pomocy TMR2 na 100us tzn 
;
;
         
         bcf      INTCON,RBIF
         
;        btfsc    markers2,odbior
;        goto     wyjscie_przerwanie
         
         btfsc    port_serial,RXD
         goto     wyjscie_przerwanie         
;        btfsc    bit,7
;        goto     wylaczam_odbior
;        bsf      markers2,poczatkowy_bit
         
         goto     wyjscie_przerwanie

wykryto_t0
;uzywam do wykrywania czy juz zrobic pomiar
IF (procek == 18f442)
         bcf      INTCON,T0IF
         bcf      INTCON,T0IE
         
ENDIF

IF (procek == 18f4320)
         bcf      INTCON,TMR0IF
         bcf      INTCON,TMR0IE
         
ENDIF
         
         bsf      ADCON0,GO 
         ;clrf     pomiarH
         ;clrf     pomiarL
         ;clrf     pomiar_ulamek        
         goto     wyjscie_przerwanie
         
wykryto_t2
;uzywam do odmierzania czasu dla DS1820
;1 - 
;oczekuje kolejne max 480 us. jezeli po tym czasie nie wystapi jeden to napisz blad

;

;
         bcf      PIR1,TMR2IF
         
;jezeli tesuje czas     
;          bcf     PORTC,2         
         ;bsf      STATUS,RP0
         bcf     PIE1,TMR2IE
         ;bcf      STATUS,RP0
         bcf      T2CON,TMR2ON
             
         
         
;        btfss    markers2,
;        goto     wyjscie_przerwanie
         
;        bsf      markers2,odbierz_bit
        

wykryto_odbior
;        btfsc    odebrano_liter,4
         ;call     miganie
;czytanie rcsta go kasuje
wykryto_odbior_odczyt
;jezeli mam ustawione na ekran to nic nie odbieraj    
         btfsc    markers2,sprawdz_odebrane
         goto     wyjscie_przerwanie
;wylacz inne przerwania
;        bsf      STATUS,RP0
;        bcf      PIE1,TMR1IE
;        bcf      STATUS,RP0
         
;          bcf      markers2,blad_transmisji
;czy jest framing error
         btfsc    RCSTA,FERR
         goto     wykryto_blad
;        bsf      markers2,blad_transmisji
         
         btfsc    RCSTA,OERR
         goto     wykryto_oerr
         
         
         movf     odebrano_liter,w
         addlw    dane_odebraneL
         movwf    FSR0L
         movlw    dane_odebraneH
         movwf    FSR0H
         
         movf     RCREG,w
         movwf    INDF0
;jezeli blad transmisji to nie zapamietuj         
;          btfsc    markers2,blad_transmisji
;          goto     wykryto_odbior_odczyt_dalej  
;                    
         
         
         
         movlw    0x0a
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     wykryto_odbior_CR
         
;        movlw    0x0a
;        xorwf    INDF0,w
;        btfss    STATUS,Z
        incf     odebrano_liter,f
         
         goto     wyjscie_przerwanie
;        goto     wykryto_odbior_wyjscie
;        
         
;        movlw    0x0A
;        xorwf    INDF0,w
;        btfss    STATUS,Z
;        goto     wykryto_odbior_wyjscie
         
                  
wykryto_odbior_CR 
;sprawdz czy pierwszym znakiem jest *
         
         bsf      markers2,sprawdz_odebrane
;        clrf     odebrano_liter
;        movf     RCREG,w
;        movwf    INDF0
;        
;        czysc dwa bwyswietlajty na zero -> znacznik konca wyswietlania         
;        
         
        movlw     0x0d
         movwf    INDF0
          
        incf    FSR0L,f
        movwf    INDF0
        incf    FSR0L,f
        clrf     INDF0
         incf    FSR0L,f
        clrf     INDF0
;wylaczam szeregowy odbior
         bcf      RCSTA,CREN        

przerwanie_wysylania       
         goto     wyjscie_przerwanie

wykryto_oerr      
         bcf      RCSTA,CREN        
         nop
         bsf      RCSTA,CREN
                                    
         goto     wyjscie_przerwanie
wykryto_blad
         movf     RCREG,w
         goto     wyjscie_przerwanie

przerwanie_pomiaru
         bcf      PIR1,ADIF
;kopiuje pomiar do rejestru
;sprawdz czy ustawiono 1 lub 0 - wtedy nic nie dziele 
         
         movlw    wynikh
         btfss    markers,czy_usrednianie
         movlw    pomiarH
;        addwf    ktory_rejestr_zapisuje,w
         movwf    FSR1L
         clrf     FSR1H
         
         movf     ADRESH,w
         movwf    INDF1
         incf     FSR1L,f

         movf     ADRESL,w

         movwf    INDF1
         bsf      markers2,wyslij_pomiar
;nastepnym razem zapisze do kolejnego rejestru        
;        incf     ktory_rejestr_zapisuje,f
         goto     wyjscie_przerwanie
   

wykryto_t3

      bcf   PIR2,TMR3IF
      ;sprawdzam czy klawisz jest dalej wcisniety
      
      ;robie and z zawartoscia stan_key
      ;jezeli jest w wyniku 0 (tzn ze klawisz wciaz jest trzymany
      ;np dla klawisza back stan latch_keys:  xxxx1110 - jezeli wcisniety 
      ;                                      stan_keys          xxxx001  
      ;w wyniku 0 chyba że klawisz puszczono i jest 1
      movf        stan_key,w
      andwf       latch_keys,w
;tzn ze wciaz przycisk jest wcisniety
      ;i nic nie robie czyli wychodze
      btfsc       STATUS,Z
      goto         wykryto_t3_nie_puszczono
      
      ;natomiast jezeli wyszlo 1 to sprawdz ktory przycisk zostal puszczony  
      ;i wymus sprawdzenie i dalsze podprogramy zwiazane z danym klawiszem
      bcf         markers3,wcisnieto_klawisz
      bcf         markers,trzymanie_klawisza
      bcf         znaczniki,czy_moge_juz_zmieniac
      
      ;wylacz przerwanie tmr3
      bsf         markers3,dzialanie_po_klawiszu
      goto        wyjscie_przerwanie
      
wykryto_t3_nie_puszczono
;jeżeli zaznaczony jest bit trzymanie_klawisza to pozwól na szybką zmianę wartości w trakcie 
;trzymania przycisku

;jeżeli już zaznaczono ze moge zmieniac to nie sprawdzaj miniecia sekundy
      btfsc       znaczniki,czy_moge_juz_zmieniac
      goto        wyjscie_przerwanie

      btfss       markers,trzymanie_klawisza
      goto        wyjscie_przerwanie
;szybka zmiana dopiero po sekundzie - czyli dwa zliczenia
      decfsz      szybka_zmiana_wartosci,f
      goto        wyjscie_przerwanie

      movlw       1
      movwf       szybka_zmiana_wartosci
;jeżeli już jest 0 to pozwól na zmianę       
      bsf         znaczniki,czy_moge_juz_zmieniac
      goto        wyjscie_przerwanie
      
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;KOniec Przerwan   
;;;;;;;;;;;;;;;;;;;;;;;;
;;;PROGRAM
;;;;;;;;;;;;;;;;;;;;;;;;;
include  "../libs/lcd.h"

include  "../libs/lcd4bit18.asm"

;include  "../../libs/dziel_przez2_18.asm"

include  "../libs/eeprom18.asm"

Start
;odczytuje wartosci poprawek czujnikow temperatury
      movlw     poprawka0_ee
      movwf      FSR0L
      clrf       FSR0H
      movlw      poprawka0
      movwf      FSR1L
      clrf       FSR1H
      
petla_odczytu_poprawek_z_eeprom
      movf       FSR0L,w
      call        czytaj_eeprom
      movwf      INDF1
      
      incf       FSR0L,f
      incf       FSR1L,f
      movlw      0x0a
      xorwf      FSR0L,w
      btfss      STATUS,Z
      goto        petla_odczytu_poprawek_z_eeprom
      
      

IF  (czy_ekran==1)
         call     lcd_init
         call     check_busy
         call    cmd_off
         
         
;        call     check_busy
         movlw   linia_gorna
         call    send
         call     check_busy
         movlw    _E
         call     write_lcd
ENDIF
         
;konfiguruje port szeregowy
;ustawiam baud rate
         ;bsf      STATUS,RP0
         ;bcf      STATUS,RP1
;        movlw    0x1a
;         movlw    0x1a
;         movlw    0x1a
         movlw    0x0c
         movwf    SPBRG
         clrf     TXSTA
         bsf      TXSTA,BRGH
         bsf      TXSTA,TXEN
         

         
;wlaczam przerwanie szeregu
         bsf      PIE1,RCIE
;        bsf      PIE1,TXIE
         ;bcf      STATUS,RP0
         movlw    b'10010000'
         movwf    RCSTA
         
         

         movlw    0
         movwf    ktory_rejestr_zapisuje
                  
         
         
         movwf   ktora_probka
         

         movlw    8
         movwf    jak_duzo_bajtow_odbieram_z_ds
         
         bsf      port_CTS,znacznik_CTS
         
         
         ;tu ustawiam napiecia referencyjne jako AN3 i Vss 
;wszystkie 
IF  (procek==18f442)
         movlw    b'10000001'
         movwf    ADCON1
ENDIF         
IF  (procek==18f4320)         
         movlw    b'00011010'
         movwf    ADCON1
         
         movlw    b'10100110'
         movwf    ADCON2
ENDIF

      bsf   markers3,czy_zegar_wyswietlac

         movlw    0x30
         movwf    dzien_10
         movwf    dzien_1
         movwf    godziny_10
         movwf    godziny_1
         movwf    minuty_10
         movwf    minuty_1
         movwf    sekundy_10
         movwf    sekundy_1
         
         
         ;ustawienie opcji pomiarowych dla menu
         movlw          0
         movwf          ile_kanalow
         movlw          0x20
         movwf          odstep_pomiarowy
         movlw          0x80
         movwf          jak_duzo_probek
         
         call           ustaw_wartosc_dzielenia_usredniania
         
         bsf            markers,czy_usrednianie
         
         movlw    0
         movwf    jaka_wartosc_regulujeH
         movlw    0x80
         movwf    jaka_wartosc_regulujeL
         
         movlw    4
         movwf    histereza
         
         ;włączam znaczniki sprawiające że przy opuszczeniu menu następuje ponowne włączenie
;zegara oraz pokazywania temperatury
;z poziomu menu można zmienić te znaczniki tak by nie nastąpiło ponowne wyświetlanie zegara i temperatur
         
         bsf            znaczniki,czy_ponownie_wlaczyc_zegar
         bsf            znaczniki,czy_ponownie_wlaczyc_temp
         
         goto     LOOP
  
         
hex2dec18
      ;zamiana wartosci szesnastkowej na dziesietne
      ;dziele przez 10 tzn mnoze przez 0x1a/256 (0x26) lub przez 0x19/256 (25)
;      i wynik jednosci w PRODH, a ulamek w ProdL
      ;w młodszym bajcie wyniku jest ułamek
      ;należy przed uruchomieniem procedury 
      ; umieścić liczbę dzieloną w rejestrze  
      ;tmp_hex
      ;bajt starszy w tmp_hex_H
      
      
      ;clrf        dec1
      ;clrf        dec10
      clrf        dec100
      
      ;dziele przez 5
      ;mullw       0x33
      ;wynik jest w starszym bajcie
      ;movf        PRODH,w
      ;dzielę przez 2 - 0x80
      ;dzielę przez 0.0976 - mnoże przez 0x19
      movf        tmp_hex,w
      mullw       0x19
      movf        PRODH,w
      
      movwf       dec10
      mullw       0xa
      movf        PRODL,w
      ;tmp_hex - dec10*10 = liczba jednosci
      subwf       tmp_hex,w
      movwf       dec1
;sprawdzam czy liczba jedności nie przekracza 10, czyli czy nie jest większa > 9
      movlw       0x9
      cpfsgt      dec1  
      goto        hex2dec18_nie_przekroczono_1
      
      movlw       0xa
      subwf       dec1,f
      incf        dec10,f
      
      btfsc       STATUS,C
      incf        dec100,f
      
      
hex2dec18_nie_przekroczono_1
;sprawdz czy liczba dziesiatek  nie przekracza liczby 10 tzn podziel liczbę przez 10 (mnożę przez 0x1a)
      ;przez 5
      movf       dec10,w
      ;mullw       0x33
      
      ;movf        PRODH,w
      ;dzielę przez 26
      mullw       0x1a
      
      movf        PRODH,w
;jezeli jest 0 to skocz dalej
      bz          hex2dec18_brak_setek
;jezeli brak 0 tzn ze w wyniku mamy jakies liczby setek
      movwf       dec100
      ;a ile zostalo liczb 10 - 
      movlw       0xa
      mulwf       dec100
      ;mnoze dec100*100 i wynik odejmuje od liczby 10
      movf        PRODL,w
      subwf       dec10,f
; i juz mam ilosc dziesiatek i setek i jednosci z wyniku zamiany jednego bajta na postać dziesiętną
      
hex2dec18_brak_setek
;teraz sprawdzam czy w starszym bajcie liczby dzielonej stoi jakas wartość jezeli tak to zwiekszam ilosc setek i dziesiatek
;jezeli w starszym bajcie stoi cos:
      
      movf       tmp_hex_H,w
            
      
      ;jezeli 0 to koncz prace procedury
      bz          hex2_dec_koniec
      ;jezeli nie to popraw wyniki o poprawke
      xorlw       0x01
      bz          hex2dec_temperatur_popraw_o_64
      
      movf       tmp_hex_H,w
      xorlw       0x02
      bz          hex2dec_temperatur_popraw_o_128

      goto        hex2_dec_koniec
      
hex2dec_temperatur_popraw_o_64
      movlw       0x06
      addwf       dec10,f
      movlw       0x04
      addwf       dec1,f
      goto        hex2_dec_koniec
      
hex2dec_temperatur_popraw_o_128
      movlw       0x01
      addwf       dec100,f
      movlw       0x02
      addwf       dec10,f
      movlw       0x08
      addwf       dec1,f
      goto        hex2_dec_koniec
      
hex2_dec_koniec
      return


                                                                                                ;ZEGAR    Systemowy  
 

napisz_czas
      bcf   markers3,odswiezanie_zegara
      ;wyswietlam wszyskie wielkosci czasowe na 1 linii ekranu
      call     check_busy
      movlw   linia_gorna
      call    send
      call     check_busy
      
     movlw  _puste 
     ;jeżeli praca w trybie regulacji to pisz r
     btfsc  markers2,reguluj
     movlw  _r
     call   write_lcd
     
     call     check_busy
     
     ;jeżeli praca w trybie transferu szeregowego
     movlw  _puste 
     btfsc  markers,czy_wysylac_pomiary_serial
     movlw  _s
     call   write_lcd
     call     check_busy 
      
      
      
      ;addlw 2
      
      
            
      movlw       dzien_10
      movwf       FSR2L      
      clrf        FSR2H
      goto        petla_napisz_czas
      
petla_napisz_czas_dwukropek      
;po kazdych dwóch cyfrach pisz dwukropek
      movlw       _dwukropek
      call        write_lcd
      call        check_busy
            
;w FSR2l umieszczam adres komorki dzien_10, zwiekszajac ten adres o 1 mam dostep po kolei do wszystkich wartosci 
;czasowych
petla_napisz_czas
;sprawdz czy cyfra 10 jest 0 - jezeli tak to wyswietl puste
      movlw 0x30
      xorwf FSR2L,w
      btfsc STATUS,Z
      goto  wyswietl_puste
;jezeli wyswietlam zawartosc rejestru      
      movf  INDF2,w
      goto  wyswietl_1
      
wyswietl_puste
      movlw _puste
      
wyswietl_1      
      
      
      call  write_lcd
      call  check_busy
      
      incf  FSR2L,f
      movf  INDF2,w
      call  write_lcd
      call  check_busy
      
      incf  FSR2L,f
      
      movlw       sekundy_1+1
      xorwf       FSR2L,w
      bnz         petla_napisz_czas_dwukropek
      
      ;po wyswietleniu zegara znow kaz mierzyc
      
      btfss       markers,czy_wlaczyc_ponownie_temp
      goto        LOOP 
      
      
      ;bcf   markers,pomiary_zrobione
      ;i zaznacz zeby je jeszcze raz wlaczyl po wyswietleniu czasu
      bcf   markers,czy_wlaczyc_ponownie_temp
      
      goto  LOOP
      ;sprawdz czy INDF2 ==    sekundy_1 + 1
      
      
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                                 SPRAWDZANIE CZY nastapilo 0  
odznacz_by_znow_mierzyc
                                    ;sprawdz czy odstep miedzy pomiarami juz minal
      
      ;incf  aktualny_odstep,w
      
      ;movf  aktualny_odstep,w
      ;bnz   bez_wlaczania_pomiarow
      
         decfsz   aktualny_odstep,f
         return                
         
         movf     odstep_pomiarowy,w
         movwf    aktualny_odstep
         
         btfss    markers,pomiary_zrobione
         return
         
         bcf      markers,pomiary_zrobione
         bsf      markers,inicjuj_pomiary
         return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;  KAZDE ROZPOCZEcie POMIAROW         
rozpocznij_pomiary         
;dokonuj pomiaru  na pierwszym kanale
;wlaczam tez przerwanie analogowego pomiaru
         
;wlacz przerwanie jak skonczy mierzyc zeby wyslac
;wystarczy ze 000 do bitow kanalu
      clrf  linia2
      clrf  linia4
         bcf      markers2,wyslij_pomiar 
         ;
         movf     ile_kanalow,w
         movwf    ktory_kanal_mierze 
         
         movf    jak_duzo_probek,w
         movwf   ktora_probka
         clrf     ktory_kanal
         
         ;movwf   ktore_dzielenie_przez2
         
         movf     port_multiplekser,w
;czyszcze aktualne ustawienia multipleksera
;jezeli byl tu b'01010001'     
         andlw    b'11111000'
;w wyniku mamy b'01010000'      
         movwf    latch_multiplekser   
         
         movf     ADCON0,w
         
         ;bsf      STATUS,RP0
         ;bcf      STATUS,RP1
;        movlw    0x1a
         
         ;bcf      STATUS,RP0    
         ;clrf     TMR0L
IF (procek == 18f442)
         ;bcf      INTCON,T0IF
         ;bsf      INTCON,T0IE
         andlw    b'11000111'
         movwf    ADCON0
         
ENDIF
IF (procek == 18f4320)
         ;bcf      INTCON,TMR0IF
         ;bsf      INTCON,TMR0IE
         andlw    b'11000011'
         movwf    ADCON0
         
ENDIF
         
         ;jezeli mam wykonywac pomiary to zapisz z rejestru ile mam robic pomiarow
         btfsc    markers3,pomiary_pradu
         clrf     ktory_aktualnie_kanal_pradu
         
         bcf      markers,inicjuj_pomiary
         
         bsf      ADCON0,GO
         bsf      PIE1,ADIE
         
        return             

         
bez_wlaczania_pomiarow

         
      
procedura_obslugi_zegara
;najpierw sprawdz czy minelo 16 zliczen?
      


      ;jezeli pomiary to cy je robic?
         btfsc    markers2,pomiary
         call     odznacz_by_znow_mierzyc
      ;odznacz    
         bcf      markers2,przerwanie_t1
      
      
         ;btfss    portlampka,lampka
         ;goto     zapal    
         ;bcf      portlampka,lampka
                  
         return
;zapal    
 ;        bsf      portlampka,lampka
  ;       return

zapal_lampke
         btg    portlampka2,lampka2
         
         ; goto     zapal_lampke2
         ; bcf      portlampka2,lampka2
                  
         ; goto     powrot_z_polecen
; zapal_lampke2
         ; bsf      portlampka2,lampka2
         
          goto     powrot_z_polecen



sumuj_liczby
         clrf     liczba2
         clrf     liczba1
         
         ;incf     FSR0L,f
         
sumuj_liczby_do_kropki
         
         call     kopiuj_liczbe_przeslana
         movff    tmp,liczba1
                           
;sprawdz czy przekroczono bajt
         ;btfsc    STATUS,C
         ;incf     liczba2,f
         ;                  
         ;incf     FSR0L,f
         ;movlw    _kropka
         ;xorwf    INDF0,w
         ;btfsc    STATUS,Z
         ;incf     FSR0L,f
         
         ;movlw    0x0a
         ;xorwf    INDF0,w
         ;btfss    STATUS,Z
         ;goto     sumuj_liczby_do_kropki     
         call     kopiuj_liczbe_przeslana
         movff     tmp,liczba2
         
         
         swapf    PRODH,w
         andlw    0x0f
         call     zamien_na_hex
         movwf    TXREG
         
         call     sprawdz_czy_mozna_wysylac
         
         movf     PRODH,w
;robiac taka operacje kasuje starszy bajt na 3 a mlodszy bez zmian      
         andlw    0x0f
         call     zamien_na_hex
         movwf    TXREG
         call     sprawdz_czy_mozna_wysylac
         
         swapf    PRODL,w
         andlw    0x0f
         call     zamien_na_hex
         movwf    TXREG
         
         call     sprawdz_czy_mozna_wysylac
         
         movf     PRODL,w
;robiac taka operacje kasuje starszy bajt na 3 a mlodszy bez zmian      
         andlw    0x0f
         call     zamien_na_hex
         movwf    TXREG
         
         call     sprawdz_czy_mozna_wysylac
;zapisz  cyfra
         
         ;call     wyswietlanie_liczby
         goto     powrot_z_polecen

sprawdz_czy_mozna_wysylac
         ;bsf      STATUS,RP0
TMR_nie_pusty     
         btfss    TXSTA,TRMT
         goto     TMR_nie_pusty     
         ;bcf      STATUS,RP0
TXREG_nie_pusty   
         btfss    PIR1,TXIF
         goto     TXREG_nie_pusty
         return   
         
wyslij_znak
;sprawdz czy USART transmit buffer jest pusty
         movlw    dane_odebraneL
         
         movwf    FSR0L
         movlw    dane_odebraneH
         movwf    FSR0H
         
wyslij_znak_petla 
         call     sprawdz_czy_mozna_wysylac
;laduje dane do wyslania   
         incf     FSR0L,f
         
;        movf     INDF0,w
;        call     write_lcd
;        call     check_busy
         
         movlw    0x0d
        xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     wyslij_znak_koniec
         
         movf    INDF0,w
         movwf    TXREG
         goto     wyslij_znak_petla
wyslij_znak_koniec
         call     sprawdz_czy_mozna_wysylac
         movlw    _puste
         movwf    TXREG
         call     sprawdz_czy_mozna_wysylac
         movlw    _dwukropek
         movwf    TXREG
         call     sprawdz_czy_mozna_wysylac
         movlw    _minus
         movwf    TXREG
         call     sprawdz_czy_mozna_wysylac
         movlw    znak_lf
         movwf    TXREG
         
         decf     FSR0L,f
;        call     sprawdz_czy_mozna_wysylac
;        movlw    znak_lf
;        movwf    TXREG
         
         goto     powrot_z_polecen
         
sprawdz_czy_odebrano_litere
         movlw    0x30
         subwf    INDF0,w
         movwf    tmp7
;sprawdzam czy zostaly jakies bity w gornej polowce bajtu
         
         andlw    0xf0 
         btfsc    STATUS,Z
         return
;jezeli odebrano litere duza (A,B,C,D,E,F) to po odjeciu 0x41 nic nie powinno zostac w                    
         movlw    0x41
         subwf    INDF0,w
         movwf    tmp7

         andlw    0xf0 
         btfss    STATUS,Z
         goto     sprawdz_czy_odebrano_mala_litere
;zasada taka to co zostalo po odjeciu 0x41 to 0 dla A 1 dla B etc
;aby miec prawdziwy znak dodaje do tego 0x0a         
         movlw    0x0A
         addwf    tmp7,f
         return
sprawdz_czy_odebrano_mala_litere
         movlw    0x61
         subwf    INDF0,w
         movwf    tmp7
         andlw    0xf0 
         btfss    STATUS,Z
         goto     zla_dana_wez_0
         movlw    0x0A
         addwf    tmp7,f
         return
zla_dana_wez_0
         clrf     tmp7
         return
         
kopiuj_liczbe_przeslana
;procedura dziala na tej zasadzie
;ze znaki 0123456789;:<=>?
;wysłane na ekran 
;po odjeciu 0x30 sa 4bitami liczby
;pierwszy znak jest wyzszym bajtem
;drugi znak nizszym

;dodano obsluge literek a,b,c,d,e,f
;zamiast znakow ;:<=>?
         incf     FSR0L,f
         
         call   sprawdz_czy_odebrano_litere  
         
         
         swapf    tmp7,w
         movwf    tmp
         
         incf     FSR0L,f
         call     sprawdz_czy_odebrano_litere
         movf     tmp7,w
         addwf    tmp,f
         
         return
                  
zamien_na_hex
;jezeli po odjeciu 0a jest niezanaczony bit C
;to znaczy ze dodaj 
         movwf    tmp7
         movlw    0x0a
         subwf    tmp7,w
         btfss    STATUS,C
         goto     cyfry_0_9
         movf     tmp7,w
         addlw    0x37
         return
cyfry_0_9         
         movf     tmp7,w
         addlw    0x30
         return
         
ustaw_spbrg
         
         
         call     kopiuj_liczbe_przeslana
         movf     tmp,w
;zmieniam SPBRG
         ;bsf      STATUS,RP0
         ;bcf      STATUS,RP1
;        movlw    0x1a
         movwf    SPBRG    
         ;bcf      STATUS,RP0
         goto     powrot_z_polecen

pokaz_rejestr     
         
         call     kopiuj_liczbe_przeslana
         
;przechowuje FSR0L gdzies    
         
         
         movf     tmp,w
         movwf    FSR2H
         call     kopiuj_liczbe_przeslana
         movf     tmp,w
         movwf    FSR2L
;        movf     INDF0,w
;teraz rodzielam bajt na 4 bity starsze i 4 bity mlodsze
         swapf    INDF2,w
         andlw    0x0f
         call     zamien_na_hex
         movwf    TXREG
         
         call     sprawdz_czy_mozna_wysylac
         
         movf     INDF2,w
;robiac taka operacje kasuje starszy bajt na 3 a mlodszy bez zmian      
         andlw    0x0f
         call     zamien_na_hex
         movwf    TXREG
         call     sprawdz_czy_mozna_wysylac
         movlw    znak_lf
         movwf    TXREG
         call     sprawdz_czy_mozna_wysylac
         
         goto     powrot_z_polecen


;inicjuje pomiar co ile sekund na ktoryms z kanalow     
zle_polecenie
         clrf     tmp
zle_polecenie_petla
;jestem w pamieci gdzie skok musi byc wykonany w  
;250 komorce stad do 
;PCLATH musze zaladowac 0x2
         movlw    0x02
         movwf    PCLATH
         movf     tmp,w
        call    Tab_zle_polecenie
        clrf      PCLATH
;je?eli przeczytał 0 to kończ wyświetlanie
         xorlw    0
         btfsc    STATUS,Z
         goto     powrot_z_polecen
         call     sprawdz_czy_mozna_wysylac
         movwf    TXREG
         incf     tmp,f
         goto    zle_polecenie_petla
         
Tab_zle_polecenie         
         addwf    PCL,f
         retlw    _z
         retlw    _l
         retlw    _e
         retlw    _puste
         retlw    _p
         retlw    _o
         retlw    _l
         retlw    _e
         retlw    _c
         retlw    _e
         retlw    _n
         retlw    _i
         retlw    _e
         retlw    znak_cr
         retlw    0
         
inicjuj_pomiar
;odbierz cyfre ile mam wlaczyc portow analogowych
         
;do pomiarow potrzebuje rejestr TMR2         
         incf     FSR0L,f
         movf     INDF0,w
         btfsc    STATUS,Z
         goto     wylacz_pomiary
         
         movlw    0x30
         subwf    INDF0,w
         btfsc    STATUS,Z
         goto     wylacz_pomiary
         movwf    ile_kanalow
         
         movwf    ktory_kanal_mierze
         
            
;sprawdz czy liczba kanalow nie jest wieksza od 8
;jezeli od ile_kanalow odejme 8 i nie wyjdzie bit C
;tzn pozyczki to przyjmij 0x07
         sublw    0x08
         btfss    STATUS,C
         goto     zle_polecenie
;jezeli nie ma kropki to koncz
         incf     FSR0L,f
         movlw    _kropka
         xorwf    INDF0,w
         btfss    STATUS,Z
         goto     powrot_z_polecen
;odbierz kolejne cyfry
        
         call     kopiuj_liczbe_przeslana
         movf     tmp,w
         movwf    odstep_pomiarowy
         movwf    aktualny_odstep
;wlacz analog/cyfre
         movlw    b'00000001'
         movwf    ADCON0
         bsf      markers2,pomiary
         ;bcf      portlampka2,lampka2
         ;clrf     TMR2
         ;movlw    b'00000000'
         ;movwf    T2CON
         movf    jak_duzo_probek,w
         
         movwf   ktora_probka
         movf     port_multiplekser,w
         
;czyszcze aktualne ustawienia 
;jezeli byl tu b'01010001'     
         andlw    b'11111000'
;w wyniku mamy b'01010000'      
         movwf    latch_multiplekser
         
;IF  (czy_ekran==1)
;         
;         movlw   linia_gorna+4
;         call    send
 ;        call     check_busy
;         movlw    _B
;         call     write_lcd
;ENDIF
         bsf      markers,czy_wyswietlam_temp
         bsf      markers,pomiary_zrobione
         bsf   markers,czy_wysylac_pomiary_serial
         
         goto     powrot_z_polecen    

wylacz_pomiary
      bcf   markers,czy_wysylac_pomiary_serial
         movlw    b'00000000'
         movwf    ADCON0
         bcf      markers2,pomiary
         bcf     markers2,wyslij_pomiar
         bcf     portlampka2,lampka2
         bcf      markers2,reguluj
         ;bcf      markers2,
         bcf      markers,czy_wyswietlam_temp
         goto     powrot_z_polecen                      
;polecenie ustawia regulator -> pokazuje wzgledem ktorego pomiaru ma regulowac wyjscie regulatora wybrane arbitralnie np PORTC0
;i do tego portu podlaczam wyjscie na przekaznik lub triac     
;
;*Rx.yyyy
wylacz_regulator
         bcf      markers2,reguluj
         bcf      portlampka2,lampka2
         goto     powrot_z_polecen              
ustaw_regulator
;jezeli nie wlaczylem wczesniej analoga to nie wlaczam regulatora

         btfss    markers2,pomiary
         goto     wylacz_regulator
         
         incf     FSR0L,f
         call     sprawdz_czy_odebrano_litere
         movf     tmp7,w
;         btfsc    STATUS,Z
;         goto     wylacz_regulator
         
        movwf    jaka_wartosc_regulujeH
         call     kopiuj_liczbe_przeslana
         movf     tmp,w 
         movwf    jaka_wartosc_regulujeL
         
         bsf      markers2,reguluj
         goto     powrot_z_polecen    

         
ustaw_wartosc_dzielenia_usredniania         
;sprawdzam    który bit jest ustawiony
;jeżeli jak_duzo_probek == 0x80 to ustawiony jest bit 7
      btfsc       jak_duzo_probek,7
      movlw       0x02
;bit 6 = 0x40   
      btfsc       jak_duzo_probek,6
      movlw       0x04
      
      btfsc       jak_duzo_probek,5
      movlw       0x08
;0x10      
      btfsc       jak_duzo_probek,4
      movlw       0x10
;0x20      
      btfsc       jak_duzo_probek,3
      movlw       0x20
;0x40      
      btfsc       jak_duzo_probek,2
      movlw       0x40
      
;2 próbki      
      btfsc       jak_duzo_probek,1
      movlw       0x80
      
      movwf       usrednianie_przez_co_mnoze
      
      return
      
ustaw_probki                              ;                 PROBKI
         clrf     pomiarH
         clrf     pomiarL
         clrf     pomiar_ulamek
         clrf     wynikh
         clrf     wynik
;zawsze wyłącz na początku usrednianie
         bcf      markers,czy_usrednianie
         
         call     kopiuj_liczbe_przeslana
         movf     tmp,w
         movwf    jak_duzo_probek
         
         ;movwf   ktora_probka
         
;sprawdz czy usredniamy czy nie tzn czy wartosc jak_duzo_probek < 2
         sublw    1
         btfsc    STATUS,C
         goto     powrot_z_polecen
         bsf      markers,czy_usrednianie
;ustaw wartość liczby przez którą mnoże każdy z pomiarów -> tzn przez ile dzielę
         
         call     ustaw_wartosc_dzielenia_usredniania
         
         goto     powrot_z_polecen

rozkaz_wysylania_znaku_na_lcd
         call     kopiuj_liczbe_przeslana
         movf     tmp,w
         call     send
         call     kopiuj_liczbe_przeslana
         movf     tmp,w
         call     write_lcd
         goto     powrot_z_polecen

                                                                  ;*                                  *************************POLecenie DS1820
PIN_HI
        
        BSF     TRISC, czujnik_ds1820           ; high impedance
        
        
        RETURN

PIN_LO
        BCF     port_ds1820,czujnik_ds1820
        
        BCF     TRISC, czujnik_ds1820           ; low impedance zero
        
        
        RETURN
send_1
         clrf     TMR2
         bcf      PIR1,TMR2IF
         call     PIN_LO
         nop
         call     PIN_HI
         ;bcf      port_ds1820,czujnik_ds1820
         ;nop
         ;nop
         ;nop
         ;nop
         ;nop
         ;nop
         ;bsf      port_ds1820,czujnik_ds1820
petla_send1
         btfss    PIR1,TMR2IF        
         goto     petla_send1
         
         return

send_0
         ;bsf      port_ds1820,czujnik_ds1820
         call     PIN_LO
         clrf     TMR2
         nop
         
         bcf      PIR1,TMR2IF
         
         bcf      port_ds1820,czujnik_ds1820
petla_send0
         btfss    PIR1,TMR2IF        
         goto     petla_send0
         call     PIN_HI
         
         return



inicjacja_ds1820
;wysyla 0 na linie danych do ds1820 przez 
;inicjalizacja 0 na wyjsciu okolo 480us tzn dla ustawienia 1:2 
;        dokladnie 256 z liczeniem TMR2 co 2, pozniej otwarcie portu na wejscie przejscie do 1 i po kilkunastu us otwarcie portu na wejscie
;        powinien byc obecny sygnal 0 do okolo 240 us.
;otwieram port na wyjscie
         bcf      RCSTA,CREN
         
         bcf      TRISC,czujnik_ds1820
         
;ustawiam tmr2 na zliczanie 2 
         movlw    0xff
         
         movwf    PR2
         
         
         movlw    b'00001100'
         movwf    T2CON
         bcf      PIR1,TMR2IF
;wlaczam przerwanie Tmr2
         ;bsf      STATUS,RP0
         ;bsf      PIE1,TMR2IE2
         ;bcf      STATUS,RP0         
         call     PIN_HI
         call     PIN_LO
;daje znacznik ze dotyczy to inicjacji ds1820
         ;bsf      znaczniki_ds,inicjacja
;petla czekania na koniec inicjacji
petla_inicjacji1
         
         btfss    PIR1,TMR2IF
         goto     petla_inicjacji1
;teraz przelaczam sie na odbior danych z ds1820
         
         bsf      TRISC,czujnik_ds1820
         
         nop
         bcf      PIR1,TMR2IF
;sprawdzam czy w ciagu 480us pojawilo sie 0 na porcie czujnika
petla_inicjacji2
         btfss    port_ds1820,czujnik_ds1820
         goto     petla_inicjacji3
         btfss    PIR1,TMR2IF
         goto     petla_inicjacji2
         
blad_inicjacji_ds
         call    sprawdz_czy_mozna_wysylac
         movlw    znak_lf
         movwf   TXREG
         call    sprawdz_czy_mozna_wysylac
         movlw    0x35
         
         movwf   TXREG
         call    sprawdz_czy_mozna_wysylac
         movlw    znak_lf
         movwf   TXREG
         goto     powrot_z_polecen   
petla_inicjacji3
         btfsc    port_ds1820,czujnik_ds1820
         goto     inicjacja_ok
         btfss    PIR1,TMR2IF
         goto     petla_inicjacji3
         
inicjacja_ok
         btfsc    markers,czy_wysylanie
         goto     wysylanie_danych_rozkaz
         
         call    sprawdz_czy_mozna_wysylac
         movlw    znak_lf
         movwf   TXREG
         call    sprawdz_czy_mozna_wysylac
         movlw    _O
         
         movwf   TXREG
         call    sprawdz_czy_mozna_wysylac
         movlw    _K
         movwf   TXREG
         call    sprawdz_czy_mozna_wysylac
         movlw    znak_lf
         movwf   TXREG
         call    sprawdz_czy_mozna_wysylac
         
         goto     powrot_z_polecen
         
         
             
;jezeli otrzyma 1 to na ekran wysyla informacje 'ds ok'         


wysylanie_danych
         bsf      markers,czy_wysylanie
         goto     inicjacja_ds1820
wysylanie_danych_rozkaz
         bcf      markers,czy_wysylanie
         
        
;ustawiam tmr2 na 60us bo tyle trwa jeden bit  
         movlw    0x3c
         
         movwf    PR2
         
         ;bcf      TRISC,czujnik_ds1820
        
         ;bcf      STATUS,RP0
;zliczanie 1:1         
         movlw    b'00000100'
         movwf    T2CON
         bcf      PIR1,TMR2IF
;wlaczam przerwanie Tmr2
         
wysylanie_bajtu_rozkazu
;zczytuje dana do wyslania
        call      kopiuj_liczbe_przeslana
        movf      tmp,w
        movwf     polecenie_wysylane
        clrf      TMR2
        movlw     8
        movwf     n
petla_sending        
;jezeli 0 to wyslij   0
        btfss     polecenie_wysylane,0
        call      send_0
        btfsc     polecenie_wysylane,0
        call      send_1
        bsf       port_ds1820,czujnik_ds1820
        bcf       STATUS,C
        rrcf       polecenie_wysylane,f
        ;bcf       STATUS,C
        ;movf      polecenie_wysylane,w
        ;btfss     STATUS,Z
        decfsz    n,f
        goto      petla_sending
        
;sprawdzam czy kolejny bajt jest 0x0d        
        incf     FSR0L,f
        movf      INDF0,w
        xorlw     0x0d
        btfsc     STATUS,Z
        goto     sprawdz_czy_ds1820_wysyla
        
        decf      FSR0L,f
        goto      wysylanie_bajtu_rozkazu
        
        
sprawdz_czy_ds1820_wysyla
         movlw    bajt_ds
         movwf    FSR0L
         movf     jak_duzo_bajtow_odbieram_z_ds,w
         movwf    liczba1
            
        ;goto     powrot_z_polecen
;procedura sprawdza czy ds1820 cos wysyla jezeli tak to sprawdza przez 60 us czy jest choc na chwile 0
;normalnie jezeli ds1820 nic nie wysyla to jest caly czas 1 bez rzadnych zmian
petla_odbioru_ds1820
        movlw     8
        movwf     n
        clrf      TMR2
        clrf      INDF0
        bcf       PIR1,TMR2IF
        
petla_czy_jest_0
         call     PIN_LO
         nop
         call     PIN_HI
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         movf     port_ds1820,w
         movwf    liczba2
         btfss    liczba2,czujnik_ds1820
         bcf      STATUS,C
         btfsc    liczba2,czujnik_ds1820
         bsf      STATUS,C
         rrcf      INDF0,f
         
czekam_na_kolejny_bit
        btfss    PIR1,TMR2IF
        goto      czekam_na_kolejny_bit
        bcf       PIR1,TMR2IF
        
        decfsz    n,f
        goto      petla_czy_jest_0
        incf      FSR0L,f
;czy juz przeszly wszystkie linie (4 bajty odebrano)  
        decfsz    liczba1,f
        goto      petla_odbioru_ds1820
        
;jezeli minelo 60us i nic sie nie dzialo to przerwij odbieranie 
        ;btfsc    PIR1,TMR2IF
        movf     jak_duzo_bajtow_odbieram_z_ds,w
        movwf     n
        movlw    bajt_ds
        movwf    FSR0L
petla_wysylania_odebranych_bajtow        
        call    sprawdz_czy_mozna_wysylac
         
         swapf    INDF0,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG
         
         call    sprawdz_czy_mozna_wysylac
         
         movf     INDF0,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG     
         incf     FSR0L,f
         decfsz   n,f
         goto     petla_wysylania_odebranych_bajtow
         
         call    sprawdz_czy_mozna_wysylac
         movlw    znak_lf
         movwf   TXREG   
        goto     powrot_z_polecen
        
ustawienie_liczby_odbieranych_bajtow
         
         incf     FSR0L,f
         call     sprawdz_czy_odebrano_litere
         movf     tmp7,w
         sublw    0x0b
         btfss    STATUS,C
         goto     ustawienie_liczby_odbieranych_bajtow_zero
         
         movf     tmp7,w
         movwf    jak_duzo_bajtow_odbieram_z_ds
         goto     powrot_z_polecen
         
ustawienie_liczby_odbieranych_bajtow_zero
         movlw    0x04
         movwf    jak_duzo_bajtow_odbieram_z_ds
         goto     powrot_z_polecen
         
;zarejestrowalem 0
        
;tzn czy przez czas 8  bitow cos         
rozkazy_ds1820
        incf     FSR0L,f
        movlw    _i
        xorwf    INDF0,w
        btfsc    STATUS,Z 
        goto      inicjacja_ds1820
        
        movlw    _s
        xorwf    INDF0,w
        btfsc    STATUS,Z 
        goto     wysylanie_danych
        
        movlw    _b
        xorwf    INDF0,w
        btfsc    STATUS,Z 
        goto     ustawienie_liczby_odbieranych_bajtow
        
        goto     powrot_z_polecen
        
;*********KOniec ds1820
wlaczenie_rejestracji_pradu
      call     kopiuj_liczbe_przeslana
      
      movf     tmp,w
      
;sprawdzenie czy nie podano liczby większej od 2 (mniejszą od 3)
      movlw       3
      cpfslt    tmp
;jezeli wyszlo C tzn ze przekroczono
      goto        powrot_z_polecen
      
      movf     tmp,w
      bz       wylaczenie_rejestarcji_pradu
      movwf       jak_duzo_kanalow_pradu
      
      bsf   markers3,pomiary_pradu
      clrf        ktory_aktualnie_kanal_pradu
      
      goto        powrot_z_polecen
      
wylaczenie_rejestarcji_pradu
      bcf   markers3,pomiary_pradu
      goto        powrot_z_polecen
      
rozkaz_rejestracji_poprawki_pomiaru_temperatury
      ;incf     FSR0L,f   
      call     kopiuj_liczbe_przeslana

        
      movf     tmp,w
;tmp6 przechowuje pod ktory adres zapisac poprawke      
      movwf    tmp6
      sublw    9
;jezeli wyszlo C tzn ze przekroczono a kanalow mamy tylko 8 + 2 pradowe
      btfss       STATUS,C
      goto        powrot_z_polecen
      
      
;sprawdz czy przeslana dana nie jest wieksza od 7 jezeli jest to przerwij
;odbierz kolejna liczbe
      ;incf     FSR0L,f
      call     kopiuj_liczbe_przeslana

      ;jest w tmp  poprawka
      movlw    poprawka0
      ;dec100 przechowuje ktorego czujnika to dotyczy
      addwf    tmp6,w
      movwf    FSR1L
      clrf     FSR1H
      ;zapisuje do rejestru poprawek
      movf     tmp,w
      movwf    INDF1
      ;movwf    poprawka
      movlw       tmp
      movwf    FSR1L
      
      movlw poprawka0_ee
      addwf tmp6,w
      call  zapis_eeprom
      goto        powrot_z_polecen



sprawdz_czy_polecenie                  
;sprawdz czy odebrano 'znak_cr'
         movlw    0x00
         movwf    FSR0L
         movlw    1
         movwf    FSR0H
         
         movlw    _star
         xorwf    INDF0,w
         btfss    STATUS,Z
IF (czy_ekran==1)         
         goto     wyslij_na_ekran_to_co_odebralem
ENDIF         
IF       (czy_ekran==0)
        goto     powrot_z_polecen
ENDIF         
   

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;         
sprawdz_ktore_polecenie
;polecenia:
;
;        *L-zapal lub zgas lampke lampke
;        *Px.y - pomiar kanal x wyrzucany na port szeregowy co y czasu (y to 1/2 sekundy)
;                 konfiguruje kanal 0 i referencyjne zasilajace
;        *P - puste przerywa pomiary
;        *Cx - czysci x linie ekranu i zeruje kursor
;        *Ryyy    - reguluj odczyt x(ktory kanal) na poziom y ustawienia w ilosc odczytanej cyfry
;        *+x.y - dodaje x + y i wynik na 4 linii ekranu
;        *>x      przeslij znak x
;        **xx   ustaw zegar szeregowego xxx->do SPBRG 
;        xx -> zapis szesnastkowy tzn **:: ustawia SPBRG na 0xaa
;        *#xxxx - pokaz zawartosc rejestru xxxx (podobnie jak powyzej) - podaje dwa bajty np 0fff
;        *S00 - ustawienie ilosci probek na jeden pomiar
;        
;        *Di  -  inicjuje ds1820
;        *Dr  -read rom (only one ds)
;        *Ds      -skip rom (whitout rom identification)

;        *exxyy  - na ekran w miejscu xx wyrzuc znak yy
;        *p0xyy  - poprawka kanalu x o yy
;           *i0x - pomiar pradu z kanalow 2     
;zacznij robic
;sprawdzam czy
         incf     FSR0L,f
         
         movlw    _L
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     zapal_lampke
         
         
         
         movlw    _plus
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     sumuj_liczby
;*> - znak wysylania
         movlw    0x3e
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     wyslij_znak
;**         
         movlw    _star
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     ustaw_spbrg
;*# - pokaz komorke pamieci         
         movlw    0x23
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     pokaz_rejestr
;*P -> pomiar     
         movlw    _P
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     inicjuj_pomiar


;*r ->Reguluj
         movlw    _R
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     ustaw_regulator
         
;*S ->probki
         movlw    _S
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     ustaw_probki
;*D rozkazy Ds1820
         movlw    _D
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     rozkazy_ds1820
;*e 
         movlw    _e
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     rozkaz_wysylania_znaku_na_lcd
         
         
;*p - poprawka  czujnika temperatury i o ile np: *p0009 czyli 0 o 9 (ujemne to uzupelnienia czyli *p00fe to poprawka o -1
         movlw    _p
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     rozkaz_rejestracji_poprawki_pomiaru_temperatury
         
;*i - pomiar pradu np *i0x
         
         movlw    _i
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     wlaczenie_rejestracji_pradu
         
;ustaw szybkosc portu szeregowego
;ustawienie jest zapisane do EEPROM i w momencie startu urzadzenia stamtad czytane
;mozliwe ustawienia:
;0x1a - 11200 baudow
;0x0c - 19200 baudow
;
         
                           
powrot_z_polecen
;        movlw    _up
         incf     FSR0L,f
         bcf      markers2,sprawdz_odebrane
         clrf     odebrano_liter
         bsf      RCSTA,CREN
;        clrf     FSR0L
;        movwf    INDF
         return
         
         
wyslij_na_ekran_to_co_odebralem
      call     check_busy
         movlw    linia_dolna
         call     send
         call     check_busy
         movlw    dane_odebraneL
         movwf    FSR0L      
         movlw    dane_odebraneH
         movwf    FSR0H      
         
wyswietl_litere_petla
         
         movlw    0x0d
         xorwf    INDF0,w
         btfsc    STATUS,Z
         goto     koniec_wyswietlania
         
;sprawdz czy odebrano pusty znak...
;        movlw    0x0a
;        xorwf    INDF,w
;        btfsc    STATUS,Z
;        goto     koniec_wyswietlania        
         
         movf     INDF0,w
         btfsc    STATUS,Z
         goto     koniec_wyswietlania


         movf     odebrano_liter,w
         btfss    STATUS,Z
         goto     wyswietl_litere_petla2
         
         
;        goto     koniec_wyswietlania

wyswietl_litere_petla2
         ;movlw    linia_dolna
         ;addwf    linia2,w
         ;call     send
         ;call     check_busy
         
         movf     INDF0,w
         call     write_lcd
         call     check_busy
;        clrf     odebrana_litera
         incf     linia2,f
         
;        movlw    0A
;        xorwf    linia2
         btfss    linia2,4
         goto     wyswietl_litere_petla3
         
         clrf     linia2
         movlw    0x0f
         movwf    n
         movlw    linia_dolna
         call     clear_line
         
wyswietl_litere_petla3
         incf     FSR0L,f
;        decfsz   odebrano_liter,f
         goto     wyswietl_litere_petla
         
koniec_wyswietlania        
         ;clrf     odebrano_liter
         ;bcf      markers2,wyswietl
         bsf      RCSTA,CREN
         goto     powrot_z_polecen

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                                     ;POMIARY!!!!!!!!!!!!!!!!!!!!!!!         

            
wyswietl_cyfry_temperatury
      ;sprawdz czy rzadna z cyfr nie przekracza 10
      movlw       0x0a
      subwf       dec1,w
      bnc         sprawdz_10
      movwf       dec1
      incf        dec10,f
      
sprawdz_10
     movlw       0x0a
      subwf       dec10,w
      bnc         wyswietl_cyfry_temperatury2
      movwf       dec10
      incf        dec100,f
  
wyswietl_cyfry_temperatury2  
      call     check_busy
      movlw       _puste
      
      btfsc       markers3,napisz_minus
      movlw       _minus
      call        write_lcd
      
      
         
      call     check_busy
      movf     dec100,w
      bnz       pisz_cyfre_100
      
      movlw    _puste
      call     write_lcd
      call     check_busy
      movf     dec10,w
      bnz      pisz_cyfre_10
      
      movlw    _puste
      call     write_lcd
      call     check_busy
      goto     pisz_cyfre_1
      
pisz_cyfre_100
      movf        dec100,w
      addlw       0x30
      call     write_lcd
      call     check_busy

pisz_cyfre_10
      movf        dec10,w
      addlw       0x30
      call     write_lcd
      call     check_busy
      
pisz_cyfre_1
      movf        dec1,w
      addlw       0x30
      call     write_lcd
      call     check_busy
      
      movlw    _kropka
      call     write_lcd
      
      
;sprawdz ktory ulamek
      movf     wynik01,w
      bz       pisz_ulamek_00
      
      xorlw    0x40
      bz       pisz_ulamek_25
      
      movf     wynik01,w
      xorlw    0x80
      bz       pisz_ulamek_50
      
      movf     wynik01,w
      xorlw    0xc0
      bz       pisz_ulamek_75
      
      
pisz_ulamek_00
      call     check_busy
      movlw    0x30
      call     write_lcd
      call     check_busy
      movlw    _puste
      call     write_lcd
      
      
      return

pisz_ulamek_25
      call     check_busy
      movlw    0x32
      call     write_lcd
      
      call     check_busy
      movlw    0x35
      call     write_lcd
      return
      
pisz_ulamek_50
      call     check_busy
      movlw    0x35
      call     write_lcd
      call     check_busy
      movlw    0x30
      call     write_lcd
      return
      
pisz_ulamek_75
      call     check_busy
      movlw    0x37
      call     write_lcd
      call     check_busy
      movlw    0x35
      call     write_lcd
      return
      
      
odejmij_512_od_wyniku_sredniej

         movlw    0x02
         subwf    pomiarH,f
         ;jezeli jest 0 to nic wiecej nie trzeba robic
         
         btfsc    STATUS,Z
         goto     wynik_to_po_prostu_L
         
       ;jezeli w wyniku nie ma bitu 7 to oznacza brak liczby ujemnej
       btfss      pomiarH,7
       goto       wynik_to_po_prostu_L
       
       
       
      ;w wyniku mamy np ff90 - brak 0
      ;tego nie trzeba bo polecenie negf - działa z -1 przed zastosowaniem
      ;decf  pomiarL,f
      
      ;przy odejmowaniu C jest normalnie ustawione
      ;btfss STATUS,C
      
      ;ale to trzeba bo tak samo zadziała dla starszego bajtu, a on nie ma być -1
      incf  pomiarH,f
      
      ;zaznacz ze pisz minus
      bsf   markers3,napisz_minus
      ;negf  pomiarL,f
      ;negf  pomiarH,f

wynik_to_po_prostu_L
      return


usrednianie_wartosci
;oblicz srednia dzielac za pomoca ilosc probek pobieranych
         
        movf    jak_duzo_probek,w
        
        ;movwf   ktore_dzielenie_przez2
        
        
        

        clrf      wynik01
        
petla_dzielenia
                                                                    ; bcf     STATUS,C
                                                                    ; call     dzielenie_przez_przesuwanie
                                                                  ;mam na poczatku w ktore dzieleni_przez2 b'10000000'
                                                                  ;po jednym dzieleniu mam b'01000000'
                                                                    ; bcf       STATUS,C
                                                                    ; rrcf     ktore_dzielenie_przez2,f
                                                                    ; btfss   ktore_dzielenie_przez2,0
                                                                    ; goto     petla_dzielenia
                                                                     


      movf    usrednianie_przez_co_mnoze,w
      mulwf     wynik
      
      ;w PRODH jest wartość do wynik, a w ProdL do wynik01
      movf        PRODH,w
      movwf       wynik
      movf        PRODL,w
      movwf       wynik01
      
      movf        wynikh,w
      bz          procedura_sumowania_wyniku
      
      movf      usrednianie_przez_co_mnoze,w
      mulwf     wynikh
      
      movf        PRODH,w
      movwf       wynikh
      movf        PRODL,w
      addwf       wynik,f
      ;jeżeli przekroczyłem bajt to zwiększ o 1
      
      btfsc       STATUS,C
      incf        wynikh,f
         
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
        
         movf     wynikh,w
         addwf    pomiarH,f
         return
         
znow_kaz_mierzyc

;         bsf      STATUS,RP0
 ;        bcf      STATUS,RP1
;        movlw    0x1a
  ;       bsf      PIE1,ADIE
   ;      bcf      STATUS,RP0
    ;     bsf      ADCON0,2 
         ;clrf     TMR0L
         ;bcf      INTCON,T0IF
         ;bsf      INTCON,T0IE
IF (procek== 18f442)         
         
ENDIF
IF (procek== 18f4320)         
         
ENDIF
         bsf      ADCON0,GO
         bcf      markers2,wyslij_pomiar
         
         return
          
;na koniec dodaj do pomiarH i pomiarL i pomiar_ulamek

wysylanie_pomiaru
;najpierw sprawdzam czy wysylam od razu czy nie
         bcf      markers2,wyslij_pomiar
         btfss    markers,czy_usrednianie
         goto     zapisz_do_pamieci
         ;goto     juz_wysylac

         call     usrednianie_wartosci

         decfsz   ktora_probka,f
         goto     znow_kaz_mierzyc
         ;return        
zapisz_do_pamieci
;przed zapisem pomiaru w pamieci ulamki > 0x80 (tzn od 0.5 ) zamieniam na +1 do pomiarL 
;w przeciwnym wypadku pomijam
         ;movlw    0x81
         ;subwf    pomiar_ulamek,w
         ;btfss    STATUS,C
         ;goto     zapisz_starszy
         ;bcf      STATUS,C
         ;movlw    1
         ;addwf    pomiarL,f
         ;btfsc    STATUS,C
         ;incf     pomiarH,f
;                                                              
         
         
         
         
         btfsc    markers3,znacznik_pomiaru_pradu
         goto     zapis_do_pamieci_prad
         
zapis_do_pamieci_temperatury  

                        ;                                         POPRAWKA temperatury
         clrf     FSR1H
         movlw    poprawka0
         
         
         ;ktora poprawka
         movwf    FSR1L
         movf     ktory_kanal,w
         addwf    FSR1L,f
         movf     INDF1,w
         

         addwf    pomiarL,f
         
         ;sprawdz czy poprawka jest ujemna
      ;tzn czy jest zaznaczony bit 7
      ;jezeli tak to nie sprawdzaj przekroczenia
        btfsc     INDF1,7
        goto      zapisz_do_pamieci_nie_sprawdzaj_przekroczenia
         ;jezeli przekroczylem to
         
         btfsc    STATUS,C
         incf     pomiarH,f
         
zapisz_do_pamieci_nie_sprawdzaj_przekroczenia
                        ;koniec poprawiania wyniku o blad kanalu pomiarowego i skalowanie czujnika
                        
;dopiero teraz zamieniam na wartość -512                        
              
          ;                                         teraz odejmuje od starszego bajtu 0x02 
         call     odejmij_512_od_wyniku_sredniej
        
        
         movlw    pomiar0H
         movwf    FSR1L
                  
         movf     ktory_kanal,w
         addwf    FSR1L,f
         addwf    FSR1L,f
                  
         movf     pomiarH,w         
         movwf    INDF1
                              ;IF (czy_pomiary_na_ekran==1)  
                              ;sprawdz czy mam wyswietlac 
                              ;jezeli wszedlem do menu ekranu to nie wyswietlam temperatur
                                    
                                    ; btfss      markers,czy_wyswietlam_temp
                                    ; goto        bez_wyswietlania_temp1

                                    
                              ;         movf     INDF1,w
                                       ;tu wlaczam procedurę zamiany szesnastkowej wartości na dziesiętną liczbę
                                       
                                       
                               ;        addlw    0x30
                                ;       call     write_lcd
                                 ;      incf     linia2,f
                              ;ENDIF         

bez_wyswietlania_temp1
         incf     FSR1L,f
         movf     pomiarL,w
                  
         movwf    INDF1
IF (czy_pomiary_na_ekran==1)   

      btfss      markers,czy_wyswietlam_temp
      goto        bez_wyswietlania_temp2
      
            
      ;sprawdz czy rejestr linia2 > 13
      movlw       0x0c
      ; sprawdzam                  rejestr > W
      cpfslt      linia2      
      clrf        linia2
      
      
nie_czysc_rejestru_polozenia  
  ;temperatury 0-3 na ekranie sa wyswietlane jezeli niezaznaczono bitu markers3,pokazuje_temperatury_47
      ;aby to sprawdzic dokonuje operacji odjecia od 3 - ktory_kanal
      
      movlw       0x04
      ; sprawdzam                  rejestr > W
      cpfslt        ktory_kanal
      goto          sprawdz_czy_mam_wyswietlac_47       
 
      ;jezeli wynik wskazuje na pomiary na kanale 0 - 3 to sprawdz czy nie wlaczony jest bit 
      
      btfsc       markers3,pokazuje_temperatury_47
      goto        bez_wyswietlania_temp2
      
      movlw 1
      ;bit      0-1 ida na linie 2  -> 00000011
      ; ktory_kanal   > 1 to na linii3
      cpfsgt  ktory_kanal
      goto         ustaw_linie_druga
      ;jezeli kanal 2-3
      goto        ustaw_linie_trzecia
            
      
sprawdz_czy_mam_wyswietlac_47
 ;jezeli wyswietlam kanal 4 -7
 ; i zaznaczono ten bit tzn ze mam wyswietlac na ekranie pomiary czujnikow 4-7
 
      btfss       markers3,pokazuje_temperatury_47
      goto        bez_wyswietlania_temp2
      
      movlw 5
      ;bit      0-1 ida na linie 2  -> 00000011
      ; ktory_kanal   > 5 to na linii3
      cpfsgt  ktory_kanal
      goto         ustaw_linie_druga
      ;jezeli kanal ma wartosc 6-7
      goto        ustaw_linie_trzecia
      
      
ustaw_linie_trzecia
      call     check_busy
         movlw    linia_trzecia
         addwf    linia2,w
         call      send      
         goto     napisz_wartosc_temperatury
      
ustaw_linie_druga      
      call     check_busy
         movlw    linia_dolna
         addwf    linia2,w
         call      send
         goto     napisz_wartosc_temperatury
         
 
         ;call     check_busy      
         ;call     check_busy
         ;swapf    INDF1,w
         ;andlw    0x0f
         ;call     zamien_na_hex
                         
         ;call     write_lcd
         
         ;call     check_busy
         ;movf     INDF1,w
         ;andlw    0x0f
         ;call     zamien_na_hex
         ;call     write_lcd
         ;call     check_busy
         ;movlw    _puste
         ;call     write_lcd
         
         
         
napisz_wartosc_temperatury         
      movf        INDF1,w
      movwf       tmp_hex
      
      decf        FSR1L,f ; - FSR1L pokazuje teraz wartosc starszego bajtu liczby zamienianej
      movf        INDF1,w
      
      movwf       tmp_hex_H
      
      btfsc       markers3,napisz_minus
      negf        tmp_hex
      
      btfsc       markers3,napisz_minus
      negf        tmp_hex_H
      
      movf        tmp_hex,w
      ;dziele przez 4
      mullw       0x40
      
      movf        PRODL,w
      movwf       wynik01
      
      ;temperatura jest w bajcie starszym
      movf        PRODH,w
      movwf       tmp_hex
      
         call     hex2dec18
         
         call     wyswietl_cyfry_temperatury
         
         ;call     check_busy
         ;movlw    _linia_pionowa
         
         ;call     write_lcd
         bcf      markers3,napisz_minus
         movlw    8
         
         addwf     linia2,f
         ;bcf      markers3,pokazuje_temperatury_47
ENDIF         

bez_wyswietlania_temp2

      goto  procedura_regulacji_dwustawnej
      
zapis_do_pamieci_prad
      clrf     FSR1H
      movlw    poprawka_prad1
         
         ;ktora poprawka
         movwf    FSR1L
         decf     ktory_aktualnie_kanal_pradu,w
         addwf    FSR1L,f
         movf     INDF1,w
         addwf    pomiarL,f
         ;jezeli przekroczylem to
         btfsc    STATUS,C
         incf     pomiarH,f
        ;movwf     

                  
         movlw    pomiar_prad1H        
         movwf    FSR1L
                  
         decf     ktory_aktualnie_kanal_pradu,w
         addwf    FSR1L,f
         addwf    FSR1L,f
                  
         movf     pomiarH,w         
         movwf    INDF1 
IF (czy_pomiary_na_ekran==1)  
;sprawdz czy mam wyswietlac 
;jezeli wszedlem do menu ekranu to nie wyswietlam temperatur
      
      btfss      markers,czy_wyswietlam_temp
      goto        bez_wyswietlania_pradu

      call     check_busy
         movlw    linia_czwarta
         addwf    linia4,w
         call      send
         
         
 
         call     check_busy
         movf     INDF1,w
         ;tu wlaczam procedurę zamiany szesnastkowej wartości na dziesiętną liczbę
         
         
         addlw    0x30
         call     write_lcd
         incf     linia4,f
ENDIF         

bez_wyswietlania_pradu

         
      incf     FSR1L,f
      movf     pomiarL,w
                  
      movwf    INDF1    
      
IF (czy_pomiary_na_ekran==1)

      btfss      markers,czy_wyswietlam_temp
      goto        bez_wyswietlania_pradu2
       
         call     check_busy
         swapf    INDF1,w
         andlw    0x0f
         call     zamien_na_hex
                         
         call     write_lcd
         
         call     check_busy
         movf     INDF1,w
         andlw    0x0f
         call     zamien_na_hex
         call     write_lcd
         call     check_busy
         movlw    _puste
         call     write_lcd
         incf     linia4,f
         incf     linia4,f
         incf     linia4,f
ENDIF       

bez_wyswietlania_pradu2
      
      goto     sprawdz_czy_mam_dalej_mierzyc_prad
      
procedura_regulacji_dwustawnej         
      
;jezeli ostatni kanal to wyslij wszystkie, jezeli nie ostatni to zmierz kolejny
         btfss    markers2,reguluj
         goto     sprawdz_czy_mam_dalej_mierzyc
;jezeli mierze prad to nic nie sprawdzaj

     
;porownaj wartosc pomierzona z zadana
                  

;regulacja z 0 kanalu
         
         ;movf        ktory_kanal,w
         ;xorlw         0         
         ;btfsc          STATUS,Z
         movlw    0
         cpfseq   ktory_kanal
         goto           sprawdz_czy_mam_dalej_mierzyc
         
         
         
         
         movf     jaka_wartosc_regulujeH,w
         ;pomiarh - jaka_wartosc_regulujeH
         subwf    pomiarH,w
;sprawdz czy to samo czy wieksze
         btfsc    STATUS,Z
         goto     sa_rowne_sprawdz_Lbajt
         btfss    STATUS,C 
         goto     zalacz_grzanie
;tzn reguluj<pomiaru w starszym bajcie wiec wylacz grzanie
         bsf      markers2,wylacz_moc
         goto     sprawdz_czy_mam_dalej_mierzyc
         
zalacz_grzanie    
;jezeli jakikolwiek pomiar wykazal ze trzeba wylaczyc to nie wlaczaj grzania
;        
         btfss    markers2,wylacz_moc
         bsf      markers2,zalacz_moc
         
         goto     sprawdz_czy_mam_dalej_mierzyc

                           
sa_rowne_sprawdz_Lbajt
;tak samo
         movf     jaka_wartosc_regulujeL,w
         ;sprawdz czy moc wylaczona - jezeli tak to wlacz 1  stopien nizej czyli 4 nizej
;jezeli jest wlaczona energia to dodaj wartosc histerezy tj wylacza pozniej
         ;btfsc    latch_moc,lampka2
         btfsc    port_triak,triak1
         addwf    histereza,w

         subwf    pomiarL,w
;sprawdz czy to samo czy wieksze
         btfsc    STATUS,Z
         goto     sa_rowne_nic_nie_rob
         btfss    STATUS,C 
         goto     zalacz_grzanie
;tzn reguluj<pomiaru w mlodszym bajcie wiec wylacz grzanie
         bsf      markers2,wylacz_moc
         goto     sprawdz_czy_mam_dalej_mierzyc                         
sa_rowne_nic_nie_rob
         goto     zalacz_grzanie    
         goto     sprawdz_czy_mam_dalej_mierzyc       

sprawdz_czy_mam_dalej_mierzyc
;sprawdzam tu czy mam wykonac pomiary dla kolejnego 
;kanalu
;tu czyszcze zawartosc rejestrow pomiaru
         clrf     pomiarH
         clrf     pomiarL
         clrf     pomiar_ulamek
         
         
         decfsz   ktory_kanal_mierze,f
         goto     zmierz_nastepny_czujnik_temperatury

;zmierz jeszcze prady          
         
         btfss    markers3,pomiary_pradu
         goto     wykonano_pomiary_wszystkich_kanalow
        
        ;jeszcze mierze prady jezeli ustawiono bit pomiary_pradu
         
sprawdz_czy_mam_dalej_mierzyc_prad       

         ;sprawdz czy rejestr przechowujący aktualne wskazanie mierzonej temperatury nie wskazuje 0
         movf     ktory_aktualnie_kanal_pradu,w;zwiększam o jeden żeby skala obydwu rejestrów była identyczna
         
         xorwf    jak_duzo_kanalow_pradu,w
         ;jezeli 0 tzn ze juz zmierzylem co trzeba
         btfsc    STATUS,Z
         goto     wykonano_pomiary_wszystkich_kanalow
         
      ;wlaczam pomiar pradu na 1 kanale
      
      ;do kanalu aktualnego trzeba dodać 8*2 by uzyskac kanal pradowy
      ;bo aby zmierzyc 1 kanal pradu to z AN0 przeskok do AN2
      ;z kanalu AN2 do AN4
      
      movlw    8
            
      addwf   ADCON0,f
      incf     ktory_aktualnie_kanal_pradu,f
      ;movlw    b'00111100'
      ;andwf    ADCON0,w
      goto  zmierz_prad
      
      ;goto     zmierz_nastepny_czujnik_temperatury   
         
wykonano_pomiary_wszystkich_kanalow
;jezeli juz skonczylem wszystkie mierzyc to sprawdz czy mam wlaczyc grzanie
;jezeli ustawiono bit o nie wlaczaniu to olej
         btfss    markers2,reguluj
         goto     juz_wysylac
         
         btfsc    markers2,wylacz_moc
         goto    wylaczam_moc
         
         btfss    markers2,zalacz_moc
         goto    wylaczam_moc
         
         btfss    port_triak,triak1
         bsf      port_triak,triak1
         
         goto    koncz_z_moca
wylaczam_moc
         bcf      port_triak,triak1
         
koncz_z_moca
         bcf      markers2,zalacz_moc
         bcf      markers2,wylacz_moc
         
         
         
         
                                                ;juz wszystkie kanaly i wysylaj pomiary
juz_wysylac
;wysylam po kolei bajty zmierzone
;tu petla tyle razy powtarzana ile kanalow mierze

      btfss       markers,czy_wysylac_pomiary_serial
      goto        jezeli_nie_wysylam_pomiarow
      
         bcf      port_CTS,znacznik_CTS

         clrf     ktory_kanal
         movf     ile_kanalow,w
         
         movwf    ktory_kanal_mierze
         
         movlw    pomiar0H
         movwf    FSR1L
         clrf     FSR1H
         bcf      RCSTA,CREN
         goto     wyslij_starszy
zwieksz_przy_wysylaniu_FSR
         incf     FSR1L,f
wyslij_starszy
;przed wysylaniem pomiaru wylaczam modul odbioru
         ;sprawdz czy RTS nie jest na 0
sprawdz_RTS
         ;btfss    port_RTS,znacznik_RTS
         ;goto     sprawdz_RTS
         
         call    sprawdz_czy_mozna_wysylac
         
         movf     INDF1,w
         addlw    0x30
         movwf   TXREG
           
         call    sprawdz_czy_mozna_wysylac
         
         incf     FSR1L,f
         swapf    INDF1,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG
         
         
         call    sprawdz_czy_mozna_wysylac
         
         movf     INDF1,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG     
         

         call    sprawdz_czy_mozna_wysylac
         
         movlw    _przecinek
        
         movwf   TXREG     
         
         
         
         
;sprawdz czy aktualnie mam regulowac
         
          
         
;wylacz wysylanie pomiaru           
         
         ;call    sprawdz_czy_mozna_wysylac
;wlacz odbior
         decfsz   ktory_kanal_mierze,f
         goto     zwieksz_przy_wysylaniu_FSR
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;koniec wysylania pomiarow 
         ;jezeli mierzylem prady to sprawdz to, maxymalnie dwa prady podaje
         btfss    markers3,pomiary_pradu
         goto     juz_wysylac_znak_LF
         
sprawdz_RTS_prad
         ;btfss    port_RTS,znacznik_RTS
         ;goto     sprawdz_RTS_prad
      
      ;jak duzo mialem mierzyc pradow
         call    sprawdz_czy_mozna_wysylac
         movlw    _i
        
         movwf   TXREG    
         call    sprawdz_czy_mozna_wysylac
         
         
         
         movf     pomiar_prad1H,w
         addlw    0x30
         movwf   TXREG        
         
         call    sprawdz_czy_mozna_wysylac
         
         swapf     pomiar_prad1L,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG
                  
         call    sprawdz_czy_mozna_wysylac
         
         movf    pomiar_prad1L,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG   
         
         call    sprawdz_czy_mozna_wysylac
         
         ;czy mialem mierzyc dwa prady czy tylko 1
         ;movf     jak_duzo_kanalow_pradu,w
         ;xorlw    2
         ;btfss    STATUS,Z   
         ;goto     juz_wysylac_znak_LF 

         
         
         movlw    _przecinek
        
         movwf   TXREG    
         call    sprawdz_czy_mozna_wysylac
         
         movlw    _i
        
         movwf   TXREG    
         call    sprawdz_czy_mozna_wysylac
         
         movf     pomiar_prad2H,w
         addlw    0x30
         movwf   TXREG        
         
         call    sprawdz_czy_mozna_wysylac
         
         swapf     pomiar_prad2L,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG
                  
         call    sprawdz_czy_mozna_wysylac
         
         movf    pomiar_prad2L,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG     
         call    sprawdz_czy_mozna_wysylac
         
          movlw    _przecinek
        
         movwf   TXREG    
         call    sprawdz_czy_mozna_wysylac
         
;jezeli moc zalaczona wyslij 1,
;jezeli wylaczona wyslik 0,
         
         ;call    sprawdz_czy_mozna_wysylac
         
         ;btfsc    portlampka2,lampka2
         ;movlw    0x31
         
         ;btfss    portlampka2,lampka2
         ;movlw    0x30
         
juz_wysylac_znak_LF         
         ;movwf   TXREG
         ;wysylam znak konca linii
         call    sprawdz_czy_mozna_wysylac
         movlw    znak_lf
         movwf   TXREG
         
         bsf      RCSTA,CREN 
         nop
         nop
         
         bsf      port_CTS,znacznik_CTS
         
         
jezeli_nie_wysylam_pomiarow

         clrf     pomiarH
         clrf     pomiarL
         clrf     pomiar_ulamek

         bsf      markers,pomiary_zrobione
         bcf      markers2,wyslij_pomiar
         bcf   markers3,znacznik_pomiaru_pradu
         clrf     linia4
         return         
 

zmierz_prad
      movf     jak_duzo_probek,w
      movwf    ktora_probka
      bsf   markers3,znacznik_pomiaru_pradu
      goto     zmierz_nastepny_nie_3
      
zmierz_nastepny_czujnik_temperatury
;tzn kanal analogowy ten sam, ale zmienia sie ustawienie multipleksera
      incf     ktory_kanal,f
      movf     jak_duzo_probek,w
      movwf    ktora_probka
      ;movf     port_multiplekser,w
;czyszcze aktualne ustawienia 
;jezeli byl tu b'01010001'     
      ;andlw    b'11111000'
;w wyniku mamy b'01010000'      
      ;addwf    ktory_kanal,w
      incf  latch_multiplekser,f
      ;movwf    latch_multiplekser   
      goto     zmierz_nastepny_nie_3
      
zmierz_nastepny_kanal
;zwiekaszam na kolejne wejscie  multipleksera
            
         incf     ktory_kanal,f
         movf     jak_duzo_probek,w
         movwf    ktora_probka
         movf     ADCON0,w
;musze zwiekszyc o jeden ten wycinek bitowy
;b'xx000xxx' - czyli nawet nie starszy 4 bit
;tylko cos w srodku
;aby to zrobic stosuje prosty wybieg + 8 do ADCON0

;dla 18f4x20 mamy troszke zmian
;ADCON0  wyglada ;b'xx0000xx'
IF (procek == 18f442)
         addlw    8
         movwf    ADCON0
         movlw    b'00111000'
         andwf    ADCON0,w
         xorlw    b'00011000'
         bnz      zmierz_nastepny_nie_3
;drugi raz zwiekszam ADCON0 dla pominiecia 3 kanalu         
         movlw    8
         addwf    ADCON0,f
ENDIF

IF (procek == 18f4320)
         addlw    4
         movwf    ADCON0
         movlw    b'00111100'
         andwf    ADCON0,w
         xorlw    b'00001100'
         bnz      zmierz_nastepny_nie_3
;drugi raz zwiekszam ADCON0 dla pominiecia 3 kanalu         
         movlw    4
         addwf    ADCON0,f
ENDIF
         
zmierz_nastepny_nie_3
;wlaczam pomiar i przerwanie
         
         bsf      PIE1,ADIE
         
;rozpocznij pomiar      
;wedlug opisu procka tu trzeba czekac okolo 20-30us  
;dla pewnosci bede czekal 120us wykozystujac TMR2
;czyszcze obecny TMR2
         clrf     pomiarH
         clrf     pomiarL
         clrf     pomiar_ulamek
         clrf     TMR0L
IF (procek == 18f442)
         bcf      INTCON,T0IF
         bsf      INTCON,T0IE
ENDIF
IF (procek == 18f4320)
         bcf      INTCON,TMR0IF
         bsf      INTCON,TMR0IE
ENDIF
         
         ;clrf     TMR2
         ;bsf    T2CON,TMR2ON
        
;tzn wlaczam przerwanie TMR2
         ;bsf      STATUS,RP0
         ;bsf     PIE1,TMR2IE
         ;bcf      STATUS,RP0
;przetestowanie czy dobry czas  
;          bsf     PORTC,2         
         bcf      markers2,wyslij_pomiar
         return   
    
    
    
    
    
    
    
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;procedury klawiszy
wlacz_przerwanie_tmr3

      bcf   PIE2,TMR3IE
      clrf  TMR3H
      clrf  TMR3L
      bcf   PIR2,TMR3IF
      
      bsf   PIE2,TMR3IE

      return
      
wcisnieto_back
      btfsc   markers3,wcisnieto_klawisz
      return
      
      bsf   markers3,wcisnieto_klawisz
      clrf  stan_key
      bsf   stan_key,mamy_back
      
      goto  wlacz_przerwanie_tmr3
      
      

      
      
wcisnieto_down
;jeżeli zaznaczono że upłynął czas oczekiwania to wybierz procedurę zmiany      
      btfsc   znaczniki,czy_moge_juz_zmieniac
      goto  wykryto_down
      
      ;goto    wykryto_down_zmiana_opcji
      
      btfsc   markers3,wcisnieto_klawisz
      return
      
      bsf   markers3,wcisnieto_klawisz
      clrf  stan_key
      bsf   stan_key,mamy_down
      
      ;btfsc       pozycja_menu,zmiana_opcji
      ;goto        sprawdz_czy_wlaczyc_szybka_zmiane
      
      goto        ustaw_sprawdzanie_szybkiej_zmiany
      
      goto  wlacz_przerwanie_tmr3

      
wcisnieto_up
      btfsc   znaczniki,czy_moge_juz_zmieniac
      goto        wykryto_up
      ;goto    wykryto_up_zmiana_opcji
      
      btfsc   markers3,wcisnieto_klawisz
      return
      
      bsf   markers3,wcisnieto_klawisz
      clrf  stan_key
      bsf   stan_key,mamy_up
      
;jeżeli klawisz up wcisnieto w momencie gdy uzytkownik wybral juz zmiane wartosci
      ;btfsc       pozycja_menu,zmiana_opcji
      ;goto        sprawdz_czy_wlaczyc_szybka_zmiane
      
      goto        ustaw_sprawdzanie_szybkiej_zmiany
      
      goto        wlacz_przerwanie_tmr3
      
sprawdz_czy_wlaczyc_szybka_zmiane
;jest w menu na pozycji     
;opcja_odstep
;opcja_ustaw_temp

      movlw       opcja_odstep
      cpfseq      numer_opcji
      goto        sprawdz_czy_wlaczyc_szybka_zmiane2

      goto        ustaw_sprawdzanie_szybkiej_zmiany
      
sprawdz_czy_wlaczyc_szybka_zmiane2      
      movlw       opcja_ustaw_temp
      cpfseq      numer_opcji
      goto        sprawdz_czy_wlaczyc_szybka_zmiane3

      goto        ustaw_sprawdzanie_szybkiej_zmiany
      
sprawdz_czy_wlaczyc_szybka_zmiane3
      
      goto  wlacz_przerwanie_tmr3
 
ustaw_sprawdzanie_szybkiej_zmiany
;jak długo trzymam przycisk zanim zaczne zmieniac wartości
      movlw       dlugosc_oczekiwania_na_zmiane
      movwf       szybka_zmiana_wartosci
;zaznaczam że procedury sprawdzają zmianę opcji w czasie trzymania przycisku      
      bsf         markers,trzymanie_klawisza
      goto  wlacz_przerwanie_tmr3
 
wcisnieto_enter
      btfsc   markers3,wcisnieto_klawisz
      return
      
      bsf   markers3,wcisnieto_klawisz
      clrf  stan_key
      bsf   stan_key,mamy_enter
      
      goto  wlacz_przerwanie_tmr3

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                BACK
wykryto_back
      ;co sie dzieje jezeli wykryje ze wcisnieto i puszczono klawisz cofnij
      
      ;jezeli jestem w menu to wyswietl ponownie czas i temperatury
      ;movf        pozycja_menu,w
      ;bz         wykryto_back_nic_nie_rob
      
;jezeli pozycja menu jest różna od 0 to po nacisnieciu klawisza back
;następuje powrót do ekranu z pomiarami temperatury oraz z zegarem systemowym
;oraz z prądami
      ;czyszczę wszystkie linie ekranu - polecenie clear display
      call        check_busy
      movlw       display_clear
      call        send
      call        check_busy
      
      ;następnie włączam wyświetlanie czasu i temperatur
;jeżeli znaczniki są ustawione to przy wyjściu
      
      btfsc       znaczniki,czy_ponownie_wlaczyc_temp
      bsf         markers,czy_wyswietlam_temp
      
      btfsc       znaczniki,czy_ponownie_wlaczyc_zegar
      bsf         markers3,czy_zegar_wyswietlac
      
      clrf       pozycja_menu
      clrf        numer_opcji
      
      goto  wykryto_back_exit
      

     
      ;jezeli w ekranie zegara to nic nie rob
      
      ;dla testow wyswietl na dole ekranu litere b
      
      
; wykryto_back_pisz
      ; call     write_lcd
wykryto_back_nic_nie_rob
wykryto_back_exit
      bcf   markers3,dzialanie_po_klawiszu
      clrf  stan_key
      goto  LOOP11
      
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                DOWN
wykryto_down
      
      ;co sie dzieje jezeli wykryje ze wcisnieto i puszczono klawisz cofnij
      
      btfsc       pozycja_menu,zmiana_opcji
      goto        wykryto_down_zmiana_opcji
      
      ;jezeli jestem w menu to przeskocz na kolejną opcję gwiazdką
      
      
      ;jezeli w ekranie zegara to pokaż kolejny zestaw czujników
      movf        pozycja_menu,w
      bnz         wykryto_down_sprawdz_czy_wyswietlam_kolejne_opcje
;jezeli pozycja menu ==0 to po nacisnieciu klawisza zmien wskazania temperatury
      ;najpierw czyść ekran
      call        check_busy
      movlw       display_clear
      call        send
      call        check_busy
      btg         markers3,pokazuje_temperatury_47
      ;dla testow wyswietl na dole ekranu litere b
      
       goto        wykryto_down_exit
      
wykryto_down_sprawdz_czy_wyswietlam_kolejne_opcje
      
      ; polozenie gwiazdki przechowuje liczbe wskazującą aktualny adres polozenia
      ;gwiazdki w 
      ;tablicy_gwiazdki
      ;
      
      movlw       HIGH tablica_gwiazdki
      movwf       TBLPTRH
      
      movlw       LOW tablica_gwiazdki
      movwf       TBLPTRL
      
      ;poniewaz najpierw zmniejszam polozenie
      incf        polozenie_gwiazdki,f
      movf       polozenie_gwiazdki,w
      
      addwf       TBLPTRL,f
      
       ;a nastepnie czytam z adresu tablica_gwiazdki + polozenie_gwiazdki to uzywam polecenia
      TBLRD *
      
      movlw       1
      cpfseq      TABLAT
;jezeli odczytano 1 tzn ze gwiazdka jest polozona na 
; dole ekranu
; i nalezy zmienic pozycje_menu oraz wyswietlic opcje menu z kolejnego ekranu

      goto         wykryto_down_zmiana_polozenia_gwiazdki
      ;polozenie_gwiazdki == 1
      ;tzn opcje kolejnego ekranu sa wyswietlane
      movlw       1
      movwf       polozenie_gwiazdki;znow na pierwszej linii
      
      ;numer opcji ulega zmianie na kolejny
      incf        numer_opcji,f
      ;czyszczenie ekranu
      call        check_busy
      movlw       display_clear
      call        send
      call        check_busy
      
      ;zaznaczam ze wyświetlam kolejny ekran opcji
      
      
      ;clrf        numer_opcji
      
      
      ;call        check_busy
      movlw       linia_gorna
      
      call        send
      call        check_busy
      
      movlw       _star
      call        write_lcd
      call        check_busy      
      
      bcf         STATUS,C
      rlcf       pozycja_menu,f
      
      ;btfsc       pozycja_menu,menu_opcje1
      ;goto        wykryto_down_wyswietl_opcje_tablicy_jeden
      
      btfsc       pozycja_menu,menu_opcje2
      goto        wykryto_down_wyswietl_opcje_tablicy_druga
      
      btfsc       pozycja_menu,menu_opcje3
      goto        wykryto_down_wyswietl_opcje_tablicy_trzy
      
      btfsc       pozycja_menu,menu_opcje4
      goto        wykryto_down_wyswietl_opcje_tablicy_cztery
      
      ;btfsc       pozycja_menu,menu_opcje_end ;(tj zaznaczono bit ekranu którego nie ma w tym wypadku są   ekrany bit 0 i 1,  2  a bit 3 oznacza ekran którego nie ma     )
      ;goto        wykryto_down_wyswietl_opcje_tablicy_end
      ;pisanie 
      
      
      ;gdy wyświetlam opcje ekranu 1 - tzn gwiazdka byla na koncu opcji linii czwartej ekranu 2
      movlw       1
      movwf       numer_opcji
      movwf       pozycja_menu
      
      movlw       HIGH tablica_pierwsza
      movwf       TBLPTRH
      
      movlw       LOW tablica_pierwsza
      movwf       TBLPTRL
      
      call        wyswietl_opcje_menu
      
      goto        wykryto_down_exit
      
      
      
wykryto_down_wyswietl_opcje_tablicy_druga
      ;gdy wyświetlam opcje ekranu 2
      movlw       HIGH tablica_druga
      movwf       TBLPTRH
      
      movlw       LOW tablica_druga
      movwf       TBLPTRL
      
      
      call        wyswietl_opcje_menu
      
      goto        wykryto_down_exit
      


wykryto_down_wyswietl_opcje_tablicy_trzy
      ;gdy wyświetlam opcje ekranu 3
      movlw       HIGH tablica_trzecia
      movwf       TBLPTRH
      
      movlw       LOW tablica_trzecia
      movwf       TBLPTRL
      
      
      call        wyswietl_opcje_menu
      
      goto        wykryto_down_exit
      
      
;wykryto_down_wyswietl_opcje_tablicy_end      
wykryto_down_wyswietl_opcje_tablicy_cztery      
      movlw       HIGH tablica_czwarta
      movwf       TBLPTRH
      
      movlw       LOW tablica_czwarta
      movwf       TBLPTRL
      
      call        wyswietl_opcje_menu
      
      goto        wykryto_down_exit
      
wykryto_down_zmiana_polozenia_gwiazdki
      ;opcje zmnieniaja się o tą położoną wyżej
      incf        numer_opcji,f
      
      ;nowa gwiazdka jest rysowana w miejscu odczytanym z tablicy
      call     check_busy
      movf        TABLAT,w
      call        send
      
      call     check_busy
      
      movlw       _star
      call        write_lcd
      call     check_busy
      ;gwiazdka poprzednia jest kasowana - tzn znow czytam z tablicy ale tym razem polozenie poprzednie
      
      
      decf        TBLPTRL,f
      TBLRD *
      movf        TABLAT,w
      call        send
      call     check_busy
      movlw       _puste
      call        write_lcd
      
      incf        TBLPTRL,f
      
      goto        wykryto_down_exit

      
wykryto_down_zmiana_opcji
      movlw       opcja_czujniki
      cpfseq      numer_opcji
      goto          wykryto_down_sprawdz_2
      
      ;jeżeli zmieniam ilość obsługiwanych czujników temp
      ;to tu powinno być zmiana o 1 ilości kanałów 
      ;i sprawdzenie czy nie przekroczyłem dopuszczalnych 8
      
      decf        ile_kanalow,f
      
      movlw      0xff
      
      cpfseq      ile_kanalow
      goto         wykryto_down_zmiana_opcji_wyswietl_kanaly
      
      movlw       8
      movwf       ile_kanalow
      
wykryto_down_zmiana_opcji_wyswietl_kanaly
      call     check_busy
      movlw    linia_gorna
      addlw       0xc
      call      send
      ;
      call     check_busy
      movf        ile_kanalow,w
      addlw       0x30
      call        write_lcd
      
      goto        wykryto_down_exit
      
wykryto_down_sprawdz_2
      movlw       opcja_odstep
      cpfseq      numer_opcji
      goto        wykryto_down_sprawdz_3

      decf        odstep_pomiarowy,f
      movf        odstep_pomiarowy,w
      movwf       tmp_hex
      clrf        tmp_hex_H
      clrf        dec1
      clrf        dec10
      call        hex2dec18
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
      call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
  
      goto        wykryto_down_exit
      
wykryto_down_sprawdz_3  
      movlw       opcja_srednia
      cpfseq      numer_opcji
      goto        wykryto_down_sprawdz_4
      
      ;bsf      markers,czy_usrednianie
      
      ;sprawdz czy liczba próbek == 1
      movlw       0x1
      cpfseq      jak_duzo_probek
      goto        wykryto_down_sprawdz_3_zmniejsz_probki
      ;zmieniam liczbe próbek na 0x80
      movlw       0x80
      movwf       jak_duzo_probek
      goto        wykryto_down_3_wyswietl
      
wykryto_down_sprawdz_3_zmniejsz_probki
;dziele przez 2
      movlw       0x80 
      mulwf       jak_duzo_probek
      movf        PRODH,w
      movwf       jak_duzo_probek
      
      call     ustaw_wartosc_dzielenia_usredniania
      
wykryto_down_3_wyswietl
;sprawdz czy liczba próbek ==1
      bcf      markers,czy_usrednianie
      
      movlw       1
      cpfseq      jak_duzo_probek
      bsf      markers,czy_usrednianie      
      
      movf        jak_duzo_probek,w
      movwf       tmp_hex
      clrf        tmp_hex_H
      clrf        dec1
      clrf        dec10
      call        hex2dec18
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
      call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa

      goto        wykryto_down_exit


wykryto_down_sprawdz_4
      
      
wykryto_down_sprawdz_5
      movlw       opcja_ustaw_temp
      cpfseq      numer_opcji
      goto        wykryto_down_sprawdz_6
      
      ;wlacz pomiar pradu
      ;jako test wlacz podswietlenie lub je wylacz
      
      ;btg   portlampka2,lampka2
      
      decf        jaka_wartosc_regulujeL,f
      
      btfsc       STATUS,C
      goto        wykryto_down_sprawdz_5_zero
      ;jeżeli w H jest 0 to  umieść tam 1
      movf       jaka_wartosc_regulujeH,w
      bz          wykryto_down_sprawdz_5_zawracanie
      
      decf        jaka_wartosc_regulujeH,f
      
      btfss       STATUS,Z
      goto        wykryto_down_sprawdz_5_zero
wykryto_down_sprawdz_5_zawracanie
      movlw       1
      movwf       jaka_wartosc_regulujeH
      
wykryto_down_sprawdz_5_zero      
                                                ; movf        jaka_wartosc_regulujeL,w
                                                ; movwf       tmp_hex
                                                ; movf        jaka_wartosc_regulujeH,w
                                                ; movwf        tmp_hex_H
                                                ; clrf        dec1
                                                ; clrf        dec10
                                                ; call        hex2dec18
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
                                                ;call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
      
      
      call  wyswietl_temp_w_opcjach
      
      goto        wykryto_down_exit
      
wykryto_down_sprawdz_6
      
wykryto_down_sprawdz_9

      movlw       opcja_histereza
      cpfseq      numer_opcji
      goto        wykryto_down_sprawdz_10
      
      ;wlacz pomiar pradu
      ;jako test wlacz podswietlenie lub je wylacz
      
      ;btg   portlampka2,lampka2
      decf        histereza,f
      
      movf        histereza,w
      movwf       tmp_hex
      
      clrf        tmp_hex_H
      clrf        dec1
      clrf        dec10
      call        hex2dec18
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
      call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
      
      goto        wykryto_down_exit     

wykryto_down_sprawdz_10
      
      
wykryto_down_sprawdz_11
      movlw       opcja_ustaw_zegar
      cpfseq      numer_opcji
      goto        wykryto_down_sprawdz_opcje12
      
;sprawdzenie która wielkość zegara podlega zmianie
;jeżeli dzien_10 to zmniejszam o jeden dzien_1
;problem polega na tym, że nie mogę skorzystać z FSR2 bo  każda z wielkości
;czasu musi być indywidualnie rozpatrywana
      movlw       dzien_10
      cpfseq      ustawianie_czasu_co_wyswietlam
      goto        wykryto_down_sprawdz_11_1

;jeżeli dzień_1 jest 0 (0x30) to jeżeli dzien_10 <> 0x30 zmniejsz dzien_10

      movlw       0x30
      cpfseq      dzien_1
      goto        zmniejsz_dzien_1
      
      ;sprawdz czy dzien_10 == 0x30
      movlw       0x30
      cpfseq      dzien_10
      goto        zapisz_do_dzien_1_99
      
      movlw       0x39
      movwf       dzien_10
      movwf       dzien_1
      
      goto        wykryto_down_sprawdz_11_4
      
zapisz_do_dzien_1_99
      movlw       0x39
      movwf       dzien_1
      decf        dzien_10,f
      goto        wykryto_down_sprawdz_11_4
      
      
zmniejsz_dzien_1      
      decf        dzien_1,f
      
      
      goto        wykryto_down_sprawdz_11_4
      
wykryto_down_sprawdz_11_1
      movlw       godziny_10
      cpfseq      ustawianie_czasu_co_wyswietlam
      goto        wykryto_down_sprawdz_11_2
      
      movlw       0x30
      cpfseq      godziny_1
      goto        zmniejsz_godziny_1
      
      ;sprawdz czy dzien_10 == 0x30
      movlw       0x30
      cpfseq      godziny_10
      goto        zapisz_do_godziny_1_9
      
      movlw       0x32
      movwf       godziny_10
      movlw       0x33
      movwf       godziny_1
      
      goto        wykryto_down_sprawdz_11_4
      
zapisz_do_godziny_1_9
      movlw       0x39
      movwf       godziny_1
      decf        godziny_10,f
      goto        wykryto_down_sprawdz_11_4
      
      
zmniejsz_godziny_1      
      decf        godziny_1,f
      
      
      goto        wykryto_down_sprawdz_11_4
      
      
wykryto_down_sprawdz_11_2
      movlw       minuty_10
      cpfseq      ustawianie_czasu_co_wyswietlam
      goto        wykryto_down_sprawdz_11_3
      
      movlw       0x30
      cpfseq      minuty_1
      goto        zmniejsz_minuty_1
      
      ;sprawdz czy dzien_10 == 0x30
      movlw       0x30
      cpfseq      minuty_10
      goto        zapisz_do_minuty_1_9
      
      movlw       0x35
      movwf       minuty_10
      movlw       0x39
      movwf       minuty_1
      
      goto        wykryto_down_sprawdz_11_4
      
zapisz_do_minuty_1_9
      movlw       0x39
      movwf       minuty_1
      decf        minuty_10,f
      goto        wykryto_down_sprawdz_11_4
      
      
zmniejsz_minuty_1      
      decf        minuty_1,f
      
      goto        wykryto_down_sprawdz_11_4
      
wykryto_down_sprawdz_11_3     
      movlw       0x30
      cpfseq      sekundy_1
      goto        zmniejsz_sekundy_1
      
      ;sprawdz czy dzien_10 == 0x30
      movlw       0x30
      cpfseq      sekundy_10
      goto        zapisz_do_sekundy_1_9
      
      movlw       0x35
      movwf       sekundy_10
      movlw       0x39
      movwf       sekundy_1
      
      goto        wykryto_down_sprawdz_11_4
      
zapisz_do_sekundy_1_9
      movlw       0x39
      movwf       sekundy_1
      decf        sekundy_10,f
      goto        wykryto_down_sprawdz_11_4
      
      
zmniejsz_sekundy_1      
      decf        sekundy_1,f
      
wykryto_down_sprawdz_11_4            

      call        procedura_wyswietlania_kolejnych_liczb_zegara
      
      goto        wykryto_down_exit           
;       call     check_busy
;       movlw    linia_czwarta
;       call      send
;         
;       call     check_busy
; ;czy gasze czy wyswietlam      
;       btfsc       markers,test
;       goto        zamaz_D
; napisz_D
;       bsf   markers,test
;       movlw       _d
;       goto  wykryto_down_pisz
; zamaz_D      
;       bcf   markers,test
;       movlw       _puste
;       
; wykryto_down_pisz
;       call     write_lcd
wykryto_down_sprawdz_opcje12
      
wykryto_down_exit
;jeżeli jest opuszczenie procedury w trakcie przyciskania kończ w inny sposób

      btfsc   znaczniki,czy_moge_juz_zmieniac
      goto    wykryto_down_exit_trzymanie
      
      bcf   markers3,dzialanie_po_klawiszu
      clrf  stan_key
      goto  LOOP11
 
wykryto_down_exit_trzymanie
      bcf     znaczniki,czy_moge_juz_zmieniac
      return
 
                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                UP
wykryto_up
      ;co sie dzieje jezeli wykryje ze wcisnieto i puszczono klawisz up
      
      btfsc       pozycja_menu,zmiana_opcji
      goto        wykryto_up_zmiana_opcji
      
      movf        pozycja_menu,w
      bnz         wykryto_up_sprawdz_czy_wyswietlam_kolejne_opcje
;jezeli pozycja menu ==0 to po nacisnieciu klawisza zmien wskazania temperatury

      call        check_busy
      movlw       display_clear
      call        send
      call        check_busy
      btg         markers3,pokazuje_temperatury_47
      ;tzn pozwala obejrzec temperatury 0-3 lub 4-7 (zawsze 4)
      goto        wykryto_up_exit
      

      
wykryto_up_sprawdz_czy_wyswietlam_kolejne_opcje
      ;movlw       1
      ;cpfseq      pozycja_menu
      ;goto        sprawdz_czy_wyswietlam_zmiane_opcji
      
      ; polozenie gwiazdki przechowuje liczbe wskazującą aktualny adres polozenia
      ;gwiazdki w 
      ;tablicy_gwiazdki
      ;
      
      movlw       HIGH tablica_gwiazdki
      movwf       TBLPTRH
      
      movlw       LOW tablica_gwiazdki
      movwf       TBLPTRL
      
      ;poniewaz najpierw zmniejszam polozenie
      decf        polozenie_gwiazdki,f
      movf       polozenie_gwiazdki,w
      
      addwf       TBLPTRL,f
      
       ;a nastepnie czytam to uzywam polecenia
      TBLRD *
      movf        TABLAT,w
;jezeli odczytano 0 tzn ze bylem na gorze ekranu (pierwsze polecenie)
; i następuje przeskok do ekranu menu 0 lub 1 
      bnz         wykryto_up_zmiana_polozenia_gwiazdki
      ;polozenie_gwiazdki == 4 bo gwiazdka jest na dole opcji ekranu poprzedniego
      movlw       4
      movwf       polozenie_gwiazdki
      
      
      decf        numer_opcji,f
      ;czyszczenie ekranu
      call        check_busy
      movlw       display_clear
      call        send
      call        check_busy
      
           
      
      ;zaznaczam ze wyświetlam kolejny ekran opcji
      
      
      btfsc       pozycja_menu,menu_opcje1 ;(tj zaznaczony jet bit wskazujący na pokazywanie opcji ekranu 1, czyli przeskok do ekranu koncowego)
      goto        wykryto_up_wyswietl_opcje_tablicy_end
      
      
      
      
      
      bcf         STATUS,C
      rrcf       pozycja_menu,f
      
;########################################## WAZNE
;jeżeli będzie więcej ekrnów opcji menu, to tu należy dodać procedurę wykrywania adres której tablicy jest używany do wyświetlania opcji
       
      ;gdy wyświetlam opcje ekranu 2 - tzn gwiazdka byla na górze opcji linii pierwszej ekranu 2
      
      ;jeżeli po przesunięciu zaznaczony jest bit menu_opcje1 to wyswietl menu_opcje1
      btfsc       pozycja_menu,menu_opcje1 ;(tj zaznaczony jet bit wskazujący na pokazywanie opcji ekranu 1, czyli przeskok do ekranu 0)
      goto        wykryto_up_wyswietl_opcje_tablicy_pierwsza
      
      
      btfsc       pozycja_menu,menu_opcje2 ;(tj zaznaczony jet bit wskazujący na pokazywanie opcji ekranu 1, czyli przeskok do ekranu 0)
      goto        wykryto_up_wyswietl_opcje_tablicy_dwa

      btfsc       pozycja_menu,menu_opcje3 ;(tj zaznaczony jet bit wskazujący na pokazywanie opcji ekranu 1, czyli przeskok do ekranu 0)
      goto        wykryto_up_wyswietl_opcje_tablicy_trzy
      
      
wykryto_up_wyswietl_opcje_tablicy_pierwsza
      movlw       HIGH tablica_pierwsza
      movwf       TBLPTRH
      
      movlw       LOW tablica_pierwsza
      movwf       TBLPTRL
      
      call        wyswietl_opcje_menu
      
      ;wyswietlam gwiazdke na linii ostatniej poprzedniego ekranu
      call        check_busy
      movlw       linia_czwarta
      
      call        send
      call        check_busy
      movlw       _star
      call        write_lcd
      call        check_busy
      
      goto        wykryto_up_exit
      
           
wykryto_up_wyswietl_opcje_tablicy_dwa
      ;tu jest przeskok z numeru opcji 1 do ostatniej możliwej czyli 8
      
      ;wyświetlam opcje ekranu 2
      
      
      movlw       HIGH tablica_druga
      movwf       TBLPTRH
      
      movlw       LOW tablica_druga
      movwf       TBLPTRL
      
      call        wyswietl_opcje_menu
      
      ;wyswietlam gwiazdke na linii ostatniej poprzedniego ekranu
      call        check_busy
      movlw       linia_czwarta
      call        send
      
      call        check_busy
      movlw       _star
      call        write_lcd
      call        check_busy
      
      goto        wykryto_up_exit


wykryto_up_wyswietl_opcje_tablicy_trzy
      
      movlw       HIGH tablica_trzecia
      movwf       TBLPTRH
      
      movlw       LOW tablica_trzecia
      movwf       TBLPTRL
            
      call        wyswietl_opcje_menu
      
      call        check_busy
      movlw       linia_czwarta      
      call        send
      
      call        check_busy
      movlw       _star
      call        write_lcd
      call        check_busy
      
      goto        wykryto_down_exit
      
wykryto_up_wyswietl_opcje_tablicy_end
      movlw       numer_opcji_koncowej    
      movwf       numer_opcji
      clrf            pozycja_menu
      bsf            pozycja_menu,(menu_opcje_end-1)

      movlw       HIGH tablica_czwarta
      movwf       TBLPTRH
      
      movlw       LOW tablica_czwarta
      movwf       TBLPTRL
      
      
      call        wyswietl_opcje_menu
      
      call        check_busy
      movlw       linia_czwarta      
      call        send
      
      call        check_busy
      movlw       _star
      call        write_lcd
      call        check_busy
      
      goto        wykryto_down_exit
      
      
wykryto_up_zmiana_polozenia_gwiazdki
      ;opcje zmnieniaja się o tą położoną wyżej
      decf        numer_opcji,f
      
      ;nowa gwiazdka jest rysowana w miejscu odczytanym z tablicy
      
      call     check_busy
      movf        TABLAT,w
      call        send
      
      call     check_busy
      movlw       _star
      call        write_lcd
      call     check_busy
      ;gwiazdka poprzednia jest kasowana - tzn znow czytam z tablicy ale tym razem polozenie poprzednie
      
      
      incf        TBLPTRL,f
      TBLRD *
      movf        TABLAT,w
      call        send
      call     check_busy
      movlw       _puste
      call        write_lcd
      
      decf        TBLPTRL,f
      
      goto        wykryto_up_exit


      
;#########################################KLAWISZ UP
;ZMIANA Opcji
wykryto_up_zmiana_opcji
;sprawdz którą opcję zmieniam
      movlw       opcja_czujniki
      cpfseq      numer_opcji
      goto          wykryto_up_sprawdz_2
      
      ;jeżeli zmieniam ilość obsługiwanych czujników temp
      ;to tu powinno być zmiana o 1 ilości kanałów 
      ;i sprawdzenie czy nie przekroczyłem dopuszczalnych 8
      incf        ile_kanalow,f
      movlw      9
      
      cpfseq      ile_kanalow
      goto         wykryto_up_zmiana_opcji_wyswietl_kanaly
      
      clrf              ile_kanalow
      
wykryto_up_zmiana_opcji_wyswietl_kanaly
      call     check_busy
      movlw    linia_gorna
      addlw       0xc
      call      send
      ;
      call     check_busy
      movf        ile_kanalow,w
      addlw       0x30
      call        write_lcd
      
      goto        wykryto_up_exit
      
wykryto_up_sprawdz_2
      movlw       opcja_odstep
      cpfseq      numer_opcji
      goto        wykryto_up_sprawdz_3

      incf        odstep_pomiarowy,f
      movf        odstep_pomiarowy,w
      
      movwf       tmp_hex
      clrf        tmp_hex_H
      clrf        dec1
      clrf        dec10
      call        hex2dec18
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
      call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
      
      
      goto        wykryto_up_exit
      
wykryto_up_sprawdz_3
      movlw       opcja_srednia
      cpfseq      numer_opcji
      goto        wykryto_up_sprawdz_4
      
      ;sprawdz czy liczba próbek == 128 (0x80)
      movlw       0x80
      cpfseq      jak_duzo_probek
      goto        wykryto_up_sprawdz_3_zwieksz_probki
      ;zmieniam liczbe próbek na 1
      movlw       1
      movwf       jak_duzo_probek
      bcf      markers,czy_usrednianie
      
      goto        wykryto_up_3_wyswietl
      
wykryto_up_sprawdz_3_zwieksz_probki
      bsf      markers,czy_usrednianie
      movlw       0x02
      mulwf       jak_duzo_probek
      movf        PRODL,w
      movwf       jak_duzo_probek
      
      call     ustaw_wartosc_dzielenia_usredniania      
      
wykryto_up_3_wyswietl
      movf        jak_duzo_probek,w
      movwf       tmp_hex
      clrf        tmp_hex_H
      clrf        dec1
      clrf        dec10
      call        hex2dec18
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
      call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
      
      goto        wykryto_up_exit
            

wykryto_up_sprawdz_4
wykryto_up_sprawdz_5
      movlw       opcja_ustaw_temp
      cpfseq      numer_opcji
      goto        wykryto_up_sprawdz_6
      
            
      incf        jaka_wartosc_regulujeL,f
      
      bnc         wykryto_up_sprawdz_5_dalej
      ;czy  przekroczono 0x200
            
      incf        jaka_wartosc_regulujeH,f
      
      movlw       0x02
      cpfseq      jaka_wartosc_regulujeH
      goto        wykryto_up_sprawdz_5_dalej
      
      
      ;jeżeli w H jest 3 to wyzeruj 
      clrf       jaka_wartosc_regulujeH
      
      
wykryto_up_sprawdz_5_dalej
                                                ; movf        jaka_wartosc_regulujeL,w
                                                ; movwf       tmp_hex
                                                ; movf        jaka_wartosc_regulujeH,w
                                                ; movwf        tmp_hex_H
                                                ; clrf        dec1
                                                ; clrf        dec10
                                                ; call        hex2dec18
                                          ;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
                                           ;     wyświetlam obok nazwy opcji czyli 
                                                ; call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
      
      call  wyswietl_temp_w_opcjach
      
      
      goto        wykryto_down_exit
wykryto_up_sprawdz_6


wykryto_up_sprawdz_9

      movlw       opcja_histereza
      cpfseq      numer_opcji
      goto        wykryto_up_sprawdz_10
      
      ;wlacz pomiar pradu
      ;jako test wlacz podswietlenie lub je wylacz
      
      ;btg   portlampka2,lampka2
      incf        histereza,f
      
      movf        histereza,w
      movwf       tmp_hex
      
      clrf        tmp_hex_H
      clrf        dec1
      clrf        dec10
      call        hex2dec18
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
      call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
      
      goto        wykryto_up_exit     
      
wykryto_up_sprawdz_10

wykryto_up_sprawdz_11
      movlw       opcja_ustaw_zegar
      cpfseq      numer_opcji
      goto        wykryto_up_sprawdz12
      
;sprawdzenie która wielkość zegara podlega zmianie
;jeżeli dzien_10 to zmniejszam o jeden dzien_1
;problem polega na tym, że nie mogę skorzystać z FSR2 bo  każda z wielkości
;czasu musi być indywidualnie rozpatrywana
      movlw       dzien_10
      cpfseq      ustawianie_czasu_co_wyswietlam
      goto        wykryto_up_sprawdz_11_1

;jeżeli dzień_1 jest 9 (0x39) to jeżeli dzien_10 <> 0x39 zwieksz dzien_10

      movlw       0x39
      cpfseq      dzien_1
      goto        zwieksz_dzien_1
      
      ;sprawdz czy dzien_10 == 0x39
      movlw       0x39
      cpfseq      dzien_10
      goto        zapisz_do_dzien_1_0
      
      movlw       0x30 
      movwf       dzien_1            
      movwf       dzien_10
      
      goto        wykryto_up_sprawdz_11_4
      
zapisz_do_dzien_1_0
      movlw       0x30
      movwf       dzien_1
      incf        dzien_10,f
      goto        wykryto_up_sprawdz_11_4
      
      
zwieksz_dzien_1      
      incf        dzien_1,f
      
      
      goto        wykryto_up_sprawdz_11_4
      
wykryto_up_sprawdz_11_1
      movlw       godziny_10
      cpfseq      ustawianie_czasu_co_wyswietlam
      goto        wykryto_up_sprawdz_11_2
      
      ;najpierw sprawdze czy godziny_1 i godziny_10 == 23 godzina bo wtedy wpisuje 00
      movlw       0x33
      cpfseq      godziny_1
      goto        sprawdz_zwiekszanie_godzin_normalnie
      movlw       0x32
      cpfseq      godziny_10
      goto        sprawdz_zwiekszanie_godzin_normalnie
      
;jest godzina 23 => zapisz do godzin 00      
      movlw       0x30
      movwf       godziny_10      
      movwf       godziny_1
      goto        wykryto_up_sprawdz_11_4
      
sprawdz_zwiekszanie_godzin_normalnie      
      movlw       0x39
      cpfseq      godziny_1
      goto        zwieksz_godziny_1      

      movlw       0x30
      movwf       godziny_1
      incf        godziny_10,f
      goto        wykryto_up_sprawdz_11_4
            
zwieksz_godziny_1      
      incf        godziny_1,f
      
      
      goto        wykryto_up_sprawdz_11_4
      
      
wykryto_up_sprawdz_11_2
      movlw       minuty_10
      cpfseq      ustawianie_czasu_co_wyswietlam
      goto        wykryto_up_sprawdz_11_3
      
      
      movlw       0x39
      cpfseq      minuty_1
      goto        zwieksz_minuty_1
     
      movlw       0x35
      cpfseq      minuty_10
      goto        zapisz_do_minuty_1_0
      
      movlw       0x30
      movwf       minuty_10
      movwf       minuty_1
      
      goto        wykryto_up_sprawdz_11_4
      
zapisz_do_minuty_1_0
      movlw       0x30
      movwf       minuty_1
      incf        minuty_10,f
      goto        wykryto_up_sprawdz_11_4
      
      
zwieksz_minuty_1      
      incf        minuty_1,f
      
      goto        wykryto_up_sprawdz_11_4
      
wykryto_up_sprawdz_11_3     
      movlw       0x30
      cpfseq      sekundy_1
      goto        zwieksz_sekundy_1
      
      ;sprawdz czy dzien_10 == 0x30
      movlw       0x30
      cpfseq      sekundy_10
      goto        zapisz_do_sekundy_1_0
      
      movlw       0x35
      movwf       sekundy_10
      movlw       0x39
      movwf       sekundy_1
      
      goto        wykryto_up_sprawdz_11_4
      
zapisz_do_sekundy_1_0
      movlw       0x30
      movwf       sekundy_1
      incf        sekundy_10,f
      goto        wykryto_up_sprawdz_11_4
      
      
zwieksz_sekundy_1      
      incf        sekundy_1,f
      
wykryto_up_sprawdz_11_4            

      call        procedura_wyswietlania_kolejnych_liczb_zegara
      goto        wykryto_up_exit
      
wykryto_up_sprawdz12
      
wykryto_up_exit
      btfsc   znaczniki,czy_moge_juz_zmieniac
      goto    wykryto_up_exit_trzymanie
      bcf   markers3,dzialanie_po_klawiszu
      clrf  stan_key
      goto  LOOP11
 
wykryto_up_exit_trzymanie
      bcf     znaczniki,czy_moge_juz_zmieniac
      return      
 




;############################################
;#####
;######PISZ na ekranie słowa z tablicy opcji menu


wyswietl_opcje_menu
      call        check_busy
      movlw       linia_gorna
      addlw       1        
      call        send
      call        check_busy
czytam_pierwsza_linie
      
      ;czytam aktualny adres i zwiekszam
      TBLRD       *+
      
      movf        TABLAT,w
      ;jezeli 0 to skocz do wyswietlania slowa z linii 2
      bz          czytam_druga_linie
      call        write_lcd
      call        check_busy
      goto        czytam_pierwsza_linie
      
czytam_druga_linie
      
      movlw       linia_dolna
      addlw       1        
      call        send
      call        check_busy
      
czytam_druga_linie2
      ;czytam aktualny adres i zwiekszam
      TBLRD       *+
      
      movf        TABLAT,w
      ;jezeli 0 to skocz do wyswietlania slowa z linii 2
      bz          czytam_trzecia_linie
      call        write_lcd
      call        check_busy
      
      goto        czytam_druga_linie2
      
czytam_trzecia_linie
      movlw       linia_trzecia
      addlw       1        
      call        send
      call        check_busy
czytam_trzecia_linie2      
      TBLRD       *+
      
      movf        TABLAT,w
      ;jezeli 0 to skocz do wyswietlania slowa z linii 2
      bz          czytam_4_linie
      call        write_lcd
      call        check_busy
      
      goto        czytam_trzecia_linie2
      
czytam_4_linie
      movlw       linia_czwarta
      addlw       1        
      call        send
      call        check_busy
      
czytam_4_linie2
      TBLRD       *+
      
      movf        TABLAT,w
      ;jezeli 0 to skocz do wyswietlania slowa z linii 2
      bz          czytam_4_linie3
      call        write_lcd
      call        check_busy
      
      goto        czytam_4_linie2
      
czytam_4_linie3
      return 
 
 
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                                ENTER
wykryto_enter
      ;co sie dzieje jezeli wykryje ze wcisnieto i puszczono klawisz enter
      
      btfsc       pozycja_menu,zmiana_opcji
      goto        wykryto_enter_zmiana_opcji
      
      movf        pozycja_menu,w
      bnz         sprawdz_czy_wchodze_do_zmiany_opcji
;jezeli pozycja menu ==0 to po nacisnieciu klawisza enter wyswietlane sa napisy ekranu menu 0 i gwiazdka w linii pierwszej przy pierwszej opcji
      
      ;wylaczam wskazywanie temperatur i czasu
      bcf         markers,czy_wyswietlam_temp
      bcf         markers3,czy_zegar_wyswietlac
      
      
      
      call        check_busy
      movlw       display_clear
      call        send
      call        check_busy
      
      movlw       1
      movwf       pozycja_menu
      movwf       polozenie_gwiazdki
      
      movwf        numer_opcji
            
      call        check_busy
      movlw       linia_gorna
      
      call        send
      call        check_busy
      movlw       _star
      call        write_lcd
      call        check_busy
      
      
      movlw       HIGH tablica_pierwsza
      movwf       TBLPTRH
      
      movlw       LOW tablica_pierwsza
      movwf       TBLPTRL
      
      call  wyswietl_opcje_menu
      
      goto        wykryto_enter_exit     
      
sprawdz_czy_wchodze_do_zmiany_opcji
      movlw       opcja_czujniki
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje2
      ;obok nazwy opcji wypisuje aktualna ilosc mierzonych temperatur
      ;naciskanie klawiszy gora/ dół to zmiana ilości kanałów mierzonych
      ;klawisz enter lub back powoduje zatwierdzenie pomiarów 
      
      ;opcja wyboru jest umieszczona na pierwszej linii ekranu
      ;
      ;*pomiar t   2
      ;na 12 znaku linii pierwszej piszemy aktualną cyfrę kanałów
      call     check_busy
      movlw    linia_gorna
      addlw       0xc
      call      send
      ;
      call     check_busy
      movf        ile_kanalow,w
      addlw       0x30
      call        write_lcd
            
      ;zaznaczam ze jest zmiana opcji
      bsf         pozycja_menu,zmiana_opcji
      
      goto        wykryto_enter_exit
      
wykryto_enter_sprawdz_opcje2

      movlw       opcja_odstep
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje3

      ;pokaz na ekranie ustawienie aktualne odstępu w s.
      movf        odstep_pomiarowy,w
      movwf       tmp_hex
      clrf        tmp_hex_H
      clrf        dec1
      clrf        dec10
      call        hex2dec18
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
      call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
      
      ;zaznaczam ze jest zmiana opcji
      bsf         pozycja_menu,zmiana_opcji
      
      goto        wykryto_enter_exit
      
      
wykryto_enter_sprawdz_opcje3
      movlw       opcja_srednia
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje4

      ;pokaz na ekranie ustawienie aktualne odstępu w s.
      movf        jak_duzo_probek,w
      movwf       tmp_hex
      clrf        tmp_hex_H
      clrf        dec1
      clrf        dec10
      call        hex2dec18
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
      call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
      
      bsf         pozycja_menu,zmiana_opcji
      
      goto        wykryto_enter_exit
      
wykryto_enter_sprawdz_opcje4
      movlw       opcja_regulacja
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje5
      
      btg         markers2,reguluj
      
      goto        wykryto_enter_exit
      
wykryto_enter_sprawdz_opcje5
      movlw       opcja_ustaw_temp
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje6
      
      
      
                                          ;movf        jaka_wartosc_regulujeL,w      
                                          ;movwf       tmp_hex
                                          ;movf        jaka_wartosc_regulujeH,w
                                          ;movwf        tmp_hex_H
                                          ;clrf        dec1
                                          ;clrf        dec10
                                          ;call        hex2dec18
                                          ;call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
                                          
      call  wyswietl_temp_w_opcjach
      
      bsf         pozycja_menu,zmiana_opcji
      
      goto        wykryto_enter_exit
      
wyswietl_temp_w_opcjach      
      movf        jaka_wartosc_regulujeL,w
           ;dziele przez 4
      mullw       0x40
      
      movf        PRODL,w
      movwf       wynik01
      
      ;temperatura jest w bajcie starszym
      movf        PRODH,w
      movwf       tmp_hex
      
      movf        jaka_wartosc_regulujeH,w
      movwf        tmp_hex_H
      
         call     hex2dec18
         
         movlw       HIGH tablica_gwiazdki
      movwf       TBLPTRH
      
      movlw       LOW tablica_gwiazdki
      movwf       TBLPTRL
      
      ;poniewaz najpierw zmniejszam polozenie
      
      movf       polozenie_gwiazdki,w
      
      addwf       TBLPTRL,f
      
      
      
      call        check_busy
       ;a nastepnie czytam to uzywam polecenia
      TBLRD *
      movf        TABLAT,w
  ;teraz należy do adresu lini dodać miejsce położenia cyfry 100
  

      addlw       0x09
      call        send
         
       call     wyswietl_cyfry_temperatury
      
      return
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
      
      
      
wykryto_enter_sprawdz_opcje6 
      movlw       opcja_pomiar_i
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje7
      
      movlw       2
      movwf       jak_duzo_kanalow_pradu
      clrf        ktory_aktualnie_kanal_pradu
      
      btg   markers3,pomiary_pradu
      
      
      goto        wykryto_enter_exit
     
wykryto_enter_sprawdz_opcje7

      movlw       opcja_wlacz_1
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje8
      
      btg   port_triak,triak1
      
      
      
      goto        wykryto_enter_exit
      
wykryto_enter_sprawdz_opcje8
      movlw       opcja_wlacz_2
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje9
      
      btg   port_triak,triak2
      
      
      
      goto        wykryto_enter_exit
      
      
wykryto_enter_sprawdz_opcje9
      movlw       opcja_histereza
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje10
      
      ;wlacz pomiar pradu
      ;jako test wlacz podswietlenie lub je wylacz
      
      ;btg   portlampka2,lampka2
      movf        histereza,w
      movwf       tmp_hex
      
      clrf        tmp_hex_H
      clrf        dec1
      clrf        dec10
      call        hex2dec18
;czyli zawartość rejestru jest zamieniana na postać dziesiętną i przenoszonona do dec100 dec10 dec1
      ;wyświetlam obok nazwy opcji czyli 
      call        wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
      
      bsf         pozycja_menu,zmiana_opcji
      
      goto        wykryto_enter_exit

wykryto_enter_sprawdz_opcje10

wykryto_enter_sprawdz_opcje11
      movlw       opcja_ustaw_zegar
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje12
      ;czyszcze rejestr przechowujący wyświetlaną liczbę
      movlw       dzien_10
      movwf        ustawianie_czasu_co_wyswietlam
      bsf         pozycja_menu,zmiana_opcji
      
      call        procedura_wyswietlania_kolejnych_liczb_zegara
      
      
      goto        wykryto_enter_exit
      
wykryto_enter_sprawdz_opcje12
      movlw       opcja_ustaw_serial
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje13
      
      btg         markers,czy_wysylac_pomiary_serial      
      
           
      goto        wykryto_enter_exit

      
wykryto_enter_sprawdz_opcje13      

      movlw       opcja_wyswietl_zegar
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje14
      
      btg   znaczniki,czy_ponownie_wlaczyc_zegar
      
      goto        wykryto_enter_exit
      
wykryto_enter_sprawdz_opcje14

      movlw       opcja_wyswietl_temp
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje15
      
      btg   znaczniki,czy_ponownie_wlaczyc_temp
      
      goto        wykryto_enter_exit

wykryto_enter_sprawdz_opcje15

      movlw       opcja_podswietlenie
      cpfseq      numer_opcji
      goto        wykryto_enter_sprawdz_opcje16
      
      btg   portlampka2,lampka2
      
      goto        wykryto_enter_exit

      
wykryto_enter_sprawdz_opcje16
      goto        wykryto_enter_exit
      
wykryto_enter_zmiana_opcji
      movlw       opcja_czujniki
      cpfseq      numer_opcji
      goto          wykryto_enter_wyjscie_opcje2
      
      
      call     enter_back_wyjsc_z_opcji_czujniki
      
      ;jeżeli zmieniam ilość obsługiwanych czujników temp
      ;to tu powinno być wyjście z opcji włączania czujników
      ;czyli jeżeli ile_kanalow > 0 to włącz pomiary
      
      movf         ile_kanalow,w
      bz          wykryto_enter_exit
      
      
      movwf    ktory_kanal_mierze
      
      
      movf    odstep_pomiarowy,w
      
      movwf    aktualny_odstep
      
      
      bsf      markers2,pomiary
      bsf      markers,pomiary_zrobione
      bsf       markers,czy_usrednianie
      ;włączyć trzeba moduł A/D
      movlw    b'00000001'
      movwf    ADCON0
      ;bsf      markers,czy_wyswietlam_temp
      goto        wykryto_enter_exit
            
      
wykryto_enter_wyjscie_opcje2
;opcja z liczbą      
      movlw       opcja_odstep
      cpfseq      numer_opcji
      goto          wykryto_enter_wyjscie_opcje3
      call  enter_back_wyjsc_z_opcji_wyswietlanie_liczby
      
      ;call  wykryto_enter_back_wyjsc_z_opcji_skasuj_liczbe
      
      
      
      goto        wykryto_enter_exit
      
wykryto_enter_wyjscie_opcje3
      
      movlw       opcja_srednia
      cpfseq      numer_opcji
      goto          wykryto_enter_wyjscie_opcje4
      call  enter_back_wyjsc_z_opcji_wyswietlanie_liczby
      
     ; bcf        pozycja_menu,zmiana_opcji
      
      goto        wykryto_enter_exit
      

wykryto_enter_wyjscie_opcje4

wykryto_enter_wyjscie_opcje5

      movlw       opcja_ustaw_temp
      cpfseq      numer_opcji
      goto          wykryto_enter_wyjscie_opcje6
      call  enter_back_wyjsc_z_opcji_wyswietlanie_liczby
      
      ;bcf        pozycja_menu,zmiana_opcji
      
      goto        wykryto_enter_exit
      
wykryto_enter_wyjscie_opcje6

wykryto_enter_wyjscie_opcje9

      movlw       opcja_histereza
      cpfseq      numer_opcji
      goto          wykryto_enter_wyjscie_opcje10
      call  enter_back_wyjsc_z_opcji_wyswietlanie_liczby
      
      ;bcf        pozycja_menu,zmiana_opcji
      
      goto        wykryto_enter_exit


wykryto_enter_wyjscie_opcje10

wykryto_enter_wyjscie_opcje11
      movlw       opcja_ustaw_zegar
      cpfseq      numer_opcji
      goto        wykryto_enter_wyjscie_opcje12

      movlw       sekundy_10
      cpfseq      ustawianie_czasu_co_wyswietlam
      goto        wykryto_enter_wyjscie_opcje11_2
      ;jezeli jest w tej chwili sekundy_10 tzn ze wychodze z wyswietlania ustawien zegara
            
      call  enter_back_wyjsc_z_opcji_wyswietlanie_liczby
      
      ;bcf        pozycja_menu,zmiana_opcji
      
      goto        wykryto_enter_exit
      
      
wykryto_enter_wyjscie_opcje11_2
      movlw       2
      addwf       ustawianie_czasu_co_wyswietlam,f
      call        procedura_wyswietlania_kolejnych_liczb_zegara
      goto        wykryto_enter_exit
      

      goto        wykryto_enter_exit
      
wykryto_enter_wyjscie_opcje12      
;             
;       call     check_busy
;       movlw    linia_czwarta
;       call      send
;         
;       call     check_busy
; ;czy gasze czy wyswietlam      
;       btfsc       markers,test
;       goto        zamaz_E
; napisz_E
;       bsf   markers,test
;       movlw       _E
;       goto  wykryto_back_pisz
; zamaz_E
;       bcf   markers,test
;       movlw       _puste
;       
; wykryto_enter_pisz
;       call     write_lcd
      
      
      
wykryto_enter_exit 
      bcf   markers3,dzialanie_po_klawiszu
      clrf  stan_key
      goto  LOOP11
 
;wykryto_enter_back_wyjsc_z_opcji_skasuj_liczbe
;odczytaj_polozenie_gwiazdki_wybierz_linie
 
odczytaj_adres_polozenia_gwiazdki
      movlw       HIGH tablica_gwiazdki
      movwf       TBLPTRH
      
      movlw       LOW tablica_gwiazdki
      movwf       TBLPTRL
      
      ;poniewaz najpierw zmniejszam polozenie
      
      movf       polozenie_gwiazdki,w
      
      addwf       TBLPTRL,f
      
      
      
      call        check_busy
       ;a nastepnie czytam to uzywam polecenia
      TBLRD *
      movf        TABLAT,w
;na zakończenie procedury adres linii z gwiazdką jest umieszczany w rejestrze W
      return
      
      
wykryto_enter_gdzie_wyswietlam_liczbe_bajtowa
;aby liczba wyświetlana znalazła się obok swojej opcji w menu, należy wcześniej odczytać aktualne położenie gwiazdki
;z tablicy
;dzięki temu uniknięte zostanie wielokrotne powtarzanie procedur wyświetlania liczb w zależności od opcji przy której umieszczona ma być wartośc liczby
;poza tym w wypadku zmiany położenia opcji w tablicy opcji menu ( z linii 2 na 3) to zmiana nastąpi automatycznie
;gdyż to położenie gwiazdki decyduje o położeniu cyfr
      movlw       HIGH tablica_gwiazdki
      movwf       TBLPTRH
      
      movlw       LOW tablica_gwiazdki
      movwf       TBLPTRL
      
      ;poniewaz najpierw zmniejszam polozenie
      
      movf       polozenie_gwiazdki,w
      
      addwf       TBLPTRL,f
      
      
      
      call        check_busy
       ;a nastepnie czytam to uzywam polecenia
      TBLRD *
      movf        TABLAT,w
  ;teraz należy do adresu lini dodać miejsce położenia cyfry 100
  

      addlw       0x0d       
      call        send
      call        check_busy
 
 ;i wyswietlic wszystkie cyfry
      movf        dec100,w
      addlw       0x30
      call        write_lcd      
      call        check_busy
      
      movf        dec10,w      
      addlw       0x30
      call        write_lcd      
      
      call        check_busy
      movf        dec1,w
      addlw       0x30
      call        write_lcd      
      
      return
      
 
enter_back_wyjsc_z_opcji_czujniki
      ;czysc ustawienia opcji i zgas bit zmiana_opcji
       
       bcf        pozycja_menu,zmiana_opcji
       call     check_busy
      movlw    linia_gorna
      addlw       0xc
      call      send
      ;
      
      call     check_busy
      movlw       _puste
      call        write_lcd
      
      return
       
procedura_wyswietlania_kolejnych_liczb_zegara
      call  odczytaj_adres_polozenia_gwiazdki
      addlw       0x0c
      call        send
      
      call        check_busy
      
;która litera jest wyświetlana obok cyfr = D - day, H - hours, M - minute, S- seconds      
      movlw       dzien_10
      cpfseq      ustawianie_czasu_co_wyswietlam
      goto        procedura_wyswietlania_kolejnych_liczb_zegara_1
      movlw       _D
      goto        procedura_wyswietlania_kolejnych_liczb_zegara_4
      
procedura_wyswietlania_kolejnych_liczb_zegara_1
      movlw       godziny_10
      cpfseq      ustawianie_czasu_co_wyswietlam
      goto        procedura_wyswietlania_kolejnych_liczb_zegara_2
      movlw       _H
      
procedura_wyswietlania_kolejnych_liczb_zegara_2
      movlw       minuty_10
      cpfseq      ustawianie_czasu_co_wyswietlam
      goto        procedura_wyswietlania_kolejnych_liczb_zegara_3
      movlw       _M
      goto        procedura_wyswietlania_kolejnych_liczb_zegara_4
      
procedura_wyswietlania_kolejnych_liczb_zegara_3     
      ; movlw       sekundy_10
      ; cpfseq      ustawianie_czasu_co_wyswietlam
      ; goto        procedura_wyswietlania_kolejnych_liczb_zegara_1
      movlw       _S
      
procedura_wyswietlania_kolejnych_liczb_zegara_4            
      
      call        write_lcd
      
      clrf        FSR2H
      movf        ustawianie_czasu_co_wyswietlam,w
      movwf      FSR2L      
      
      call        check_busy
      movf        INDF2,w      
      call        write_lcd
      
      call        check_busy
      
      incf        FSR2L,f
      movf        INDF2,w      
      call        write_lcd
      
      call        check_busy
      
      incf        FSR2L,f       
       
      return

      
enter_back_wyjsc_z_opcji_wyswietlanie_liczby
;procedrura analogiczna to tej związanej z obsługą wyświetlania rejestru
      movlw       HIGH tablica_gwiazdki
      movwf       TBLPTRH
      
      movlw       LOW tablica_gwiazdki
      movwf       TBLPTRL
      
      ;poniewaz najpierw zmniejszam polozenie
      
      movf       polozenie_gwiazdki,w
      
      addwf       TBLPTRL,f
      
       ;a nastepnie czytam to uzywam polecenia
      TBLRD *
      
      call        check_busy
      
      movf        TABLAT,w
;teraz należy do adresu lini dodać miejsce położenia cyfry 100
      addlw       0x0b 
      call        send
      
      call        check_busy       
      movlw       _puste
      call        write_lcd      
      call        check_busy
      movlw       _puste
      call        write_lcd      
      call        check_busy
      movlw       _puste
      call        write_lcd      
      call        check_busy       
      movlw       _puste
      call        write_lcd      
      call        check_busy
      movlw       _puste
      call        write_lcd 
      bcf        pozycja_menu,zmiana_opcji
      
      return
;menu wyswietlane w ten sposob, ze na jednym ekranie umieszczone sa cztery opcje
;a do kazdej linii odnosi sie zwiazana z nia tablica nazw opcji
;przy przejsciu do kolejnego ekranu opcji nastepuje zmiana tych opcji na kolejne
      org         1900h
tablica_pierwsza
      db   "pomiar t",0,"odstep",0,"srednia",0,"regulacja",0
      
tablica_druga
      db    "ustaw t",0,"pomiar i" ,0, "wlacz1" ,0, "wlacz2" ,0
tablica_trzecia
      db     "histereza",0,"ustaw moc",0,"zegar",0,"przesyl serial",0

tablica_czwarta
      db     "wyswietl. zegar",0,"wyswietl. temp",0,"podswietlenie",0," - ",0      
;####################  TABLICA POLOZEN gwiazdki

tablica_gwiazdki        
      db    0,linia_gorna,linia_dolna,linia_trzecia,linia_czwarta,1
      
      
 
    
LOOP

      btfss       markers3,dzialanie_po_klawiszu
      goto        LOOP_sprawdz_keys        


      
      btfsc   stan_key,latch_back
      goto    wykryto_back
                  
      btfsc    stan_key,latch_down
      goto     wykryto_down
                           
      btfsc    stan_key,latch_up
      goto     wykryto_up
         
      btfsc    stan_key,latch_enter
      goto     wykryto_enter 
      
;jeżeli zaznaczono że należy zmieniać już wartości to sprawdź które klawisze i które procedury wywołuję      
;      btfss       znaczniki,czy_moge_juz_zmieniac
 ;     goto        
      
      
      
LOOP_sprawdz_keys
      btfss   latch_keys,latch_back
      call    wcisnieto_back
                  
      btfss    latch_keys,latch_down
      call     wcisnieto_down
                           
      btfss    latch_keys,latch_up
      call     wcisnieto_up
         
      btfss    latch_keys,latch_enter
      call     wcisnieto_enter

LOOP11      
      btfsc markers3,odswiezanie_zegara
      goto  napisz_czas
      
LOOP_temperatury      
;jezeli jest ustawiony bit pomiary to sprawdz 
         btfss    markers2,pomiary
         goto     LOOP1

         
;jezeli ustawiony jest bit czy_wlaczyc_ponownie_temp to nawet nie sprawdzaj
            btfsc      markers3,odswiezanie_zegara
            goto        LOOP1   
         
         btfsc    markers,pomiary_zrobione
         goto     LOOP1
         
         btfsc    markers,inicjuj_pomiary
         call     rozpocznij_pomiary
                  
         btfsc    markers2,wyslij_pomiar
         call     wysylanie_pomiaru
LOOP1         
         btfsc    markers2,przerwanie_t1
         call     procedura_obslugi_zegara
         
         btfsc    markers2,sprawdz_odebrane
         call     sprawdz_czy_polecenie


;          btfsc    markers2,wyswietl
;          call     wyswietl_litere
                  
;        btfsc    markers2,blad_transmisji
;        call     wyswietl_error
         
         
         
;        btfsc    markers2,poczatkowy_bit
;        call     poczatek_odbioru
         
LOOP2    
         

         goto     LOOP
         


         
; org    800h
;ta funkcja zlicza nacisniecia klawisza rb0ółńżą
;funkcja odczekuj?ca



         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;POCZATEK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;       
         ;org      0800h    


                
inicjacja
         ;ulamek 0,25 - tzn 1 
          ;movlw    0x0
          ;movlw   numer_opcji_koncowej
          ;movwf   
          ;movwf    tmp
          ;decf    tmp,f
          ;bsf   tmp,(menu_opcje_end)
          ;btfss   STATUS,C
          ;incf    tmp,f
;          
;          addlw    0xc3
         ;movwf    tmp7
         ;mnoze 2,5 * 0x30 tzn 
         ;movlw    0x30
         ;ulamek
         ;mulwf    tmp
         ;movf     PRODH,w
         ;movwf    dec10
         ;movf    PRODL,w
         ;movwf    dec1
         
         ;movlw    0x30
         
         
         ;mulwf    tmp7
         
         
         clrf    STATUS ;czyszcze status
         ;movlw    
         ;clrf    czas;
         clrf     PORTA
         clrf     PORTB
         clrf     PORTC
          clrf     PORTD
         clrf     PORTE
         clrf     LATA
         clrf     LATB
         clrf     LATC
         clrf     LATD
         clrf     LATE
;przerwania kompatybilne z 16fxx
         bsf      RCON,IPEN         
         
;ustawiam TMR1
                                    ;Timer 1 ustawiony jako 1/16 sekundy
         movlw    b'00000001'
         movwf    T1CON
;pzrerwania
         clrf     INTCON
         bsf      INTCON,GIE
         bsf      INTCON,PEIE
         
         
         clrf     INTCON3
         movlw    b'10000000'
         movwf    INTCON2
         bcf     INTCON,TMR0IE
         bcf      TRISE,PSPMODE
         bcf      SSPCON1,SSPEN
         BCF      RCSTA,SPEN
         
         ;ustawienia comparatora
         movlw    b'00000000'
         movwf    CVRCON
         ;komparator wylaczony
         movlw    b'00000111'
         movwf    CMCON
         ;movlw   b'00000000'       ;wszystkie linie na wysoko
         ;ovwf    PORTB
         
CCP_init         
         movlw    0
         movwf    CCP1CON
         movwf    CCP2CON
         ;BCF     
         clrf     TMR2
         
Timer3_init                                                 ;ustawienie zegara tmr3
            movlw       b'01100001'
            movwf       T3CON
         
         
BEGIN2lcd_init
         ;bsf      STATUS,RP0        ;bank 1
         clrf     PIE1
         clrf     PIE2
         bsf      PIE1,TMR1IE
         
     ;ustawiam na wyjscia 1 -wejscie
        ;movlw   b'11111111'
         
         movlw    b'00111111'
         movwf    TRISA
         
IF (czy_ekran==1)
         movlw   b'11100000'
         movwf    TRISB
ENDIF

IF (czy_ekran==0)
         movlw   b'11111111'
         movwf    TRISB
ENDIF

        movlw   b'10100000'
         movwf    TRISC
         
;tu sie zminienia dla kabli
        ;movlw   b'11111111'
IF (czy_ekran==1)        
         movlw    normalne_ustawienie_tris_lcd
         movwf    TRISD
ENDIF
         
IF (czy_ekran==0)
         movlw    0x0F
         movwf    TRISD
ENDIF
         
         movlw   b'00000111'
         movwf    TRISE
         
         
;ustawienia timera 0
         movlw    b'11000111'
         movwf    T0CON
 ;dopiero teraz w??cz zegar
         


;90  czyli 5a
;50      32
;210(200us) d2
;196(190us) c4    
;        movlw    b'11010010'
         movlw    0x80
         movwf    PR2
         
;bank 0
         ;bcf      STATUS,RP0
;        movlw    b'01000000'
;        movwf    ADCON0
         
;ustawiam TMR2 z licznikiem 1:1
         
;wyczyscic trzeba pamiec na zmienne
;jezeli tego nie zrobie to
;po wlaczeniu zasilani moga pojawic
; sie problemy bo moga tam byc losowe dane
;od 000 do f7f
         movlw    0x80
         movwf    FSR0L
         clrf     FSR0H
next
         ;movlw   0
         clrf     INDF0
         INCF     FSR0L,f
         ;movlw    0ffh
         
         btfss    STATUS,C
         goto     next
         
         incf     FSR0H,f
         movlw    b'00000010' ;02 banki
         xorwf    FSR0H,w
         BTFSS    STATUS,Z
         ;btfss    FSR0H,4
         goto     next
         
         goto     test_koniec
;w przyadku testowania

         movlw    dane_odebraneL
         movwf    FSR0L
         movlw    dane_odebraneH
         movwf    FSR0H
         
        
        movlw      HIGH(tab_test)
        movwf     PCLATH
test_petla        
         
         
        
        ;movf      PCLATH,w,0
         movf     tmp,w
         call     tab_test
         
         
         
         movwf    INDF0
         xorlw    0
         btfsc    STATUS,Z
         goto     test_regulator
         incf     tmp,f
         incf     tmp,f
         incf     FSR0L,f
         goto     test_petla
         
         
tab_test
         addwf    PCL,f
         ;retlw    0x2a
         
         ;retlw    0x43
         ;retlw    0x46
         ;retlw    0x0d
         retlw    _star
         ;retlw    _wiekszosci
         ;retlw    _P     
         retlw    _p
         ;retlw    _1
         
         retlw    0x30
         ;retlw    _
         
         ;retlw    _F
         ;retlw    _
         ;retlw    _F
         retlw    0x32
         ;retlw    _kropka
         retlw    0x30
         retlw    0x36
         ;retlw    _e
         ;retlw    0x34
         ;retlw    0x30
         ;retlw    _A
         ;retlw    0x30
         ;retlw    0x37
         retlw    0
         
         
test_regulator
      ;bsf      markers2,sprawdz_odebrane
         ;goto     test_koniec
         
         movlw    1
         movwf    ile_kanalow
         
         movlw    0
         movwf    ktory_kanal_mierze
         
         ;movwf     ktore_dzielenie_przez2
         
         movlw    0x01
         movwf    jak_duzo_probek
         
         movlw    0x04
         movwf    odstep_pomiarowy
         movlw    0x04
        movwf    aktualny_odstep
         
         
         bsf       markers,czy_usrednianie
         bsf      markers2,pomiary
         bsf      markers,pomiary_zrobione
         bsf      markers,czy_wyswietlam_temp
         ;
         movlw    0x01
         movwf    ADCON0   
               
         movlw    0xf
         movwf    odebrano_liter
         movlw    0xff
         movwf    linia1
         movlw    0xf0
         movwf    linia2
         movlw    0x11
         movwf    znaczniki
         
         
         
         
test_koniec
         
         ;bcf      PCLATH,3
         ;bcf      PCLATH,4
         clrf     PCLATH
         goto    Start
                  
;test ustawiania probkowania
;0x2a 0x93 probka         


         end
