SRC=example1.c

CC=sdcc
FAMILY=pic14
PROC=16f913
DEBUG=--debug-xtra
ASM=gpasm 
LINKER=gplink
OUTPUT=sdcc_test.hex
OBJECTS=example1.o  delay.o
SCRIPT = 16f913_linker.lkr

all: $(OUTPUT)

%.o: %.c
	$(CC) --verbose --std-sdcc11 --asm --use-non-free  -m$(FAMILY) -p$(PROC) -c $^

%.o:	%.asm 
	$(ASM) -L -f -S0 -e ON -c $<

$(OUTPUT):	$(OBJECTS) $(SCRIPT)
	gplink  -O0 -m -S2 -c -I/usr/local/share/sdcc/lib/pic14 -I/usr/local/share/sdcc/non-free/lib/pic14  -o $(OUTPUT) -s $(SCRIPT) $(OBJECTS) libsdcc.lib libc.lib libm.lib pic16f913.lib

clean:
	rm -f $(SRC:.c=.asm) $(SRC:.c=.cod) $(SRC:.c=.hex) $(SRC:.c=.lst) $(SRC:.c=.o) $(OBJECTS)

.PHONY: all clean