---
title: A Manual ATC Feature
description: This feature allows you to use  a toolsetter to speed tool changes
published: true
date: 2026-08-01T19:35:37.825Z
tags: 
editor: markdown
dateCreated: 2025-04-11T21:20:18.788Z
---

# A Manual ATC feature

This feature uses a tool setter to speed up manual tool changes. A fully automatic tool changer is quite expensive, but you can still get some improved productivity if you automate some of the process and manually do the rest.

With this feature the user manually installs the tools and sets the work Z zero for the first tool on the workpiece.

The firmware helps by moving the spindle to a convenient location before each tool change and using a tool setter to adjust Z offset when tools have different lengths.

> This is an advanced feature. You should be familiar with gcode and have a fully functional and reliable machine before you add this feature. Do try to implement this before have a lot of experience with your machine, FluidNC and your CAM program.
{.is-info}

# Machine requirements

- The machine must have accurate and reliable homing switches on all axes.
- You need to have a tool setter in a fixed and stable position on your machine within work area.
- You need a way to set the initial Z work zero. This is typically done with a touch plate or an automatic electronic probe.

# How to configure FluidNC to do this

## Set up your probe(s)

See the [probes page](http://wiki.fluidnc.com/en/config/probe) to do this.

## Setup the ATC parameters

You first need add the **atc_manual:** spindle to your config file. It looks like this. All values are in millimeters and all axis values are in machine coordinates. Below are the descriptions of each config item.

```
atc_manual:
  safe_z_mpos_mm: -1.000000
  probe_seek_rate_mm_per_min: 800.000000
  probe_feed_rate_mm_per_min: 80.000000
  change_mpos_mm: 80.000 0.000 -1.000
  ets_mpos_mm: 5.000 -9.000 -40.000
  ets_rapid_z_mpos_mm: -25.000000
```

- **safe_z_mpos_mm:**
  - This is the z position where the XY motion will occur. It is generally as high as possible to clear all work with a long bit installed.
- **probe_seek_rate_mm_per_min::**
  - If this is set to a higher value than the `probe_feed_rate_mm_per_min:` value it will do this faster probe, retract a small amount and then do a second probe at the `probe_feed_rate_mm_per_min` rate.
- **probe_feed_rate_mm_per_min:**
  - This is a probe speed that is used to when setting the tool length.
- **change_mpos_mm:**
  - This is the location where you want to manually change the tools. It should be in an easily accessible location. It is generally done at the top of Z travel.
- **ets_mpos_mm:**
  - This is the location of the electronic tool setter. The X and Y should be the center of the toolsetter. The Z location is used to check for a missing tool. Lower the spindle down until an empty collet is just above the tool setter. If the spindle ever goes this low on a tool setter probe, it will terminate the tool change with an alarm.
- **ets_rapid_z_mpos_mm:**
  - This can be used to speed up the ETS operation. The tool will rapidly move to this Z location before the probe cycle starts. You need to make sure that your longest tool will not touch the ETS at this position. To be safe, start with this as the same value as `safe_z_mpos_mm:` 

## Add ***atc_manual*** to your spindle config

All spindles have a config item called `atc:`. You use this to tell what ATC type you want to use with this spindle. FluidNC only has one ATC type in the default firmware. It is a manual ATC and called `atc_manual`. Here is an example of a Huanyang spindle definition with the manual ATC. You could add it to any spindle type the same way.

```
Huanyang:
  uart_num: 1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 0=25% 6000=25% 24000=100%
  off_on_alarm: false
  atc: atc_manual
```

> Note: Spindles also have an m6_macro: config item. Do not use this with the manual ATC feature.
{.is-info}


## Use with multiple spindles

It is possible to use multiple spindles with one or more having an ATC configured, but this is a really advanced setup. Please don't try this unless you have hundreds of hours of success with a single spindle. 

Start with one spindle that has ***tool_num: 0***


# Gcode behavior

> To get the current tool number you can send $G or [D#5400](http://wiki.fluidnc.com/en/features/gcode_parameters_expressions#numbered-parameters)
{.is-info}


These are the gcodes you will be using. This is how the machine will react to each one when using this feature.

- **M61Q\<num\>**
  - Sets the current tool
  - If there was a previous tool number it resets the TLO to 0.0  
- **T0 or M6T0** 
  - Moves to the `change_mpos_mm:` position and waits.
  - Resets TLO and other saved tool info.
- **M6T\<not 0\> From T0**
  - Moves to the change location and does nothing else. This is used when you want to insert the first tool.
- **M6T\<not 0\> to T\<not 0\>** first time 
  - Determines the TS offset
  - Goes to tool change location
  - Set TLO
  - Returns to position before command
- **M6T\<not 0\> to T\<not 0\>** after first time
  - Goes to tool change location
  - Set TLO
  - Returns to position before command
- **M6T\<current tool\> to T\<current tool\>**
  - Does nothing

# Typical Job Workflow

This is **what you must do manually before running** any CAM files.

- Home the machine
- Install the first tool.
  - If the tool was already installed you can send M61Q<tool_num> where <tool_num> is the number of the tool. Like M61Q2
  - If you need to install a tool send M6T<tool_num>. The machine will move to the change location. You now install the tool.
- Zero the installed tool on the workpiece.
- Move to a safe Z location.

You can now run your CAM file.

**After the gcode file is complete.**

- If you have more to do with the current workpiece
  - You should be able to run a new gcode file
  - If the new file uses a new tool, it will move to the change location for you to install the tool. After you install the new tool, send the [cycle start command character "~"](http://wiki.fluidnc.com/en/features/serial_terminals#immediate-characters)  or push a [cycle start control switch](http://wiki.fluidnc.com/en/config/control) if you have defined one, to resume the file.
- If you are going to use a new workpiece (even with the same gcode file)
  - The previous work zeros are probably no longer valid. 
  - You must send M6T0 to reset all of the saved values.
  - Start the "typical workflow" shown above from the beginning.
  
# CAM Program Post Processor Notes

Your post processor and resulting gcode is responsible for this.

- Retract from the material before the M6 command
- Turn on the spindle and set the speed after returning from the tool change

# Using an automatic touch probe and a tool setter.

![auto_probe.png](/hardware/probes/auto_probe.png =x200)

To use an automatic touch probe give it a tool number just like any other tool. You zero with the touch probe. All cutting tools must use other tool numbers. 

- Install the touch probe.
- Send **M61Q1** (or whatever tool you have assigned to the probe, if it is not 1)
- Use the probe to zero the workpiece.
- Send **M6T2** (or whatever is the first tool of your job)
- Install the first tool
- Run your gcode job.

> This only works if the touch probe and tool setter are compatible. If one or both are spring loaded, when the probe touches the tool setter, the tool setter must send the signal before the touch probe moves at all.
{.is-warning}

