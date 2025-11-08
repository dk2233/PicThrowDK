;wersja 2014-05-20
;dla prockow serji 18fxxx
;do odczekania 64ms uzywam komendy cpfsgt


;definicje zmiennych
;ktore_bity_uzywane_na_lcd - ktore porty ekranu sa uzywane jako dane
;ktore_bity_lcd_tris   - definiuje ktore bity maja byc zamieniane na wejscie podczas check busy
;tris_lcd   -definiuje ktory tris wplywa na tris lcd
;set_4bit   - ustawienia dla lcd
;tmp_lcd - tymczasowa zmienna u¿ywana tylko w procedurach lcd

wait
        clrf     TMR0L ;64 ms
        clrf     TMR0H ;64 ms
        bcf     INTCON,TMR0IF
        
wait_petla         
        btfss   INTCON,TMR0IF      
        goto    wait_petla
        bcf     INTCON,TMR0IF
        bcf      INTCON,TMR0IE
        
        return
        
        
        
        
        
        
wait_bez_tmr
        movlw   jak_duzo_taktow_czekac_LCD

        movwf   n
        
wait_bez_tmr_petla 
        nop
        decfsz  n,f
        goto    wait_bez_tmr_petla
        
        return
        
        
         
;funkcja wysy?aj?ca 4 bitowa
;LCD
;;;;;;;;;;;;;;;;;;;;;;;;;

send
;np PORTA bity 0-3  sa uzywane przez 4 bitowy ekran lcd
;najpierw wysylane sa 4bity gorne
         movwf    dane_lcd
         movlw    2
         movwf    tmp_lcd
send4bit_petla
         
;przenosze PORTA tak aby gorne bity nieulegly zmianie
         movlw    ktore_bity_uzywane_na_lcd
         andwf    latch_lcd,f
                          
        IF (polozenie_danych_lcd == 0)        
;jesli na gorze bitow port d
         
         swapf    dane_lcd,f
        ENDIF

         
         movlw    ktore_bity_lcd_tris
         andwf    dane_lcd,w
         addwf    latch_lcd,f
         
         bsf      latch_lcd_e,enable
         nop
         nop
         call wait_bez_tmr
         bcf      latch_lcd_e,enable
         
        IF (polozenie_danych_lcd == 1)        
;jesli na gorze bitow port d
         
         swapf    dane_lcd,f
        ENDIF
            
         decfsz   tmp_lcd,f
         goto     send4bit_petla
         return
         ;movwf    latch_lcd
         
         
;funkcja pisz?ca na ekranie
write_lcd

         
         bsf      latch_lcd_rs,rs
         
         
         call     send
         
         bcf      latch_lcd_rs,rs    
         
         return

;funkcja czyszcz?ca ekran

;funkcja czyszcz?ca ekran

cmd_off

         
         bcf      latch_lcd_rs,rs
         
         
        return
         


;funkcja czysci cala linie
; przed jej wywolaniem w W umi#1esc adres linii
;po zakonczeniu z powrotem w niej umieszcza adres
;stara wersja - dziala na cala linie
         
clear_line
;przed wywolaniem do n trzeba wrzucic ilosc kasowanych znakow
;a w W musi byc adres linii         
         movwf    dane_lcd
         call     send
         
clear_line_petla
         call     check_busy
         movlw    _puste
         movwf    dane_lcd
         call     write_lcd
         
         decfsz   n,f
         goto     clear_line_petla
         
         call     cmd_off
        
         return

         
         
check_busy
check_busy4bit
        IF (polozenie_danych_lcd == 1)
;jesli na gorze bitow port d
         movlw    0x0f
         
         andwf    latch_lcd,f
        ENDIF

        IF (polozenie_danych_lcd == 0)        
;jesli w dolnej polowce  bajtu rejestru  portd
         movlw    0xf0
         
         andwf    latch_lcd,f
        ENDIF
         
         ;clrf     port_lcd
         ;clrf     PORTD
;przesylam dane np tris 00000001
;chce zrobic tak by bylo 
;  11110001
       
         movf     tris_lcd,w
         iorlw    ktore_bity_lcd_tris
         movwf    tris_lcd    
         
      
         
         
                  
         bsf      latch_lcd_rw,rw
         bcf      latch_lcd_rs,rs

