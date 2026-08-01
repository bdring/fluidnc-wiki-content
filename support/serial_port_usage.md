---
title: USB/Serial Port Usage
description: 
published: true
date: 2026-08-01T19:39:27.565Z
tags: 
editor: markdown
dateCreated: 2022-07-21T20:54:40.272Z
---

# USB/Serial Port Usage

The serial port is the most basic connection. It can fully control FluidNC and it also receives useful messages before other interfaces like WiFi and Bluetooth are running. If the ESP32 crashes, detailed information about the reason is sent there. 



The FluidTerm program that comes with FluidNC in the release installer package is a good way to interface directly with the serial port for debugging and initial setup.  You could also use other terminal programs like the one in WebInstaller, or the Arduino IDE, or platformio, or the console in a Grbl sender UI.  If you use a terminal program that is not specifically intended for FluidNC, set the communications parameters to **115200 baud, 8 data bits, 1 stop bit, no parity**. 

If you want to reboot to see the startup info, send **$bye** or click the boot button on your module.  FluidTerm also lets you reset the ESP32 by typing Ctrl-R.

## Serial Port Rebooting ESP32 (Technical Details)

In order for you to be able to automatically program an ESP32 through the serial port. The serial port must be able to reboot the ESP32 and tell it to enter bootloader mode. It does this using a sequence of pulses on the RTS and DTR signals coming out of the USB to serial chip on the dev kit module.

It does this using this circuit...

<img src="http://www.buildlog.net/blog/wp-content/uploads/2021/01/esp32.png" width="300">

And this sequence...

- RTS low, DTR high = Reset low, GPIO0 high -> Reset the chip
- RTS high, DTR low = Reset high, GPIO0 low -> Switch to boot mode
- RTS high, DTR high = Reset high, GPIO high -> normal operation

If your serial terminal does the first step of this when opening a connection, it will reboot the ESP32. If you are trying to connect to a running ESP32 and don't want to reboot it, you must make sure the serial terminal does not do this.

- Arduino IDE (Windows) Does not reboot the ESP32
- PlatformIO (Windows) Inconsistent, but usually reboots the ESP32
- fluidterm Does not reboot the ESP32
- GCode senders
  - Some reboot it the ESP32
  - Some send a Grbl reset command
  - Some do neither.
  
## CH340 USB/Serial on Mac

Many low-cost controller use a "CH340" USB/Serial chip, instead of the CP210x chip that is more common on Espressif modules and official FluidNC controllers from the FluidNC developers.  It is often necessary to install a special driver for that chip on Mac, as the standard Mac drivers do not support some variants of that chip.  This is especially troublesome on newer versions of MacOS like Tahoe, because their security requires you to unlock several things to enable unsigned drivers to be installed, and the older signed drivers do not work.  It is further complicated by the two different Mac processors - Intel on older Macs and ARM on new M1..M5 Macs.

This section explains how I finally succeeded in installing a working CH340 driver on an M4 Mac running Tahoe 26.2.

### Use CH340SER v2.0 or later

Many instructions on the internet refer to v1.5 of the CH340 installer package.  That did not work for me.  Apparently v1.5 works with some versions of the CH340 chip, specifically USB VID 1A86 PID 7523, but it does not recognize CH340s that identify as VID 1A86 PID 7522.  I finally found v2.0 at https://www.wch.cn/downloads/CH341SER_MAC_ZIP.html, downloading it from the GitHub link.

There are many links on the internet to older versions that will tie you in knots trying to resolve security problems.  Version 2.0, and hopefully subsequent versions, appears to be signed so MacOS will install it without problems.

### Use the .dmg installer, not .pkg, on M-series Macs

Apparently .pkg installation is for Intel Macs.  It can work using Rosetta emulation, but I could not get it to work.

The .dmg installer installs an app in the Applications folder.  When you run that app, it does the final driver installation.

### The serial port name is /dev/tty.wchusbserialNNNNNN

Some older drivers apparently used a dev name like /dev/cu.SOMETHING, which is similar to other chips, but this CH340 driver uses /dev/tty.wchusbserialNNNNNN where NNNNNN is some number that changes if you have more than one CH340 plugged in.  FluidTerm and Fluid WebInstaller both know how to find those device names, and will present you with a menu to select one.  If there is only one suitable serial device, FluidTerm will skip the menu.

## Troubleshooting on Windows

### Cannot Connect Initially

If you cannot connect to the ESP32 with a serial terminal like FluidTerm, or with a serial download program like the installer in the release package or WebInstaller, use Windows Device Manager to see if the PC recognizes the USB Serial device on the controller board <img src=/images/devicemanager.png>.

The types of USB Serial devices that are common on ESP32 systems are "Silicon Labs CP210x" and "CH340".  If there are several such devices, the one you want is the one that disappears from the list when you unplug it.

If there is no such device, sometimes it is because your controller board requires external power.  Most controllers let you power the USB Serial chip and the ESP32 itself directly from the USB cable, but there are some boards that only work if you have external power.

Another possible problem is a bad USB cable, or a power-only USB cable that is meant for charging only and has no data wires inside.

If Device Manager shows a device but indicates that it has problems, the problem could be that you do not have a device driver installed for the USB Serial chip that is on your board.  Install a [CP210x driver](https://www.silabs.com/developer-tools/usb-to-uart-bridge-vcp-drivers?tab=downloads) or a [CH340 driver - enter ch340 in the search box and look for CH341SER.ZIP](https://www.wch.cn/search.html) as needed.

### Dropped Connections

If you are having issues with dropped USB connections, keep in mind the firmware and the ESP32 have very little to do with this connection. There is a USB to serial chip that maintains the connection and turns it into serial data. The firmware and ESP32 cannot cause a drop in the USB connection. If there is a problem in that area, the transfer of data may stop, but the USB connection is not affected. The firmware does not know that the connection was lost.

The typical problem is related to electrical noise, physical connection or voltage drop. Be sure you are using a high quality cord that is as short as possible. Tie it down, so it cannot wiggle at the connector. Consider using a powered USB hub to make sure it have plenty of voltage. Route it away from any wires on your machine, especially motor wires and power wires.

We are sorry, but we can only provide limited help with this problem.





