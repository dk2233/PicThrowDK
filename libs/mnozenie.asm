;procedura mnozy dowolną liczbe
;zapisana w ;
;mnozonah i mnozonal 
;ulamki w ulamekh i ulamekl
;przez zawrtosc
;rejestru operandl
;i operandh
;wynik obejmuje rowniez ulamki


;6 bajtowy wynik


;mnozenie działaniem

;  mnozonah:mnozona * operandh:operand

; wynik3:wynika = 


;mnozenie z uzyciem polecenia mulwf
;wygodne dla 1 bajtu i 
; oraz dla dwoch bajtow
; uzywane tez dla dzielenia:
;np jesli chce podzielic liczbe dwubajtowa przez 100
;to mnoze ja przez 0.01 czyli 65536*0.01 = 655.3 czyli 656 =  hex 0x290
;ale mniejsze ulamki trudniej tak uzyc  - ulamek 0.001 ma za mala dokladnosc

mnozenie 
         
         clrf     wynik
         clrf     wynik1
         clrf     wynik2
         clrf     wynik3
         clrf     wynik01
         clrf     wynik001

mnozenie_l
;mnozona*operand 
         ;decf    operandl,f
         
         movf     operandl,w
         mulwf    mnozonal         
         movff    PRODH,wynik1
         movff    PRODL,wynik
         

;mnozonah*operandh* 2^16
         
         movf     operandh,w
         mulwf    mnozonah
         movff    PRODH,wynik3
         movff    PRODL,wynik2


         movf     operandh,w
         mulwf    mnozonal
         ;movff    PRODH,wynik3
         movf     PRODL,w
         addwf    wynik1,f
         movf     PRODH,w
         addwfc   wynik2,f
         clrf     WREG
         addwfc   wynik3,f
         

         
         movf     operandl,w
         mulwf    mnozonah
         ;movff    PRODH,wynik3
         movf     PRODL,w
         addwf    wynik1,f
         movf     PRODH,w
         addwfc   wynik2,f
         clrf     WREG
         addwfc   wynik3,f
         
                          
         return