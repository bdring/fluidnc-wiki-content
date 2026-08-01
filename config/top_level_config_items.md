---
title: Top Level Config Items
description: 
published: true
date: 2026-08-01T19:34:06.015Z
tags: 
editor: markdown
dateCreated: 2022-07-21T16:55:09.207Z
---

# FluidNC Top Level Keys

These are keys (not section names) at the top (not indented) level. It does not matter where you put them. When output from the firmware they may not be grouped together.

<!-- config-item path="(top-level machine items).board" -->
### board
- **Type:** [String](/config/overview#string)
- **Range:** 0 to 255 characters
- **Default:** `"None"`

Descriptive text such as "ESP32 Dev Controller V4".
<!-- /config-item -->

<!-- config-item path="(top-level machine items).name" -->
### name
- **Type:** [String](/config/overview#string)
- **Range:** 0 to 255 characters
- **Default:** `"None"`

A basic description of the machine such as "Router XYYZ 10V Spindle"
<!-- /config-item -->

<!-- config-item path="(top-level machine items).meta" -->
### meta
- **Type:** [String](/config/overview#string)
- **Range:** 0 to 255 characters
- **Default:** `""` (empty)

This is used to store information about the config file such as "B. Dring 2022-03-15 Rev 2"
<!-- /config-item -->

<!-- config-item path="(top-level machine items).arc_tolerance_mm" -->
### arc_tolerance_mm
- **Type:** [Float](/config/overview#float)
- **Range:** 0.001 to 1.0
- **Default:** `0.002`

FluidNC converts arcs into tiny line segments representing the arc. This value determines how closely the segments represent the arc. This value is rarely changed by the user.
<!-- /config-item -->

<!-- config-item path="(top-level machine items).junction_deviation_mm" -->
### junction_deviation_mm
- **Type:** [Float](/config/overview#float)
- **Range:** 0.01 to 1.0
- **Default:** `0.01`

Junction deviation is used by the planner to calculate cornering speeds. This is generally not adjusted by the user. Read the firmware source code for a full description.
<!-- /config-item -->

<!-- config-item path="(top-level machine items).verbose_errors" -->
### verbose_errors
- **Type:** [Boolean](/config/overview#boolean)
- **Default:** `true`

Prints an error string with each error code. This might not be compatible with some gcode senders.
<!-- /config-item -->

<!-- config-item path="(top-level machine items).report_inches" -->
### report_inches
- **Type:** [Boolean](/config/overview#boolean)
- **Default:** `false`

Set to true for inches and false for millimeters. This is only for reporting and not input values.
<!-- /config-item -->

<!-- config-item path="(top-level machine items).enable_parking_override_control" -->
### enable_parking_override_control
- **Type:** [Boolean](/config/overview#boolean)
- **Default:** `false`

This allows you to override the parking feature via gcode. When true M56 P0 disables parking and M56 P1 enables it.
<!-- /config-item -->

<!-- config-item path="(top-level machine items).use_line_numbers" -->
### use_line_numbers
- **Type:** [Boolean](/config/overview#boolean)
- **Default:** `false`

Allow FluidNC to use line numbers in gcode. To use line numbers, set this to true. Put line numbers in the gcode with N\<line number\>, like N100. The line number that is currently being executed by the motion planner will be displayed in the status reports with Ln:100. If there is no line number information in the gcode, it will report Ln:0.
<!-- /config-item -->

<!-- config-item path="(top-level machine items).planner_blocks" -->
### planner_blocks
- **Type:** [Integer](/config/overview#integer)
- **Range:** 10 to 120
- **Default:** `16`

This sets the number of blocks used in the planner. You should leave it at the default unless you are tuning for a special application.
<!-- /config-item -->

## Config Example
```yaml
board: ESP32 Dev Controller V4
name: ESP32 Dev Controller V4
meta: B. Dring 2022-03-15 Rev 2

arc_tolerance_mm: 0.002
junction_deviation_mm: 0.010
verbose_errors: false
report_inches: false
enable_parking_override_control: false
use_line_numbers: false
planner_blocks: 16
```
