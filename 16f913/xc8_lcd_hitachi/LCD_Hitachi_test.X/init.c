#include <xc.h>

#define OSTS_INIT_OSC_START_WITH_EXTERNAL_CLOCK    0      

#define SCS_SYSTEM_CLOCK_EXTERNAL    0


#define LCD_OFF()    do{ \
                    LCDCON = 0; \
                    LCDSE0; \
                    LCDSE1 = 0; \
                    } \
                    while(0);

void pic16f_init(void)
{
    /*
    oscillator set 
    */
	OSCCONbits.IRCF =  7; // 8MHZ
	OSCCONbits.SCS = SCS_SYSTEM_CLOCK_EXTERNAL;
	OSCCONbits.OSTS = OSTS_INIT_OSC_START_WITH_EXTERNAL_CLOCK;

    //TMR0
	OPTION_REGbits.PS = 7;
	OPTION_REGbits.PSA = 0;

    //T1CON
	T1CONbits.T1CKPS = 0;
	T1CONbits.TMR1CS = 0;
	T1CONbits.TMR1ON = 1;

    //OFF ANAlOG and LCD
    LCD_OFF();
	ANSEL=0;
	ADCON0= 0 ;
	CMCON0 = 0b111;
	CCP1CON = 0;
	VRCONbits.VREN = 0;

    //ports

    TRISA = 0;
    PORTA = 0;

    TRISB = 1;


}