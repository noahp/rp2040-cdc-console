# Example USB-CDC Console for RP2040

Small example USB-CDC console project based on:

https://github.com/raspberrypi/pico-examples/tree/afd1d2008f3fb3fa7a837dd1bdf17a6fecbc57fe/hello_world/usb

## Prerequisites

```bash
# install build tools
❯ sudo apt install cmake ninja-build
# install compiler if not already on PATH
❯ sudo apt install gcc-arm-none-eabi

# make sure to add yourself to dialout on linux
❯ sudo usermod -a -G dialout $USER
# logout and login to have it take effect

# install some serial console, for example pyserial-miniterm
❯ pip install pyserial
```

## Build

```bash
❯ git clone --recursive https://github.com/noah/rp2040-cdc-console.git
❯ cd rp2040-cdc-console
❯ cmake -B build -GNinja
❯ cmake --build build
```

To flash the board, put it in BOOT mode by holding the BOOTSEL button and power
cycling, then copy the UF2 file to the board and power cycle:

```bash
# copy the UF2 image to the board
❯ cp  build/rp2040_cdc_console.uf2 /media/$USER/RPI-RP2/
```

## Test

```bash
# open miniterm to talk to the device
❯ pyserial-miniterm /dev/serial/by-id/usb-Raspberry_Pi_Pico_E66118604B705F29-if00 115200 --raw
```
