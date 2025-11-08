;definicje do licznika


;porty licznika

;RA0 - cyfra 1
;RA1 -	cyfra 10
;RA2 - cyfa 1000
;RA3 - cyfra 100
;RA4 - buzzer
;RA5 - sygnal sznurka
;RA6 - klawisze S4 i S5 (in) 
;RA7 - klawisze S2 i S3 (in)


;RB7 - port zliczajacy impulsy  (in)
;RB6-RB0  - LED 1000- 1

;RC7 - printer
;Rc6 - Rc0 - LED 100 - 10

;
;include "p16f873.inc"

	cblock 20h
	cyfra1
	cyfra10
	cyfra100
	cyfra1000
	
	cyfra1_set
	cyfra10_set
	cyfra100_set
	cyfra1000_set
	
	
	ktora_cyfra
	ktora_cyfra_set
	port_change
	zegar1
	zegar4
	zegar3_off
	temp_B;czasowo dla portb
	temp_C;czasowo dla portc
	temp_1
	markers ; tu zaznaczam ktore sa zalaczone
;cyfry 
;markers,0 - to jezeli jest 1 to takt 1-1000 i klawisze
;markers,1	- to czy wyswietlamy cyfre aktualna - 0
; czy cyfre do ustawiania - 1
;markers,2- zarejestrowano klawisz 2
;markers,3- zarejestrowano klawisz 3
;markers,4- zarejestrowano klawisz 4
;markers,5- zarejestrowano klawisz 5
;markers,6 - zrob miganie
;mnarkers,7 - gdy zwiekszam o jeden cyfre zliczen
;s2-25
	markers2
	stan_RB7
	endc
	
	cblock	70h
	w_temp
	status_temp
	intcon_temp
	endc	
;8 - bit jest zajęty przez cos innego 	
;		 'gfedcba'
_0	equ 	b'0111111'
_1	equ 	b'0000110' ; ab
_2	equ	b'1011011'
_3 	equ	b'1001111'	
_4	equ	b'1100110'
_5	equ	b'1101101'
_6	equ	b'1111101'	
_7	equ	b'0000111'
_8	equ 	b'1111111'
_9	equ 	b'1101111'
	

cyfra1_port	equ	PORTA
cyfra1b		equ	0

cyfra10_port	equ	PORTA
cyfra10b	equ	1

cyfra100_port	equ	PORTA
cyfra100b	equ	3

cyfra1000_port	equ	PORTA
cyfra1000b	equ	2


input_port	equ	PORTB
input		equ	7

krancowa_port	equ	PORTA
krancowa	equ	5

buzzer_port	equ	PORTA
buzzer		equ	4

printer_port	equ	PORTC
printer		equ	7
;domyslnie jest to portA 

;dla pic16f876
;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;
;domyslnie	jest to porta6
;dla pic16f876
	IF	procek==1
;domyslnie	jest to porta7 
but23_port	equ	PORTC
;but23_port	equ	PORTA
but45		equ	4
;but45		equ	7
	ENDIF

;dla pic16f916
	IF	procek==2
but23_port	equ	PORTA
but45		equ	6
	ENDIF
; to zawsze takie samo

but45_port	equ	PORTA
;but45_port	equ	PORTC
but23		equ	7
;but23		equ	5




;dla pic16f916


;ktora_cyfra
inc1		equ	0
inc10		equ	1
inc100		equ	2
inc1000		equ	3


;markers

takt1000	equ	0;klawisze s2-s5
cyfra_set	equ	1
key2		equ	2 ;jezeli raz nacisnalem
key3		equ	3
key4		equ	4
key5		equ	5
alarm		equ	6
inc_paczka	equ	7


;markers2

nie_swiece	equ	0
przerwanie_rb7	equ	1
przerwanie_t1	equ	2
przerwanie_t0	equ	3
juz_zmieniam	equ	4
;sprawdzam tym bitem czy testuje 4 sek od puszczenia key
check_off	equ	5
sznurek		equ 	6
temp_t1e	equ	7	 ; tu przechowuje ;ustawienie t1e podczas braku sznurka	