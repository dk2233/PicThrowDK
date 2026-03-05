
#define NO_BIT_DEFINES

#include <pic14/pic16regs.h>
#include <pic14/pic16fam.h>
#define OSTS_INIT_OSC_START_WITH_EXTERNAL_CLOCK    0      

#define SCS_SYSTEM_CLOCK_INTERNAL    1


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
	OSCCONbits.SCS = SCS_SYSTEM_CLOCK_INTERNAL;
	OSCCONbits.OSTS = OSTS_INIT_OSC_START_WITH_EXTERNAL_CLOCK;
    
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1;
    INTCONbits.T0IE = 1;
    
    //TMR0
    OPTION_REG = 0;
	OPTION_REGbits.PS = 7;
	OPTION_REGbits.PSA = 0;
    
    OPTION_REGbits.NOT_RBPU = 0;
    
    WPUBbits.WPUB3 = 1;

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

    TRISA = 0b11111110;
    PORTA = 0;
    PORTB = 0;
    PORTC = 0;

    TRISB = 0b11111111;




}