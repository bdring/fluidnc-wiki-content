---
title: xPro V5
description: 
published: true
date: 2025-11-01T17:26:41.974Z
tags: 
editor: markdown
dateCreated: 2022-10-08T02:48:38.036Z
---

![xpro.png](/hardware/xpro.png)

## Overview

This page is to share information helpful when using FluidNC on the [Spark Concepts xPro V5](https://www.spark-concepts.com/cnc-xpro-v5/). Your first line of support should be directly with the supplier. [They also have a wiki](https://github.com/Spark-Concepts/xPro-V5/wiki). We cannot guarantee this is accurate and mistakes could damage your controller.

## Stepper Driver Pinout

The controller uses [Trinamic](http://wiki.fluidnc.com/en/config/axes#trinamic-drivers) [TMC5160](http://wiki.fluidnc.com/en/config/axes#tmc5160) stepper motor drivers. The drivers are set up and controlled by the firmware using a daisy chained SPI bus shared with the SD card. It uses the default SPI pinout for FluidNC.

```yaml
spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18
```

- The `cs_pin:` is `gpio.17` and should be defined under the first motor.
- There are no enable pins. You should set `use_enable: true` on each axis.

The labels for the motors are suggestions only. You can use any driver for any axis or motor(0/1) you want. The things that you cannot change are shown in the notes in the graphic below. For example: the terminal block labeled Y can be anything, but whatever you assign it to, that driver must use `spi_idex: 2`, etc.

**NOTE:** Due to the way SPI daisy chain works, you must have a motor with `spi_index: 4`. This insures data is pushed through the whole daisy chain. For example: if you only want to use 2 axes, one must be `spi_index: 4` (labeled A/Y2).  

![xpro_axes.png](/hardware/xpro_axes.png =x600)

## Other Pins
XLimit: gpio.35
YLimit: gpio.34
ZLimit: gpio.39
A/Y2Limit: gpio.36
Probe: gpio.22

Mist: gpio.21
Door: gpio.16
Macro1: gpio.13
Macro2: gpio.0

Spindle Enable or RS485RX: gpio.4
Spindle PWM Output or RS485TX: gpio.25

SPI SCK: gpio.18
SPI MISO: gpio.19
SPI MOSI: gpio.23

SDCard CS: gpio.5
TMC CS: gpio.17

## Programming

The xPro V5's circuitry for entering programming mode based on signals from the USB serial chip is not the same as on most Espressif modules.  If you have trouble with programming with the FluidNC installer or esptool, you can manually force it into programming mode:
* Press and hold the Reset button
* While holding Reset, press and hold the Program button
* Release the Reset button
* Release the Program button

Then it will be in programming mode and you can run the installer or esptool to program the ESP32.

## Example Config File

```yaml
board: XPro V5
name: xPro V5 XYZA
stepping:
  engine: RMT
  idle_ms: 255
  pulse_us: 2
  dir_delay_us: 1
  disable_delay_us: 0

axes:
  shared_stepper_disable_pin: NO_PIN
  x:
    steps_per_mm: 200.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.35:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      tmc_5160:
        step_pin: gpio.12
        direction_pin: gpio.14
        use_enable: true
        cs_pin: gpio.17
        spi_index: 1
        r_sense_ohms: 0.050
        run_amps: 1.800
        hold_amps: 1.250
        microsteps: 8
        toff_disable: 0
        toff_stealthchop: 5
        run_mode: CoolStep
        homing_mode: CoolStep
        stallguard: 16
        stallguard_debug: false
        toff_coolstep: 3
        tpfd: 4

  y:
    steps_per_mm: 200.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.34:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      tmc_5160:
        step_pin: gpio.27
        direction_pin: gpio.26
        use_enable: true
        cs_pin: NO_PIN
        spi_index: 2
        r_sense_ohms: 0.050
        run_amps: 1.800
        hold_amps: 1.250
        microsteps: 8
        toff_disable: 0
        toff_stealthchop: 5
        run_mode: CoolStep
        homing_mode: CoolStep
        stallguard: 16
        stallguard_debug: false
        toff_coolstep: 3
        tpfd: 4

  z:
    steps_per_mm: 200.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.39:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      tmc_5160:
        step_pin: gpio.15
        direction_pin: gpio.2
        use_enable: true
        cs_pin: NO_PIN
        spi_index: 4
        r_sense_ohms: 0.050
        run_amps: 1.800
        hold_amps: 1.250
        microsteps: 16
        toff_disable: 0
        toff_stealthchop: 5
        run_mode: CoolStep
        homing_mode: CoolStep
        stallguard: 16
        stallguard_debug: false
        toff_coolstep: 3
        tpfd: 4

  a:
    steps_per_mm: 200.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.36:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      tmc_5160:
        step_pin: gpio.33
        direction_pin: gpio.32
        use_enable: true
        cs_pin: NO_PIN
        spi_index: 3
        r_sense_ohms: 0.050
        run_amps: 1.800
        hold_amps: 1.250
        microsteps: 16
        toff_disable: 0
        toff_stealthchop: 5
        run_mode: CoolStep
        homing_mode: CoolStep
        stallguard: 16
        stallguard_debug: false
        toff_coolstep: 3
        tpfd: 4

spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18

sdcard:
  card_detect_pin: NO_PIN
  cs_pin: gpio.5

probe:
  pin: gpio.22:low
  check_mode_start: true
  
control:
  safety_door_pin: gpio.16:low
  macro0_pin: gpio.13:low
  macro1_pin: gpio.0:low

macros:
  startup_line0:
  startup_line1:
  macro0:
  macro1:
  macro2:
  macro3:

start:
  must_home: false
  
coolant:
  mist_pin: gpio.21
  delay_ms: 0
```
## Spindles

The XPro-V5 documentation [explains how to hook up different types of spindles](https://github.com/Spark-Concepts/xPro-V5/wiki/Front_Panel#spindle-types).  That documentation uses Grbl_ESP32 configuration commands, but FluidNC configuration is different, as detailed below.

The old Grbl_ESP32 firmware has a $Spindle/Type=value setting to select which spindle to use.  The values include "NONE", "PWM", "Laser", "HUANYANG", and "H2A".  Instead of $Spindle/Type, FluidNC has a section in the config.yaml file that selects the spindle and sets it parameters.  See this [information for configuring FluidNC spindles](/config/config_spindles#spindles)

The thing you need to know that is specific to XPro-V5 is the pin numbers for controlling the spindle.  For controlling Laser, PWM, and 10V spindles, you need "output_pin: gpio.25" and "enable_pin: gpio.4" in the spindle section, like this:
```yaml
10V:
  output_pin: gpio.25
  enable_pin: gpio.4
```
The section name is not necessarily "10V:"; it could be "Laser:" or "PWM:" depending on your machine.

For RS485 VFD type spindles, you need "txd_pin: gpio.4", "rxd_pin: gpio.25", and "rts_pin: NO_PIN".

Unless you are an expert, you are better off using 0-10V control for VFD spindles, instead of RS485 control.  RS485 can be very difficult to get working reliably.

### Huanyang VFD Spindle Example

```yaml
uart1:
  txd_pin: gpio.4
  rxd_pin: gpio.25
  rts_pin: NO_PIN
  baud: 9600
  mode: 8N1

huanyang:
  uart_num: 1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 0=25% 6000=25% 24000=100%
  off_on_alarm: false
```

## Known Problems

XProV5 is a commercial product so your first line of support should be the vendor; that said, here are a couple of things that might come up:

  * Dead Y Axis - there appears to be a [recurring problem with fried Y axis drivers](https://github.com/Spark-Concepts/xPro-V5/issues/194)
  * RS485/VFD Spindle Hookup - Some people have [ground loop problems with RS485 hookup](https://github.com/Spark-Concepts/xPro-V5/wiki/RS485-VFD).  Adding a repeater seems to help.
