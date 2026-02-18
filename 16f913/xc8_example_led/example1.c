#include <xc.h>
#include <stdint.h>
#include  "init.h"

static uint32_t simple_add(uint16_t x1, uint16_t x2);


#pragma config WDTE = OFF , MCLRE=ON, DEBUG=ON, IESO=OFF, FOSC=INTOSCIO, FCMEN=OFF, PWRTE=ON , BOREN=OFF

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

	pic16f_init();
	
	TMR1L = 0;
	TMR1H = 0;
	TMR0 = 0;
	value1 = value1 / 3; 
	elapsed = TMR0;
	elapsed_u16 = ((TMR1H << 8) | TMR1L);
	
	value = 5000;
	TMR1L = 0;
	TMR1H = 0;
	
	elapsed_u16 = ((TMR1H << 8) | TMR1L);

	value >>= 2;
	value = value -  100;
	value *= 3;




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

		_delay(1e6);

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