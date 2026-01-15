blink_of_led_in_game macro status 
    if (status == 0)
    bcf game_status, game_blink_led
    else 
    bsf game_status, game_blink_led
    endif

    endm