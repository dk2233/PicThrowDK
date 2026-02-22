


#include <xc.h>
#include <stdint.h>

#define HOW_MANY_COUNT_TO_1SEC    31

void __interrupt() int_handler(void) 
{
    //counter to measure 1 sec
    // 4/8e6 * 256 * 256 = one int tmr0 is 32768 us 
    //
    static uint8_t t0_counter_u8 = HOW_MANY_COUNT_TO_1SEC;

    if ((INTCONbits.T0IE) && (INTCONbits.T0IF))
    {
        INTCONbits.T0IF = 0;
        if (t0_counter_u8 == 0)
        {
            t0_counter_u8 = HOW_MANY_COUNT_TO_1SEC;
            if (PORTAbits.RA0 == 1)
            {
                PORTAbits.RA0 = 0;
            }
            else
            {
                PORTAbits.RA0 = 1;
            }
           
        }
        else 
        {
            
            t0_counter_u8--;
        }



    }


}