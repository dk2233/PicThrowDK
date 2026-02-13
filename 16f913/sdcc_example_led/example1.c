#define NO_BIT_DEFINES

#include <pic14/pic16regs.h>
#include <pic14/pic16fam.h>
#include <stdint.h>

extern void delay_proc_500ms(uint16_t t);

static uint32_t simple_add(uint16_t x1, uint16_t x2);

#define NO_LEGACY_NAMES

#define mcu_frequency   4000000
static __code uint16_t __at (_CONFIG) configword1 = _WDT_OFF & _MCLRE_ON & _DEBUG_ON & _IESO_OFF  & _FOSC_INTOSCIO & _FCMEN_OFF & _PWRTE_ON & _BOREN_OFF;

typedef struct {
	uint8_t Pin0:1;
	uint8_t Pin1:1;
	uint8_t Pin2:1;
	uint8_t Pin3:1;
	uint8_t Pin4:1;
	uint8_t Pin5:1;
	uint8_t Pin6:1;
	uint8_t Pin7:1;

} PortType_t;

typedef union {
	PortType_t  Port_bits;
	uint8_t Ports_u8;
} PortUnion_t;

typedef struct {
	uint8_t   byte1;
	uint16_t  word1;
	uint32_t  double_word1;
} Data_t;
//#define LED_LAT LATDbits.LATD0
//#define LED_TRIS TRISDbits.TRISD0

static uint32_t simple_add(uint16_t x1, uint16_t x2)
{
	return (uint32_t)(x1+x2);
}

void main(void)
{
	PortType_t  *porta_p = (PortType_t *)&PORTA ;
	PortUnion_t *porta2_p  = (PortUnion_t *)&PORTA;
	uint32_t result_u32;
	static uint16_t value = 5000;
//we can use macros from asembler - so same macros for asembler and C files
	__asm 

    include ../../PicLibDK/init16f_common.inc
	config_lcd_off 

	__endasm;
	
	value = value / 3; 
	value >>= 2;
	value = value -  100;
	value *= 3;

	LCDCON = 0;
	LCDSE0 = 0;
	LCDSE1 = 0;
	ANSEL=0;
	ADCON0= 0 ;
	CMCON0 = 0b111;
	CCP1CON = 0;
	VRCONbits.VREN = 0;

	PORTA = 0;
	TRISA = 0;
	//0b11110110;

	//porta_p= PORTA;
	//porta_p->Pin0 = 1;
	porta_p->Pin3 = 1;
	porta_p->Pin7 = 1;

	//LED_TRIS = 0; // Pin as output
	//LED_LAT = 0; // LED off
	result_u32 = simple_add(2000, 3000);

	result_u32 = simple_add(value		, 6000);
	
	Data_t data1 = {10, 30000, 3e6}; 

	if (result_u32 > value)
		{
			porta_p->Pin0 = 1;
		}

    for(uint8_t i = 0 ; i < data1.byte1; i++)
	{
		data1.double_word1++;
	}
	porta2_p->Ports_u8 = 7;

	value *= 3;
	value++;
	value = value / 3;
	value = 8*9;
	if (value < 1000)
	{
		porta2_p->Ports_u8 = 1;
	}
	uint8_t temp;
	while (1) {
		//LED_LAT = !LED_LAT; // Toggle LED
		//delay10ktcy(100); //500 1000cykli @ 4MHz = 

		__asm 

		include ../../PicLibDK/macro_time_common.inc

;wait_specific_time_no_tmr_us  mcu_frequency, 500000, temp 


		__endasm;

		delay_proc_500ms(100);

		if (porta_p->Pin0 == 1)
		{
			porta_p->Pin0 = 0;
		}
		else 
		{
			porta_p->Pin0 = 1;

		}
	}
}