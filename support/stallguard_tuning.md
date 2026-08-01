---
title: StallGuard Tuning
description: 
published: true
date: 2026-08-01T19:39:37.213Z
tags: 
editor: markdown
dateCreated: 2022-07-22T14:17:47.900Z
---

# StallGuard Tuning

## Overview

Trinamic drivers have 2 basic modes. **SteathChop** is the super quiet mode and **CoolStep** is a mode where the driver can dynamically increase the current when the motor is under load. Since **CoolStep** can determine the load, in many cases it can sense when the motor is about to stall or has already stalled. For further reading, Trinamic has an [app note about StallGuard](https://www.trinamic.com/fileadmin/assets/Support/Appnotes/AN002-stallGuard2.pdf).

It does this by measuring the ratio of energy sent to the motor and energy returned. As the load on a motor increases, less energy is returned. When the returned energy falls to a certain point, the driver will indicate a stall. Since there are many sources of power loss, like wiring and motor design, the driver allows you to set the level where the stall is indicated.

Each machine needs to be tuned for motor size/current, speeds, mass, etc. It is a slow and time consuming process. The firmware can only help a little because this is purely a driver feature.

The method does not work at very low and very high speeds. You must test your system to determine a good speed for stall detection to avoid missed stalls or false indications.

The driver chips output a signal on the pin associated with the StallGuard state. This pin must be wired to the ESP32. Some controllers do this directly on the PCB. Some may require the use of a jumper or physical wire. This is treated exactly like a mechanical switch by FluidNC. Please read about limits switch setup in other areas of this wiki for [help with that](http://wiki.fluidnc.com/en/support/help_with_switch_problems).

## Is StallGuard right for you?

At best it is accurate to about 1-2 full steps. Most basic switches will be far more accurate. The accuracy may be fine for X and Y on a 3D printer or pen plotter, but probably not for a router or laser engraver. 

- Due to it not working well at low and and high speeds, it is not recommended for use with hard limits (full time limit detection). 
- It should work with dual motor axes, but is likely to be more difficult to set up. 
- It is seriously not recommended for CoreXY, because 2 motors are used for each axis move. Hitting a hard stop is unlikely to only be detected by the correct motor.
- It is not recommended for machines like routers that can have high and variable loads on the axes.
- I have found that over time, under changing loads or at different temperatures, stallguard tuning can change. This can result in rougher stops, premature stops or failure to stop at all. 

> Setting it up can be a long and frustrating process. Please do not expect a lot of help and support with it. It is not something that is easy to help with remotely.
{.is-warning}


## Config File Setup

Here are the config file settings that apply to Stallguard homing. You still need all the other settings, but these specifically apply to this mode.

- **limit switch** You must have the limit switch inputs you will be using with StallGuard set up properly. You have to have the high/lo attributes set so the active state correctly reports. Controllers may invert this signal, so we cannot recommend the active state based on the driver chip alone. 
- Set **homing/feed_mm_per_min** and **seek_mm_per_min** to the same value and to a medium speed. StallGuard is less sensitive at high and low speeds.
- The diag1 pin on the stepper driver should directly connect to the limit switch input.
- Select a middle range value for **stallguard**, like 15. This will be tuned later.
- Set **stallguard_debug** to false. It will be set to true when tuning.
- **homing_mode** must be StallGuard

```yaml
homing:     
      feed_mm_per_min: 200.000
      seek_mm_per_min: 200.000
motor0:
      limit_neg_pin: gpio.4:high
      tmc_2209:      
        stallguard: 15
        stallguard_debug: false
        homing_mode: StallGuard
```

## Hardware Setup

In most cases the circuit on the stepper driver is an open drain that closes to ground. This means you define the switch pin as active low (`:low`). You also need a pull up resistor somewhere. If your controller has pull up resistors that will be fine. You can also add the ESP32 internal pullup with `:pu` on the [pins that support it](http://wiki.fluidnc.com/en/hardware/esp32_pin_reference#input-only-no-pulluppulldown).

```yaml
      limit_neg_pin: gpio.33:low:pu
```


## Testing and Tuning

Check the state of the limit switches with no motion with the `?` status request command. No limit swithces should be reporting. If they are, change the active state with [pin attributes](http://wiki.fluidnc.com/en/config/overview#pin_declaration).

Turn on the display of StallGuard data with **$/axes/x/motor0/tmc_2209/stallguard_debug=true**. This will cause StallGuard data to be output to the [USB/Serial](https://github.com/bdring/Grbl_Esp32/wiki/Serial-Port-Setup-and-Usage) port. It must use the serial port for best speed and timing of the data. The data will look like this. These are 4 readings directly before a stall was detected. Note: Only use this reporting when tuning. Turn off the reporting when running normal gcode.

> Sometimes the exact reporting text and style changes with the release version, but generally the basic information is the same.
{.is-info}


```
[MSG:INFO: X Axis Stallguard 0   SG_Val:784 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 0   SG_Val:784 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 0   SG_Val:553 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 0   SG_Val:403 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 0   SG_Val:403 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 0   SG_Val:403 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 1   SG_Val:0 Rate:200.000 mm/min SG_Setting:6]
```

This is what the values mean...

- **X Axis** This is the axis being displayed
- **Stallguard 0** A stall is not detected.
- **SG_Val: 0168** This is the current value of the StallGuard sensor. You want to get this to 0. The reporting is slowed down to prevent interfering with the motion, so you may not actually see it get to a 0 when it triggers.
- **Rate: 200 mm/min** This is the current step rate Grbl_ESP32 is producing. This should be close to your **$/axes/x/homing/seek_mm_per_min** (or feed) value, but will rise and lower due to acceleration and deceleration
- **SG_Setting:30** This is the current **$/axes/x/motor0/tmc_2209/stallguard** setting.

Home using **$HX**. Add a load to the motor close to stalling it. Watch the values.

You want SG_Val: to drop to 0.

Try different speeds and **$/axes/x/motor0/tmc_2209/stallguard** values.

Lower values = **$/axes/x/motor0/tmc_2209/stallguard** lower make it more sensitive.

Try adjusting **$/axes/x/motor0/tmc_2209/stallguard** up and down until you get the best sensitivity without false triggers. Record your result.

Try different homing speed values with the same process.

If the second touch, after pull off, is not triggering try using a larger value of [feed_scaler:](https://github.com/bdring/FluidNC/wiki/FluidNC-Motor-Setup#feed_scaler).

Use the best combination of values you find.

# Troubleshooting

## Pull off move

If the first phase of a homing sequence is a pull off move, FluidNC thinks the switch is already active at the time you commanded the homing sequence. For StallGuard this should never happen. It should always report the non active state until it is blocked from moving. Your active state attribute could be wrong.

## Second Cycle Fails

If the first (seek) cycle works, but the second (feed) cycle fails, try increasing the **homing/feed_scaler:**. This will cause it to move a little further in that phase. Sometimes it takes a few skipped steps to register a stall.
