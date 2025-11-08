list p=18f1220
include  "p18f1220.inc"

         ;__CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CPD_OFF & _WRT_ENABLE_OFF & _CP_OFF & _DEBUG_OFF
         __CONFIG _XT_OSC & _WDT_OFF & _PWRTE_ON & _BODEN_OFF & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF & _DEBUG_OFF

;definicje są w odzielnym pliku

include "def_var.h"

;poczatek programu - tzn inicjacja ekranu    

;ten program odbiera dane korzystajac z modulu obslugi USART
;w procesorze

;jest to "karta2" zbioru danych z 1 czujnika temp LM35
;dodatkowo jest tez komunikacja z ds1820

;PORTB -0 
;PORTB -1 TX
;PORTB -2 
;PORTB -3 - port migajacej lampki
;PORTB -4 CX
;PORTB -5
;PORTB -6
;PORTB -7         

;PORTA - 0 - 
;PORTA - 1 - 
;PORTA - 2 - 
;PORTA - 3 - 
;PORTA - 4 -  


         org      0000h
BEGIN
         bsf      PCLATH,3
         bcf      PCLATH,4
         
         goto     inicjacja
                  
         
         org      0004h
         
przerwanie        
;zachowuje rejestr W
         movwf    w_temp
;zachowuje rejestr STATUS
         swapf    STATUS,w
         clrf     STATUS
         ;movf    STATUS,w
         movwf    status_temp
         movf     PCLATH,w
         movwf    pclath_temp
         clrf     PCLATH
         movf     FSR,w
         movwf    fsr_temp
         
;po to by wszystkie ustawienia banki itd byly na 0    
         bsf      STATUS,RP0
         btfss    PIE1,RCIE
         goto     przerwanie_1
         
         bcf      STATUS,RP0
         btfsc    PIR1,RCIF
         goto     wykryto_odbior    

przerwanie_1      
         bsf      STATUS,RP0
         
         btfss    PIE1,TMR1IE
         goto     przerwanie_2
         
         bcf      STATUS,RP0
         btfsc    PIR1,TMR1IF
         goto     wykryto_t1

przerwanie_2      
         bsf      STATUS,RP0
         
         btfss    PIE1,TXIE
         goto     przerwanie_3
         
         bcf      STATUS,RP0
         btfsc    PIR1,TXIF
         goto     przerwanie_wysylania
         
przerwanie_3      
         bsf      STATUS,RP0
         
         btfss    PIE1,ADIE
         goto     przerwanie_4
         
         bcf      STATUS,RP0
         btfsc    PIR1,ADIF
         goto     przerwanie_pomiaru
         
przerwanie_4
         bsf      STATUS,RP0
         
         btfss    PIE1,TMR2IE
         goto     przerwanie_5
         
         bcf      STATUS,RP0
         btfsc    PIR1,TMR2IF
         goto     wykryto_t2
przerwanie_5


         ;        btfsc    INTCON,RBIF
;        goto     wykryto_rb
         
;        btfsc    INTCON,T0IF
;        goto     wykryto_t0
         
;        btfsc    PIR1,TMR2IF
;        goto     wykryto_t2
         
;        btfsc    PIR1,TMR2IF
;        goto     wykryto_t2
         
wyjscie_przerwanie
         movf     pclath_temp,w
         movwf    PCLATH
         swapf    status_temp,w
         movwf    STATUS
         swapf    w_temp,f
         swapf    w_temp,w
         movf     fsr_temp,w
         movwf    FSR
;        bsf      INTCON,GIE
;        bsf      
         retfie
         
wykryto_t1
         bcf      PIR1,TMR1IF
         bsf      markers2,przerwanie_t1
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

         
wykryto_t2
;uzywam do wykrywania czy juz zrobic pomiar
         bcf      PIR1,TMR2IF
         
;jezeli tesuje czas     
         bcf     PORTC,2         
         bsf      STATUS,RP0
         bcf     PIE1,TMR2IE
         bcf      STATUS,RP0
         bcf      T2CON,TMR2ON
             
         
         bsf      ADCON0,2 
         clrf     pomiar0H
         clrf     pomiar0L
         clrf     pomiar0_ulamek
