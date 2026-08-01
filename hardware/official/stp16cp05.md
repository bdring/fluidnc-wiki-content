---
title: STP16CP05 LED Driver Chip Reference Page
description: 
published: true
date: 2026-06-30T16:33:51.956Z
tags: 
editor: markdown
dateCreated: 2026-06-25T15:22:28.967Z
---

# STP16CP05 Reference Page



# Overview

The **STP16CP05** is a 16‑channel constant‑current LED sink driver designed for driving LEDs. It uses shift register interface making it ideal for use with the existing I2S features of FluidNC. "Sink driver" means it controls the low side of the LED. You set the constant current for all 16 channels via an external resistor between 5mA and 100mA. 

This will work well for driving the LEDs in the optos of stepper motor signal inputs. The optos already have current limiting resistors, so current limiting is not required. They typically draw about 6mA to 20mA of current. If the current on the STP16CP05 is set slightly above this, the current limiting will normally not not come into play.

The big advantage to this is current limiting when mis-wired. If a user accidentally mis-wires a channel, the chip will shut down the voltage to the that output. The 74AHCT595 chips that are used in virtually all I2S supporting controllers are very easily damaged. The STP16CP05  should be much more robust to abuse. 

The only disadvantage of this chip it it only works as a current sink. This means the driver must use a common + voltage on the opto terminals and connect the - terminals to the STP16CP05 outputs. This is actually the default wiring for most stepper drivers.

## Design Guidelines

The chip dissipates power when the outputs are current limiting. It does have an over temp shutdown, but operating near that point for long periods of time could damage the chip. Therefore, the chip package with the exposed thermal pad is recommended.

Status LEDs with current limiting resistors in parallel with the stepper driver outputs are handy for testing and debugging

## Reference Design

![stp12cp05_schm.png](/hardware/development/stp12cp05_schm.png)

# Chip Details

- [Datasheet](https://item.szlcsc.com/datasheet/STP16CP05TTR/138548.html)
- [Test PCB Project](https://u.easyeda.com/account/user/projects/index/detail?project=fb05643ca2f54a0c97a064e4e9e50177)

# Config File Example (proto board)

```
board: STP16CP05 S3
name: LED Driver Test

stepping:
  engine: I2S_STATIC
  idle_ms: 254
  pulse_us: 10
  dir_delay_us: 10
  disable_delay_us: 0

i2so:
  bck_pin: gpio.16
  data_pin: gpio.17
  ws_pin: gpio.18

start:
  must_home: false

axes:
  x:
    steps_per_mm: 160
    max_rate_mm_per_min: 1000
    acceleration_mm_per_sec2: 200
    max_travel_mm: 100
    soft_limits: false
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      hard_limits: false
      standard_stepper:
        disable_pin: I2SO.0
        step_pin: I2SO.1
        direction_pin: I2SO.2
        

  y:
    steps_per_mm: 160
    max_rate_mm_per_min: 1000
    acceleration_mm_per_sec2: 200
    max_travel_mm: 100
    soft_limits: false
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      hard_limits: false
      standard_stepper:
      standard_stepper:
        disable_pin: I2SO.3
        step_pin: I2SO.4
        direction_pin: I2SO.5

  z:
    steps_per_mm: 480
    max_rate_mm_per_min: 1000
    acceleration_mm_per_sec2: 800
    max_travel_mm: 100
    soft_limits: false
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      hard_limits: false
      standard_stepper:
        disable_pin: I2SO.6
        step_pin: I2SO.7
        direction_pin: I2SO.8
        
  a:
    steps_per_mm: 160
    max_rate_mm_per_min: 1000
    acceleration_mm_per_sec2: 200
    max_travel_mm: 100
    soft_limits: false
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      hard_limits: false
      standard_stepper:
        disable_pin: I2SO.9
        step_pin: I2SO.10
        direction_pin: I2SO.11
        

  b:
    steps_per_mm: 160
    max_rate_mm_per_min: 1000
    acceleration_mm_per_sec2: 200
    max_travel_mm: 100
    soft_limits: false
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      hard_limits: false
      standard_stepper:
      standard_stepper:
        disable_pin: I2SO.12
        step_pin: I2SO.13
        direction_pin: I2SO.14

  c:
    steps_per_mm: 480
    max_rate_mm_per_min: 1000
    acceleration_mm_per_sec2: 800
    max_travel_mm: 100
    soft_limits: false
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      hard_limits: false
      standard_stepper:
        disable_pin: I2SO.15
        step_pin: I2SO.16
        direction_pin: I2SO.17
```

![proto_pcb.jpg](/hardware/development/proto_pcb.jpg =x400)

## Tested (current at 20mA)

- 8 LEDs with no series resistors (got warm)
- External stepper driver optos (no noticeable temp rise)
- Shorting outputs to 5V (no damage)
- Shorting outputs to Gnd (no damage)
- Shorting outputs to each other (no damage)
