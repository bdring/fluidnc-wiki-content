---
title: BESC Spindle
description: Brushless DC motors used as spindle motors
published: true
date: 2026-08-01T19:32:37.327Z
tags: 
editor: markdown
dateCreated: 2025-03-07T20:08:26.282Z
---

# BESC Spindle Motors

![spmxsemc14_a0_u6fsagxp.jpg](/motors/spmxsemc14_a0_u6fsagxp.jpg =x250)

The radio controlled car, plane, drone industry has created many powerful and low cost brushless DC motors. They are controlled with a BESC (Brushless Electronic Speed Controllers). Many people use these as spindless motors for CNC machines.

## Control Signal

RC devices used to be powered by gas motors with a throttle controlled by a RC servo. BESCs were therefore designed to be compatible with RC servos.

The standard signal for these is PWM where the pulse length determine the position. The standard for this signal is 50Hz with the pulse length range of 1ms to 2ms. Some can handle a higher frequency of up to 200Hz and some extend the pulse length range a little below and above the standard.  

### Direction control

Some BESCs allow reversing the motor. You must start the BESC with the pulse length in the middle. We have no way to safely control these.

## Power

These are often low voltage motors that are designed to run off battery power. They can pull huge currents and are noisy. The optional brake feature can generate large amounts of back EMF. Batteries are generally fine with this. Power supplies and nearby electronics can struggle with it.

We recommend a large, separate power supply. Keep the motor and power wires away from other wiring especially switches and other inputs.

## Startup

For safe turn on, most BESCs require you to set the pulse length to the minimum at startup. FluidNC will do this automatically. If the turn on sequence is more complex you might need to write a macro to do this.

## Config File

The [BESC spindle type](/config/config_spindles#besc) is used, not a plain PWM spindle. BESC has its own `min_pulse_us`/`max_pulse_us` fields, in microseconds -- the driver maps a plain 0-100% `speed_map` onto that pulse range internally, so you don't need to compute what percentage of the PWM period a given pulse length corresponds to.

Here is a minimal config file section. This sets an RPM range of 0-1000 to the standard 1ms-2ms pulse width range at 50Hz.

```yaml
BESC:
  pwm_hz: 50
  output_pin: gpio.12
  min_pulse_us: 1000
  max_pulse_us: 2000
  speed_map: 0=0% 1000=100%
```



## Helpful tools

Setup, programming and testing can be helped with these tools.

### Servo Tester

This is an easy way to test a BESC and can do manual programming by changing the output pulse length. 

![servo_tester.jpg](/motors/servo_tester.jpg =x250)

### BESC Programmer
This can help you program or reset the features of the BESC
![besc_prog_card.png](/motors/besc_prog_card.png =x250)

# Examples

## Turnigy Plush 30A

This was used with a Turnigy D3520/14 motor on a 12V 24A power supply.

![turnigy-d3530-14.jpg](/motors/turnigy-d3530-14.jpg =x200) 

I used a frequency of 50Hz (`pwm_hz:`) and a pulse range of 1ms to 2ms (`min_pulse_us: 1000`, `max_pulse_us: 2000`).

I chose an arbitrary RPM range of 0-1000 for the test speed_map because I don't know the real RPM range. The motor is 1100KV (RPM per volt) so it is closer to 0-13200 RPM.

I tested the motor and found that it did not really work well until about S200, so I added an extra term in the speed map to insure all S values over 0 were at least 1.2ms -- 20% of the way from min_pulse_us (1ms) to max_pulse_us (2ms).

My config

```yaml
BESC:
  pwm_hz: 50
  direction_pin: NO_PIN
  output_pin: gpio.12
  enable_pin: NO_PIN
  min_pulse_us: 1000
  max_pulse_us: 2000
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 100
  speed_map: 0=0% 0=20% 1000=100%
  off_on_alarm: false
  atc:
  m6_macro:
```

### BESC Wiring

I wired the white wire to the signal `output_pin`. I wired ground to ground on the controller. I did not wire the red (5v) wire. The BESC powered itself from its primary voltage. This made it easier to power down the BESC and leave the FluidNC controller running.

### Normal Startup

For a normal startup you need start the motor with the PWM at the minimun pulse length (same as set in the range). This happens naturally because the PWM Spindle powers up at the 0 RPM. 

I found that both the FluidNC controller and BESC could be powered on at the same time.

### Range Setting

- Power on the FluidNC controller
- Send M3S1000 to go to the max pulse length
- Power on the BESC
- Wait for the Beep-beep (about 2 seconds), then quickly send S0. If you wait too long it will enter programming mode
- A long Beep should confirm the setting
- Power off the BESC

### Programming

- Power on the FluidNC controller
- Send M3S1000 to go to the max pulse length
- Power on the BESC
- Wait for the Beep-beep (about 2 seconds). Wait another 5 seconds for 5 tones of rising and lowering frequency.
- Follow the programming instructions
- Power off the BESC

> Note: I had to use this to reset factory settings. The brake function was on which cause spikes when the motor turned off (S0). This latched up my power supply.
{.is-info}

