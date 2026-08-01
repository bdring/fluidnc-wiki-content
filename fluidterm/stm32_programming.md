---
title: STM32 Programming with FluidTerm
description: How to use FluidTerm to program an STM32 Expander
published: true
date: 2026-08-01T19:37:06.501Z
tags: 
editor: markdown
dateCreated: 2025-02-03T22:14:28.087Z
---

# Programming an STM32 MCU with FluidTerm
FluidTerm can program the Flash inside an STM32 MCU.  The STM32 device can be installed in an expansion module slot on a FluidNC controller, so FluidTerm connects to FluidNC via the usual USB-Serial port and the programming data is passed through to the STM32.  Alternatively, you can connect the STM32 device to the FluidTerm PC via a USB-Serial dongle.

> This only works with the Windows version of FluidTerm.  If someone wishes to take on the project of adding STM32 programming to the Python FluidTerm, please contact the FluidNC developers.
{.is-info}


## Configuring FluidNC for STM32 Passthrough
The STM32 device must be connected via a FluidNC uart device like *uart1* or *uart2*.  In the config file, you must add *passthrough_baud* and *passthrough_mode* items to define the serial parameters to use for programming the STM32.  They are often different from the parameters used for normal communication between FluidNC and the STM32.
```
uart1:
    passthrough_baud: 57600
    passthrough_mode: 8e1
    (and the usual other uart config items)
```
The default value for *passthrough_baud* is 0, meaning that the uart device is not intended for passthrough mode.  Most STM32 devices can be programmed reliably with 57600 baud, and some can work at 115200 baud.  The default value for *passthrough_mode* is "8e1" - 8 data bits, even parity, one stop bit - which is correct for most STM32 models.  Data bits is 5, 6, 7, or 8.  Parity is e (even), o (odd), or n (none).  Stops bits is 1, 1.5, or 2.

## Preparing the STM32 for Programming

The STM32 must be set into "bootloader mode".  To do that you must reset the device with the BOOT0 pin set to low, either by a jumper or a pushbutton according to what is present on the hardware.  For example, if the device has both BOOT0 and RESET buttons, press the BOOT0 button and hold it while pressing and releasing the RESET button.  The device will enter bootloader mode and stay in that mode until it is later reset without the BOOT0 button held down.

## Common Use Case - Programming the STM32 Flash

With FluidTerm talking to a FluidNC controller configured for passthrough, you can program the STM32 by typing **Ctrl-S**, then `-w<Enter>` as shown below.  **Boldface** shows what you type; the rest is informational output from FluidTerm.

  > **Ctrl-S**                    *(Type the Ctrl-S key in FluidTerm)*
> 
> STM32 Loader Command: **-w**
> *(A file selector dialog lets you choose the file)*
> Using Parser : Raw BINARY
> < $Uart/Passthrough=auto
> 
> Version      : 0x22
> Option 1     : 0x00
> Option 2     : 0x00
> Device ID    : 0x0410 (STM32F10xxx Medium-density)
> - RAM        : Up to 20KiB  (512b reserved by bootloader)
> - Flash      : Up to 128KiB (size first sector: 4x1024)
> - Option RAM : 16b
> - System RAM : 2KiB
> Write to memory
> Erasing memory
> Wrote address 0x08020000 (100.00%) Done.

## File Format

For writing to Flash, the file format can be either raw binary or Intel Hex format.  If the file contents appear to be a valid Intel Hex file, that format will be used; otherwise raw binary format will be used.

For reading from Flash, a binary file is created.  If the read-to file already exists, the operation will fail with an error message, so delete the old file first.

## Port Selection Overrides
Instead of letting FluidNC choose which uart to use based on the *passthrough_baud* value, you can force it to use, for example, **uart2** by adding `-p uart2` to the command, so the full command would be `-p uart2 -w myprogram.bin`.  If you do not specify `-p something`, it is the same as saying `-p auto`.  There is also a direct mode whereby you can program an STM32 that is not on a FluidNC controller, with `-p direct`, as described in a section below.

## Other Commands

### Help
`-h` will display the list of commands

### Reading from STM32 Flash

`-r` will read the STM32 Flash into a file chosen with a file selector dialog.

### Device Info/Testing

You can test the connection without actually programming the device.  The command for that is the empty command, i.e. just type Enter at the **STM32 Loader Command:** prompt (a `-p uart2` override with nothing else on the line also tests the connection.  The response will be the Version and other information as shown in the Simple Usage example above.

### Miscellaneous Commands

You can access other features of the STM32's internal bootloader as follows. In most cases you will not need these.
* `-C`		Compute CRC of flash content
* `-u`		Disable the flash write-protection
* `-j`		Enable the flash read-protection
* `-k`		Disable the flash read-protection
* `-o`		Erase only
* `-e n`	Only erase n pages before writing the flash
* `-v`		Verify writes
* `-n count`	Retry failed writes up to count times (default 10)
* `-g address`	Start execution at specified address (0 = flash start)
* `-S address[:length]`	Specify start address and optionally length for	read/write/erase operations
* `-F RX_length[:TX_length]`  Specify the max length of RX and TX frame
* `-s start_page`	Flash at specified page (0 = flash start)
* `-f`		Force binary parser
* `-h`		Show this help
* `-c`		Resume the connection (don't send initial INIT)
          *Baud rate must be kept the same as the first init*
* `-R`		Reset device at exit.
* `-b rate`		Baud rate (default 115200) (direct mode only)
* `-m mode`		Serial port mode (default 8e1) (direct mode only)
 

## Direct Connect Via a USB-Serial Dongle

You can connect an STM32 device directly to a USB-Serial dongle that is plugged into a USB port on your PC.  You need a 3.3V dongle because STM32 is a 3.3V device.  Connect GND to GND, Rx to Tx, Tx to Rx, and power the STM32 from 3.3V (or 5V if the module has a 5V power input with a stepdown to 3.3V).  Find the COM port that is associated with that USB dongle and select it at the initial FluidTerm prompt (if there is only one COM port available, FluidTerm will select it automatically).

Then type **Ctrl-S** to invoke STM32 programming and add `-p direct` in the programming command.


## Entering Passthrough Mode Manually
FluidTerm uses this FluidNC command automatically, so you usually would not need to use it directly, but it is documented here for completeness.
> **$Uart/Passthrough=** *port*

*port* can be **uart1** or **uart2** to manually select the given port or **auto** to select the first uart device with a nonzero *passthrough_baud* value.  **auto** is usually a good choice, but if you happen to have two STM32 devices, you might need to specify the desired one with, for example, **uart2**.  The **direct** value is not available, since it applies to FluidTerm without FluidNC passthrough.

FluidNC automatically exits passthrough mode after a few seconds of inactivity on the upstream and downstream ports.

    