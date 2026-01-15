
    list p=16f913 

	include	"p16f913.inc"


    include defines.inc
    include ../../PicLibDK/macro16f_analog_d.inc
    include ../../PicLibDK/math/macro_random.inc
    include ../../PicLibDK/macro_time_common.inc
    

rng_ud    udata
tmp_rng    res 1 
result_rng res 2
rng_seed  res 1

    global rand_generate
    global rand_generate_pseudo

    global rng_init
rand_code    code 

rand_generate 

    run_analog_conversion    0, mcu_freq, tmp_rng, result_rng 
    BANKSEL result_rng
    movf result_rng,w
    return 


rand_generate_pseudo
    BANKSEL rng_seed

    rand_8bit  rng_seed 

    andlw  led_port_mask
    return 

rng_init
    config16f_ansel 1
    config16f_analog_on 1, 0, 0, b'001'
    call rand_generate
    movwf rng_seed
    return 
    end