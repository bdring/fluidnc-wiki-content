---
title: MKS DLC32 Max
description: 
published: true
date: 2026-01-08T17:32:29.975Z
tags: 
editor: markdown
dateCreated: 2025-09-09T15:49:02.979Z
---

# Header

![mks-dlc32-max-header-2.jpg](/hardware/mks-dlc32-max-header-2.jpg =x500)

## Overview

This controller uses the ESP32 S3 chip.  Current FluidNC releases work with it.

## USB

This uses a CH340 USB to serial chip. Make sure you have the driver for this. Most computers do not come with this driver. 

This is not the CDC USB that is built into the ESP32-S3. That is not available on this controller.

## MKS Documentation

- [Github Repo](https://github.com/makerbase-mks/MKS-DLC32/tree/main/MKS--DLC32-MAX-main)
- [Operation Manual](https://github.com/makerbase-mks/MKS-DLC32/blob/main/MKS--DLC32-MAX-main/tool/MKS%20DLC32%20MAX%20Manual.pdf)
- Schematic (can't find one)

## Motors

Use The motors use a shared disable pin (gpio.8). Use motor type "stepstick:" or "standard_stepper:"

## SD Card

```yaml
spi:
  miso_pin: gpio.12
  mosi_pin: gpio.14
  sck_pin: gpio.13

sdcard:
  cs_pin: gpio.21
  card_detect_pin: gpio.10
  frequency_hz: 8000000
```

## RJ11 Uart Connector

```yaml
# Begin expansion port uart and channel setup
uart1:
  txd_pin: gpio.17
  rxd_pin: gpio.18
  baud: 1000000
  mode: 8N1

uart_channel1:
  report_interval_ms: 75
  uart_num: 1
# End expansion port set up.
```

## External power switch

There are 2 solder pads labeled "switch". This can be used for an external power switch. The fuse completes the circuit when a switch is not used, so you musat remove the fuse when using an external switch.  

## Example Config

```yaml
board: MKC DLC32 Max 
name: MKC DLC32 Max Default
meta: 
stepping:
  engine: Timed
  idle_ms: 255
  pulse_us: 4
  dir_delay_us: 0
  disable_delay_us: 0
  segments: 12

spi:
  miso_pin: gpio.12
  mosi_pin: gpio.14
  sck_pin: gpio.13

sdcard:
  cs_pin: gpio.21
  card_detect_pin: gpio.10
  frequency_hz: 8000000
  
# Begin expansion port uart and channel setup
uart1:
  txd_pin: gpio.17
  rxd_pin: gpio.18
  baud: 1000000
  mode: 8N1

uart_channel1:
  report_interval_ms: 75
  uart_num: 1
# End expansion port set up.

kinematics:
  Cartesian:

axes:
  shared_stepper_disable_pin: gpio.8
  homing_runs: 2
  x:
    steps_per_mm: 80.000000
    max_rate_mm_per_min: 1000.000000
    acceleration_mm_per_sec2: 25.000000
    max_travel_mm: 1000.000000
    soft_limits: false
    motor0:
      limit_neg_pin: gpio.39:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000000
      stepstick:
        step_pin: gpio.16
        direction_pin: gpio.15

  y: 
    steps_per_mm: 80.000000
    max_rate_mm_per_min: 1000.000000
    acceleration_mm_per_sec2: 25.000000
    max_travel_mm: 1000.000000
    soft_limits: false
    motor0:
      limit_neg_pin: gpio.40:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000000
      stepstick:
        step_pin: gpio.7
        direction_pin: gpio.6

  z:
    steps_per_mm: 80.000000
    max_rate_mm_per_min: 1000.000000
    acceleration_mm_per_sec2: 25.000000
    max_travel_mm: 1000.000000
    soft_limits: false
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: gpio.41:low
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000000
      stepstick:
        step_pin: gpio.5
        direction_pin: gpio.4

  a:
    steps_per_mm: 80.000000
    max_rate_mm_per_min: 1000.000000
    acceleration_mm_per_sec2: 25.000000
    max_travel_mm: 1000.000000
    soft_limits: false
    motor0:
      limit_neg_pin: gpio.48:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000000
      stepstick:
        step_pin: gpio.20
        direction_pin: gpio.19


control:
  safety_door_pin: gpio.38:low
  reset_pin: NO_PIN
  feed_hold_pin: NO_PIN
  cycle_start_pin: NO_PIN
  macro0_pin: NO_PIN
  macro1_pin: NO_PIN
  macro2_pin: NO_PIN
  macro3_pin: NO_PIN
  fault_pin: NO_PIN
  estop_pin: NO_PIN
  homing_button_pin: NO_PIN

coolant:
  # Labeled Air
  flood_pin: gpio.1
  # Beeper
  mist_pin: gpio.42
  delay_ms: 0

probe:
  pin: gpio.37
  toolsetter_pin: NO_PIN
  check_mode_start: true
  hard_stop: false

macros:
  startup_line0:
  startup_line1:
  Macro0:
  Macro1:
  Macro2:
  Macro3:
  after_homing:
  after_reset:
  after_unlock:
  
Laser:
  pwm_hz: 5000
  output_pin: gpio.2
  enable_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  tool_num: 0
  speed_map: 0=0.000% 255=100.000%
  off_on_alarm: true
  
pwm:
  pwm_hz: 5000
  direction_pin: NO_PIN
  output_pin: gpio.35
  enable_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 1
  speed_map: 0=0.000% 10000=100.000%
  off_on_alarm: false

start:
  must_home: false
  deactivate_parking: false
  check_limits: true

arc_tolerance_mm: 0.002000
junction_deviation_mm: 0.010000
verbose_errors: true
report_inches: false
enable_parking_override_control: false
use_line_numbers: false
planner_blocks: 16




```

## Pinout

![mks_dlc32_max_pinout.png](/hardware/mks_dlc32_max_pinout.png =x450)
