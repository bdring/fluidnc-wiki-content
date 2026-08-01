---
title: MKS Bumblebee
description: 
published: true
date: 2022-11-27T16:47:37.760Z
tags: 
editor: markdown
dateCreated: 2022-11-23T16:32:11.146Z
---

# ZDT Bumblebee

A work in progress. Please be patient.

![bumblebee.png](/hardware/bumblebee.png)

![bumblebee_io.jpg](/hardware/bumblebee_io.jpg)

![bumblebee_conns.jpg](/hardware/bumblebee_conns.jpg)

## Programming 

GPIO pin 0 must be pulled low to enter boot mode. Most controllers have a boot button or use the RTS & DTR signals. You might need to do it manually on EXP1.

![bootjumper.jpg](/hardware/bootjumper.jpg)

## IO pins

So far we are assuming pins labeled IO128 through IO159 are is2o.0 through i2so.31

### I2SO

```yaml
i2so:
   bck_pin: gpio.27
   data_pin: gpio.25
   ws_pin: gpio.26
```

### SD Card

```yaml
spi:
   miso_pin: gpio.19
   mosi_pin: gpio.23
   sck_pin: gpio.18

SD card:
   cs_pin: gpio.5
   card_detect_pin: NO_PIN
```
### Stepper Pins

The table shown in the board photo is obviously wrong, with duplications and nonsense numbers.  Here is the corrected table

![bumblebeestepperpins.png](/bumblebeestepperpins.png)

### I2SO Misc Output Pins

- EXP IO - I2SO.18
- H-Bed - I2SO.19
- HE1 - I2SO.20
- HE0 - I2SO.21
- Fan1 - I2SO.22
- Fan2 - I2SO.23

## Example Config

```yaml
board: "ZDT_Bumblebee"
name: "ZDT_Bumblebee_8"
meta: Juergen H. 24Nov2022

kinematics:
  Cartesian:

i2so:
  bck_pin: gpio.27
  data_pin: gpio.25
  ws_pin: gpio.26

spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18

sdcard:
  cs_pin: gpio.5
  card_detect_pin: gpio.15:low

stepping:
  engine: I2S_STATIC
  idle_ms: 255
  pulse_us: 4
  dir_delay_us: 1
  disable_delay_us: 2

axes:
  x:
    steps_per_mm: 50
    max_rate_mm_per_min: 8000.000
    acceleration_mm_per_sec2: 300.000
    max_travel_mm: 2500.000
    soft_limits: true
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 300.000
      seek_mm_per_min: 1500.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      # On X- Connector
      limit_neg_pin: gpio.33:low:pu
      # On X+ Connector
      limit_pos_pin: gpio.4:low:pu
      hard_limits: true
      pulloff_mm: 4.000
      stepstick:
        step_pin: I2SO.6
        direction_pin: I2SO.7
        disable_pin: I2SO.31

    # use E0 driver for 2nd X axis motor
    motor1:
      limit_neg_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 4.000
      stepstick:
        step_pin: I2SO.0
        direction_pin: I2SO.1
        disable_pin: I2SO.28

  y:
    steps_per_mm: 50
    max_rate_mm_per_min: 8000.000
    acceleration_mm_per_sec2: 300.000
    max_travel_mm: 1250.000
    soft_limits: true
    homing:
      cycle: 3
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 300.000
      seek_mm_per_min: 2000.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      # On Y- Connector
      limit_neg_pin: gpio.32:low:pu
      # On Y+ Connector
      limit_neg_pin: gpio.14:low:pu
      hard_limits: false
      pulloff_mm: 4.000
      stepstick:
        step_pin: I2SO.4
        direction_pin: I2SO.5
        disable_pin: I2SO.30

    # use E1 driver for 2nd Y axis motor
    motor1:
      limit_neg_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 4.000
      stepstick:
        step_pin: I2SO.14
        direction_pin: I2SO.15
        disable_pin: I2SO.27

  z:
    steps_per_mm: 50.000
    max_rate_mm_per_min: 8000.000
    acceleration_mm_per_sec2: 300.000
    max_travel_mm: 80.000
    soft_limits: true
    homing:
      cycle: 1
      positive_direction: true
      mpos_mm: 0.000
      feed_mm_per_min: 300.000
      seek_mm_per_min: 500.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      # On Z- Connector
      limit_neg_pin: gpio.35:low
      # On Z+ Connector
      limit_neg_pin: gpio.13:low
      hard_limits: false
      pulloff_mm: 3.000
      stepstick:
        step_pin: I2SO.2
        direction_pin: I2SO.3
        disable_pin: I2SO.29

  # Z2
  a:
    steps_per_mm: 50
    max_rate_mm_per_min: 8000.000
    acceleration_mm_per_sec2: 300.000
    max_travel_mm: 2500.000
    soft_limits: true
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 300.000
      seek_mm_per_min: 1500.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 4.000
      stepstick:
        step_pin: I2SO.12
        direction_pin: I2SO.13
        disable_pin: I2SO.26

# Z3
  b:
    steps_per_mm: 50
    max_rate_mm_per_min: 8000.000
    acceleration_mm_per_sec2: 300.000
    max_travel_mm: 2500.000
    soft_limits: true
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 300.000
      seek_mm_per_min: 1500.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 4.000
      stepstick:
        step_pin: I2SO.10
        direction_pin: I2SO.11
        disable_pin: I2SO.25

  # Z4
  c:
    steps_per_mm: 50
    max_rate_mm_per_min: 8000.000
    acceleration_mm_per_sec2: 300.000
    max_travel_mm: 1250.000
    soft_limits: true
    homing:
      cycle: 3
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 300.000
      seek_mm_per_min: 2000.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 4.000
      stepstick:
        step_pin: I2SO.8
        direction_pin: I2SO.9
        disable_pin: I2SO.24

control:  
  safety_door_pin: NO_PIN
  reset_pin: NO_PIN
  # on TH0 connector gpio.36:low
  feed_hold_pin: gpio.36:low
  # on TB connector gpio.39:low
  cycle_start_pin: gpio.39:low
  macro0_pin: NO_PIN
  macro1_pin: NO_PIN
  macro2_pin: NO_PIN
  macro3_pin: NO_PIN

coolant:
  # Heated Bed Terminal Block
  flood_pin: i2so.19
  # HE0 Terminal Block
  mist_pin: i2so.21
  delay_ms: 0

# spindle PWM signal
PWM:
  pwm_hz: 2500
  # on EXP2 IO15 connector
  output_pin: gpio.17:high
  s0_with_disable: true
  tool_num: 0
  spinup_ms: 4000
  spindown_ms: 4000
  speed_map: 0=0.000% 12000=100.000%

Laser:
  pwm_hz: 5000
  # on EXP 2 IO2 connector
  output_pin: gpio.16:high:pd
  s0_with_disable: true
  tool_num: 1
  speed_map: 0=0.000% 1000=100.000%

start:
  must_home: false
  deactivate_parking: false
  check_limits: false
  
```

