# Building VICE with Ethernet support on Ubuntu 24.04 LTS

This guide builds the [VICE](https://vice-emu.sourceforge.io) Commodore emulator from source with Ethernet support enabled, so that it can emulate network cartridges such as the RR-Net.

The commands use VICE 3.9 as an example. Check the [VICE website](https://vice-emu.sourceforge.io) for the current release and adjust the version number.

## 1. Remove the apt version (if installed)

```bash
sudo apt remove vice
```

This avoids launching the wrong binary by accident.

## 2. Install the build tools and libraries

```bash
sudo apt update
sudo apt install build-essential autoconf automake pkg-config byacc flex gawk \
  xa65 dos2unix texinfo libgtk-3-dev libglew-dev libpulse-dev libasound2-dev \
  libpng-dev libgif-dev libcurl4-openssl-dev libevdev-dev libpcap-dev libcap-dev
```

`libpcap-dev` is the package that makes Ethernet support possible. `libcap-dev` lets VICE
see the network permissions granted in step 6. Without it, VICE only uses pcap when run as
root, and otherwise falls back to the "tuntap" driver, which fails with
`ERROR transmitting frame: 'Input/output error'`.

## 3. Download and unpack the source

```bash
wget https://sourceforge.net/projects/vice-emu/files/releases/vice-3.9.tar.gz
tar xf vice-3.9.tar.gz
cd vice-3.9
```

## 4. Configure with Ethernet enabled

```bash
./configure --enable-gtk3ui --enable-ethernet --disable-pdf-docs
```

If `configure` stops with an error about a missing library, install the `-dev` package it names and run the command again.

At the end, `configure` prints a summary. Check that it contains these two lines:

```
Network capture/injection support: yes
POSIX 1003.1e capabilities support: yes
```

## 5. Build and install

```bash
make -j$(nproc)
sudo make install
```

VICE is installed to `/usr/local`, with the ROMs included, so no separate ROM step is needed.

## 6. Allow network access without root

```bash
sudo setcap cap_net_raw,cap_net_admin=eip /usr/local/bin/x64sc
```

Repeat this for any other emulator binary you want to use with Ethernet (for example `x128`).

`make install` replaces the binary and removes these permissions, so repeat this step
every time you rebuild VICE.

## 7. Clear the shell's command cache

```bash
hash -r
```

Bash remembers the path of commands it has already run. If you previously ran the apt version, the shell still looks for `/usr/bin/x64sc` and fails to find the new binary in `/usr/local/bin`. `hash -r` clears that cache. Opening a new terminal has the same effect.

## 8. Verify the build

```bash
x64sc -help | grep -i ether
```

If this lists Ethernet options, the build has Ethernet support.

## 9. Enable the RR-Net in VICE

The Ethernet cartridge is disabled by default, so remember this step. Start `x64sc` and open **Settings → I/O extensions → Ethernet
cartridge**. Tick **Enable**, set the mode to **RR-Net**, the base address to **$DE00**,
the driver to **pcap**, and the interface to your wired network card (for example
`enp3s0`). Then save the settings.

The same settings on the command line are

```bash
x64sc -ethernetcart -ethernetcartmode 1 -ethernetcartbase 56832 \
  -ethernetiodriver pcap -ethernetioif enp3s0
```

If VICE cannot open the network card (for example because step 6 was skipped, or the
interface name is wrong) it silently leaves the cartridge disabled. Programs then report
that no Ethernet chip was found.

## Notes

- Packet capture works well on wired Ethernet but is often unreliable on Wi-Fi, because many wireless drivers will not pass frames that carry the emulated MAC address.
- The RR-Net is hardware only. The TCP/IP stack comes from the software you run in the emulator, for example programs built with ip65.

