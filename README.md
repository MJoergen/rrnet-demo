# RR-Net demo for C64

This repo contains a small proof-of-concept program for the C64 that allows you to connect
to the Internet using the RR-Net cartridge.

This program may be run on a physical C64 (or a MEGA65 with the C64 core), with the
additional RR-Net cartridge (the MK3 ROM is not needed).

Alternatively, you can run it on an emulated C64 using VICE, but the latter has to be
compiled with Ethernet support.

This program serves an educational purpose of showing how to develop C64 programs that
make use of the Internet.

## What can you do with this program?
For now, this program is a simple port of the "ping" utility. You enter an IP address, and
it will print out a line saying `reply from <ip address> after <num> seconds`.

## What is RR-Net?
RR-Net is a physical cartridge with an Ethernet (RJ45) connector that allows network
connectivity.

## How to build using "ca65"
The program is written in 6502 assembly for the "ca65" assembler, which is part of the
cc65 tool chain. To install cc65 (including "ca65" and the "ld65" linker) type

```
sudo apt install cc65
```

The network stack comes from the [ip65](https://github.com/cc65/ip65) library. To download
it and build the parts needed for the C64 with RR-Net type

```
git clone https://github.com/cc65/ip65.git
make -C ip65/ip65 ip65_tcp.lib
make -C ip65/drivers c64rrnet.lib
```

This produces two libraries:
* `ip65/ip65/ip65_tcp.lib` : The TCP/IP stack (ARP, IP, ICMP, UDP, TCP, DHCP, DNS, ...).
* `ip65/drivers/c64rrnet.lib` : The driver for the CS8900A Ethernet chip in the RR-Net,
  together with C64 helper routines for printing, keyboard input and timing.

## How to test using VICE

Follow the [INSTALL.md](INSTALL.md) guide for instructions on how to install VICE on
Ubuntu 24.04 LTS.

## File overview of this repo
* `README.md` : This file.
* `INSTALL.md` : How to build VICE with Ethernet support on Ubuntu 24.04 LTS.
* `LICENSE` : The MIT license.
