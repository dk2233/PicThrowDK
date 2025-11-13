;ten program ma za zadanie zliczac poprzez kazdy sygnal z 

;RB7 rozpoznawany za pomoca przerwan - sygnal dodaja 1


;wyswietlac liczbe sygnalow zczytanych
;na czterech wyswietlaczach 7 -iemio segmentowych
;RB6 - RB0 - 
;dwa wyswietlacze 
;dajace cyfry : 1000 i 10 
;zalaczanie katod - Ra2 i Ra1



;RC6 - RC0 - 100 i 1
;zalaczanie katod - Ra3 i Ra0

;klawisze 4 - jeden to jumper i na razie nie jest istotny

; klawisze sa podlaczone po osc1 i osc2 co dla pic16f916
;stanowi ra7 - osc 1
;ra6 - osc2

;klawisze generowane sa poprzez te same fale co 
;zalaczanie tranzystorow
;
;
;
;;;;;;;;UWAGA !
;ta wersja ma zwiekszanie pojedynczych cyfr
;
;
;
	
;czekanie 1 sekundy miedzy puszczeniem przycisku ustawiajacego a odswiezeniem ekranu
;pierwsze nacisniecie - pokazuje ustawienia
;dopiero drugie (przytrzymanie)- zwieksza

;	definicja procesora
;
;
;
;#define procek 16f916
;1 - 16f876
;2 - 916
procek	equ	1

;#define procek 16f876	
	
	;
	
;dla pic16f916
	IF	(procek==2)
	list p=procek
	include	"p16f916.inc"
	__CONFIG _WDT_OFF & _INTOSCIO & _MCLRE_ON & _DEBUG_OFF & _IESO_OFF  
	  ENDIF          
;dla pic16f873
	IF	(procek==1)
	list p=16f876
	include	"p16f876.inc"
	__CONFIG _XT_OSC & _WDT_OFF
	ENDIF	
;definicje s w odzielnym pliku

	include "./definicje.h"
	include ../../libs/memory_operation_16f.inc
	include ../../libs/interrupts.inc

	org	000h

	PAGESEL inicjacja
	goto	inicjacja

	org 	0004h
przerwanie	
	context_store16f

	btfsc	INTCON,T0IF
	goto	wykryto_t0
	
	btfsc	PIR1,TMR1IF
	goto	wykryto_t1
		
	
	btfsc	INTCON,RBIF
	goto	wykryto_rb7
	
	btfsc	PIR1,TMR2IF
	goto	wykryto_t2

wyjscie_przerwanie
	context_restore16f	

	retfie
	
wykryto_t2	
	call	bank1
	bcf	PIE1,TMR2IE
	call	bank0
	bcf     PIR1,TMR2IF
	bcf	printer_port,printer	
	goto	wyjscie_przerwanie
	
wykryto_t0
	bcf	INTCON,T0IF
	bsf	markers2,przerwanie_t0
	goto	wyjscie_przerwanie

wykryto_t1
	bcf	PIR1,TMR1IF
	bsf	markers2,przerwanie_t1
	goto	wyjscie_przerwanie
	
wykryto_rb7
	movf	PORTB,w
	
	bcf	INTCON,RBIF
	btfsc	input_port,input
	goto	wyjscie_przerwanie
	
	bsf	markers2,przerwanie_rb7
	goto	wyjscie_przerwanie
		
	
ustawianie
	bcf	markers2,przerwanie_t1	

	
	btfsc	markers2,check_off
	goto	off23
	
	btfsc	markers,key4
	goto	button4_check
	
	;btfsc	markers,3
	;call	button23_dalej
	;goto	button23_check
	
	;
	
	;btfsc	markers,2	
	;goto	button23_check
;	
	btfsc	markers,key3
	call	zwieksz_cyfra_set
	
	btfsc	markers,key2
	call	zmniejsz_cyfra_set
	
			
	return
	
