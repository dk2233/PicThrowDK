;funkcja zamieniajaca dane 8 bitowe na dwie polowki 4bitowe
;wysylane po kolei


wait
        
        btfss   INTCON,T0IF      
        goto    wait
        bcf     INTCON,T0IF      
        return
        
         
;funkcja wysy?aj?ca
;LCD
;;;;;;;;;;;;;;;;;;;;;;;;;

send4bit
send
;np PORTA bity 0-3  sa uzywane przez 4 bitowy ekran lcd
;najpierw wysylane sa 4bity gorne
         movwf    tmp_lcd
         movlw    2
         movwf    tmp
send4bit_petla
         
;przenosze PORTA tak aby gorne bity nieulegly zmianie
         movlw    ktore_bity_uzywane_na_lcd
         andwf    port_lcd,f
                          
IF (polozenie_danych_lcd == 0)        
;jesli na gorze bitow port d
; bo najpierw wysylam starsze
         
         swapf    dane_lcd,f
ENDIF        


         movlw    ktore_bity_lcd_tris
         andwf    tmp_lcd,w
         addwf    port_lcd,f
         
         bsf      port_lcd_e,enable
         nop
         nop
         bcf      port_lcd_e,enable
         
         decfsz   tmp,f
         goto     send4bit_petla
         return

;funkcja pisz?ca na ekranie
write_lcd

         
         bsf      port_lcd_rs,rs
         
         call     send4bit
         
         bcf      port_lcd_rs,rs
         return

;funkcja czyszcz?ca ekran

cmd_off

         
         bcf      port_lcd_rs,rs
         
         
        return
         


;funkcja czysci cala linie
; przed jej wywolaniem w W umi#1esc adres linii
;po zakonczeniu z powrotem w niej umieszcza adres
;stara wersja - dziala na cala linie

clear_line_old
         movwf    n
         bcf      port_lcd_rs,rs
         
         movf     n,w
         movwf    tmp_lcd
         call     send
         movlw    ile_znakow
         movwf    tmp7
         addlw    0xff
         movwf    tmp
clear_line_old2
         call     check_busy4bit
         movlw    _puste
         movwf    tmp_lcd
         call     write_lcd
         
         decfsz   tmp7,f
         goto     clear_line_old2
         
         call     cmd_off
         movf     n,w
         return
         
clear_line
;przed wywolaniem do n trzeba wrzucic ilosc kasowanych znakow
;a w W musi byc adres linii         
         movwf    dane_lcd
         call     send
         
clear_line_petla
         call     check_busy4bit
         movlw    _puste
         movwf    dane_lcd
         call     write_lcd
         
         decfsz   n,f
         goto     clear_line_petla
         
         call     cmd_off
        
         return

         
         
check_busy4bit
         ;clrf     port_lcd
         movlw    0xf0
         andwf    port_lcd,f
         bsf      STATUS,RP0        ;bank 1
;tu musze ustawic ktore bity Portu lcd na wejscie
;poniewaz czesc bitow moze byc uzywana do czegos innego         
         movlw   port_data
         movwf   tris_lcd
         bcf      STATUS,RP0
                  
         bsf      port_lcd_rw,rw
         bcf      port_lcd_rs,rs

check
         
         bsf      port_lcd_e,enable
         
         swapf    port_lcd,w
         andlw    0xf0
         
         movwf    tmp_lcd
         
         bcf      port_lcd_e,enable
         nop
         bsf      port_lcd_e,enable
         
         movf     port_lcd,w
         andlw    0x0f
         addwf    tmp_lcd,f
         
         bcf      port_lcd_e,enable
         
         
         btfsc    tmp_lcd,7
         goto     check
         
         bsf      STATUS,RP0        ;bank 1
         movlw    trisc_normalnie
         movwf    tris_lcd
         bcf      STATUS,RP0
         
         bcf      port_lcd_rw,rw
         bcf      port_lcd_rs,rs
         return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                           
;pocz?tek dzia?ania ekranu

lcd_init
         call     cmd_off
         clrf     port_lcd
;wylaczam przerwanie
        
         clrf     TMR0
         bcf    INTCON,T0IE
;wylaczam przerwania tmr0         
         movlw    1
         movwf    tmp
        
lcd_init_3_petla
         call     wait     ;fosc/4/256/256 (tak jest ustawiony tmr0) dla 4Mhz 64 ms dla 8 Mhz 32 ms
;dwa bity nizsze musza byc zaznaczone przez okolo 64ms
         
         bcf      port_lcd,0
         bsf      port_lcd,1
         bsf      port_lcd_e,enable
         nop
         bcf      port_lcd_e,enable
         clrf     TMR0 ;64 ms
         call     wait
         
         decfsz   tmp,f
         goto     lcd_init_3_petla

         movlw   set_4bit
         movwf    tmp_lcd
         call     send4bit
         
         call     check_busy4bit
         
         movlw    display_clear
         movwf    tmp_lcd
         call     send4bit
        
        call     check_busy4bit
        
         movlw    display_on
         movwf    tmp_lcd
         call     send4bit
        
        call     check_busy4bit
        
         movlw   entry
         movwf    tmp_lcd
         call     send4bit
        
        call     check_busy4bit
        return