;        btfss    markers2,
;        goto     wyjscie_przerwanie
         
;        bsf      markers2,odbierz_bit
        goto     wyjscie_przerwanie

wykryto_odbior
;        btfsc    odebrano_liter,4
         
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
         addlw    0xa0
         movwf    FSR
         
         movf     RCREG,w
         movwf    INDF
;jezeli blad transmisji to nie zapamietuj         
;          btfsc    markers2,blad_transmisji
;          goto     wykryto_odbior_odczyt_dalej  
;          
         
         
         
         movlw    0x0a
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     wykryto_odbior_CR
         
;        movlw    0x0a
;        xorwf    INDF,w
;        btfss    STATUS,Z
        incf     odebrano_liter,f
         
         goto     wyjscie_przerwanie
;        goto     wykryto_odbior_wyjscie
;        
         
;        movlw    0x0A
;        xorwf    INDF,w
;        btfss    STATUS,Z
;        goto     wykryto_odbior_wyjscie
         
                  
wykryto_odbior_CR 
;sprawdz czy pierwszym znakiem jest *
         
         bsf      markers2,sprawdz_odebrane
;        clrf     odebrano_liter
;        movf     RCREG,w
;        movwf    INDF
;        
;        czysc dwa bwyswietlajty na zero -> znacznik konca wyswietlania         
;        
         
        movlw     0x0d
         movwf    INDF
          
        incf    FSR,f
        movwf    INDF
        incf    FSR,f
        clrf     INDF
         incf    FSR,f
        clrf     INDF
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
         movlw    pomiar0H
;        addwf    ktory_rejestr_zapisuje,w
         movwf    FSR
         movf     ADRESH,w
         movwf    INDF
         incf     FSR,f
         bsf      STATUS,RP0
         movf     ADRESL,w
         bcf      STATUS,RP0
         movwf    INDF
         bsf      markers2,wyslij_pomiar
;nastepnym razem zapisze do kolejnego rejestru        
;        incf     ktory_rejestr_zapisuje,f
         goto     wyjscie_przerwanie
                  
;;;;;;;;;;;;;;;;;;;;;;;;
;;;PROGRAM
;;;;;;;;;;;;;;;;;;;;;;;;;
include  "../libs/lcd.h"

include  "../libs/lcd8bit.asm"

include  "../libs/dziel_przez2.asm"

Start
         ;przesuwam kursor o 4 znaki
;        movlw    2
;        addlw    0x0f
         call     lcd_init
         call     check_busy
         call    cmd_off
         
         
;        call     check_busy
         movlw   linia_gorna
         call    send
         
;        movlw    linia_dolna
;        movlw   linia_trzecia
         ;gorna
         
;        call     wyswietl_error
;konfiguruje port szeregowy
;ustawiam baud rate
         bsf      STATUS,RP0
         bcf      STATUS,RP1
;        movlw    0x1a
         movlw    0x1a
         movwf    SPBRG
         clrf     TXSTA
         bsf      TXSTA,BRGH
         bsf      TXSTA,TXEN
         
;wlaczam przerwanie szeregu
         bsf      PIE1,RCIE
;        bsf      PIE1,TXIE
         bcf      STATUS,RP0
         movlw    b'10010000'
         movwf    RCSTA
         
         

         movlw    0
         movwf    ktory_rejestr_zapisuje
                  
         movlw    0x04
         movwf    jak_duzo_probek
         
         movwf   ktora_probka
         bsf      markers,czy_usrednianie
;          call     show_word
;jezeli cos testuje        
;        movlw    0xa0
;        movwf    INDF
         
         
         goto     LOOP
         
show_word
         ;addlw   01h
;1 znak od pocz?tku
         
         
        
         
                  
         
show_word2
         
         
;ustaw czwarta linie ekranu
;        movlw    linia_gorna
;        call     send
         
show_word2_dalej
         call     check_busy
         movf     linia1,w
         incf     linia1,f
