CC=gcc
ASMBIN=nasm

all: asm cc link

asm: 
	$(ASMBIN) -o lissajous.o -g -f elf64 lissajous.asm

cc: 
	$(CC) -c -g -O0 main.cpp

link: 
	$(CC) -no-pie -g -o lissajous main.o lissajous.o -lstdc++ `pkg-config --libs allegro-5`

clean:
	rm *.o
	rm lissajous