inc_zegar	
	
	bcf	markers2,przerwanie_t0
	
	btfsc	markers2,sznurek
	goto	refresh_led
	
;jezeli alarm to zastanow sie czy zapalic czy tez nie
	btfss	markers,alarm
	goto	refresh_led
	
	
;jezeli wyswietlam ustawienia to tez zapal	
	incf	zegar1,1
	movlw	03dh
	xorwf	zegar1,w
	btfsc	STATUS,Z
	goto	_full
	
	;btfsc	markers2,swiece
	;goto	refresh_led
	
	goto	refresh_led
_full	
	clrf	zegar1
;czy teraz minelo 0,5 sekundy nie swiecenia
;czy nie?	
	btfss	markers2,nie_swiece
	goto	nieswiece
;zaswiec
	bcf	markers2,nie_swiece
	bcf	buzzer_port,buzzer	
	goto	refresh_led

nieswiece
	;bcf	cyfra1_port,cyfra1b
	;bcf	cyfra10_port,cyfra10b
	;bcf	cyfra100_port,cyfra100b
	;bcf	cyfra1000_port,cyfra1000b	
	
	bsf	markers2,nie_swiece	
	bsf	buzzer_port,buzzer
	clrf	PORTB
	movlw	b'10000000'
	andwf	PORTC,f
	
wylaczone	
;	btfsc	markers,takt1000
;	goto	
; 	bcf	markers,takt1000
	
;	btfss	markers,takt1000
;	goto	
	
; 	bsf	markers,takt1000
	
	
	return
	


		
	
refresh_led
;najpierw wyłączamy katody po to by nie zmieniac
;wskazan
;	btfss	markers2,sznurek
;	bcf	buzzer_port,buzzer
	
	bcf	cyfra1_port,cyfra1b
	bcf	cyfra10_port,cyfra10b
	bcf	cyfra100_port,cyfra100b
	bcf	cyfra1000_port,cyfra1000b
	
	
	
;najpierw cyfry 1 i 1000
; 	movf	PORTC,0
; 	movwf	temp_C
; 	movf	PORTB,0
; 	movwf	temp_B
	
	
;które liczby teraz załączam 
;sprawdzam to tym czy cyfry 10 i 100
;czy 
;1 i 1000
; jezeli zaznaczony jest bit markers<0> to znaczy ze 
;trwa	1-1000 	
	btfsc	markers,0
	goto	cyfry10_100
;tzn ze teraz trwa 10-100
;jezeli sznurek to wciaz wyswietlam to samo

	btfsc	markers2,sznurek
	goto	zalacz_katody1000

	
	btfsc	markers2,nie_swiece
	goto	zalacz_katody1000
	
	btfsc	markers,1
	movlw	cyfra1_set
	
	btfss	markers,1
	movlw	cyfra1
	
;do INDF idzie cyfra1 badz cyfra1_set	
	movwf	FSR
	movf	INDF,0	
	call	tab_cyfr
	;movwf	PORTC
	movwf	temp_C
;czy drukarka jest zalaczona	
	btfsc	printer_port,printer
	bsf	temp_C,printer
	movf	temp_C,w
	;movwf	PORTC
	movwf	PORTC
	movlw	0x03
	addwf	FSR,f
	movf	INDF,0
	call	tab_cyfr
	movwf	PORTB
;	btfsc	temp_B,7
;	bsf	PORTB,7
zalacz_katody1000	
	bsf	cyfra1_port,cyfra1b
	bsf	cyfra1000_port,cyfra1000b
zalacz_takt	
	bsf	markers,takt1000
	return ; bo to cały czas było przerwanie
	
cyfry10_100
	btfsc	markers2,sznurek
	goto	zalacz_katody100
;jezeli zaznaczono nie swiece	
	btfsc	markers2,nie_swiece
	goto	zalacz_katody100
	
	btfsc	markers,1
	movlw	cyfra10_set
	
	btfss	markers,1
	movlw	cyfra10
	
	movwf	FSR
	movf	INDF,0	
	call	tab_cyfr
	movwf	PORTB
