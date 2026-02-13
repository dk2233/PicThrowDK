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

uint32_t  var1; 

static uint32_t simple_add(uint16_t x1, uint16_t x2)
{
	return (uint32_t)(x1+x2);
}

static uint32_t value = 5000;
static uint32_t value1 = 5000;
static uint16_t number = 3;
static uint16_t fraction = 0;
static uint8_t result_001 = 0;
void main(void)
{
	/*
	I would suggest to avoid such approach
	it is better to use PORTAbits.RAX to set or read values 
	however it is for test purpose
	*/
	PortType_t  *porta_p = (PortType_t *)&PORTA ;
	PortUnion_t *porta2_p  = (PortUnion_t *)&PORTA;
	uint32_t result_u32;
	static uint8_t  elapsed = 0;
	volatile uint16_t  elapsed_u16 = 0;
	const uint8_t ConstVar = 100;

	/*
	simple test how to use asembler procedure
	also macros - very useful - here division procedure
	*/
	__asm 

    include ../../PicLibDK/init16f_common.inc
    include ../../PicLibDK/macro_time_common.inc
    include ../../PicLibDK/macro_time_tmr1_tmr2.inc
    include ../../PicLibDK/macro16f_osccon.inc

	config_lcd_off 

    config_osccon osccon_internal_8MHZ, osts_internal_clock_startup, scs_internal_clock
	configure_tmr0   7, 1
    config_tmr1_as_timer  b'0', 0 ; every interrupt pass 524 ms = about 1 sec after two

	__endasm;
	
	
	TMR1L = 0;
	TMR1H = 0;
	TMR0 = 0;
	value1 = value1 / 3; 
	elapsed = TMR0;
	elapsed_u16 = ((TMR1H << 8) | TMR1L);
	
	value = 5000;
	TMR1L = 0;
	TMR1H = 0;
	/*
	simple test how to use asembler procedure
	also macros - very useful - here division procedure
	*/
	__asm 

    include ../../PicLibDK/math/math_macros.inc

	macro_division_16f_24bit_16bit  _value+2, _value+1, _value, _number+1, _number, _fraction+1, _fraction, _result_001 

	
	
	
	
	__endasm;
	elapsed_u16 = ((TMR1H << 8) | TMR1L);

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

	TMR1L = 0;
	TMR1H = 0;
	porta_p->Pin3 = 1;

	elapsed_u16 = ((TMR1H << 8) | TMR1L);

	porta_p->Pin7 = 1;

	/*
	function usage
	*/
	result_u32 = simple_add(2000, 3000);

	result_u32 = simple_add(value		, 6000);
	
	Data_t data1 = {10, 30000, 3e6};

	if (result_u32 > value)
	{
		porta_p->Pin0 = 1;
	}

	/*

	loop usage

	*/
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

	INTCONbits.GIE = 1;
	INTCONbits.PEIE = 1;
	INTCONbits.T0IE = 1;
	while (1) {

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