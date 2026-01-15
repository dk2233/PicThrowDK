CC=gpasm
LINKER=gplink

SRC=blink.asm
OBJECTS=blink.o  init.o  leds.o  analog_random.o
SCRIPT=16f913_linker.lkr
OUTPUT=blink.hex


all:  $(OUTPUT)

$(OUTPUT): $(OBJECTS)
	$(LINKER) -u -O0 -m -S2 -s $(SCRIPT) -c $(OBJECTS) -o $(OUTPUT)

%.o: %.asm
	$(CC) -L -f -e ON -c $<

clean:
	rm -f *.o *.lst *.map *.hex *.co*