;	btfsc	temp_B,7
;	bsf	PORTB,7
	
	
	incf	FSR,f
	movf	INDF,0
	call	tab_cyfr
	movwf	temp_C
	btfsc	printer_port,printer
	bsf	temp_C,printer
	;movwf	PORTC
	movf	temp_C,w
	movwf	PORTC
;	btfsc	temp_C,7
;	bsf	PORTC,7
	
	

zalacz_katody100
	bsf	cyfra100_port,cyfra100b
	bsf	cyfra10_port,cyfra10b
wylacz_takt
	bcf	markers,0
	
	return ; bo to cały czas było przerwanie

tab_cyfr
	addwf	PCL,1
	retlw	_0
	retlw	_1
	retlw	_2
	retlw	_3
	retlw	_4
	retlw	_5
	retlw	_6
	retlw	_7
	retlw	_8
	retlw	_9
	
	
zmniejsz_cyfra1000
	incf	FSR,1
	movf	INDF,w
	xorlw	00h
	btfsc	STATUS,Z
	goto	jest_zero_1000
	
	decf	INDF,1
			
	return
jest_zero_1000
	clrf	ktora_cyfra_set
	return
	

	
zmniejsz_cyfra100
	
;teraz wskazuje indf - cyfra100	
	incf	FSR,1
	movf	INDF,w
	xorlw	00h
	btfsc	STATUS,Z
	goto	jest_zero_100
	
	decf	INDF,1
	
	return
jest_zero_100
	clrf	ktora_cyfra_set
	bsf	ktora_cyfra_set,inc1000
	goto	zmniejsz_cyfra1000
	return
	
	
	
	
	
zmniejsz_cyfra10
	incf	FSR,1
	movf	INDF,w
	xorlw	00h
	btfsc	STATUS,Z
	goto	jest_zero_10
	
	decf	INDF,1
			
	return
jest_zero_10
	clrf	ktora_cyfra_set
	bsf	ktora_cyfra_set,inc100
	goto	zmniejsz_cyfra100
	return

	
zmniejsz_cyfra1
	movf	INDF,w
	xorlw	00h
	btfsc	STATUS,Z
	goto	jest_zero_1
	
	decf	INDF,1
	return
jest_zero_1
	clrf	ktora_cyfra_set
	bsf	ktora_cyfra_set,inc10
	goto	zmniejsz_cyfra10
	return

zmniejsz_cyfra_set
	btfss	markers2,juz_zmieniam
	return
	;btfsc	markers,alarm
	;bsf	markers,inc_paczka
	movlw	cyfra1_set
	movwf	FSR
	btfsc	ktora_cyfra_set,inc1
	goto	zmniejsz_cyfra1
	
	btfsc	ktora_cyfra_set,inc10
	goto	zmniejsz_cyfra10
;bo w okreslonej procedurze zmniejszamy o jeden FSR\
;a teraz jest tam jeden
;wiec jezeli zmniejszamy o jeden bedziemy miec 10 nie 100

	movlw	cyfra10_set
	movwf	FSR
	
	btfsc	ktora_cyfra_set,inc100
	goto	zmniejsz_cyfra100
	movlw	cyfra100_set
	movwf	FSR
	btfsc	ktora_cyfra_set,inc1000
	goto	zmniejsz_cyfra1000
	return
		
zwieksz_cyfra1000
	incf	FSR,1
	incf	INDF,1
	movf	INDF,w
	xorlw	0ah
	btfss	STATUS,Z
	goto	nieprzekroczono
	
	btfss	markers2,przerwanie_rb7
	;INTCON,RBIF
	goto	zwieksz_cyfra1000_set
	
	clrf	INDF
	clrf	cyfra1
	clrf	cyfra10
	clrf	cyfra100
	bcf	INTCON,RBIF
