---
title: Displays and Pendants
description: How to use displays and pendants with FluidNC
published: true
date: 2026-08-23T09:10:44.510Z
tags: 
editor: markdown
dateCreated: 2023-12-27T14:29:45.137Z
---

# Displays and Pendants

# Overview

We are transitioning away from direct support of displays in FluidNC. With FluidNC, everyone uses the same compiled version. This means every feature, whether you use it or not, is in the firmware. Displays can take up a lot of code space due the graphics and large amount of text. Trying to support many types is impossible.

The solution is to provide a very robust interface to external smart displays. Smart displays have a programmable processor, communicate via a UART and are very cheap and powerful these days. The interface uses the same protocol the gcode senders use over [UART channels](http://wiki.fluidnc.com/en/config/uart_sections). This means they can do anything a traditional gcode sender can do. Channels also implements optional pushed status. This means you don't constantly poll FluidNC. It tells you nearly immediately when something has changed. This means the display is more responsive and uses less bandwidth.


# Getting Started

## Library

We have a [Github repo with an API written in C and C++](https://github.com/MitchBradley/GrblParser). This does all of the work of communicating with and parsing the information from FluidNC.

## Basic Examples

 There are also some [simple example projects here](https://github.com/bdring/PendantsForFluidNC).

# Existing Projects

## M5 FluidDial

[![fd1.png](/hardware/fd1.png =x400)](/hardware/official/M5Dial_Pendant)

[M5Dial wiki page](/hardware/official/M5Dial_Pendant)

## CYD Dial
[![cydpendant.jpg](/cydpendant.jpg =x480)](/hardware/official/CYD_Dial_Pendant)
[CYD Dial Wiki Page](/hardware/official/CYD_Dial_Pendant)

## PiBot CNC Pendant V4.0

- **Open Source:** [No]
- **[Documentation](https://www.pibot.com/pibot-cnc-pendant-v4)**
- **Project Supporter:** Yes
- **Discord Name** @abcpibot
- **For Sale:** [Yes](https://www.pibot.com/pibot-cnc-pendant-v4) 
- **Description:** We adapted FluidDial by providing firmware that enables one-click installation for immediate use. Additionally, we integrated standalone Bluetooth communication for wireless connectivity and a battery power system. new ESP3DX firmware UI has been developed to support both FluidDial.

![pibotpendantv4331.jpg](/hardware/displays/pibotpendantv4331.jpg)


## FluidTouch

- **Open Source:** [Yes, MIT](https://github.com/jeyeager65/FluidTouch)
- **[Documentation](https://github.com/jeyeager65/FluidTouch/blob/main/README.md)**
- **Discord Name:** @jeyeager
- **For Sale:** No, but display can be purchased from Elecrow.
- **Description:** FluidTouch is a wireless touch-screen pendant for Elecrow CrowPanel 7-inch ESP32 displays.

<img src="https://github.com/jeyeager65/FluidTouch/blob/main/docs/images/photo.png?raw=true" />

## FluidDial-CYD (Wired or Wireless + Li-Ion Battery)

- **Open Source:** [Yes, GPL-3.0](https://github.com/dJOS1475/FluidDial-CYD)
- **[Documentation](https://github.com/dJOS1475/FluidDial-CYD/blob/main/README.md)**
- **Discord Name:** @dJOS_500
- **For Sale:** [Yes](https://www.tindie.com/products/38825/) or [DIY](http://wiki.fluidnc.com/en/hardware/official/CYD_Dial_Pendant).
- **Firmware Web-Installer:** https://djos1475.github.io/FluidDial-CYD/
- **Description:** FluidDial-CYD is a custom firmware for CYD-equipped FluidDial CNC pendants. The UI has been rebuilt from the ground up for devices with 3 physical buttons and a jog dial. Supports both resistive (XPT2046) and capacitive (CST816S) CYD screen variants.
- **Probing:** Includes onboard support for Z Surface Probes, XYZ Probes and 3D Touch probes. Supports Z Surface, XYZ Corner, Bore, and Boss Probing.
- **Wireless and Li-Ion Battery support**: is included for the Capacitive CYD's and you can switch between them as desired. Wireless connectivity is via ESP-NOW which performs extremely well. FluidNC v4.0.4+ is required on the CNC controller. Pouch cell batteries of less that 3000mAh are ideal and fit under the display in the stock case.
Note: Resistive CYD's have no built in Li-Ion battery support but do still support ESP-NOW.

![img_4804_2.jpeg](/img_4804_2.jpeg =x550)