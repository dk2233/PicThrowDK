
    cblock 20h 

    status_bits

    endc

    cblock   70h
    w_temp
    status_temp
    pclath_temp
    fsr_temp
	result_001
	result_01
	result_ll
	result_lh
	result_hl
	result_H
	operandl
	operandh
	fraction_l
	fraction_h
	number_l
	number_h   ;0x7f
    endc     




mcu_freq  equ  .4000000


;status_bits bits 
run_system equ 7