;
;
;	tu trzeba doda�czyszczenie wszystkich cyfr
;
;	oraz alarm
;	
	goto	zwieksz_cyfra
	
zwieksz_cyfra1000_set
	clrf	INDF
	clrf	cyfra100_set
	clrf	cyfra10_set
	clrf	cyfra1_set
	;clrf	INDF
	
	clrf	ktora_cyfra_set
	bsf	ktora_cyfra_set,inc1
	return
	
zwieksz_cyfra100
	
;teraz wskazuje indf - cyfra100	
	incf	FSR,1
	incf	INDF,1
	movf	INDF,w
	xorlw	0ah
	btfss	STATUS,Z
	goto	nieprzekroczono
	
	btfss	markers2,przerwanie_rb7
	;INTCON,RBIF
	goto	zwieksz_cyfra100_set
	
	clrf	INDF
	goto	zwieksz_cyfra1000
	
zwieksz_cyfra100_set
	;decf	INDF,1
	clrf	INDF
	clrf	ktora_cyfra_set
	bsf	ktora_cyfra_set,inc1000
	goto	zwieksz_cyfra1000
	return

	
zwieksz_cyfra10
	
	incf	FSR,1
	incf	INDF,1
	movf	INDF,w
	xorlw	0ah
	btfss	STATUS,Z
	goto	nieprzekroczono
	
	btfss	markers2,przerwanie_rb7
	;INTCON,RBIF
	goto	zwieksz_cyfra10_set
	
	clrf	INDF
	goto	zwieksz_cyfra100
	
zwieksz_cyfra10_set	
	;decf	INDF,1
	clrf	INDF
	clrf	ktora_cyfra_set
	bsf	ktora_cyfra_set,inc100
	goto	zwieksz_cyfra100
	;clrf	INDF
	return
		
	
	
zwieksz_cyfra1
	incf	INDF,1
	movf	INDF,0
	xorlw	0ah
	btfss	STATUS,Z
	goto	nieprzekroczono
	
	btfss	markers2,przerwanie_rb7
	goto	zwieksz_cyfra1_set
	
	clrf	INDF
	goto	zwieksz_cyfra10
	
	
	
	
zwieksz_cyfra1_set	
	;decf	INDF,1	
	clrf	INDF
	clrf	ktora_cyfra_set
	bsf	ktora_cyfra_set,inc10
	goto	zwieksz_cyfra10
	return

nieprzekroczono
	btfss	markers2,przerwanie_rb7
	return
end_of_rb7	
	BCF	markers2,przerwanie_rb7
	;bcf	markers,		
	return
	
zwieksz_cyfra
;jezeli zmienam to juz nie porownuj
;	btfss	markers,alarm	
;	bsf	markers,inc_paczka
	
	btfss	markers2,juz_zmieniam
	bsf	markers,inc_paczka
;daj impuls na drukarke
;tzn wlacz przerwanie na TMR2
;i zarejesrtuj je za 65 ms
;wtedy wylacz port drukarki	
IF	procek==2
	clrf	TMR2
	movlw   b'01111111'
	movwf	T2CON
	bcf	PIR1,TMR2IF
	call	bank1
	bsf	PIE1,TMR2IE
;	movlw	0xff
;	movwf	PR2
	call	bank0
	bsf	printer_port,printer
ENDIF	
	
	movlw	cyfra1
	movwf	FSR
	
	goto	zwieksz_cyfra1
	
	
;	btfsc	ktora_cyfra,inc10
;	goto	zwieksz_cyfra10
;	btfsc	ktora_cyfra,inc100
	;goto	zwieksz_cyfra100
	;;btfsc	ktora_cyfra,inc1000
	;goto	zwieksz_cyfra1000
	
	return
