CC=gpasm
LINKER=gplink

SCRIPT = 16f84a_linker.lkr
OBJECTS = main.o init.o math_module.o led_module.o ds1820_module.o
OUTPUT = 18b20_16f84a.hex
INC = ../../PicLibDK

all:		$(OUTPUT)

$(OUTPUT):	$(OBJECTS) $(SCRIPT)
	gplink   -r -O1 -m -p1 -S2 -s $(SCRIPT) -c $(OBJECTS) -o $(OUTPUT)

%.o:		%.asm
	$(CC) -p 16f84a -L -f -S0 -e ON -I$(INC) -c $<

clean:
	rm -f *.o *.lst *.map *.hex *.d

main.o:  				 main.asm
ds1820_module.o:		 ds1820_module.asm   

init.o:     			init.asm 

math.o:     			math_module.asm

led_module.o:   led_module.asm