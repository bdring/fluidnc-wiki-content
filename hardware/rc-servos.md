---
title: RC Servos
description: How to use RC servos with FluidNC
published: true
date: 2026-08-01T19:38:20.047Z
tags: en
editor: markdown
dateCreated: 2025-03-26T13:59:35.886Z
---

# RC Servos

<img src="https://github.com/bdring/FluidNC/wiki/images/servo-samples.jpg" width="300">

How to use RC servos with FluidNC

# Overview

RC Servos, similar to what we use today, have been around since 1960. They use a 50Hz PWM signal with a 1ms to 2ms duty to set the position. They were purely analog devices. Internally they generate a reference pulse based on the position of the servo. An incoming pulse was compared to the reference pulse. If length was different the motor was energized in the correcting direction during the pulse difference.

If you try to displace a servo that is receiving pulses you can feel this. You will feel the 50Hz vibration and the strength will be proportional to the displacement amount.

Note: If you use a frequency higher than 50Hz you can burn out the servo because the correction pulses will come at a faster rate and deliver more energy than the circuit was designed for.

Digital servos use the same signal, but are a little smarter about how they correct the position. They still typically use an analog potentiometer for the position. Some high end digital servos use an optical or magnetic encoder. Since the frequency is not used for the correction rate, they can often be used up to about 200Hz. They can't go much faster than that because you still need to fit the 2ms pulses into the signal.

While 1ms to 2ms is the standard, some servos use a longer range like 0.5ms to 2.5 ms.  

> Be careful. Some servos, especially analog ones, can grind into the endstop if you send pulse widths outside their range.
{.is-warning}


# Rotation direction

There is no standardized rotation direction for RC servos. Going from 1ms to 2ms could be clockwise or counter clockwise depending on the model or brand. You can generally get this information from the servo spec. 

Ideally you would design around this or select the right rotation for you application. If you have a servo and it is not going the right way, FluidNC can help you out. Each method has a way to deal with that.

# Wiring

You need to connect power, ground and a PWM signal. The PWM signal is usually 5V, but I have never seen a servo that was not OK with 3.3v.

Most servos work at 5V, but some can go higher to get more power. The current can be several amps, especially if there is a lot of load on the servo.

If you keep a continuous load on a servo, it may over heat.

# How to control them with FluidNC

Any feature that allows you to set the frequency and duty of a PWM signal can be used.

## As a motor on an axis


If the servo is used to move an axis, like the pen on a plotter, this is probably the best option. Things like jogging controls and soft limits can be used.

[See this page](http://wiki.fluidnc.com/en/config/axes#rc-servo)

## As a spindle

Some programs that generate gcode for pen plotters use spindle commands. Older firmwares like Grbl did not support support other ways to control servos, so this has become a common method. 

You would use a PWM spindle. Let's say you have a the following parameters.

- The PWM frequency you want is 50Hz
- The pulse range you want is 1ms to 2ms
- The speed range you want is 0 to 1000 RPM
- You want to use gpio.4 as the signal



```yaml
pwm:
 output_pin: gpio.4
 pwm_hz: 50
 speed_map: 0=5% 1000=10%
```

If your rotation direction is not correct, just invert the speed_map.

```yaml
 speed_map: 0=10% 1000=5%
```
  

[See this page](http://wiki.fluidnc.com/en/config/config_spindles)

Note: The BESC spindle can be used too and has some good information, but we may be getting rid of this spindle in favor of the PWM.



## As an analog output

You can use the [M67 command](http://wiki.fluidnc.com/en/features/supported_gcodes#m67-analog-output) and use 5% and 10% for the Q values.

Adjust the percentages based on your range and frequency.