zwieksz_cyfra_set
;	btfss	markers,alarm
;	bsf	markers,inc_paczka	
	;bcf	
	btfss	markers2,juz_zmieniam
	return
	movlw	cyfra1_set
	movwf	FSR
	;btfss	markers2,alarm	
	;bcf	markers,alarm
	btfsc	ktora_cyfra_set,inc1
	goto	zwieksz_cyfra1
	
	btfsc	ktora_cyfra_set,inc10
	goto	zwieksz_cyfra10
;bo w okreslonej procedurze zwiekszamy o jeden FSR\
;a teraz jest tam jeden
;wiec jezeli zwiekszamy o jeden bedziemy miec 10 nie 100

	movlw	cyfra10_set
	movwf	FSR
	
	btfsc	ktora_cyfra_set,inc100
	goto	zwieksz_cyfra100
	movlw	cyfra100_set
	movwf	FSR
	btfsc	ktora_cyfra_set,inc1000
	goto	zwieksz_cyfra1000
	return
	
;porownaj cyfry z ustawien i aktualnego stanu jesli te same to
;zacznij migac wyswietlaczami


;dodac sprawdzanie czy 0
porownanie
;sprawdz czy 0 jest w ustawieniach
	movf	cyfra1000_set,w
	btfss	STATUS,Z
	goto	porownanie_dalej
	movf	cyfra100_set,w
	btfss	STATUS,Z
	goto	porownanie_dalej
	movf	cyfra10_set,w
	btfss	STATUS,Z
	goto	porownanie_dalej
	movf	cyfra1_set,w
	btfss	STATUS,Z
	goto	porownanie_dalej
;jezeli wszystkie sa 0 to nie sprawdzaj
	goto	nie_rowne
	
porownanie_dalej	
	movf	cyfra1000,w
; 	xorwf	cyfra1_set,w
	subwf	cyfra1000_set,w
;cyfra1000_set - cyfra1000
;jezeli w wyniku 0 - rowne
;jezeli w wyniku C=0 -> cyfra1000_set < cyfra1000 - tzn calosc ;wieksza
;jezeli w wyniku C=1 -> cyfra1000_set > cyfra1000 - dalej nie sprawdzam

	btfss	STATUS,C
	goto	wieksze
;jezeli jest 0 to sprawdz dalej bo cyfra 1000  jest rowna		
	btfss	STATUS,Z
	goto	nie_rowne
	
	movf	cyfra100,w
; 	xorwf	cyfra100_set,w
	subwf	cyfra100_set,w
	
	btfss	STATUS,C
	goto	wieksze
	
	btfss	STATUS,Z
	goto	nie_rowne
	
	
	movf	cyfra10,w
	subwf	cyfra10_set,w
	
	btfss	STATUS,C
	goto	wieksze
	
	btfss	STATUS,Z
	goto	nie_rowne
	
	movf	cyfra1,w
	subwf	cyfra1_set,w
	
	btfss	STATUS,C
	goto	wieksze
	
	btfss	STATUS,Z
	goto	nie_rowne
wieksze	
	bsf	markers,alarm
	bsf	markers2,nie_swiece
	bcf	markers,inc_paczka
	clrf	PORTB
	movlw	b'10000000'
	andwf	PORTC,f
	return
	
nie_rowne
;koniec sprawdzania ani nie wieksze ani nie rownae
	bcf	markers,inc_paczka
	bcf	markers,alarm
	bcf	markers2,nie_swiece
	return
;przeczanie bankow
bank3
	bsf	STATUS,RP0
	bsf	STATUS,RP1
	return

bank2
	bcf	STATUS,RP0
	bsf	STATUS,RP1
	return
bank1
	bsf	STATUS,RP0
	return
	
bank0	
	bcf	STATUS,RP0
	bcf	STATUS,RP1
	return	

;podstawa czasowa to bedzie mikrosekunda
;dla 4.096 Mhz tzn mamy na sekunde 1024000 operacji
;aby miec wyswietlanie z czestotliwoscia 100 razy na sekunde
;zliczamy 40 *256 - aby raz odswiezyc leda


