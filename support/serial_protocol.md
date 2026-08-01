---
title: Serial Protocol
description: 
published: true
date: 2026-08-01T19:39:32.397Z
tags: 
editor: markdown
dateCreated: 2022-07-22T14:13:22.151Z
---

# Serial Protocol

We use the standard Grbl 1.1 status report. This is done to preserve compatibility with gcode senders This has some limitations, so it cannot report individual switches on axes with multiple switches. We have added some extra pin reporting.

# Status

The command to get status is the `?` character.  It is an immediate command. It does not wait for other commands to complete and it will not return an OK response.

Typical responses looks like this. Note that not all responses contain WCO or OVR. Every 10 responses the cycle will retart. Also, if anything changes that affect WCO or OVR, it will force a restart of the status cycle, so interfaces can rapidly update.

```
<Alarm|MPos:0.000,0.000,0.000|FS:0,0|WCO:0.000,0.000,0.000>
<Alarm|MPos:0.000,0.000,0.000|FS:0,0|Ov:100,100,100>
<Alarm|MPos:0.000,0.000,0.000|FS:0,0>
<Alarm|MPos:0.000,0.000,0.000|FS:0,0>
<Alarm|MPos:0.000,0.000,0.000|FS:0,0>
<Alarm|MPos:0.000,0.000,0.000|FS:0,0>
<Alarm|MPos:0.000,0.000,0.000|FS:0,0>
<Alarm|MPos:0.000,0.000,0.000|FS:0,0>
<Alarm|MPos:0.000,0.000,0.000|FS:0,0>
<Alarm|MPos:0.000,0.000,0.000|FS:0,0>
<Alarm|MPos:0.000,0.000,0.000|FS:0,0|WCO:0.000,0.000,0.000>
...
```

Each section of the response is separated by the '|' character.

> FluidNC Only: You can have the firmware automatically report status whenever something changes. The eliminates the need to poll for status. [See this page](http://wiki.fluidnc.com/en/support/interface/automatic_reporting)
{.is-success}

## Reporting Mask

The reporting mask is the $10 setting. It determines what data is reported with the real-time status report. It is a binary mask.

- The first bit is for the position
  - 0 Reports WPos (current work position)
  - 1 Reports MPos (machine coordinate)
- The second bit is determines whether the buffer states are reported
  - 0 Does not report the buffer
  - 2 Reports the buffer
  
So...

- $10=1 reports WPos
- $10=1 reports MPos
- $10=2 reports WPos and buffer
- $10=3 reports MPos and buffer

## State Section

This shows the current mode of the machine. It will be one of the following.

- `Idle`
- `Alarm`
- `Check` This shows that the machine is in check mode. This is a special mode that allows gcode to run and be checked without actually sending I/O.
- `Homing`
- `Run`
 - `Jog`
- `Hold`
  - `Hold:0` Hold complete. Ready to resume.
  - `Hold:1` Hold in-progress. Reset will throw an alarm.
- `Door`
  - `Door:0` Door closed. Ready to resume.
  - `Door:1` Machine stopped. Door still ajar. Can't resume until closed.
  - `Door:2` Door opened. Hold (or parking retract) in-progress. Reset will throw an alarm.
  - `Door:3` Door closed and resuming. Restoring from park, if applicable. Reset will throw an alarm
- `Sleep`

## Position Section

This section shows the current position. It will report **MPos** for machine position and **WPos** for work position. You can change type with `$10=1` for MPos and `$10=2` for WPos. It will show a value for each axis you have defined. It does not label the values, so they are always in XYZABC order. Therefore you cannot skip an axis in your config file.

## Pin Section

The `Pn:` section shows any input pins in the currently active state. It does not show the state of individual limit switch pins. It shows the axis as active if any limit switch on that is active. We have a $Limits command to show those for debugging.

- `XYZABC` Limit switch pins
- `P` Probe pin
- `T` Toolsetter
- `R` Reset pin
- `S` Cycle start pin 
- `H` Feed hold pin
- `D` Door pin
- `0123` Macro pins status
- `F` Fault pin
- `E` E-Stop pin
- 


## FS: Feeds and Speed section

This is the section `FS:` section and tells the current feed rate and spindle speed. 

The feed rate is actual feed rate, so it shows intermediate values when acceleration to the requested speed.

The spindle speed is the current S value in M3 and M4 modes. It will report 0 in M5 mode. 

## WCO: Work Coordinate system Offset

This show the current work offset from the machine position. This allows you to calculate WPos from MPos, or the other way. This will only show up in the report when it has changed. It is also sent periodically, even if it has not change. The WCO results from things like zero'ing an axis or setting a G54-G59 offset.

## BF: Buffer State

This is the `Bf:` section. It only reports if $10=2 or $10=3

Bf:15,128. The first value is the number of available blocks in the planner buffer and the second is the number of available bytes in the serial RX buffer.

The number of planner blocks is set in the config file. [Read about it here](http://wiki.fluidnc.com/en/config/top_level_config_items#planner_blocks).

## Ln:

This reports the current line number is you have [use_line_numbers: true](http://wiki.fluidnc.com/en/config/top_level_config_items#use_line_numbers) in your config file.

Ln:99999 indicates line 99999 is currently being executed.

If you have the option set, but are not using line numbers, nothing is reported.



## Ov: Overrides

This gives you the current **Feed:Rapid:Spindle** override values. The numbers are in percent. 

```
<Idle|MPos:0.000,0.000,0.000|FS:0,0|Ov:100,100,100>
```

## SD: SD card file progress.

This shows the percent complete `SD:nn.nn` of the file sent from an SD card to the FluidNC motion planner. FluidNC still has to complete the last motion commands after they have all been sent. This is only present while an SD card job is running.

```
<Run|MPos:0.000,0.000,0.000|FS:0,0|Ov:100,100,100|SD:47.32>
```
