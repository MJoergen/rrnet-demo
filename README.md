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

## How to build using "as65"
To install the "as65" assembler type

```
sudo apt install cc65
```

To download the "ip65" library type

```
TODO
```

## How to test using VICE

Follow the [INSTALL.md](INSTALLL.mD) guide for instructions on how to install VICE on
Ubuntu 24.04 LTS.

## File overview of this repo

