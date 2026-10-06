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

# VICE settings for "make run". ETH_IF is the host network interface VICE
# uses for the emulated RR-Net. It defaults to the interface of the default
# route. Override it if needed, e.g. "make run ETH_IF=enp3s0".
X64    ?= x64sc
ETH_IF ?= $(shell ip route show default 2>/dev/null | awk '{print $$5; exit}')

# Enable the Ethernet cartridge in RR-Net mode (mode 1) at $DE00 (56832),
# using the pcap driver on the chosen interface.
X64_ETH_OPTS := -ethernetcart -ethernetcartmode 1 -ethernetcartbase 56832 \
                -ethernetiodriver pcap $(if $(ETH_IF),-ethernetioif $(ETH_IF))

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
	$(X64) $(X64_ETH_OPTS) -autostart $(PRG)

clean:
	rm -rf build $(PRG)
	-$(MAKE) -C ip65/ip65 clean
	-$(MAKE) -C ip65/drivers clean

.PHONY: all run clean
