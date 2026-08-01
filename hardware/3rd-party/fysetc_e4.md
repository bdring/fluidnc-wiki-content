---
title: Fysetc E4
description: 
published: true
date: 2026-02-25T00:12:25.646Z
tags: 
editor: markdown
dateCreated: 2023-02-25T19:44:44.672Z
---

# Fysetc E4

![fysetc_e4.png](/hardware/fysetc_e4.png =x400)

## Documentation

 - [Github Repo](https://github.com/FYSETC/FYSETC-E4)
 - [Schematic](https://github.com/FYSETC/FYSETC-E4/blob/main/hardware/FYSETC%20E4_V1.0%20SCH.pdf)

## Motor Drivers

They are TMC2209 chips

> The chip addresses are in a confusing order. See below 
{.is-warning}

 - MOT X is addr: 1
 - MOT Y is addr: 3
 - MOT Z is addr: 0
 - MOT E is addr: 2

## Example Config

```yaml
name: "EleksLaser with Fysetc E4 controller"
board: "Fysetc E4"

stepping:
  engine: RMT
  idle_ms: 250
  dir_delay_us: 1
  pulse_us: 2
  disable_delay_us: 0
  
kinematics:
  cartesian:

uart1:
  txd_pin: gpio.22
  rxd_pin: gpio.21
  rts_pin: NO_PIN
  cts_pin: NO_PIN
  baud: 115200
  mode: 8N1

axes:
  shared_stepper_disable_pin: gpio.25:high
  
  x:
    steps_per_mm: 80
    max_rate_mm_per_min: 16000.000
    acceleration_mm_per_sec2: 500.000
    max_travel_mm: 370.000
    soft_limits: true
    homing:
      cycle: 1
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 200.000
      seek_mm_per_min: 2000.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.15
      hard_limits: false
      pulloff_mm: 3.000
      tmc_2209:
        uart_num: 1
        addr: 1
        r_sense_ohms: 0.110
        run_amps: 1.0
        hold_amps: 0.500
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: StealthChop
        homing_mode: StealthChop
        use_enable: false
        step_pin: gpio.27
        direction_pin: gpio.26:low
        disable_pin: NO_PIN

  y:
    steps_per_mm: 80
    max_rate_mm_per_min: 12000.000
    acceleration_mm_per_sec2: 500.000
    max_travel_mm: 295.000
    soft_limits: true
    homing:
      cycle: 1
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 200.000
      seek_mm_per_min: 2000.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.35
      hard_limits: false
      pulloff_mm: 3.000
      tmc_2209:
        # Labeled Y
        uart_num: 1
        addr: 3
        r_sense_ohms: 0.110
        run_amps: 1.0
        hold_amps: 0.500
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: StealthChop
        homing_mode: StealthChop
        use_enable: false
        step_pin: gpio.33
        direction_pin: gpio.32
        disable_pin: NO_PIN
    motor1:
      limit_neg_pin: gpio.34
      hard_limits: false
      pulloff_mm: 3.000
      tmc_2209:
        uart_num: 1
        # Labeled Z
        addr: 0
        r_sense_ohms: 0.110
        run_amps: 1.000
        hold_amps: 0.500
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: StealthChop
        homing_mode: StealthChop
        use_enable: false
        step_pin: gpio.14
        direction_pin: gpio.12:low
        disable_pin: NO_PIN

  z:
    motor0:
      tmc_2209:
        uart_num: 1
        # Labeled E
        addr: 2
        r_sense_ohms: 0.110
        run_amps: 1.0
        hold_amps: 0.500
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: CoolStep
        homing_mode: CoolStep
        use_enable: false
        step_pin: gpio.16
        direction_pin: gpio.17
        disable_pin: NO_PIN

laser:
  output_pin: gpio.2
  speed_map: 0=0% 1000=100%

coolant:
  mist_pin: gpio.13

spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18

sdcard:
  cs_pin: gpio.5
  card_detect_pin: NO_PIN

start:
  must_home: true
  deactivate_parking: false
  check_limits: false

probe:
  pin: NO_PIN
  check_mode_start: true
```

