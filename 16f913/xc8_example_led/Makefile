SRC=example1.c

CC=xc8-cc
FAMILY=pic14
PROC=16F913
DEBUG=--debug-xtra
ASM=gpasm 
LINKER=xc8-cc
OUTPUT=xc8_test.hex
OBJECTS=example1.p1  int_handler.p1 init.p1
SCRIPT = 16f913_linker.lkr
BUILD_FOLDER=build
MDF="/media/dan/Workbench/Mplab_X_v6.30/packs/Microchip/PIC16Fxxx_DFP/1.7.162/xc8"

all: $(OUTPUT)

%.p1: %.c
	$(CC)  -O0 -std=c99 -xassembler-with-cpp -Wa,-a  -mcpu=$(PROC) -mdfp=$(MDF)  -c $^



$(OUTPUT):	$(OBJECTS) 
	$(LINKER)  -O0 -mcpu=$(PROC) -mdfp=$(MDF) -gcoff $(OBJECTS)

clean:
	rm -f $(SRC:.c=.asm) $(SRC:.c=.cod) $(SRC:.c=.hex) $(SRC:.c=.lst) $(SRC:.c=.o) $(OBJECTS)

.PHONY: all clean