zmieniaj 
	bsf	markers2,juz_zmieniam
	clrf	ktora_cyfra_set
	bsf	ktora_cyfra_set,inc1
	clrf	TMR1L
 	clrf	TMR1H
 	movlw	b'00100001'
	movwf	T1CON
	call	bank1
	bsf	PIE1,TMR1IE	 
	call	bank0
	bcf	PIR1,TMR1IF
	bcf	markers2,check_off
	bcf	buzzer_port,buzzer
	bcf	markers2,nie_swiece
	bcf	markers,alarm
	goto  LOOP2


button3
;zwiekszanie
;jezeli wciaz trzymasz pierwsze nacisniecie to nic nie rob
	btfsc	markers2,juz_zmieniam
	goto	LOOP2
	
	
	
	btfsc 	markers,key3
	goto  LOOP2
button3_on
	bcf	markers,key2	
	bsf	markers,key3
	bsf	markers,cyfra_set
	btfsc	markers2,check_off
	goto	zmieniaj
	
	goto  LOOP2
	
button2
;to jest zmniejszanie ustawien
	
;oznaczam ze teraz wyswietlanie trwa cyfr ustawien
;sprawdzac czy przytrzymanie trwa sekunde
;zaznaczam ze przytrzymanie zarejestrowano
	btfsc	markers2,juz_zmieniam
	goto	LOOP2

	
	
	btfsc 	markers,key2
	goto  LOOP2
button2_on
	bcf	markers,key3	
	bsf	markers,key2
	bsf	markers,cyfra_set
	btfsc	markers2,check_off
	goto	zmieniaj
	goto  LOOP2
	
button23_on	
;inicjalizacja TMR1
; 	clrf	TMR1L
; 	clrf	TMR1H
;pic16f876
;	movlw	b'00111001'
;pic16f916	na 1/4 sekundy
; 	 movlw	b'00100001'
; 	 movwf	T1CON
;przerwanie:
; 	call	bank1
; 	bsf	PIE1,TMR1IE	 
; 	call	bank0
;zwiekszam cyfre 1
zmieniam
 	
;gdyby przypadkiem puszczony przycisk ponownie nacisnieto przed upluynieicem czasy 1 s
;	clrf	zegar3_off	
;	decf	zegar3_off,f
;	bcf	markers2,check_off
; 	bcf	markers2,juz_zwiekszam
;wlaczam przerwania sprzetowe

button23_off
	btfsc	markers2,check_off
	return
 	clrf	TMR1L
 	clrf	TMR1H
 	movlw	b'00100001'
	movwf	T1CON
	call	bank1
	bsf	PIE1,TMR1IE	 
	call	bank0
	bsf	markers2,check_off
;jezeli juz zmieniam	
	bcf	markers2,juz_zmieniam
	clrf	zegar3_off
	decf	zegar3_off,f
	clrf	zegar4
	decf	zegar4,f
	bcf	markers,key3
	bcf	markers,key2
	return
off23	
	incf	zegar3_off,f
	
	btfss	zegar3_off,2
	return	
	clrf	zegar3_off
	decf	zegar3_off,f
;	bcf	markers2,juz_zwiekszam
;	bcf	markers,key2	
;	bcf	markers,key3		
;	goto	off_tmr1_interrupt
	
;button3_off
	
;	bcf	markers2,juz_zmieniam
	bcf	markers2,check_off
	bcf	markers,key3
	bcf	markers,key2
;	bcf	markers,1
		

off_tmr1_interrupt
		
	;bcf	markers2,juz_zwiekszam
	bcf	markers,cyfra_set
;	bcf	markers2,juz_zmieniam
	call	bank1
	bcf	PIE1,TMR1IE	 
	call	bank0				
	bsf	markers,inc_paczka
	goto  LOOP2

	
			
