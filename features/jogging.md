---
title: Jogging
description: 
published: true
date: 2026-08-01T19:36:13.702Z
tags: 
editor: markdown
dateCreated: 2022-07-21T19:49:00.284Z
---

# Jogging FluidNC

FluidNC uses the Grbl v1.1 jogging method. See the [Grbl wiki](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Jogging) for more details.

Each jog command is independent of existing modal values and feed rates. It will not change existing modal values.

  - Required Words
    - `XYZABC` You need at least one axis word
    - `F` You need a [feed rate](http://wiki.fluidnc.com/en/features/supported_gcodes#f-feed-rate) for each jog command.
  - Optional Words
    - `G90/G91` You can specify the [distance mode](http://wiki.fluidnc.com/en/features/supported_gcodes#g90-g91-distance-mode) otherwise it will use the current value
    - `G20/G21` You can specify the [units, inch or mm](http://wiki.fluidnc.com/en/features/supported_gcodes#g20-g21-units), otherwise it will use the current value
    - `G53` You can specify an absolute [move in machine space](http://wiki.fluidnc.com/en/features/supported_gcodes#g53-use-machine-coordinates) 

Examples

```gcode
$J=X10.0 Y-1.5 F100 ;move to work coords X10 Y-1.5 at a rate of 100
$J=G91 F200 Z5 ; move +5 units on Z at a rate of 200
$J=G53 Y5.0 F100 ; move to machine coord Y5.0 at a rate of 100 
```

## FluidNC Differences

The one change we have made concerns soft limits. With Grbl, if you have soft limits enabled and attempt to jog outside the range, you will get a soft limit alarm. With FluidNC, the jog will be constrained to the soft limit range. For example: If 300 is the maximum end of travel and you attempt to jog to 350. The machine will jog to 300 and stop.

 This was done to allow a simpler method of continuous jogging. Continuous jogging is typically used with a button on a gcode sender. The button down event starts a jog and the button up event stops it. You would send a command like **$J =G91 X1000 F1000** where the X distance is longer than you intend to jog. FluidNC will adjust the value to prevent hitting the limits, so it will work regardless of the location. If the value you use for the distance is less than range, the jog will stop after moving the full distance. You could then click the button again. As soon as you release the button the machine will decelerate to a stop.