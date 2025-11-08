

        cblock  0x60
        
        
        W_TEMP
        status_temp
        bsr_temp
        ilosc_zliczen_tmr2
        ilosc_zliczen_tmr3
         
         
         tmp
         n
         dane_lcd
         tmp_lcd
         
        zliczenia_przerwania_TMR0
        
        stan_key
        
         ; markers
	    
	markers_klawisze
         
;menu
         opcja_menu     ; zmienna przechowuj¹ca opcjê przy której jest gwiazdka
         
         polozenie_gwiazdka
         
         znaczniki_klawiszy_menu
         
         stan_menu

        wartosc_opcji1
         wartosc_opcji2
         wartosc_opcji3
         wartosc_opcji4
         wartosc_opcji5

        
       	dec100
	dec10
	dec1

        
        
        tmp_hex_H
        tmp_hex
         
        endc
        





	list p=18f46k80
	include  "p18f46k80.inc"

	CONFIG RETEN=OFF , XINST=OFF,SOSCSEL=DIG,  FOSC = INTIO2, PLLCFG = OFF , FCMEN = OFF , IESO = OFF , PWRTEN = ON , BOREN=OFF , WDTEN= OFF , CANMX=PORTB , MSSPMSK = MSK7 , MCLRE=ON , STVREN = ON 

;definicje 

	
      include "libs/lcd.h"

czestotliwosc     equ      16000000

port_lampki   equ     PORTD
latch_lampki   equ     LATD
pin_lampki      equ     2

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
; jak_duzo_zliczen_TMR2   equ     0x4c
jak_duzo_zliczen_TMR2   equ     0x1


;znaczniki klawiszy MENU

opcje_po_przycisku_dol     equ      0
opcje_po_przycisku_gora     equ      1
opcja_bez_przycisku        equ       2
                


;stan MENU
menu_glowne       equ      0
wybor_opcji       equ     1                
  
  
  
; 4 opcje od 0 do 3 - tu trzeba wpisaæ jak du¿o opcji
; 5 opcje od 0 do 4 - tu trzeba wpisaæ jak du¿o opcji

koncowa_opcja_menu   equ            4



polozenie_wartosci    equ      0x0b






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


;TMR1 - 

;TMR2

;TMR3

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
         
         
         ;btfss    PIE1,RCIE
         ;goto     przerwanie_0
         
przerwanie_0
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
         
         goto     wyjscie_przerwanie                  


                           

         

         
wykryto_t2

         bcf      PIR1,TMR2IF
               
        decfsz   ilosc_zliczen_tmr2,f
         goto    wyjscie_przerwanie

        movlw   jak_duzo_zliczen_TMR2
         movwf   ilosc_zliczen_tmr2
         
        btfsc       latch_lampki,pin_lampki
        goto       wylacz_lampke
        
        
        bsf     port_lampki,pin_lampki
        goto     wyjscie_przerwanie
        
wylacz_lampke        
        bcf     port_lampki,pin_lampki
        goto     wyjscie_przerwanie



         
wykryto_t3
;uzywam do wykrywania czy juz wylaczyc triaka
         bcf      PIR2,TMR3IF
               
         decfsz   ilosc_zliczen_tmr3,f
         goto    wyjscie_przerwanie
         
         movlw   0x13
         movwf   ilosc_zliczen_tmr3
         
        ; btfsc       latch_lampki,pin_lampki
        ; goto       wylacz_lampke
        
        
        ; bsf     port_lampki,pin_lampki
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


      ; include "../libs/dzielenie.asm"
      include "libs/hex2dec18.asm"

        
Start
        
        ;wywolanie lcd inicjacji
       
        call     lcd_init
        
        
        
   
   
   

	bsf      INTCON,GIE
        bsf      INTCON,PEIE

        movlw   jak_duzo_zliczen_TMR2
         movwf   ilosc_zliczen_tmr2
        
        ; movlw   0x4c
        ; movwf   PR2
        
        ; movlw   0xff
        movlw   0x6e
        movwf   PR2
        
        ;ustawienia 13 ms T2con
        
        movlw   b'01111111'
        movwf   T2CON
        bsf     PIE1,TMR2IE
        
        movlw   b'00110001'
        movwf   T3CON
        movlw   0x13
        movwf   ilosc_zliczen_tmr3
        bcf     PIE2,TMR3IE
        
        call     check_busy4bit
        movlw   linia_1
        call    send
        
        call     check_busy4bit
        movlw   _a
         call   write_lcd

        call     check_busy4bit
        movlw   _h
         call   write_lcd
        
        
        call wait_kilka_sekund
        call wait_kilka_sekund
        
        
inicjuj_napis
      
      
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
         
           
         ;test opcji w menu
         
         movlw    0x20
         movwf    wartosc_opcji1
         
         movlw    0xbc
         movwf    wartosc_opcji2
         
         movlw    0x10
         movwf    wartosc_opcji3
         
         movlw    0x99
         movwf    wartosc_opcji4
         
         
         
         ; clrf     znak_linia
         ;clrf     znak_linia2

         movlw    linia_1
         movwf    polozenie_gwiazdka
         
;druga strona pamieci tAM umieszczam wszystkie slowa menu

         call       Wyswietlanie_Menu   

        
       goto LOOP




       
       
 
opcja0
         
         db "napis1",0
         
opcja1  
         
         db     "napis2",0
         


opcja2
         
         db     "napis3",0

opcja3
         
         db     "opcja4",0

opcja4
         
         db     "opcja5",0

       
       










;;;;;;;;;;;;;;;;;;;;;MENU


