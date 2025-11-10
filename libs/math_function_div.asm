;in number_h|number_l place number to be dividend

;in operandl - number that will be divisor
;result - quotient in
; resultlh | resultll 

;reminder in numberh|number_l 


func_div_16bit_8bit 
    BANKSEL result_ll
    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll 
    return