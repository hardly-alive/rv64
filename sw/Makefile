# Toolchain Config
CC = riscv64-unknown-elf-gcc
OBJCOPY = riscv64-unknown-elf-objcopy
CFLAGS = -march=rv64im -mabi=lp64 -nostdlib -T link.ld

# Targets
all: program.hex

# 1. Compile C & Assembly to ELF
program.elf: crt0.s main.c link.ld
	$(CC) $(CFLAGS) -o $@ crt0.s main.c

# 2. Extract Raw Binary
program.bin: program.elf
	$(OBJCOPY) -O binary $< $@

# 3. Convert Binary to Hex (Byte-aligned for Verilog)
program.hex: program.bin
	hexdump -v -e '1/1 "%02x\n"' $< > $@

# Cleanup
clean:
	rm -f *.elf *.bin *.hex