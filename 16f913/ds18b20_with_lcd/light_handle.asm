    list p=16f913 
	include	"p16f913.inc"


    include symbols.inc 

    global light_change 

    extern program_states





light_code    code 

light_change 
    bcf  program_states, buttton_pressed

    BANKSEL led_green_port
    ;btfsc led_green_port,led_green_pin
    ;goto $+3
    ;bsf   led_green_port, led_green_pin
    ;goto  $+2

    ;bcf   led_green_port, led_green_pin
    btfsc  led_green_port, led_green_pin
    goto $+3

    bsf led_green_port, led_green_pin
    goto $+2

    bcf  led_green_port, led_green_pin

    return 

    end 