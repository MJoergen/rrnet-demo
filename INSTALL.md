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
  libpng-dev libgif-dev libcurl4-openssl-dev libevdev-dev libpcap-dev
```

`libpcap-dev` is the package that makes Ethernet support possible.

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

Start `x64sc`, open **Settings → Cartridges / I/O extensions → Ethernet**, enable the RR-Net cartridge and select the host network interface.

## Notes

- Packet capture works well on wired Ethernet but is often unreliable on Wi-Fi, because many wireless drivers will not pass frames that carry the emulated MAC address.
- The RR-Net is hardware only. The TCP/IP stack comes from the software you run in the emulator, for example programs built with ip65.

