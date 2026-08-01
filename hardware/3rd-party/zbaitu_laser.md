---
title: ZBaitu Laser Controller
description: 
published: true
date: 2022-08-31T19:23:37.057Z
tags: 
editor: markdown
dateCreated: 2022-08-31T12:20:54.518Z
---

# Overview

This is a controller shipped with [Zbaitu lasers](http://www.zbaitu-tech.com/h-col-103.html). It typically comes with Grbl_ESP32 pre-installed.

They typically refuse to answer support questions. Here is some info that can help getting it to run with FluidNC.

![zbaitu_00.png](/hardware/zbaitu_00.png)
![zbaitu_01.png](/hardware/zbaitu_01.png)

# I/O

  - Shared Motor Disable: gpio.12 
  - **X Axis**
  	- **Step:** gpio.14
    - **Dir:** gpio.27
    - **Switch:** gpio.13
  - **Y Axis**
    - **Step:** gpio.26
    - **Dir:** gpio.25
    - Switch: gpio.39
  - **Z Axis**
    - **Step:** gpio.33
    - **Dir:** gpio.32
    - **Switch:** gpio.34 (where is the connection?)
  - **Laser**
    - **PWM:** gpio.17
    
## Example Config
    
```yaml
board: Zbaitu Controller
name: Zbaitu XYY Laser
meta: B. Dring for @mmeulstee 8/30/2022

stepping:
  engine: RMT
  idle_ms: 255
  pulse_us: 4
  dir_delay_us: 1
  disable_delay_us: 0
  
start:
  must_home: false
  deactivate_parking: false
  check_limits: false

axes:
  shared_stepper_disable_pin: gpio.12
  x:
    steps_per_mm: 80.000
    max_rate_mm_per_min: 50000.000
    acceleration_mm_per_sec2: 800.000
    max_travel_mm: 810
    soft_limits: true
    homing:
      cycle: 1
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 200.000
      seek_mm_per_min: 3000.000
      settle_ms: 250
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.13:pu:low
      hard_limits: false
      pulloff_mm: 1.000
      stepstick:
        step_pin: gpio.14
        direction_pin: gpio.27
        
  y:
    steps_per_mm: 80.000
    max_rate_mm_per_min: 50000.000
    acceleration_mm_per_sec2: 800.000
    max_travel_mm: 460.000
    soft_limits: true
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 200.000
      seek_mm_per_min: 3000.000
      settle_ms: 250
      seek_scaler: 1.100
      feed_scaler: 1.100
      

    motor0:
      limit_neg_pin: gpio.39:low
      pulloff_mm: 1.000
      hard_limits: false
      stepstick:
        step_pin: gpio.26
        direction_pin: gpio.25:low
        
    motor1:
      #limit_neg_pin: gpio.34:low
      pulloff_mm: 1.000
      hard_limits: false
      stepstick:
        step_pin: gpio.33
        direction_pin: gpio.32
        
spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18

sdcard:
  card_detect_pin: NO_PIN
  cs_pin: gpio.5

Laser:
  pwm_hz: 5000
  output_pin: gpio.17
  enable_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  tool_num: 0
  speed_map: 0=0.000% 1000=100.000%
  ```
    
    