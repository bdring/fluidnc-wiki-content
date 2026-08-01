---
title: RC Servo
description: Configuring an RC servo as an axis motor
published: true
date: 2026-08-01T22:15:00.000Z
tags: en
editor: markdown
dateCreated: 2026-08-01T22:15:00.000Z
---

# RC Servo

<img src="https://github.com/bdring/FluidNC/wiki/images/servo-samples.jpg" width="300">

RC Servos have an internal control system that allows them to move to a specific location based on a PWM signal. There are analog and digital versions of these. They both use the same PWM input, but the digital ones use a more advanced control system. They use the width of the pulse to determine where to move. One end of the travel usually uses a 1ms pulse width and the other end uses a 2ms pulse width. There is no standard on the rotation range of motion and many can use a slightly wider pulse width range. If the PWM signal is removed the servo can often be turned by hand.

> A servo can also be configured as a spindle, if you want to control it with `M3`/`M5` instructions - see the [besc section of the spindles page](/en/config/config_spindles#besc).
{.is-info}

The PWM frequency for analog servos is typically 50Hz. If you increase that it changes the control loop and could overheat the servo. Digital servos can use a higher frequency, but typically never higher than 200 Hz. The PWM signal is only sent when the motors are enabled. Set **idle_ms** to 255 if you want the signal to always be on.

FluidNC creates a virtual stepper motor for the axis. You give it parameters for speed, acceleration, etc like normal motors. The servo range will be mapped to the max_travel of the axis. If your servo is not rotating the correct direction with respect to the virtual axis, you can swap the min_pulse_us/max_pulse_us key values. If your servo cannot keep up with the max rate in your config file and you have a short `idle_ms:`, the servo may turn off before it reaches the commanded location.

Like a normal axis, they operate in machine space. You can still place a work zero wherever you like. Soft limits can be used. Homing works a little differently. They do not use switches because they always know where they are. If you put them on a homing cycle, they will immediately move to the end of travel in the direction specified in the homing: section. To give them enough time to get there. A time of **max_travel: / speed:** will be given.

At startup A servo will immediately move to machine position 0.0 or the closest point in the range if the range does not include 0.0. This will only occur when the motors are enabled. If the motors are not enabled at startup (idle_ms: not 255), then the servos will move to the current machine position as soon as any other axis moves.

**Testing the RC Servo** In the startup messages you will see the range like **Axis Z (-5.000,0.000)**. Send **G53G0Z-5** and **G53G0Z0** to test that range.


**Config file keys**

<!-- config-item path="axes.<letter>.motorN.rc_servo.output_pin" -->
### output_pin
- **Type:** [Pin](/config/overview#pin) (output)
- **Range:** gpio
- **Default:** `NO_PIN`

PWM signal output to the servo.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.rc_servo.pwm_hz" -->
### pwm_hz
- **Type:** [Integer](/config/overview#integer)
- **Range:** 50 to 200
- **Default:** `50`

Servo PWM pulse repetition rate. 50Hz is the standard analog-servo value; some digital servos can repeat faster.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.rc_servo.min_pulse_us" -->
### min_pulse_us
- **Type:** [Integer](/config/overview#integer)
- **Range:** 500 to 2500
- **Default:** `1000`

Pulse width, in microseconds, corresponding to one end of the servo's travel.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.rc_servo.max_pulse_us" -->
### max_pulse_us
- **Type:** [Integer](/config/overview#integer)
- **Range:** 500 to 2500
- **Default:** `2000`

Pulse width, in microseconds, corresponding to the other end of the servo's travel. If your servo is not rotating the correct direction with respect to the virtual axis, you can swap the min_pulse_us/max_pulse_us values.
<!-- /config-item -->

<!-- config-item path="axes.<letter>.motorN.rc_servo.timer_ms" -->
### timer_ms
- **Type:** [Integer](/config/overview#integer)
- **Range:** 20 to 250
- **Default:** `20`

This is how often the PWM value is recalculated and changed to match the position of the virtual axis. This will affect the smoothness of the motion. You should definitely set it higher than the PWM period (1/freq). Low values can affect overall performance, because the ESP32 is spending too much time with this.
<!-- /config-item -->

### Config Example

```yaml
  z:
    steps_per_mm: 100.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 5.000
    soft_limits: true
    homing:
      cycle: 1
      positive_direction: true
      mpos_mm: 5.000
      
    motor0:
      rc_servo:
        pwm_hz: 50
        output_pin: gpio.27
        min_pulse_us: 1000
        max_pulse_us: 2000
```
example with rotation reversed
```yaml
    rc_servo:
      pwm_hz: 60
      output_pin: gpio.27
      min_pulse_us: 2000
      max_pulse_us: 1000
```

<a name="rc_servo_tuning"></a>
#### RC Servo Tuning:

All servos have their own speed and acceleration. If you use faster motion values for the virtual axis in the config file than the servo can handle, it will not be able to follow accurately. The virtual axis will reach position before the servo does and the next gcode will execute. The servo eventually catches up, but this lack of coordination is undesirable.

FluidNC will not be able to detect this. You must experiment with values until you get the performance you like. The steps_per_mm key is used for the virtual axis. Most servos will only have 200-1000 units of accuracy across the entire range of motion. Double that higher end number and divide by the max_travel for the axis. Example: For a max_travel or 10mm, set you steps_per_mm to (2 * 1000 / 10) = 200 steps_per_mm.



<a name="rc_servo_range"></a>
#### **RC Servo Range**

Unlike stepper motors, RC servos have a fixed rotational range. That range is mapped to the machine coordinates using the max_travel, mpos_mm and homing direction config items ([more details here](/config/axes#homing)). If you try to move outside the range the servo will stop at the end of travel, but the machine position will still increment. You can still jog the machine position outside the range, but the servo will not move until it is in the range. You can apply soft limits to the axis if you want to prevent this. **Soft limits are strongly recommended for RC servos for this reason.**

#### Pulse Lengths

Pulse lengths vary by manufacturer. The default is 1000-2000 microseconds, but many manufacturers use a larger range. If you are trying to get the FluidNC units to match specific locations in the servo travel you can tweak these values a little. Servo motors are not too accurate, so don't expect them to match stepper motors. Be sure to stay within the servo's range. Servo can be damaged by operating outside their range.

Here is a complete axis RC servo axis definition. In this case the travel is 5mm, the machine position after homing is 5mm, so the range is 0mm to 5mm. You can test the motion on this axis with the following gcode commands. I use G53 to make sure the motion is in machine coordinates, overriding any work offsets you may have created.

```
G53 G0 Z5
G53 G0 Z0
```

```yaml
z:
    steps_per_mm: 100
    max_rate_mm_per_min: 5000
    acceleration_mm_per_sec2: 100
    max_travel_mm: 5
    homing:
      cycle: 1
      mpos_mm: 0
      positive_direction: true

    motor0:
      rc_servo:
        pwm_hz: 50
        output_pin: gpio.27
        min_pulse_us: 1000
        max_pulse_us: 2000
```

