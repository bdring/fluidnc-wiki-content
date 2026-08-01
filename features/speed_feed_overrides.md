---
title: Speed and Feed Overrides
description: 
published: true
date: 2026-08-01T19:36:32.752Z
tags: 
editor: markdown
dateCreated: 2022-07-21T20:46:04.478Z
---

# Overrides

Overrides are realtime commands that affect parameters while a job is running. They are generally sent via a gcode sender or pendant. Here is the WebUI override panel as an example. 

<img src="https://github.com/bdring/FluidNC/wiki/images/overrides.png" width="600">


## Overview

Speed (Spindle).  rapid (G0 Motion), and feed (G1,G2,G3 Motion) overrides let you override current values. They can be used while running a gcode job. For example: if you think changing the spindle speed may improve cut quality, you can increase or decrease the speed in 1% or 10% increments. You can never go faster than the max in your config files.

The increments are based on the current S (speed) or F (feed) value. If you have a speed of 1000, increments of 10% will take it to 1100, 1200, etc.

You can see the current values in the status responses.

```
<Idle|MPos:60.000,0.000,0.000,0.000,0.000,0.000|FS:500,8000|Ov:100,100,110>
```

- `FS:500,8000` contains real-time feed rate, followed by spindle speed, data as the values.
- `Ov:100,100,110` indicates current override values in percent of programmed values for feed, rapids, and spindle speed, respectively.



Send **$G** to see all the gcode values.

```
[GC:G0 G54 G17 G21 G90 G94 M5 M9 T0 F200 S1000]
```

- `F200` This gives the programmed feed rate (before overrides).
- `S1000` This gives the programmed speed  (before overrides).

## Spindle Override Stop

This **only works in hold mode**. It allows you to stop the spindle. If your bit is tangled in chips, you could do a feedhold, then do a spindle override stop, You can now clear the chips. You can either click the button again to start the spindle or the spindle will automatically restart when feedhold is ended.

**Note:** This cannot be used to toggle the spindle in idle. Use M3, M4, and M5 for that.

## Coolant Toggles

You can override the coolant state of a running job. This is not meant for normal control of coolant. Use M7, M8, and M9 for that.

### Command characters

These are all single character "immediate" commands. They take effect in a fraction of a second. The characters are all non printable characters, so they cannot be accidentally placed in gcode. You need a sender application or the WebUI to send them.

Here are the values

```
    FeedOvrReset          = 0x90,  // Restores feed override value to 100%.
    FeedOvrCoarsePlus     = 0x91,
    FeedOvrCoarseMinus    = 0x92,
    FeedOvrFinePlus       = 0x93,
    FeedOvrFineMinus      = 0x94,
    RapidOvrReset         = 0x95,  // Restores rapid override value to 100%.
    RapidOvrMedium        = 0x96,
    RapidOvrLow           = 0x97,
    RapidOvrExtraLow      = 0x98,  // *NOT SUPPORTED*
    SpindleOvrReset       = 0x99,  // Restores spindle override value to 100%.
    SpindleOvrCoarsePlus  = 0x9A,  //
    SpindleOvrCoarseMinus = 0x9B,
    SpindleOvrFinePlus    = 0x9C,
    SpindleOvrFineMinus   = 0x9D,
    SpindleOvrStop        = 0x9E,
    CoolantFloodOvrToggle = 0xA0,
    CoolantMistOvrToggle  = 0xA1
```

# Advanced Users

These are the defined values in `config.h` for the overrides.

```cpp
// Configure rapid, feed, and spindle override settings. These values define the max and min
// allowable override values and the coarse and fine increments per command received. Please
// note the allowable values in the descriptions following each define.
namespace FeedOverride {
    const int Default         = 100;  // 100%. Don't change this value.
    const int Max             = 200;  // Percent of programmed feed rate (100-255). Usually 120% or 200%
    const int Min             = 10;   // Percent of programmed feed rate (1-100). Usually 50% or 1%
    const int CoarseIncrement = 10;   // (1-99). Usually 10%.
    const int FineIncrement   = 1;    // (1-99). Usually 1%.
};
namespace RapidOverride {
    const int Default  = 100;  // 100%. Don't change this value.
    const int Medium   = 50;   // Percent of rapid (1-99). Usually 50%.
    const int Low      = 25;   // Percent of rapid (1-99). Usually 25%.
    const int ExtraLow = 5;    // Percent of rapid (1-99). Usually 5%.  Not Supported
};

namespace SpindleSpeedOverride {
    const int Default         = 100;  // 100%. Don't change this value.
    const int Max             = 200;  // Percent of programmed spindle speed (100-255). Usually 200%.
    const int Min             = 10;   // Percent of programmed spindle speed (1-100). Usually 10%.
    const int CoarseIncrement = 10;   // (1-99). Usually 10%.
    const int FineIncrement   = 1;    // (1-99). Usually 1%.
};
```
