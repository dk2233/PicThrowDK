CC=gpasm
LINKER=gplink

SRC=blink913.asm
OBJECTS=blink913.o led.o  ports.o
SCRIPT=16f913_linker.lkr
OUTPUT=blink.hex


all:  $(OUTPUT)

$(OUTPUT): $(OBJECTS)
	$(LINKER) -u -O0 -m -S2 -s $(SCRIPT) -c $(OBJECTS) -o $(OUTPUT)

%.o: %.asm
	$(CC) -L -f -X -e ON -c $<

clean:
	rm -f *.o *.lst *.map *.hex *.co*

#blink913:  blink913.asm