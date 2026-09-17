---
title: Greyhound 6x S3 Controller
description: The 2nd generation 6x controller
published: true
date: 2026-09-17T22:28:56.047Z
tags: 
editor: markdown
dateCreated: 2026-09-17T14:49:53.603Z
---

# Greyhound 6x-S3 Controller

> This page is a work in progress. The first set of prototype controllers have not arrived yet.
{.is-info}

![greyhound_render1.png](/hardware/greyhound/greyhound_render1.png =x500)


# Overview

This is the second generation of the popular [6x controller](http://wiki.fluidnc.com/en/hardware/official/6x_CNC_Controller). This uses the ESP32-S3 MCU to gain a few extra pins and features.

This is designed for people who prefer screw terminals over crimp connectors. If you prefer connectors, I suggest the very similar [Doberman controller](http://wiki.fluidnc.com/en/hardware/official/doberman).

# Features

- (6) Motor connectors for [external stepper drivers](http://wiki.fluidnc.com/en/support/external_stepper_motor_drivers). Each motor has separate step, direction and enable signals. LEDs are on each signal to help with setup.
- (10) Inputs for switches (limits, probes, control)
- (2) 3A MOSFETs to drive relays, solenoids and valves.
- (4) 5V Output signals with PWM capability
- Micro SD card socket for local storage of gcode files
- CNC I/O Module socket for added I/O and advanced features like wired Ethernet
- RJ12 expansion connector for I/O expanders, displays and pendants.
- (2) USB-C connectors
   - The primary one is a USB to serial adapter to connect to gcode senders and programmers.
   - The secondary one is a native USB interface to the ESP32.
- Spindles (many types supported). Multi-spindle arrangements are possible like RS485 & laser on the same machine.
  - Isolated RS485 circuit for VFD Spindles
  - 0-10V controlled spindles with additional forward and reverse direction signals
  - PWM Speed controllers with optional separate enable signals
  - Relay (on/off) controlled spindles.
  - BESC (Brushless Motor) based spindles
  - Lasers with PWM and enable
- Reverse voltage protection on the input voltage.


# Where to buy it

Elecrow coming soon.

# Getting Started

The controller ships with a version of FluidNC that was current when the controller was built. You should upgrade the firmware using the web installer.

1. Do not install your config file yet.
2. Do not connect any external devices yet.
3. Connect the antenna. You should only operate when the antenna is connected. A missing antenna can cause the ESP32 chip to overheat. 
5. Connect main power. Be sure the polarity is correct before you turn on the power.
6. Turn on the main power and confirm that the 5v LED (green, near the center of the PCB) is lit.
7. Connect a USB-C cable between your computer and the controller. Use the USB connector labeled **USB1** . Check to see that your computer has added a serial port.
8. Go to the [web installer](https://installer.fluidnc.com/). Connect to your controller.
9. Click the button to open the terminal. Enter the command $localfs/run=test.nc. This should sequencially blink all of the I/O test LEDs on the controller.
10. Do an upgrade (not full installation).
11. You may want to connect to your wifi at this time.
12. Open the [configuration wizard](https://mitchbradley.github.io/FluidNC-config-wizard/) on your browser, select the greyhound controller and create a config file.
13. Power down and connect all your devices. It might be helpful to connect just a few at a time and test as you go.

# Config Files

It is strongly recommended that you use the [configuration wizard](https://mitchbradley.github.io/FluidNC-config-wizard/) to create config files. You can see a demonstration video here.



# Asking for Help

# Power

The controller should be powered by 12V. Your power supply should be able to provide about 1A for the basic controller functions plus whatever current is attached to the MOSFET terminal. The terminal block is rated for 10A. It should be connected to the "Vin" pins on the green terminal block. Double check the polarity before powering on, but there is reverse polarity protection.

A green LED will light in the center of the conntroller when power is properly applied. Depending on the state of the controller other LEDs may also light or blink.

> You cannot power the controller with either USB connector. Nothing will work until the primary power connected for anything to work including USB.
{.is-warning}

# ESP32 Chip Type

It is an ESP32-S3-WROOM-1U-N8R2.

- 1U = Antenna connector rather than a built in one. 
- N8 = 8 MB (Quad SPI) Flash
- R2 = 2 MB (Quad SPI) PSRAM
  
## ESP32 Antenna

The antenna connector is an IPEX connector type. It ships with a basic one like this. You can easily find larger or more directional ones on Amazon or AliExpress. You should always have an antenna connected when using the Wifi or Bluetooth modes.

<img src="https://github.com/bdring/FluidNC/wiki/images/ipex_antenna.png" width="200">

# USB

## Primary (USB1)

The primary USB-C connector (upper one) is used for the basic interface of the controller. It creates a COM port on your computer when it is connected and power is on. It is used for programming and connecting gcode senders.

## Secondary (USB2)

**This feature is experimental at this time**

The other USB connector, labeled USB CDC, connects directly to the ESP32. By default this native USB will be a CDC (communication device class) USB/Serial UART. Most computers will already have a driver for this.

This USB can also work in host mode, where it can communicate and power devices like keyboards, joysticks, wire ethernet and jog controllers.

>  At this time FluidNC has no support for any devices in host mode. The connector was tested using simple example sketches of host mode. There is no guarantee that FluidNC will ever support this. This was just an attempt to future proof the controller and work as a development platform.  
{.is-warning}

# Motor Driver Terminals

The motor drivers circuits use (2) [STMicro STP16CP05](https://item.szlcsc.com/datasheet/STP16CP05TTR/138548.html) chips. These are constant current, LED sink driver, shift register chips. We use the Is2o feature of the ESP32 to output the shift register signals. 

The constant current feature is setup for about 20mA. This means a 20mA or lower current will be driven constantly. This should be way more than the optos motors drivers use. This method was chosen to protect the pins from some accidental mis-wires, like a short to ground or a positive voltage. Anything attempting to pull more current will cause them to PWM to lower the average current, or shut off completely.

They sink current which means the signals must be connected to the minus side of the optos and the plus side should be connect to +5V. In the off state the pins are floating (not connected to any voltage)

> Any usused signal, plus the extra 6 i2so pins on the 8 pin header connector, can be used as outputs to control other features. Keep in mind that these current sync to ground in the active state and float in the inactive state.
{.is-info}

```yaml
# motor 1
      standard_stepper:
        step_pin: I2SO.1
        direction_pin: I2SO.2
        disable_pin: I2SO.0

# motor2
      standard_stepper:
        step_pin: I2SO.4
        direction_pin: I2SO.5
        disable_pin: I2SO.3

# motor3
      standard_stepper:
        step_pin: I2SO.7
        direction_pin: I2SO.8
        disable_pin: I2SO.6

# motor4
      standard_stepper:
        step_pin: I2SO.17
        direction_pin: I2SO.18
        disable_pin: I2SO.16

# motor 5
      standard_stepper:
        step_pin: I2SO.20
        direction_pin: I2SO.21
        disable_pin: I2SO.19

# motor 6
      standard_stepper:
        step_pin: I2SO.23
        direction_pin: I2SO.24
        disable_pin: I2SO.22
```

## Motor Wiring example

 

### Closed loop motors

Most closed loop motor drivers can be used. See [this wiki page](http://wiki.fluidnc.com/en/support/external_stepper_motor_drivers#closed-loop-steppers-and-servo-motors) for more details.

# Inputs

All inputs activate by closing the circuit to ground. You can use N.O. and N.C switch as long as one position closes to ground. 

You can use electronic switches like proximity or inductive switches as long as the output signal switches to ground (typically called NPN). If the switches require external power you need to connect that elsewhere on the controller or an external power supply that shares a common ground.

All of the inputs have external pullup resistors. You do not need to add :pu in the config file.

For normally open switches you need the **:low** attribute on all inputs. Normally closed are active high. You can add the ***:high*** attribute, but it is not needed because that is default in FluidNC.

# 5V Outputs



# Spindles

# MOSFETs

The (2) NPN MOSFETs are rated for 3A continuous and 5A peak. There are flyback diodes connected to Vin to make them safe for use with inductive loads, such as relays and solenoids.

The MOSFETs share pins with (2) 5V outputs. If you are using the wizard, please assign the MOSFET beforee the 5V outputs so you know which 5v pins are still available.

The VMot terminals are always connected to VMot. Terminals labeled with the io pin numbers switch to ground when the io pins are active. If you need to operate devices with other voltages than VMot, you can use a separate DC power supply as long as it shares a common ground with the controller.

# RJ12 Expansion Port

Here is a config file example.

```yaml
uart1:
  txd_pin: gpio.0
  rxd_pin: gpio.35
  rts_pin: NO_PIN
  cts_pin: NO_PIN
  baud: 1000000
  mode: 8N1

uart_channel1:
  report_interval_ms: 75
  uart_num: 1
```

# CNC I/O Module Socket

The expansion socket is compatible with all existing CNC I/O Module designs (4 I/O pins). It also adds (3) extra pins that are connected to the SPI bus that the SD card also uses.

![module_v2.png](/hardware/greyhound/module_v2.png =x300)

## Wired Ethernet Module

You need to install a separately purchased ethernet module and install it like this.

![gh_eth.png](/hardware/greyhound/gh_eth.png =x300)

Here is what you need in the config file. [See this wiki page](http://wiki.fluidnc.com/en/features/wifi_bt#wired-ethernet).

```yaml
ethernet:
  cs_pin: gpio.14
  int_pin: gpio.13
  rst_pin: gpio.10
  phy_type: w5500
  phy_addr: 1
  frequency_hz: 1000000
```

# Source Files

Source files will be provided when the controller is ready for sale,

# Pinout Reference

> The config wizard is also very good way to determine the pin numbers.
{.is-info}


