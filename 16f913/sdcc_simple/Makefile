SRC=main.c

CC=sdcc
FAMILY=pic14
PROC=16f913
DEBUG=
#--debug-xtra
ASM=gpasm 
LINKER=gplink
OUTPUT=test
OBJECTS=main.o 

SCRIPT = 16f913_linker.lkr
# Flagi
# --use-non-free: wymagane dla bibliotek gputils (np. 16f877)
# --opt-code-size: optymalizacja rozmiaru
# -Wl,-m: generuje plik .map (warto go mieć do diagnozy)
CFLAGS  = -m$(FAMILY) -p$(PROC) --no-pcode-opt \
          --std-sdcc11 --use-non-free --opt-code-size \
		  -Wa-L \
		  --fverbose-asm \
          -Wl-m
#,-s16f913_linker.lkr 
all: $(OUTPUT).hex

$(OUTPUT).hex: $(SRC) 
	$(CC) -V $(DEBUG) $(CFLAGS) $^ -o $(basename $@) 


clean:
	rm -f $(SRC:.c=.asm) $(SRC:.c=.cod) $(SRC:.c=.hex) $(SRC:.c=.lst) $(OUTPUT).hex $(OBJECTS) $(OUTPUT)

.PHONY: all clean
