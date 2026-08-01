---
title: USB Host
description: 
published: true
date: 2026-08-01T19:32:00.830Z
tags: 
editor: markdown
dateCreated: 2026-04-07T16:49:21.418Z
---

# USB Host

## Overview

This feature allows you to use the native USB on an ESP32-S3 MCU as a USB Host. This allows you to connect USB devices (clients) to FluidNC. These could be things like pendants and displays. 

Devices like the M5Stack Dial, CYD display and Elecrow HMI have USB device ports. You could directly connect them via USB. The advantages are..

- Most devices can also be powered by the USB
- USB cables are much more tolerant to electrical noise and designed for high speed connections.
- GPIO pins that were used for UART communication can now be used for other features like knobs and buttons.

> The firmware for the existing pendants and displays will need to be modified to use the USB for communication.
{.is-info}

## Supported USB port modes

### USB CDC

By default the native USB port will act as a USB/Serial client device. You can connect it to a host, like a PC. It will connect as a USB CDC (Communications Device Class) virtual serial port. Most computers should have a native driver for this. It is not setup by the config file. This is controlled by the `$USBCDC/Enable` setting.

- **$USBCDC/Enable=On** (default) This creates a USB CDC Serial device. You can connect with a PC, etc. like a normal USB/Serial chip
- **$USBCDC/Enable=Off** Set to off when you want to use the USB in Host mode.

> Note: Both modes are dynamic features created by firmware. When the ESP32 resets, the ports will go away and come back. This will cause a disconnection on connected devices. Most client devices connecting to host mode should auto-reconnect. When connecting to a PC in CDC mode, the terminal program on the PC may need to be manually reconnected.
{.is-info}

### USB Host mode

You need to set `$USBCDC/Enable=Off` and have a config section. Internally to FluidNC, the communication looks like a UART, so you need to setup a UART and link it to a channel.

Example

```yaml
uart3:
  usb_host: 
    baud: 1000000

uart_channel3: 
  report_interval_ms: 0
  uart_num: 3
  message_level: Verbose
```

**Detail**

- `baud:` The baud does not matter and does not need to match the client setting. This is a virtual serial port and the data moves at the USB speed.