;druga strona pamieci tAM umieszczam wszystkie slowa menu
         
         call     Powitanie
         
;je?eli przeczytał 0 to kończ wyświetlanie
         xorlw    0
         btfsc    STATUS,Z
         goto     show_end

         movwf    port_lcd
         call     write_lcd

         goto    show_word2
show_end
         
;        movf     linia1,w
         
show_end2
         call     cmd_off
         clrf     port_lcd
         ;bcf     PCLATH,0
         return
         ;goto    LOOP


         ;call    Tab_menu0
;;;;;;;;;;;;;;ZBIOR NAPISÓW


         
tab_h_zew
         addwf    PCL,f
         retlw    0
         retlw    9
         retlw    0x11
         retlw    0x15

Powitanie
         addwf    PCL,f
         retlw    _w
         retlw    _y
         retlw    _s
         retlw    _L
         retlw    _i
         retlw    _j
         retlw    _puste
         retlw    _z
         retlw    _n
         retlw    _a
         retlw    _k
         retlw    _i
         retlw    0

menu_linia1 
         movlw    linia_gorna
         call     clear_line
         call     check_busy
         movlw    linia_gorna
         goto     show_word
         
 ;gdy cos pisze na linii drugiej
menu_linia2
         movlw    linia_dolna
         call     check_busy
         movlw    linia_dolna
         goto     show_word
         
czy_mierzyc_wysylac
         decfsz   aktualny_odstep,f
         return
;dokonuj pomiaru  na pierwszym kanale
;wlaczam tez przerwanie analogowego pomiaru
         movf     odstep_pomiarowy,w
         movwf    aktualny_odstep
;wlacz przerwanie jak skonczy mierzyc zeby wyslac
;wystarczy ze 000 do bitow kanalu
         movf    jak_duzo_probek,w
         movwf   ktora_probka
         movwf   ktore_dzielenie_przez2
         movf     ADCON0,w
         andlw    b'11000111'
         movwf    ADCON0
         bsf      STATUS,RP0
         bcf      STATUS,RP1
;        movlw    0x1a
         bsf      PIE1,ADIE
         bcf      STATUS,RP0    
;rozpocznij pomiar
         clrf     TMR2
         bsf    T2CON,TMR2ON
        
;tzn wlaczam przerwanie TMR2
         bsf      STATUS,RP0
         bsf     PIE1,TMR2IE
         bcf      STATUS,RP0
;przetestowanie czy dobry czas  
;          bsf     PORTC,2             
         bcf      markers2,wyslij_pomiar 
        return    
         
miganie  
;odznacz markers
         btfsc    markers2,pomiary
         call     czy_mierzyc_wysylac
         
         bcf      markers2,przerwanie_t1
         
         btfss    portlampka,lampka
         goto     zapal    
         bcf      portlampka,lampka
                  
         return
zapal    
         bsf      portlampka,lampka
         return

zapal_lampke
         btfss    portlampka2,lampka2
         goto     zapal_lampke2     
         bcf      portlampka2,lampka2
                  
         goto     powrot_z_polecen
zapal_lampke2
         bsf      portlampka2,lampka2
         goto     powrot_z_polecen

linie_1_3
         movlw    linia_gorna       
         btfsc    INDF,1
         addlw    0x10
         goto     czysc_linie2      
         
czysc_linie
         incf     FSR,f
         movlw    0x30
         subwf    INDF,f
;jezeli linie     1 i 3    tzn sa bity 01 lib 11
         btfsc    INDF,0
         goto     linie_1_3
;linie_2 lub 4    
         movlw    linia_dolna
         btfsc    INDF,2   
         addlw    0x10
czysc_linie2      
         call     clear_line
         clrf     linia2
         goto     powrot_z_polecen
         
         return


sumuj_liczby
         clrf     liczba2
         clrf     liczba1
         
         incf     FSR,f
         
sumuj_liczby_do_kropki     
         
         movlw    0x30
         subwf    INDF,w
         addwf    liczba1,f         
