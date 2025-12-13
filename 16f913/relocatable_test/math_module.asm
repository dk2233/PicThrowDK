    .file "math"
    list p=16f913 
    include "p16f913.inc"
    global func_div_24bit_16bit

common_var udata 
result_001 res 1
result_01 res 1
result_ll res 1
result_lh res 1
result_hl res 1
result_H res 1
operandl res 1
operandh res 1
fraction_l res 1
fraction_h res 1
number_l res 1
number_h res 1

    global result_001, result_01, result_ll, result_lh, result_hl, result_H
    global number_l, number_h
    global fraction_l, fraction_h
    global operandl, operandh
    
    include ../../PicLibDK/memory_operation_16f.inc
    include ../../PicLibDK/math/math_macros.inc

    code 
func_div_16bit_8bit 
    BANKSEL result_ll
    macro_division_16f  number_h, number_l, operandl, result_lh, result_ll 
    return

func_div_24bit_16bit 
    BANKSEL result_hl
    macro_division_16f_24bit_16bit  result_hl, result_lh, result_ll, operandh, operandl, fraction_h, fraction_l, result_001 
    
    return
    .eof
    END