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

The network stack comes from the [ip65](https://github.com/cc65/ip65) library, which is
included in this repo as a git submodule. Clone the repo together with the submodule

```
git clone --recurse-submodules https://github.com/MJoergen/rrnet-demo.git
cd rrnet-demo
```

If you already cloned the repo without the submodule, type `git submodule update --init`.

To build the program type

```
make
```

This first builds the two ip65 libraries needed for the C64 with RR-Net:
* `ip65/ip65/ip65_tcp.lib` : The TCP/IP stack (ARP, IP, ICMP, UDP, TCP, DHCP, DNS, ...).
* `ip65/drivers/c64rrnet.lib` : The driver for the CS8900A Ethernet chip in the RR-Net,
  together with C64 helper routines for printing, keyboard input and timing.

It then assembles the source files in `src/` and links everything into `rrnet-demo.prg`.

## How to test using VICE

Follow the [INSTALL.md](INSTALL.md) guide for instructions on how to install VICE on
Ubuntu 24.04 LTS.

Once VICE is set up with the RR-Net enabled, start the program with

```
make run
```

## File overview of this repo
* `README.md` : This file.
* `INSTALL.md` : How to build VICE with Ethernet support on Ubuntu 24.04 LTS.
* `LICENSE` : The MIT license.
* `Makefile` : Builds the ip65 libraries and `rrnet-demo.prg`.
* `src/main.s` : The program source.
* `ip65/` : The ip65 library (git submodule).
* `.github/workflows/build.yml` : GitHub Actions job that checks the program builds.