;sprawdz czy przekroczono bajt
         btfsc    STATUS,C
         incf     liczba2,f
                           
         incf     FSR,f
         movlw    _kropka
         xorwf    INDF,w
         btfsc    STATUS,Z
         incf     FSR,f
         
         movlw    0x0a
         xorwf    INDF,w
         btfss    STATUS,Z
         goto     sumuj_liczby_do_kropki     

;zapisz  cyfra
         
         ;call     wyswietlanie_liczby
         goto     powrot_z_polecen

sprawdz_czy_mozna_wysylac
         bsf      STATUS,RP0
TMR_nie_pusty     
         btfss    TXSTA,TRMT
         goto     TMR_nie_pusty     
         bcf      STATUS,RP0
TXREG_nie_pusty   
         btfss    PIR1,TXIF
         goto     TXREG_nie_pusty
         return   
         
wyslij_znak
;sprawdz czy USART transmit buffer jest pusty
         movlw    0x9f
         movwf    FSR
wyslij_znak_petla 
         call     sprawdz_czy_mozna_wysylac
;laduje dane do wyslania   
         incf     FSR,f
         
;        movf     INDF,w
;        call     write_lcd
;        call     check_busy
         
         movlw    0x0d
        xorwf    INDF,w
         btfsc    STATUS,Z
         goto     wyslij_znak_koniec
         
         movf    INDF,w
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
         
         decf     FSR,f
;        call     sprawdz_czy_mozna_wysylac
;        movlw    znak_lf
;        movwf    TXREG
         
         goto     powrot_z_polecen

kopiuj_liczbe_przeslana
;procedura dziala na tej zasadzie
;ze znaki 0123456789;:<=>?
;wysłane na ekran 
;po odjeciu 0x30 sa 4bitami liczby
;pierwszy znak jest wyzszym bajtem
;drugi znak nizszym
         incf     FSR,f
         movlw    0x30
         subwf    INDF,w
;mamy w INDF liczbe od 0 do 15      
;sprawdz czy nic teraz sie nie sciaga
         movwf    tmp
         
         swapf    tmp,f
         incf     FSR,f
         movlw    0x30
         subwf    INDF,w
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
         bsf      STATUS,RP0
         bcf      STATUS,RP1
;        movlw    0x1a
         movwf    SPBRG    
         bcf      STATUS,RP0
         goto     powrot_z_polecen

pokaz_rejestr     
         movlw    linia_czwarta
         call     send
         call     check_busy
         call     kopiuj_liczbe_przeslana
;przechowuje fsr gdzies    
         movf     FSR,w
         movwf    fsr_temp
         movf     tmp,w
         movwf    FSR
;        movf     INDF,w
;teraz rodzielam bajt na 4 bity starsze i 4 bity mlodsze
         swapf    INDF,w
         andlw    0x0f
         addlw    0x30
         call     write_lcd
         call     check_busy
         movf     INDF,w
;robiac taka operacje kasuje starszy bajt na 3 a mlodszy bez zmian      
         andlw    0x0f
         addlw    0x30
         call     write_lcd
         call     check_busy
         movf     fsr_temp,w
         movwf    FSR
         goto     powrot_z_polecen

;polecenie wysyla na ekran znak zapisany 16->nastkowo          
wyslij_na_ekran
         movlw    linia_trzecia
         call    send
         call     check_busy
         call     kopiuj_liczbe_przeslana
         movf     tmp,w
         call     write_lcd
         call     check_busy
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
         incf     FSR,f
         movlw    0x30
         subwf    INDF,w
         btfsc    STATUS,Z
         goto     wylacz_pomiary
         movwf    ile_kanalow
         movwf    ktory_kanal_mierze
;sprawdz czy liczba kanalow nie jest wieksza od 7
;jezeli od ile_kanalow odejme 8 i nie wyjdzie bit C
;tzn pozyczki to przyjmij 0x07
         sublw    0x07          
         btfss    STATUS,C
         goto     zle_polecenie
