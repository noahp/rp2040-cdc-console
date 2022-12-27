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

<details><summary>You can also use the `flash` target:</summary>

This makes use of the DTR wiggle and `picotool` to flash it touchless (safe to
ignore the IOCTL error, that's because the board rebooted to bootloader).

```bash
❯ cmake --build build --target flash
[1/1] cd /home/noah/dev/github/rp2040-cdc-console/build && python -m serial --dtr 0 /dev/ttyACM0 1200 2>&1 >/dev/null || true && sleep 0.5 && picotool load -v rp2040_cdc_console.bin && picotool reboot
--- forcing DTR inactive
Traceback (most recent call last):
  File "/usr/lib/python3.10/runpy.py", line 196, in _run_module_as_main
    return _run_code(code, main_globals, None,
  File "/usr/lib/python3.10/runpy.py", line 86, in _run_code
    exec(code, run_globals)
  File "/home/noah/.virtualenvs/default/lib/python3.10/site-packages/serial/__main__.py", line 3, in <module>
    miniterm.main()
  File "/home/noah/.virtualenvs/default/lib/python3.10/site-packages/serial/tools/miniterm.py", line 998, in main
    serial_instance.open()
  File "/home/noah/.virtualenvs/default/lib/python3.10/site-packages/serial/serialposix.py", line 336, in open
    self._update_dtr_state()
  File "/home/noah/.virtualenvs/default/lib/python3.10/site-packages/serial/serialposix.py", line 715, in _update_dtr_state
    fcntl.ioctl(self.fd, TIOCMBIC, TIOCM_DTR_str)
OSError: [Errno 71] Protocol error
Loading into Flash: [==============================]  100%
Verifying Flash:    [==============================]  100%
  OK
The device was rebooted into application mode.
```

That method only works if there's a valid CDC app running already.

</details>

## Test

```bash
# open miniterm to talk to the device
❯ pyserial-miniterm /dev/serial/by-id/usb-Raspberry_Pi_Pico_E66118604B705F29-if00 115200 --raw
```
