CC=gpasm
LINKER=gplink

SRC=blink913.asm
OBJECTS=blink913.o led.o  buttons.o game.o tasks.o buttons2.o stack_handle.o random.o
SCRIPT=16f913_linker.lkr
OUTPUT=blink.hex


all:  $(OUTPUT)

$(OUTPUT): $(OBJECTS)
	$(LINKER) -u -O0 -m -S2 -s $(SCRIPT) -c $(OBJECTS) -o $(OUTPUT)

%.o: %.asm
	$(CC) -L -f -e ON -c $<

clean:
	rm -f *.o *.lst *.map *.hex *.co*

#blink913:  blink913.asm