;jezeli nie ma kropki to koncz         
         incf     FSR,f
         movlw    _kropka
         xorwf    INDF,w
         btfss    STATUS,Z
         goto     powrot_z_polecen
;odbierz kolejne cyfry
        
         call     kopiuj_liczbe_przeslana
         movf     tmp,w                         
         movwf    odstep_pomiarowy
         movwf    aktualny_odstep
;wlacz analog/cyfre
         movlw    b'10000001'
         movwf    ADCON0
         bsf      markers2,pomiary
         bcf      portlampka2,lampka2
         clrf     TMR2
         movlw    b'00000000'
         movwf    T2CON
         movf    jak_duzo_probek,w
         movwf   ktora_probka
         movlw    linia_trzecia
         call     send
         
         goto     powrot_z_polecen    

wylacz_pomiary
         movlw    b'00000000'
         movwf    ADCON0
         bcf      markers2,pomiary
          bcf     markers2,wyslij_pomiar
          bcf     portlampka2,lampka2
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
         
         incf     FSR,f
         movlw    0x30
         subwf    INDF,w
;         btfsc    STATUS,Z
;         goto     wylacz_regulator
         
        movwf    jaka_wartosc_regulujeH
         call     kopiuj_liczbe_przeslana
         movf     tmp,w 
         movwf    jaka_wartosc_regulujeL
         
         bsf      markers2,reguluj
         goto     powrot_z_polecen    

ustaw_probki
         bcf      markers,czy_usrednianie
         call     kopiuj_liczbe_przeslana
         movf     tmp,w
         movwf    jak_duzo_probek
         
         movwf   ktora_probka
;sprawdz czy usredniamy czy nie tzn czy wartosc jak_duzo_probek < 2
         sublw    1
         btfsc    STATUS,C
         goto     powrot_z_polecen
         bsf      markers,czy_usrednianie
         goto     powrot_z_polecen

sprawdz_czy_polecenie                  
;sprawdz czy odebrano 'znak_cr'
         movlw    0xa0
         movwf    FSR      
         
         movlw    _star
         xorwf    INDF,w
         btfss    STATUS,Z
         goto     powrot_z_polecen
         
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
;        *#xx - pokaz zawartosc rejestru xx (podobnie jak powyzej)
;        *S00 - ustawienie ilosci probek na jeden pomiar
;        
;zacznij robic
;sprawdzam czy
         incf     FSR,f
         
         movlw    _L
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     zapal_lampke
         
         movlw    _C
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     czysc_linie
         
         movlw    _plus
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     sumuj_liczby
;*> - znak wysylania       
         movlw    0x3e
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     wyslij_znak
;**         
         movlw    _star
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     ustaw_spbrg
;*# - pokaz komorke pamieci         
         movlw    0x23
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     pokaz_rejestr
;*P -> pomiar     
         movlw    _P
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     inicjuj_pomiar
;*e -> wyslij na ekran     
         movlw    _e
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     wyslij_na_ekran

;*r ->Reguluj
         movlw    _R
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     ustaw_regulator
         
;*S ->probki
         movlw    _S
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     ustaw_probki
                           
powrot_z_polecen           
;        movlw    _up
         incf     FSR,f
         bcf      markers2,sprawdz_odebrane
         clrf     odebrano_liter
         bsf      RCSTA,CREN
;        clrf     FSR
;        movwf    INDF
         return
         

wyswietl_litere_dalej
         incf     FSR,f
         goto     wyswietl_litere_petla      
         
wyswietl_litere
          movlw    linia_gorna
          call     send
          call     check_busy
         
          movf     odebrano_liter,w
          addlw    0x30
          movwf    port_lcd
         
          call     write_lcd
          call     check_busy                  
wyswietl_litere_petla
         movlw    0x0d
         xorwf    INDF,w
         btfsc    STATUS,Z
         goto     koniec_wyswietlania        
         
;sprawdz czy odebrano pusty znak...
;        movlw    0x0a
;        xorwf    INDF,w
;        btfsc    STATUS,Z
;        goto     koniec_wyswietlania        
         
         movf     INDF,w
         btfsc    STATUS,Z
         goto     koniec_wyswietlania
