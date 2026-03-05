SRC= init.c int_handler.c main.c lcd_hd4478.c

CC=sdcc
FAMILY=pic14
PROC=16f913
DEBUG=--debug-xtra
ASM=gpasm 
LINKER=gplink
OUTPUT=sdcc_lcd_test.hex
OBJECTS=init.o int_handler.o main.o delay.o lcd_hd4478.o
#../../lcd_hd4478_driver/lcd_hd4478.o 

#lcd_hd4478.o
#../../lcd_hd4478_driver/lcd_hd4478.o 
#delay.o 
SCRIPT = 16f913_linker.lkr

all: $(OUTPUT)

%.o: %.c
	$(CC)  $(DEBUG) --opt-code-size --std-sdcc11 --asm --use-non-free -I"../../lcd_hd4478_driver" -I. -m$(FAMILY) -p$(PROC) -c $^

%.o: ../../lcd_hd4478_driver/%.c
	$(CC)  $(DEBUG) --opt-code-size --std-sdcc11 --asm --use-non-free -I"../../lcd_hd4478_driver" -I. -m$(FAMILY) -p$(PROC) -c $^

%.o:	%.asm 
	$(ASM) -L -f -S0 -e ON -c $<

$(OUTPUT):	$(OBJECTS) $(SCRIPT)
	gplink  -O2 -m -S2 -c -I/usr/local/share/sdcc/lib/pic14 -I/usr/local/share/sdcc/non-free/lib/pic14  -o $(OUTPUT) -s $(SCRIPT) $(OBJECTS) libsdcc.lib libc.lib libm.lib pic16f913.lib

clean:
	rm -f $(SRC:.c=.asm) $(SRC:.c=.cod) $(SRC:.c=.hex) $(SRC:.c=.lst) $(SRC:.c=.o) $(OBJECTS)

.PHONY: all clean