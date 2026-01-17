CC=gpasm
LINKER=gplink

SCRIPT = 16f913_linker.lkr
OBJECTS = main.o ds1820_module.o init.o math_module.o lcd_handler.o
OUTPUT = lcd_ds18.hex

all:		$(OUTPUT)

$(OUTPUT):	$(OBJECTS) $(SCRIPT)
	gplink  -u -O0 -m -S2 -s $(SCRIPT) -c $(OBJECTS) -o $(OUTPUT)

%.o:		%.asm
	$(CC) -L -f -S0 -e ON -c $<

clean:
	rm -f *.o *.lst *.map *.hex
