---
title: Solenoid
description: Configuring a solenoid as an axis motor
published: true
date: 2026-08-01T22:15:00.000Z
tags: en
editor: markdown
dateCreated: 2026-08-01T22:15:00.000Z
---

# Solenoid

<img src="https://github.com/bdring/FluidNC/wiki/images/solenoid.png" width="200">

This lets a Solenoid act like an axis. It will be active when the machine position of the axis is above 0.0. This can be inverted with the **direction_invert:** value. If inverted, it will be active at below 0.0.

When active the PWM will come on at the pull_percent value. After pull_ms time, it will change to the hold_percent value. This can be used to keep the coil cooler.

The feature runs on a 50ms update timer. The solenoid should react within 50ms of the position. The pull_ms also used that 50ms update resolution. The PWM can be inverted using the :low attribute on the output pin. This inverts the signal in case you need it. It is not used to invert the direction logic. 

The axis position still respects your speed and acceleration and other axis coordination. If you go from Z0 to Z5, it will activate as soon as it goes above 0. If you G0 from Z5 to Z0, it will not deactivate until it gets to Z0.

Shares [output_pin](/config/rc_servo#output_pin) with RC Servo, plus:

<!-- config-item path="axes.<letter>.motorN.solenoid.pwm_hz" -->
### pwm_hz
- **Type:** [Integer](/config/overview#integer)
- **Range:** 1000 to 100000
- **Default:** `1000`

PWM frequency driving the solenoid.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.solenoid.off_percent" -->
### off_percent
- **Type:** [Float](/config/overview#float)
- **Range:** 0 to 100
- **Default:** `0.0`

Duty cycle while off.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.solenoid.pull_percent" -->
### pull_percent
- **Type:** [Float](/config/overview#float)
- **Range:** 0 to 100
- **Default:** `100.0`

Duty cycle during the initial pull-in (highest power, to overcome the solenoid's resting inertia).
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.solenoid.hold_percent" -->
### hold_percent
- **Type:** [Float](/config/overview#float)
- **Range:** 0 to 100
- **Default:** `75.0`

Duty cycle after pull-in, while holding the solenoid engaged -- typically lower than pull_percent, since holding a solenoid needs less power than pulling it in.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.solenoid.pull_ms" -->
### pull_ms
- **Type:** [Integer](/config/overview#integer)
- **Range:** 0 to 3000
- **Default:** `500`

How long the pull_percent duty cycle is applied before switching to hold_percent.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.solenoid.direction_invert" -->
### direction_invert
- **Type:** Boolean
- **Default:** `false`

Inverts which side of the axis's mpos 0.0 counts as "active" -- normally active above 0.0, inverted means active below 0.0.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.solenoid.timer_ms" -->
### timer_ms
- **Type:** [Integer](/config/overview#integer)
- **Default:** `50`

Update interval, in milliseconds, for the solenoid's PWM state machine (pull/hold timing). The solenoid should react within this long of a position change; pull_ms is also quantized to this resolution.
<!-- /config-item -->

### Config Example

```yaml
  z:
    steps_per_mm: 100.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 5.000
    soft_limits: false
    homing:
      cycle: 1
      positive_direction: true
      mpos_mm: 5.000
        
    motor0:
      solenoid:
        output_pin: gpio.26
        pwm_hz: 5000
        off_percent: 0.000
        pull_percent: 100.000
        hold_percent: 20.000
        pull_ms: 1000
        direction_invert: false

```