;sprawdzam czy jest gwiazdka bo wtedy 
; jest to rozkaz  
;ale tylko gdy jest to pierwszy znak odebrany
         movf     odebrano_liter,w
         btfss    STATUS,Z
         goto     wyswietl_litere_petla2
         
         
;        goto     koniec_wyswietlania

wyswietl_litere_petla2     
         movlw    linia_dolna
         addwf    linia2,w
         call     send
         call     check_busy
         movf     INDF,w
         call     write_lcd
         call     check_busy
;        clrf     odebrana_litera
         incf     linia2,f
         
;        movlw    0A
;        xorwf    linia2
         btfsc    linia2,4
         clrf     linia2
         
;        decfsz   odebrano_liter,f
         goto     wyswietl_litere_dalej
         
koniec_wyswietlania        
         clrf     odebrano_liter
;          bcf      markers2,wyswietl
         bsf      RCSTA,CREN
         return
         


usrednianie_wartosci
;oblicz srednia dzielac za pomoca ilosc probek pobieranych
         ;movf     pomiar0H,w
         ;movwf    wynikh
         ;movf     pomiar0L,w
         ;movwf    wynik     
        movf    jak_duzo_probek,w
        movwf   ktore_dzielenie_przez2
        clrf      wynik01
petla_dzielenia  
         
        call     dzielenie_przez_przesuwanie
;mam na poczatku w ktore dzieleni_przez2 b'10000000'
;po jednym dzieleniu mam b'01000000'

        rrf     ktore_dzielenie_przez2,f
        btfss   ktore_dzielenie_przez2,0
        goto     petla_dzielenia
         movf     wynik01,w
         addwf    pomiar0_ulamek,f
         btfsc    STATUS,C
         incf     pomiar0L,f

         movf     wynik,w
         addwf    pomiar0L,f
         btfsc    STATUS,C
         incf     pomiar0H,f
        
         movf     wynikh,w
         addwf    pomiar0H,f
         return
         
znow_kaz_mierzyc
         bsf      STATUS,RP0
         bcf      STATUS,RP1
;        movlw    0x1a
         bsf      PIE1,ADIE
         bcf      STATUS,RP0
         bsf      ADCON0,2 
         bcf      markers2,wyslij_pomiar                
         return
          
;na koniec dodaj do pomiar0H i pomiar0L i pomiar0_ulamek

wysylanie_pomiaru
;wyswietl tekst na 3 linii ekranu
         btfss    markers,czy_usrednianie
         goto     juz_wysylac
         
         call     usrednianie_wartosci

         decfsz   ktora_probka,f
         goto     znow_kaz_mierzyc
         ;return        
juz_wysylac
;przed wyslaniem pomiaru ulamki > 0x80 (tzn od 0.5 ) zamieniam na +1 do pomiar0L 
;w przeciwnym wypadku pomijam
         movlw    0x80     
         subwf    pomiar0_ulamek,w
         btfss    STATUS,C
         goto     wyslij_starszy
         incf     pomiar0L,f
         btfsc    STATUS,Z
         incf     pomiar0H,f
wyslij_starszy
;przed wysylaniem pomiaru wylaczam modul odbioru
         bcf      RCSTA,CREN
         call    sprawdz_czy_mozna_wysylac
         call     check_busy
         movf     pomiar0H,w
         addlw    0x30
         movwf   TXREG    
           
         call     write_lcd
         
         call    sprawdz_czy_mozna_wysylac
         call     check_busy
         swapf    pomiar0L,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG
         
         call     write_lcd     
         
         call    sprawdz_czy_mozna_wysylac
         call     check_busy
         movf     pomiar0L,w
         andlw    0x0f
         call     zamien_na_hex
         movwf   TXREG     
         call     write_lcd

         call    sprawdz_czy_mozna_wysylac
         call     check_busy
         movlw    _przecinek
        
         movwf   TXREG     
         call     write_lcd
         call    sprawdz_czy_mozna_wysylac
         bcf      markers2,wyslij_pomiar
         bsf      RCSTA,CREN