button4
	btfsc 	markers,4
	goto 	LOOP2
	
	;goto	button4_on
;jesli juz nacisnieto	
	;goto 	LOOP2
;wymus czekanie sekundowe zanim wyczysci wszystko	
button4_on
	clrf	zegar4
	decf	zegar4,f	
	bsf	markers,key4
	clrf	TMR1L
 	clrf	TMR1H
 	movlw	b'00100001'
	movwf	T1CON
	call	bank1
	bsf	PIE1,TMR1IE	 
	call	bank0
	;bsf	INTCON,PEIE
	goto 	LOOP2
button4_check	
	incf	zegar4,f
	btfss	zegar4,2
	return	
	clrf	zegar4
	decf	zegar4,f
	clrf	cyfra1000
	clrf	cyfra100
	clrf	cyfra10
	clrf	cyfra1
	
	clrf	cyfra1000_set
	clrf	cyfra100_set
	clrf	cyfra10_set
	clrf	cyfra1_set
	clrf	markers2
	call	bank1
	bcf	PIE1,TMR1IE	 
	call	bank0
	
	bcf	markers,alarm
	bcf	markers2,nie_swiece
	return
	
	
button4_off
	bcf	markers,key4	
	goto 	LOOP2

;button5
;test1	
;	movlw	b'01111111'
;	movwf	PORTB
;	clrf	PORTC
	;movwf	PORTC
;	bsf		cyfra1000_port,cyfra1000b
;	bsf		cyfra10_port,cyfra10b
;;	
;	bcf		cyfra1_port,cyfra1b
;	bcf		cyfra100_port,cyfra100b
;test	
;	nop
;	nop
;	goto	test		
;LOOP
;po kolei sprawdz stan portow
;klawiszy

brak_sznurka
	btfsc	markers2,sznurek
	return
		
	bsf	markers2,sznurek
;wylaczam przerwania tak by nic mi sie nie zliczalo
;tylko by odswiezac ekran
	bcf	INTCON,RBIE
	call	bank1
	movf	INTCON,w
	movwf	intcon_temp	
	bcf	PIE1,TMR1IE
	call 	bank0
	bsf	buzzer_port,buzzer
	
;dopisz zachowanie
	;movf	PORTB,w
	;movwf	temp_B
	clrf	PORTB
	;movf	PORTC,w
	;movwf	temp_C
	clrf	PORTC
	bsf	PORTB,6
	bsf	PORTC,6
	return
	
wylacz_brak
	btfss	markers2,sznurek
	return
	bcf	markers2,sznurek
;wylaczam przerwania tak by nic mi sie nie zliczalo
;tylko by odswiezac ekran
	bsf	INTCON,RBIE
	call	bank1
;jezeli byl wczesniej zaznaczony	
	btfsc	intcon_temp,TMR1IE
	bsf	PIE1,TMR1IE
	
	call 	bank0
	bcf	buzzer_port,buzzer
	
	
	;movf	temp_B,w
	;movwf	PORTB
	;movf	temp_C,w
	;movwf	PORTC
	
	return
	
	
LOOP
;jezeli rejestruje '1' na krancowce to oki 1 - tak jest ok
; - 0 - nie cos nie tak
;czy takt 1-1000
IF	procek==2
 	btfss	krancowa_port,krancowa
 	call	brak_sznurka
;a moze czas wylaczyc	
	btfsc	krancowa_port,krancowa
	call	wylacz_brak	
ENDIF	
	
 	btfsc	markers,takt1000
	goto	klawisze_25
	
	btfss  but23_port,but23
    	goto   button3
IF	procek==2	
	btfss  but45_port,but45
  	goto   button4
ENDIF
;jezeli nic nie wykryl to sprawdz czy przypadkiem nie
;zostal przycisk puszczony
	btfsc  markers,3
	call	button23_off
	
IF	procek==2	
	btfsc  markers,4
	call	button4_off