check
         
         bsf      latch_lcd_e,enable
         
         call wait_bez_tmr
         
        IF (polozenie_danych_lcd == 0) 
;jezli dolne bity portu lcd
         swapf    port_lcd,w
        ENDIF
            
        IF (polozenie_danych_lcd == 1)        
;jesli na gorze bitow port lcd
            
         movf    port_lcd,w
         
        ENDIF
         
         andlw    0xf0
         
         movwf    tmp_lcd
         
         
         bcf      latch_lcd_e,enable
         

         
         call wait_bez_tmr
         


         
         bsf      latch_lcd_e,enable
         call wait_bez_tmr
        IF (polozenie_danych_lcd == 1) 
        ;jesli na gorze bitow port d
         swapf    port_lcd,w
        ENDIF
            
        IF (polozenie_danych_lcd == 0)        
        movf    port_lcd,w
        ENDIF         
     
         andlw    0x0f
         
         addwf    tmp_lcd,f
         
          
         
         
         bcf      latch_lcd_e,enable    
         
         call wait_bez_tmr
          
         btfsc    tmp_lcd,7
         goto     check
         
         movlw   normalne_ustawienie_tris_lcd
         movwf    tris_lcd
         
         
         bcf      latch_lcd_rw,rw
         bcf      latch_lcd_rs,rs
         return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                           
;poczatek dzialania 4 bitowego ekranu

lcd_init

        IF (czestotliwosc == 20000000)
        ;ustawiam tutaj tmr0 tak aby jego przerwanie dalo
        ;64 ms minimum
        
        ;prescaler 8 - daje to 256*256*8/5e6 = 100 ms
        ;przerwania maja byc wylaczone
        movlw   b'10000010'
        movwf   T0CON
        ENDIF
        
        IF (czestotliwosc == 16000000)
        ;ustawiam tutaj tmr0 tak aby jego przerwanie dalo
        ;64 ms minimum
        
        ;prescaler 8 - daje to 256*256*8/5e6 = 133 ms
        ;przerwania maja byc wylaczone
        movlw   b'10000010'
        movwf   T0CON
        ENDIF
        
        IF (czestotliwosc == 4000000)
        ;ustawiam tutaj tmr0 tak aby jego przerwanie dalo
        ;64 ms minimum
        
        ;prescaler 2 - daje to 256*256*2/5e6 = 125 ms
        ;przerwania maja byc wylaczone
        movlw   b'10000000'
        movwf   T0CON
        ENDIF
        

         call     cmd_off
         
        IF (polozenie_danych_lcd == 1)        
;jesli na gorze bitow port d
         movlw    0x0f         
         andwf    latch_lcd,f
        ENDIF

        IF (polozenie_danych_lcd == 0)        
;jesli w dolnej polowce  bajtu rejestru  portd
         movlw    0xf0         
         andwf    latch_lcd,f
        ENDIF


         bcf      latch_lcd_rw,rw
         bcf      latch_lcd_e,enable
        
         call     wait     ;64ms

         movlw    init_4bit_start
         andlw    ktore_bity_lcd_tris
;teraz w W mam postac 0011 w tym nibbles ktory jest port lcd , jezeli gorne to 00110000
         iorwf    latch_lcd,f
         
         bsf     latch_lcd_e,enable
         nop
         call   wait_bez_tmr
         bcf     latch_lcd_e,enable
         ;call     send    ;zalaczam
         
         call     wait
         
         ; movlw    init_4bit
         ; andlw    ktore_bity_lcd_tris
         ; iorwf    latch_lcd,f
         
         ; bsf     latch_lcd_e,enable
         ; nop
         ; bcf     latch_lcd_e,enable
         ; call     wait
         
         ; movlw    init_4bit
         ; andlw    ktore_bity_lcd_tris
         ; iorwf    latch_lcd,f
         
         ; bsf     latch_lcd_e,enable
         ; nop
         ; bcf     latch_lcd_e,enable
         
         ; call     wait
         
         movlw    set_4bit
         call     send
         call     wait
         ; call     check_busy
         
         movlw    display_clear
         ;movwf    port_lcd,ACCESS
         call     send
         
         call     wait
         call     check_busy
         
         
         movlw   display_set
         call     send
          call     wait
         call     check_busy
         
        
        
         movlw   entry        
        call    send
        call     wait
        call     check_busy
        return