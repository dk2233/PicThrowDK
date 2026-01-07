
	list p=16f913
	include	"p16f913.inc"


    include defines.inc
    include ../../PicLibDK/macro16f_analog_d.inc
    include ../../PicLibDK/macro_time_common.inc

rng_ud    udata
tmp_rng    res 1 
result_rng res 2

    global rand_generate

rand_code    code 

rand_generate 

    run_analog_conversion    0, mcu_freq, tmp_rng, result_rng 
    BANKSEL result_rng
    movf result_rng,w
    return 


    end