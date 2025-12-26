CC=gpasm
LINKER=gplink

SCRIPT = 16f84a_linker.lkr
OBJECTS = main.o init.o math_module.o led_module.o
OUTPUT = led_digits_16f84a.hex

all:		$(OUTPUT)

$(OUTPUT):	$(OBJECTS) $(SCRIPT)
	gplink   -r -O0 -m -S2 -s $(SCRIPT) -c $(OBJECTS) -o $(OUTPUT)

%.o:		%.asm
	$(CC) -p 16f84a -L -f -S0 -e ON -c $<

clean:
	rm -f *.o *.lst *.map *.hex *.d

main.o:  				 main.asm
init.o:     			init.asm 
math.o:     			math_module.asm
led_module.o:   led_module.asm