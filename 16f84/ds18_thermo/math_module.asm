    list  
    include "p16f84a.inc"
    global func_div_24bit_16bit

;12
common_var udata_ovr
result_001 res 1
result_01 res 1
result_ll res 1
result_lh res 1
result_hl res 1
result_H res 1
fraction_l res 1
fraction_h res 1
number_l res 1
number_h res 1
operandl res 1
operandh res 1
;these two udata section are located in the same address
common_var udata_ovr 
ds18_read_from_RAM res 9


    global result_001, result_01, result_ll, result_lh, result_hl, result_H
    global number_l, number_h
    global fraction_l, fraction_h
    global operandl, operandh
    global ds18_read_from_RAM


    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc

    code 

func_div_24bit_16bit 
    BANKSEL result_hl
    macro_division_16f_24bit_16bit  result_hl, result_lh, result_ll, operandh, operandl, fraction_h, fraction_l, result_001 
    
    return
   END