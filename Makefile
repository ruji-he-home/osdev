all: myos.bin

iso: myos.iso

run: myos.bin
	qemu-system-i386 -kernel myos.bin

run-iso: myos.iso
	qemu-system-i386 -cdrom myos.iso

clean:
	rm -rf *.o *.bin *.iso isodir

.PHONY: all iso run run-iso clean

boot.o: boot.s
	i686-elf-as boot.s -o boot.o

kernel.o: kernel.c
	i686-elf-gcc -c kernel.c -o kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra

myos.bin: boot.o kernel.o linker.ld
	i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -O2 -nostdlib boot.o kernel.o -lgcc

myos.iso: myos.bin grub.cfg
	mkdir -p isodir/boot/grub
	cp -f myos.bin isodir/boot/myos.bin
	cp -f grub.cfg isodir/boot/grub/grub.cfg
	grub-mkrescue -o myos.iso isodir
