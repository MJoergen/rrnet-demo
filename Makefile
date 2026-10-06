# Build the RR-Net demo for the C64.
#
# Type "make" to build rrnet-demo.prg.
# Type "make run" to start it in VICE (requires VICE with Ethernet support).

PRG := rrnet-demo.prg

SRCS := $(wildcard src/*.s)
OBJS := $(SRCS:src/%.s=build/%.o)

# The ip65 libraries: the TCP/IP stack and the RR-Net driver.
IP65LIB  := ip65/ip65/ip65_tcp.lib
DRIVERLIB := ip65/drivers/c64rrnet.lib

X64 ?= x64sc

all: $(PRG)

$(PRG): $(OBJS) $(IP65LIB) $(DRIVERLIB)
	ld65 -o $@ -C c64.cfg -m build/$(PRG).map -vm $(OBJS) $(IP65LIB) $(DRIVERLIB) c64.lib

build/%.o: src/%.s | build
	ca65 -I ip65/inc -o $@ $<

build:
	mkdir -p build

$(IP65LIB): ip65/ip65/Makefile
	$(MAKE) -C ip65/ip65 $(notdir $@)

$(DRIVERLIB): ip65/drivers/Makefile
	$(MAKE) -C ip65/drivers $(notdir $@)

# Fail with a helpful message if the submodule is not checked out.
ip65/ip65/Makefile ip65/drivers/Makefile:
	@echo "The ip65 submodule is missing. Run: git submodule update --init"
	@false

run: $(PRG)
	$(X64) -autostart $(PRG)

clean:
	rm -rf build $(PRG)
	-$(MAKE) -C ip65/ip65 clean
	-$(MAKE) -C ip65/drivers clean

.PHONY: all run clean