ENDIF
	goto	LOOP2
klawisze_25

;normalnie dla 16f916
IF	procek==2
	btfss  but23_port,but23
   	goto   button2
ENDIF

;test
IF	procek==1
;	btfss  but45_port,but45
; 	goto   button2
ENDIF
	 
;to jest jumper i na razie nie ma jego obslugi	

;	btfss  but45_port,but45
;        goto   button5
	
;jezeli nic nie wykryl to sprawdz czy przypadkiem nie
;zostal przycisk puszczony
IF	procek==2
	btfsc  markers,key2
	call	button23_off
ENDIF	
;	btfsc  markers,5
;	call	button5_off

LOOP2	
;	
;czy cos trzeba zliczyc
	btfsc	markers2,przerwanie_t0
	call	inc_zegar
	
	btfsc	markers2,przerwanie_t1
	call	ustawianie
	
	btfsc	markers2,przerwanie_rb7
	call	zwieksz_cyfra
	
	btfsc	markers,inc_paczka
	call	porownanie
	
	goto	LOOP

	
	org 	0800h	
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;POCZATEK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
		
inicjacja
	

	
	BANKSEL PORTA
	clrf    STATUS ;czyszcze status

	clrf	PORTA
	clrf	PORTB
	clrf	PORTC

;dla pic16f916	
;**
IF	procek==2
	

;wylaczam modul lcd	Vjmovf	status_temp,w
	movwf	STATUS

	movf	w_temp,w	
	bsf	STATUS,RP1
	bcf	STATUS,RP0
	clrf	LCDCON
	bcf	LCDPS,LCDA
	clrf	LCDSE0
	clrf	LCDSE1
	bcf	STATUS,RP1
;wylaczam modul comparator,pwm etc
	movlw	b'00000000'
	movwf	CCP1CON
ENDIF
BEGIN2
	
	bcf	STATUS,RP1
	bsf	STATUS,RP0
	bcf	PIE1,TMR1IE
	bcf	PIE1,TMR2IE

;wylaczam serial
	bcf	RCSTA,SPEN
;**	

IF	procek==2
;**	
;dla_pic16f916		
;ustawiam oscon na 4MhZ HighF	
	movlw	b'01100111'
	movwf	OSCCON
;wszystkie analogi na cyfre
	bcf	VRCON,VREN
	movlw	b'00000111'
	movwf	CMCON0
	movlw	b'00000000'
	movwf	ANSEL
	
ENDIF
	
	BANKSEL TRISA
IF	procek==1
	
	movlw	b'11100000'	
	movwf	TRISA
	
	movlw   b'10000000'
	movwf	TRISB
   	movlw   b'10000000'
	movwf	TRISC
ENDIF
IF	procek==2
	movlw	b'11100000'	
	movwf	TRISA
	
	movlw   b'10000000'
	movwf	TRISB
	
	movlw   b'00000000'	
	movwf	TRISC
ENDIF
	
;tu wylaczam modul A/D
	movlw	b'00000000'
	movwf	ADCON1
;bank 0
	bcf	STATUS,RP0
	movlw	b'00000000'
	movwf	ADCON0

	bcf	SSPCON,SSPEN
;ustawienia timera na 256*32 zliczen
	clrwdt
	bsf	STATUS,RP0
	movlw	b'11000100'
	movwf	OPTION_REG
;**
	IF	procek==2
	movlw	b'10000000'	
	movwf	IOCB
	ENDIF
;**	
	bcf	STATUS,RP0
	
	movlw	b'11101000'
	movwf	INTCON
;ustawiam TMR2	
; 	movlw	b'01111111'
	movlw	b'00000111'
	movwf	T2CON


	
	clear_memory 0x20, 0x5f
	clear_memory 0xa0, 0x4f
	

	banksel PORTA
	clrf	PORTA
;wracamy do strony 1
	PAGESEL LOOP
	goto	LOOP	
	END


