czytaj_eeprom

       
;IF procek==1         
         movwf    EEADR
;ENDIF         
;IF procek==2
 ;        movwf    EEADRL
;ENDIF         
           
         bcf      EECON1,EEPGD
         bsf      EECON1,RD
         
       

         movf     EEDATA,w

         return
         
zapis_eeprom
;do w adres pod ktory zapisuje
;do FSR (INDF) co zapisuje         
;poprawka ze zapisuje dana spod INDF1         
         
check_if_write
         btfsc    EECON1,WR
         goto     check_if_write
    
 
         
;IF procek==1         
         movwf    EEADR
;ENDIF         

       
         movf     INDF1,w
        
         movwf     EEDATA
      
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
         
         
                  
         return         