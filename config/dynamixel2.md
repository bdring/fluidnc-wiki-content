---
title: Dynamixel Servo (Protocol 2)
description: Configuring a Dynamixel Protocol 2 servo as an axis motor
published: true
date: 2026-08-01T22:15:00.000Z
tags: en
editor: markdown
dateCreated: 2026-08-01T22:15:00.000Z
---

# Dynamixel Servo (Protocol 2)

<img src="https://github.com/bdring/FluidNC/wiki/images/XL430-W250.jpg" width="200">

This allows Dynamixel Servo motors to be used as axis motors. This document was written assuming XL430-250T servos were used, but other servo types that use [Robotis Protocol 2](https://emanual.robotis.com/docs/en/dxl/protocol2/) can probably be used (not tested). The servo's count range is mapped to the axis machine position (mpos) range. If your X axis servo has a count range from 0-4095, that would be mapped across the mpos range. If the range is 0-300 and you send G0X150 it will be told to go to count 2047.

**Servo set up** The servos must be set up with Dynamixel software first. The easiest way is to use the [Dynamixel Wizard](http://emanual.robotis.com/docs/en/software/dynamixel/dynamixel_wizard2/) software. Here are the registers you probably want to set.

| Address       | Name              | Value       | Description     |
| ------------- | ----------------- | ----------- | --------------- |
| 7             | ID                | 1-253       | Must be unique  |
| 8             | Baud Rate         | 3 (1000000) |                 |
| 9             | Return Time Delay | 100         | Faster          |
| 24            | Moving Threshold  | 1           | Most Accurate   |
| 48 (optional) | Max Position      | 0-4095      | Limits rotation |
| 52 (optional) | Min Position      | 0-4095      | Limits rotation |

> If you stall a Dynamixel motor it will likely go into a faulted mode. The only way to recover is to power cycle them. 
{.is-warning}


config values

<!-- config-item path="axes.<letter>.motorN.dynamixel2.uart_num" -->
### uart_num
- **Type:** Integer
- **Default:** `-1` (must be set -- there is no usable default)

Which top-level uartN: section this servo's Protocol 2 bus runs over. Required. This should match the programmed baud of the servos -- 1000000 is recommended, mode 8N1.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.dynamixel2.id" -->
### id
- **Type:** Integer
- **Default:** `255` (must be changed -- this is Dynamixel's broadcast address, not a usable per-device value)

This servo's Protocol 2 device ID on the bus. Each must have a unique id.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.dynamixel2.count_min" -->
### count_min
- **Type:** Integer
- **Default:** `1024`

This is the location on the servo for the lower end of the mpos range.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.dynamixel2.count_max" -->
### count_max
- **Type:** Integer
- **Default:** `3072`

This is the location on the servo for the upper end of the mpos range.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.dynamixel2.timer_ms" -->
### timer_ms
- **Type:** Integer
- **Default:** `50`

Update interval, in milliseconds, for refreshing the servo's commanded position.
<!-- /config-item -->

**Direction reversal:** Swap the count_min: and count_max: values.

**Homing:** The servo will immediately go to the homing/mpos_mm location of the axis. 

**Enable:** The servos will disable whenever the motors disable (see the idle_ms config value). When they are disabled, you can move them by hand and the mpos will track the movement.

### Config Example

```yaml
  x:
    steps_per_mm: 100.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 50.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 0.000
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
      pulloff_mm: 1.000
      dynamixel2:
        id: 1
        uart_num: 1
        count_min: 1024
        count_max: 3072
```

 