;sprawdz czy aktualnie mam regulowac
         btfss    markers2,reguluj
         goto     sprawdz_czy_mam_dalej_mierzyc
;porownaj wartosc pomierzona z zadana
                  
         movf     jaka_wartosc_regulujeH,w
         subwf    pomiar0H,w
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
         subwf    pomiar0L,w
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
         decfsz   ktory_kanal_mierze,f
         goto     zmierz_nastepny_kanal
;tzn juz wszystkie kanaly
         movf     ile_kanalow,w
         movwf    ktory_kanal_mierze
;jezeli juz skonczylem wszystkie mierzyc to sprawdz czy mam wlaczyc grzanie
;jezeli ustawiono bit o nie wlaczaniu to olej
         btfsc    markers2,wylacz_moc
         goto    wylaczam_moc
         
         btfss    markers2,zalacz_moc
         goto    wylaczam_moc
         
         btfss    portlampka2,lampka2
         bsf      portlampka2,lampka2
         
         goto    koncz_z_moca
wylaczam_moc
         bcf      portlampka2,lampka2
         
koncz_z_moca
   
         
         bcf      markers2,zalacz_moc
         bcf      markers2,wylacz_moc
          
;jezeli moc zalaczona wyslij 1,
;jezeli wylaczona wyslik 0,
         bcf      RCSTA,CREN
         call    sprawdz_czy_mozna_wysylac
         
         btfsc    portlampka2,lampka2
         movlw    0x31
         
         btfss    portlampka2,lampka2
         movlw    0x30
         
         movwf   TXREG
         ;wysylam znak konca linii
         call    sprawdz_czy_mozna_wysylac
         movlw    znak_lf
         movwf   TXREG
         movlw    linia_trzecia
         call     send
;wylacz wysylanie pomiaru           
         
         call    sprawdz_czy_mozna_wysylac
;wlacz odbior
         bsf      RCSTA,CREN        
          
         return         
                  
zmierz_nastepny_kanal
         movf     jak_duzo_probek,w
         movwf    ktora_probka
         movf     ADCON0,w
;musze zwiekszyc o jeden ten wycinek bitowy
;b'xx000xxx' - czyli nawet nie starszy 4 bit
;tylko cos w srodku
;aby to zrobic stosuje prosty wybieg + 8 do ADCON0
         addlw    8
         movwf    ADCON0
         movlw    b'00111000'
         andwf    ADCON0,w
         xorlw    b'00011000'
         btfss    STATUS,Z
         goto     zmierz_nastepny_nie_3
         movlw    8
         addwf    ADCON0,f
zmierz_nastepny_nie_3
;wlaczam pomiar i przerwanie
         bsf      STATUS,RP0
         bcf      STATUS,RP1
;        movlw    0x1a
         bsf      PIE1,ADIE
         bcf      STATUS,RP0    
;rozpocznij pomiar      
;wedlug opisu procka tu trzeba czekac okolo 20-30us  
;dla pewnosci bede czekal 120us wykozystujac TMR2
;czyszcze obecny TMR2
         clrf     pomiar0H
         clrf     pomiar0L
         clrf     pomiar0_ulamek
         clrf     TMR2
         bsf    T2CON,TMR2ON
        
;tzn wlaczam przerwanie TMR2
         bsf      STATUS,RP0
         bsf     PIE1,TMR2IE
         bcf      STATUS,RP0
;przetestowanie czy dobry czas  
         bsf     PORTC,2         
         
         return   
         
         
LOOP
         btfsc    markers2,przerwanie_t1
         call     miganie
         
         btfsc    markers2,sprawdz_odebrane
         call     sprawdz_czy_polecenie         


;          btfsc    markers2,wyswietl
;          call     wyswietl_litere
                  
;        btfsc    markers2,blad_transmisji
;        call     wyswietl_error
         
         btfsc    markers2,wyslij_pomiar
         call     wysylanie_pomiaru
         
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
         org      0800h    


                