Znajdz_wartosc_opcji
;
;tu wybieram opcje do wyswietlenia obok opcji w menu
;
         
         lfsr     FSR0, wartosc_opcji1
         
         movf     tmp,w         
         
         addwf    FSR0L,f
         
         movff    INDF0,tmp_hex
         clrf   tmp_hex_H
         call     hex2dec18

                 
         
         call     check_busy4bit
         
         movf     dec100,w
         addlw    0x30
         
         call     write_lcd
         
         call     check_busy4bit
         
         movf     dec10,w
         addlw    0x30
         
         call     write_lcd
         
         call     check_busy4bit
         
         movf     dec1,w
         addlw    0x30
         
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
         return
         
         
         
         
         
Wyswietlanie_Menu


         ;opcja_menu   - tu przechowywana jest wartoœæ wskazywanej opcji
         
         ;np 0 - opcja 0
         ;np 1 - opcja 1
         
         
         
         ;numer opcji jest wartoœci¹ rejestru wq którym jest przechowywana tablica z adresami tablic z opcjami ekranu
         call     check_busy4bit
         
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
         
         
         
         

































         








       
         


         
         
         
         
         
         


         
         


wlacz_przerwanie_tmr0
;tu wlaczane jest przerwanie jednego z zegara
; w tym wypadku zegar TMR0
;mo¿na u¿yc innego dostepnego dla okreslonego procesora
;ustawienia dowolne - minimum oko³o 0,1 sekundy oczekiwania po nacisnieciu klawisza

;ustawienia timera0
; w procedurze inicjacyjnej
; procesor ma czestotliwosc 20 Mhz
;wtedy jedno zliczenie to 1/5000000s
; a wiec przelicznik 1:256 (czyli przerwanie wystepuje po 256*256*8/5000000)
;czyli oko³o 104 ms

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
      
      
      call  wlacz_przerwanie_tmr0   
      goto LOOP


procedura_po_wci_pusz_dol
;procedura uruchamiana po zarejestrowano wcisniecia i puszczenia przycisku   
   
   
      clrf  stan_key
      clrf  markers_klawisze

      
      
       
      
      btfsc       stan_menu,menu_glowne
      goto        klawisz_dol_zmiana_menu

       

          
      btfsc       stan_menu,wybor_opcji
      goto        klawisz_dol_zmiana_wartosci

      
      
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
        lfsr     FSR0, wartosc_opcji1
         
         movf     opcja_menu,w         
         
         addwf    FSR0L,f


         
         decf     INDF0,f
         
          ;clrf        znaczniki_klawiszy_menu
      
      ;bsf         znaczniki_klawiszy_menu,opcja_bez_przycisku
      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
      
      
      goto  LOOP      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

zarejestrowano_klawisz_gora
;moze byc tak ze po zarejstrowaniu przycisku 1 i po czasie oczekiwania, wciaz jest on wcisniety
;wtedy ponownie uruchom odliczanie TMR0

      btfsc   port_klawisz_gora,pin_klawisz_gora
      goto      procedura_po_wci_pusz_gora
;to wykonuje jezeli wciaz jest wcisniety przycisk
; czyli normalnie ponownie uruchamiam TMR0
      
      
      call  wlacz_przerwanie_tmr0   
      goto LOOP

procedura_po_wci_pusz_gora
      ;np zapisuje na linii 2 ekranu numer 2
;bcf		portlampki,pin_lampki	
      clrf  stan_key
      clrf  markers_klawisze

      
      
      
      btfsc       stan_menu,menu_glowne
      goto        klawisz_gora_zmiana_menu

       

          
      btfsc       stan_menu,wybor_opcji
      goto        klawisz_gora_zmiana_wartosci

       
       
       
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

         lfsr     FSR0, wartosc_opcji1
         
         movf     opcja_menu,w         
         
         addwf    FSR0L,f

         
         incf     INDF0,f
         
        ;  clrf        znaczniki_klawiszy_menu
      
     ; bsf         znaczniki_klawiszy_menu,opcja_bez_przycisku
      
      ;jezeli jest wieksza od zmiennej 
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

      
      
      btfsc       stan_menu,menu_glowne
      goto        wybrano_zmiane_opcji
      
      
      btfsc       stan_menu,wybor_opcji
      goto        wybrano_menu_glowne
      
wybrano_zmiane_opcji
         bcf     stan_menu,menu_glowne
         bsf     stan_menu,wybor_opcji
         
         
          ;clrf        znaczniki_klawiszy_menu
      
      ;bsf         znaczniki_klawiszy_menu,opcja_bez_przycisku
      
      ;jezeli jest wieksza od zmiennej 
      call       Wyswietlanie_Menu 
         
      goto  LOOP

wybrano_menu_glowne
         bsf     stan_menu,menu_glowne
         bcf     stan_menu,wybor_opcji
         
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

         
         
         
         
         
         
         
         
         




      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
LOOP

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
         movlw    b'00000000'       
         movwf    T1CON
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
         
         movlw   b'11111111'
         movwf    TRISB
                  
        movlw   b'11110000'
         movwf    TRISC
         
;tu sie zminienia dla kabli
        movlw   b'10010011'
         movwf    TRISD
         
         movlw   b'00000111'
         movwf    TRISE
         
         
         
 
;wylaczam wszystkie analogowe wejscia
         movlw    b'10000000'
         movwf    ADCON1
         
         lfsr  FSR0,ANCON0         
         clrf   INDF0
         lfsr  FSR0,ANCON1
         clrf   INDF0
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
         
         
         movlw    02h
         xorwf    FSR0H,w
         BTFSS    STATUS,Z
         goto     clear_next
         
       

         
         goto    Start
                  



         end
