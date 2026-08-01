---
title: Boxer - 6 Axis External Driver Controller
description: Boxer - 6 Axis External Driver Controller
published: true
date: 2025-04-28T16:06:17.229Z
tags: en
editor: markdown
dateCreated: 2025-04-21T17:37:44.094Z
---

# Boxer 6 Axis CNC controller

![boxer_v1p0.jpg](/hardware/boxer_v1p0.jpg =x500)

This is the Boxer. It is designed for people who need a lot of I/O, but also need the flexibility of a couple specialized modules, like a fully isolated RS485. It has a built in RJ12 for use with the Airedale I/O expander and pendants.

..with Airedale

- (6) External stepper driver connections.
- (14) opto isolated inputs. (6 gpio and 8 on Airedale)
- (8) 5V outputs
- (2) MOSFETs (on Airdale)
- (2) GPIO CNC I/O module sockets.
- (1) IS2O CNC I/O module socket
- (1) RJ12 for pendants.

# Getting Started

The controller ships with a version of FluidNC that was current when the controller was built. You should upgrade the firmware using the web installer or the [release packages at Github](https://github.com/bdring/FluidNC/releases).

1. Do not install your config file yet.
2. Do not connect any external devices yet.
3. Do not connect the USB yet. It will not work yet anyway.
4. Connect the antenna if the ESP requires and external one. You should only operate when the antenna is connected. A missing antenna can cause the device to overheat.
5. Connect main power. Be sure the polarity is correct before you turn on the power.
6. Turn on the main power and confirm that the 5v and 3.3V LEDs turn on. They are located in the middle of the controller. The LEDs associated with the stepper drivers may blink before the firmware sets them to the default turn on staqte.
7. Connect a USB-C cable between your computer and the controller. Check to see that your computer has added a serial port. See below if you have a problem.
8. Go to the [web installer](https://installer.fluidnc.com/). Connect to your controller and do an upgrade.
9. You may want to connect to your wifi at this time.
10. Now create and load a config file for your maqchine.
11. Power down and connect all your devices. It might be helpful to connect just a few at a time and test as you go.

## Power

The controller must be powered via a 12-30VDC power supply. This primary voltage is called VMot on the schematic and in the documentation. It should be able to supply a minimum of 2A.  If you are attaching external devices to any of the VMot connections, you should add those currents to the power supply minimum.

There is a header in the middle of the controller for access to 3.3v and 5v. These are for low current only. You should not pull more than 1A from any of these connections.

> You cannot power the controller with USB alone. The USB will not connect.
{.is-info}

> Be very careful getting the voltage polarity correct. There is no reverse polariy protection, so you will destroy the controller and probably some connected items. 
{.is-warning}

# USB C connector

The USB chip is a Silicon Labs CP2102 USB to serial chip. Many operating systems ship with the drivers installed already. If can get the [latest driver here](https://www.silabs.com/developer-tools/usb-to-uart-bridge-vcp-drivers?tab=downloads).

It ships with a default config file that is primarily used for factory testing and will probably not run your machine. You will need to [create a config file](http://wiki.fluidnc.com/en/config/overview) for your machine and upload it. 

# Motors

![external_stepper.jpg](/hardware/external_stepper.jpg =x200)

The controller is designed for external stepper driver modules that accept 5V step, direction, and enable signals. Each terminal block has ena, step, direction and common pins. You can use either a common ground or common 5V. This is set via the Drvr Com jumper. Most people would use a common ground.

The pins use [i2so](http://wiki.fluidnc.com/en/support/controller_design_guidelines#i2so-chips)  pins, so you need to use I2S_STATIC or I2S_STREAM in the [stepping section](http://wiki.fluidnc.com/en/config/axes#stepping) of your config file.

```yaml
stepping:
  engine: I2S_static
  idle_ms: 255
  pulse_us: 4
  dir_delay_us: 4
  disable_delay_us: 0
  segments: 6
  
i2so:
  bck_pin: gpio.22
  data_pin: gpio.21
  ws_pin: gpio.17
```

Any motor output can be used for any axis or motor number. They are labeled Motor1 through motor6, just for reference. Here are the pins for each motors.

```yaml
# motor 1
      standard_stepper:
        step_pin: I2SO.2
        direction_pin: I2SO.1
        disable_pin: I2SO.0
        
# motor2
      standard_stepper:
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: I2SO.7
        
# motor3
      standard_stepper:
        step_pin: I2SO.10
        direction_pin: I2SO.9
        disable_pin: I2SO.8
        
# motor4
      standard_stepper:
        step_pin: I2SO.13
        direction_pin: I2SO.12
        disable_pin: I2SO.15

# motor 5
      standard_stepper:
        step_pin: I2SO.18
        direction_pin: I2SO.17
        disable_pin: I2SO.16

# motor 6
      standard_stepper:
        step_pin: I2SO.21
        direction_pin: I2SO.20
        disable_pin: I2SO.23

```

## Inputs

There are 6 opto isolated inputs. They all have 10k pullup resistors. You activate the circuit by connecting the input pin to ground. There is an LED for each input the lights when the circuit is activated.

There are (2) 5V terminals at the end of each switch that can be used to power switches like optical and proximity switches. If  

## SD Card

```yaml
spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18

sdcard:
  card_detect_pin: NO_PIN
  cs_pin: gpio.5
```

## UART Expansion Port

The UART expansion port is designed to connect to pendants, like the FluidDial  and I/O expansion boards like the Airedale. It uses the standard RJ12 connector.

![boxer_uart.png](/hardware/boxer_uart.png =x320)


```yaml
# UART Expansion Port
uart1:
  rxd_pin: gpio.25
  txd_pin: gpio.2
  baud: 1000000
  mode: 8N1
  passthrough_baud: 57600
  passthrough_mode: 8E1

uart_channel1:
  report_interval_ms: 75
  uart_num: 1
```

## CNC I/O Module Sockets

Sockets #1 and #2 use ESP32 GPIO and can use any existing modules. The pin numbers are listed on the silkscreen of the PCB.

Socket #3 uses I2SO pis. These are output only pins. It is are restricted output only modules like the relay and 5V outout modules.

## Pinout Diagram

![boxer_pinout.png](/hardware/boxer_pinout.png =x600)

The bottom of the controller also has complete pinout information.

## Open Source

- ECAD Design files (comin soon



