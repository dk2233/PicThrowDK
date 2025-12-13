CC=gpasm
LINKER=gplink

SCRIPT = 16f913_linker.lkr
OBJECTS = main.o ds1820_module.o init.o math_module.o 
OUTPUT = test_reloc.hex

all:		$(OUTPUT)

$(OUTPUT):	$(OBJECTS) $(SCRIPT)
	gplink -O0 -m -s $(SCRIPT) -c $(OBJECTS) -o $(OUTPUT)

%.o:		%.asm
	$(CC) -M -g -e ON -c $<

clean:
	rm -f *.o *.lst *.map *.hex

main.o:  				 main.asm
ds1820_module.o:		 ds1820_module.asm   

init.o:     			init.asm 

math.o:     			math_module.asm
