;procek 1  = 
;procek 2 = pic16f877

czytaj_eeprom

         bcf      STATUS,RP0
         bsf      STATUS,RP1
         
         
         IF procek==1         
         
         movwf    EEADR
         
         ENDIF    
     
         IF procek==2
         
         movwf    EEADRL
         
         ENDIF         
         
         bsf      STATUS,RP0
         bsf      STATUS,RP1

         
         bcf      EECON1,EEPGD
         bsf      EECON1,RD
         
         bcf      STATUS,RP0
         
         
         IF procek==1           

         movf     EEDATA,w
         ENDIF                  
         
         IF procek==2

         movf     EEDATL,w
         
         ENDIF         

         bcf      STATUS,RP1
         return
         
zapis_eeprom
;do w adres pod ktory zapisuje
;do FSR (INDF) co zapisuje         
         bsf      STATUS,RP0
         bsf      STATUS,RP1
         
check_if_write
         btfsc    EECON1,WR
         goto     check_if_write
         
;         bcf      STATUS,RP0
;         bcf      STATUS,RP1
         
         ;movf     tmp,w
 ;2 bank        
         bcf      STATUS,RP0
         bsf      STATUS,RP1
         
         IF procek==1         
         
         movwf    EEADR
         
         ENDIF         
         
         IF procek==2
         
         movwf    EEADRL
         
         ENDIF
         
         ;bcf      STATUS,RP0
         ;bcf      STATUS,RP1
                  
         movf     INDF,w
         
 ;        bcf      STATUS,RP0
  ;       bsf      STATUS,RP1
         
         
         IF procek==1           
         
         movwf     EEDATA
         
         ENDIF                  
         
         IF procek==2
         
         movwf    EEDATL
         
         ENDIF         

         
         bsf      STATUS,RP0
         bsf      STATUS,RP1
         
         bcf      EECON1,EEPGD
         bsf      EECON1,WREN
  ;bez przerwan       
         bcf      INTCON,GIE
         
         movlw    55h
         movwf    EECON2
         movlw    0aah
         movwf    EECON2
         
         bsf      EECON1,WR                  
         
         bsf      INTCON,GIE
         bcf      EECON1,WREN
         
         
         bcf      STATUS,RP0
         bcf      STATUS,RP1
         
         return         