inicjacja

         clrf    STATUS ;czyszcze status
         
         ;clrf    czas;
         clrf     PORTA
         clrf     PORTB
         clrf     PORTC
         clrf     PORTD
         clrf     PORTE
        
;ustawiam TMR1
         movlw    b'00110001'       
         movwf    T1CON
;pzrerwania
         clrf     INTCON
         bsf      INTCON,GIE
         bsf      INTCON,PEIE
         
         bcf     INTCON,T0IE
         bcf      TRISE,PSPMODE
         bcf      SSPCON,SSPEN
         BCF      RCSTA,SPEN
         
         ;movlw   b'00000000'       ;wszystkie linie na wysoko
         ;ovwf    PORTB
         movlw    0
         movwf    CCP1CON
         ;BCF     
         clrf     TMR2
BEGIN2lcd_init
         bsf      STATUS,RP0        ;bank 1
         clrf     PIE1
         clrf     PIE2
         bsf      PIE1,TMR1IE
         
     ;ustawiam na wyjscia 1 -wejscie
        ;movlw   b'11111111'
         
         movlw    b'00101111'
         movwf    TRISA
         
         movlw   b'11110000'
         movwf    TRISB
                  
        movlw   b'11111010'
         movwf    TRISC
         
;tu sie zminienia dla kabli
        movlw   b'00000000'
         movwf    TRISD
         
         movlw   b'00000111'
         movwf    TRISE
         
         
;ustawienia timera
         bsf     OPTION_REG,PS0
         bsf      OPTION_REG,PS1
         bsf      OPTION_REG,PS2    ;1:256
         bcf      OPTION_REG,PSA
;prescaling dla Timer0
         bcf     OPTION_REG,T0CS
         
 ;dopiero teraz w??cz zegar
         
;tu ustawiam napiecia referencyjne jako AN3 i Vss 
;wszystkie 
         movlw    b'10000001'
         movwf    ADCON1
;90  czyli 5a
;50      32
;210(200us) d2
;196(190us) c4    
;        movlw    b'11010010'
         movlw    0x80
         movwf    PR2
         
;bank 0
         bcf      STATUS,RP0
;        movlw    b'01000000'
;        movwf    ADCON0
         
;ustawiam TMR2 z licznikiem 1:1
         
;wyczyscic trzeba pamiec na zmienne
;jezeli tego nie zrobie to
;po wlaczeniu zasilani moga pojawic
; sie problemy bo moga tam byc losowe dane

         movlw    0x20
         movwf    FSR
next
         ;movlw   0
         clrf     INDF
         INCF     FSR,f
         movlw    07fh
         xorwf    FSR,w
         BTFSS    STATUS,Z
         goto     next
         
         
         
         
         movlw    0a0h
         movwf    FSR
next2
         clrf     INDF
         INCF     FSR,f
         movlw    0ffh
         xorwf    FSR,w
         BTFSS    STATUS,Z
         goto     next2
         
         goto     test_koniec
;w przyadku testowania

         movlw    0xa0
         movwf    FSR
         
test_petla        
         
;        movlw    0x08
;        movwf    PCLATH
         movf     tmp,w
         call     tab_test
         
         btfsc    STATUS,Z
         goto     test_koniec
         movwf    INDF
         incf     tmp,f
         incf     FSR,f
         goto     test_petla
         
         
tab_test
         addwf    PCL,f
         retlw    0x2a
         retlw    _S
         retlw    0x30
         retlw    0x31
         ;retlw    0x52
         ;retlw    0x31
         ;retlw    0x30
         ;retlw    0x36
         retlw    0

test_regulator
         movlw    4
         movwf    ile_kanalow
         movlw    01
         movwf    ktory_kanal_mierze
         
         movlw    0x2
         movwf    odstep_pomiarowy
        movwf    aktualny_odstep
         bsf      markers2,pomiary
         movlw    0x01
         movwf    ADCON0         
test_koniec
         
         bcf      PCLATH,3
         bcf      PCLATH,4
         
         goto    Start
                  
;test ustawiania probkowania
;0x2a 0x93 probka         


         end
