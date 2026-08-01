---
title: Open Issues and Requested Features
description: 
published: true
date: 2026-08-01T19:34:58.888Z
tags: 
editor: markdown
dateCreated: 2024-12-28T01:40:04.262Z
---

# Open Issues and Requested Features

> These are issues that have been identified or requested. This is not a roadmap or TODO list. It just captures feedback we get.
{.is-warning}


# Open Issues

## S3 Chip issues

- Allow CDC UART to be a console

## File Systems

- Create a subdirectory from console

## Web Installer

- Display subdirectories

## Motion Control Issues

### G10 P word

P should be a required parameter. Currently you can skip it and FNC will assume P0.

### Can accel be configured differently for G0 and G1/G2/G3?

 - [See this PR](https://github.com/bdring/FluidNC/pull/1567)

## Channel, Expander, Pendant and Display Issues

### The FluidDial firmware sets $RI=200.

- Change this to ask for the current value and set it to 200 if the value is 0

### Idea - rewrite dial pendant code in Python.

Adding some way for users to customize screens

(Mitch says: I wrote a version of the Tablet UI in microPython/LVGL for the CrowPanel 7, and tried to hand off the code to someone else for completion and maintenance.  It kept running into the problem that the LVGL API changes constantly, and they stopped supporting the microPython binding.  There is a guy named Kevin Schlosser who supports LVGL/microPython on his own, with a nice build system, but he changes the API rather frequently too, so deployment is sort of a never-ending hassle.)

# Requested Features and Ideas

These are things that have been suggested by others. The developers are only compensated by small donations at this time, so each is free to choose what they work on.


## Laser performance improvements (GCode clustering or other protocol)

This would improve laser engravings by making files smaller and motion more efficient.

## TLO: Add other axes to TLO per standard gcode

- For example: XY TLO could be used when changing between spindles. 

## Gcode Subroutines

This is pretty challenging. FluidNC would need to scan the entire file before starting. Gcode senders are not designed for this type of workflow.

## More Alarm inputs

I/O expansion has removed some limitations on I/O count. Motor driver and spindle alarms could be helpful. 

## Backlash compensation

We don't see this as a high priority at this time. Some features offer little benefit, but result in high amounts of work and support. We believe backlash compensation only helps large and rigid machines.

## Add a pin to enable the I2SO

Currently they are typically always enabled. Since we have more I/O with expanders, etc, it might make sense to support this. It also allows better control of startup states.

## Single-stepping

This is where a single line of gcode is run at a time. It is done for troubleshooting and testing gcode files and machines. Typically the cycle start is used to begin the next line.

## Motor setup wizard

## GCode Inputs (M66)

- Waiting for input on M66
- Support for M66 analog

The immediate (not wait) mode is now [supported](http://wiki.fluidnc.com/en/features/supported_gcodes#m66-read-user-input).

## Wifi based peripherals

- [Discord Discussion](https://discord.com/channels/780079161460916227/1334505024830574642)

## Add more non volatile things.

To persist after power cycles

- Tool number
- TLO (all axes)


## Allow jogging off active switches

Allow jogs in the proper direction to clear a switch when the active switch end is known. Also consider adding the end to the alarm message.

- Mentioned in [this issue](https://github.com/bdring/FluidNC/issues/1482)


## Coordinate rotation G10 L2

Add the ability to rotate coordinate systems with the G10 L2 command. [This is discussed here](https://discord.com/channels/780079161460916227/1409129468781527162). 

# Closed Issues

## Probing hard fault

Add an option where probe activations become hard faults when not probing. 

Many people have accidentally damaged probe tips or toolsetters crashing into them in G0 through G3 modes. It would be nice to limit it to run mode only to allow testing of the probe continuity without faulting.


### Finish and deploy the STM Expander

- [Discord Thread](https://discord.com/channels/780079161460916227/1333171112883912715)
- FluidTerm can now program STM32s [See this PR](https://github.com/bdring/FluidNC/pull/1443)
- Protocol has been updated.

### FluidDial display response seems slow.

- DRO continues to update after motion stops.
- The jog background image appears to be causing the problem.
- **Fixed** 1/2/2025 The jog background now uses a sprite instead of reading from the FD each refresh.

### Motor direction is not always correct (I2S Clocking).

- See [issue #1408](https://github.com/bdring/FluidNC/issues/1408)
- The [BetterI2SClocking branch](https://github.com/bdring/FluidNC/tree/BetterI2SClocking) appears to fix it.
- **Fixed** v3.9.4 There is now better clocking and adjustable min pulse width. This should help with the slower I2S chips.

### Hold sometimes hard stops

- See [issue #1410](https://github.com/bdring/FluidNC/issues/1410)
- This appears to be solved with [PR #1396](https://github.com/bdring/FluidNC/pull/1396)
- **Fixed** in v3.9.4

### Multiple jogs sometimes hard stop on cancel 

- This appears to be solved with [PR #1396](https://github.com/bdring/FluidNC/pull/1396)
- **Fixed** in v3.9.4

## Add Diag0 error features for SPI Trinamic motor drivers.

This feature could fine tune pulse rise times and reflections.

- [See this PR](https://github.com/bdring/FluidNC/pull/1491)

## Add gpio output drive strength control.

- [See this Discord post](https://discord.com/channels/780079161460916227/1367751511685464074/1368295907824636174).

### Change how M6 macros work

- [See this issue](https://github.com/bdring/FluidNC/issues/1422).
- [Discord discussion](https://discord.com/channels/780079161460916227/1324814397637398651)
- [PR](https://github.com/bdring/FluidNC/pull/1425)

## Torch height control

- [See this wiki page](http://wiki.fluidnc.com/en/development/plasma)
- [See this Discord topic](https://discord.com/channels/780079161460916227/1328183435524706366)

###  The transition from Hold:1 to Hold:0 is not a state change, so auto reporting does not report it.

[See release v3.9.5](https://github.com/bdring/FluidNC/releases/tag/v3.9.5)

## VFD Protocols defined by data

  - See this [PR](https://github.com/bdring/FluidNC/pull/1431)
  - See this [Discord discussion](https://discord.com/channels/780079161460916227/1330984291412476026)

