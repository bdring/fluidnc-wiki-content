---
title: Help with Machine Space and Homing
description: 
published: true
date: 2026-08-01T19:39:15.401Z
tags: 
editor: markdown
dateCreated: 2022-07-21T21:52:30.715Z
---

# Machine Space and Homing

Machine space and machine coordinates are terms used for the range of motion on an axis that FluidNC uses **internally**. These coordinates do not change when you zero an axis or change work coordinate systems (G54-G59). Work coordinates are just offset from the machine coordinates. The only thing that resets machine coordinates is homing to limit switches.

If machine space is confusing you while using the machine, just ignore it. It is primarily used by the machine and not the user. Virtually all gcode operates in work coordinate systems. These are the coordinate systems you can zero on your work and are saved in non volatile memory.

With FluidNC you are free to setup the machine range any way you like. It can be any size and you can place that size anywhere you want in space. You can have it in all positive space, all negative space or partially in both.

<img src="https://github.com/bdring/FluidNC/wiki/images/mpos_youtube.png" width="500">

[Here is a good video explaining work coordinate systems](https://www.youtube.com/watch?v=fGtbkVJBXyE) (Uses Grbl, but is still valid for FluidNC)

## Travel Range

The "travel range" is the per-axis extent of machine coordinates that the machine is permitted to travel if soft limits are enabled.  If, for example, the X axis travel range is [-40.000, 160.000] and soft limits are enabled, then a GCode command that asks to move to a machine coordinate less than -40 or greater than 160 will cause an alarm.

$J jog commands are similarly limited but without alarming.  If you issue a jog command that would travel outside the travel range, the requested distance is truncated so the jog ends at the end of the range corresponding to the jog direction. 

## Config file values

These config file items affect the homing process and the travel range:

- **axes/x/homing/positive_direction** The direction the machine travels to find the homing limit switch.  If true, homing moves in the positive direction.  If false, homing moves in the negative direction.
- **axes/x/homing/mpos_mm** The endpoint of the travel range in the homing direction. The homing switch is [pulloff_mm](http://wiki.fluidnc.com/en/config/axes#pulloff_mm) beyond mpos_mm. While homing, the machine will travel toward the switch, touch it, back off by pulloff_mm, and set the machine position to mpos_mm.
- **axes/x/max_travel_mm** The usable length of the axis, i.e. the distance from the negative endpoint to the positive endpoint of the travel range.
- **axes/x/homing/[pulloff_mm](http://wiki.fluidnc.com/en/config/axes#pulloff_mm)** The distance to pull away from the switch after homing. This is done to clear the switch.  This distance is considered to be outside of the travel range and thus does not affect the travel range endpoints.

## Examples

- axes/x/max_travel_mm: 300.0
- axes/x/homing/mpos_mm: 0.0
- axes/x/homing/positive_direction: false
- axes/x/homing/[pulloff_mm:](http://wiki.fluidnc.com/en/config/axes#pulloff_mm) 2.0

The machine will home in the negative direction and set the machine position to 0 afterwards. The startup messages will report this travel range:

```
[MSG:INFO: Axis X (0.000,300.000)]
```
***
- axes/x/max_travel_mm: 300.0
- axes/x/homing/mpos_mm: 300.0
- axes/x/homing/positive_direction: true
- axes/x/homing/[pulloff_mm](http://wiki.fluidnc.com/en/config/axes#pulloff_mm): 2.0

The machine will home in the positive direction and set the machine position to 300 afterwards. The startup messages will report this travel range:
```
[MSG:INFO: Axis X (0.000,300.000)]
```
***
- axes/x/max_travel_mm: 300.0
- axes/x/homing/mpos_mm: 150.0
- axes/x/homing/positive_direction: false
- axes/x/homing/[pulloff_mm](http://wiki.fluidnc.com/en/config/axes#pulloff_mm): 2.0

The machine will home in the negative direction and set the machine position to 150 afterwards. The startup messages will report this travel range:
```
[MSG:INFO: Axis X (150.000,450.000)]
```
***
- axes/x/max_travel_mm: 300.0
- axes/x/homing/mpos_mm: 10.0
- axes/x/homing/positive_direction: true
- axes/x/homing/[pulloff_mm](http://wiki.fluidnc.com/en/config/axes#pulloff_mm): 2.0

The machine will home in the positive direction and set the positive-end machine position to 10 afterwards.  The startup messages will report this travel range:
```
[MSG:INFO: Axis X (-290,10.000)]
```

## Not Using Switches or Homing

If you do not use homing, machine space is moot. The machine does not know where it is at any time. Soft limits should not be used. Hard limits could be used, but if you have switches, you are likely to home. You can still zero the work coordinate system anywhere you want without switches. The machine space specified by max_travel and mpos_mm will be ignored and you can freely travel past the ends.  Any zero you set is meaningless the next time you start FluidNC.

## Tips for newbies.

If all of this is confusing, just try to ignore machine space for a while. Most users will never need to think in machine coordinates. After you use your machine for a while and see that you can ignore them, you will be in a right state of mind to dig deeper into what it all means. We have spent hours trying to explain the concepts to people, who just are not quite ready to understand them.

You are probably looking at a screen right now. That screen is located at some exact latitude, longitude, altitude and rotational position, **but who cares?**. move it to the position that is meaningful to you and not the planet.

[This video can help](https://www.youtube.com/watch?v=fGtbkVJBXyE)

# FAQ

## Can I home in the middle of an axis.

The short answer is no. The machine would not know which way the home switch because it does not know which side it is starting on. Also the range is calculated from the the switch direction, the mpos value and the max travel. If you were able to home in the middle, it would create a range only on one side.

If you turned off hard and soft limits and made sure the machine was on the correct side before homing. You would have virtually limitless travel in both directions with the switch mpos value near the switch (and no protection). **Also please turn off all support questions.** At this point you are suggesting you know more than us.

