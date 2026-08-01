---
title: 6 Axis Controller board: For external motor control 
description: 6 Axis Controller board 
published: true
date: 2023-03-12T17:20:16.416Z
tags: 6axis, aliexpress, grbl, shift registers, basic, cheap, board
editor: markdown
dateCreated: 2022-12-15T07:59:33.453Z
---

![6axis_board.png](/hardware/esp32_cnc_board_6axis.jpg)

## Overview

This page is to share information helpful when using FluidNC on the [ESP32_6_axis_breakout_board](https://www.aliexpress.com/item/1005004625846519.html?spm=a2g0o.productlist.main.89.55827b5eplkHOu&algo_pvid=eb9d3609-c1c4-4723-b16d-6d77f6a62423&algo_exp_id=eb9d3609-c1c4-4723-b16d-6d77f6a62423-44&pdp_ext_f=%7B%22sku_id%22%3A%2212000030842567896%22%7D&pdp_npi=2%40dis%21AUD%2138.56%2123.52%21%21%21%21%21%40211bec8616710888698074443d0724%2112000030842567896%21sea&curPageLogUid=YIHJ4fo3UXKf). Your first line of support should be directly with the supplier. [They also have a wiki](https://github.com/Macrobase-tech/CNC-Software?spm=a2g0o.detail.1000023.17.18a21591c8x2FW). We cannot guarantee this is accurate and mistakes could damage your controller.

## Problems
> This board is Not Recommended and the FluidNC developers will not respond to questions or issues that arise from its use.  It has numerous design and build problems as detailed below.
{.is-danger}

- There has been a report of poor build quality on an instance of this board, specifically cold solder joints - probably on the thru-hole components.  Most seriously, the USB connector holddown tabs were not soldered, causing it to break away from the board.  It would be a good idea to inspect and possibly resolder the board.![usbbreak.png](/usbbreak.png)
- It does not have an SD card slot so you cannot run jobs with WebUI.  You could add one externally, but there are no connectors for the unused GPIO pins so you would have to solder tiny wires directly to the ESP32 pins.
- It does not respond to the DTR line for reset via USB.
- The ESP32 module has a built-in (not external) antenna that is located in a poor position above a ground plane, so the WiFi range is likely to be very poor.
- There have been reports of power instability even when powered from the barrel jack.
## Stepper Driver Pinout

The controller uses is compatable with most external motor drivers and can be setup with simple drivers or drivers requiring a third pin. Each axis has 3 output pins dedicated for direction, Pulse and enable (Or switchout enable with you desired pin). 


The labels for the motors are suggestions only. You can use any driver for any axis or motor(0/1) you want. Unfortunately there are a number of pins that are not used and can be soldered directly if your handy with minature wires. 

The unused pins are:
- GPIO.0
- GPIO.5
- GPIO.12
- GPIO.13
- GPIO.14
- GPIO.25
- GPIO.26


See example below for a 6 axis setup. Axis a, b or c can be stup as a dual motor axis, however there are not enough limit outputs to home independantly. **You could access an unused pin if needed**.

## Example Config File

```yaml
board: 6axis CNC controller
name: 6axis board - yaml by NewTechCreative
stepping:
  engine: I2S_STREAM
  idle_ms: 250
  pulse_us: 4
  dir_delay_us: 1
  disable_delay_us: 0

axes:
  shared_stepper_disable_pin: NO_PIN
  x:
    steps_per_mm: 800.000
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
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: gpio.33
      hard_limits: true
      pulloff_mm: 1.000
      stepstick:
        ms3_pin: i2so.3
        step_pin: I2SO.2
        direction_pin: I2SO.1
        disable_pin: I2SO.0

  y:
    steps_per_mm: 800.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: true
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: gpio.32
      hard_limits: true
      pulloff_mm: 1.000
      stepstick:
        ms3_pin: i2so.6
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: I2SO.7
        

  z:
    steps_per_mm: 800.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 1
      positive_direction: true
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 800.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: gpio.35
      hard_limits: true
      pulloff_mm: 1.000
      stepstick:
        ms3_pin: i2so.11
        step_pin: I2SO.10
        direction_pin: I2SO.9
        disable_pin: I2SO.8
        
  a:
    steps_per_mm: 53.400
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 960.000
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
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 3.000
      stepstick:
        ms3_pin: i2so.14
        step_pin: I2SO.13
        direction_pin: I2SO.12
        disable_pin: I2SO.15
        
   b:
    steps_per_mm: 808.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 200.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 800.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 3.000
      tmc_2130:
        cs_pin: i2so.19
        step_pin: I2SO.18
        direction_pin: I2SO.17
        disable_pin: I2SO.16
        
  c:      
    steps_per_mm: 808.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 200.000
    soft_limits: false
    homing:
      cycle: 1
      positive_direction: false
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 800.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 3.000
      tmc_2130:
        cs_pin: i2so.22
        step_pin: I2SO.21
        direction_pin: I2SO.20
        disable_pin: I2SO.23
      

i2so:
  bck_pin: gpio.22
  data_pin: gpio.21
  ws_pin: gpio.17

spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18  

control:
  safety_door_pin: NO_PIN
  reset_pin: NO_PIN
  feed_hold_pin: gpio.36
  cycle_start_pin: NO_PIN
  macro0_pin: NO_PIN
  macro1_pin: NO_PIN
  macro2_pin: NO_PIN
  macro3_pin: NO_PIN

coolant:
  flood_pin: NO_PIN
  mist_pin: gpio.4
  delay_ms: 0

probe:
  pin: gpio.34
  check_mode_start: true

macros:
  startup_line0:
  startup_line1:
  macro0:
  macro1:
  macro2:
  macro3:


start:
  must_home: false

PWM:
  pwm_hz: 5000
  output_pin: gpio.27
  enable_pin: NO_PIN
  direction_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 1000
  spindown_ms: 1000
  tool_num: 0
  speed_map: 0=0.000% 1000=100.000%



```

