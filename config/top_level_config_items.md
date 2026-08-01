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

- <a id="board">**board:**</a>
  - Type: [String](/config/overview#string)  
  - Range: 80 Characters
  - Default: Empty String  
  - Interactions: None  
  - Details: Descriptive text such as "ESP32 Dev Controller V4".
- <a id="name">**name:**</a>
  - Type: [String](/config/overview#string)
  - Range: 80 Characters  
  - Default: Empty String  
  - Interactions: None
  - Details: A basic description of the machine such as "Router XYYZ 10V Spindle"
- <a id="meta">**meta:**</a>
  - Type: [String](/config/overview#string)  
  - Range: 80 Characters  
  - Default: Empty String  
  - Interactions: None
  - Details: This is used to store information about the config file such as "B. Dring 2022-03-15 Rev 2"
- <a id="arc_tolerance_mm">**arc_tolerance_mm:** </a>
  - Type: [Float](/config/overview#float)
  - Range: 0.001 to 1.0 
  - Default: 0.002
  - Interactions: None
  - Details: FluidNC converts arcs into tiny line segments representing the arc. This value determines how closely the segments represent the arc. This value is rarely changed by the user.

- <a id="junction_deviation_mm">**junction_deviation_mm:** </a>
  - Type: [Float](/config/overview#float) 
  - Range: 0.01 to 1.0
  - Default: 0.01
  - Interactions: None
  - Details: Junction deviation is used by the planner to calculate cornering speeds. This is generally not adjusted by the user. Read the firmware source code for a full description.

- <a id="verbose_errors">**verbose_errors:** </a>
  - Type: [Boolean](/config/overview#boolean)
  - Default: false
  - Details: Prints an error string with each error code. This might not be compatible with some gcode senders.

- <a id="report_inches">**report_inches:**</a>
  - Type: [Boolean](/config/overview#boolean)
  - Default: false
  - Details: Set to true for inches and false for millimeters. This is only for reporting and not input values.

- <a id="enable_parking_override_control">**enable_parking_override_control:**</a>
  - Type: [Boolean](/config/overview#boolean)
  - Default: false
  - Details: This allows you to override the parking feature via gcode. When true M56 P0 disables parking and M56 P1 enables it.

- <a id="use_line_numbers">**use_line_numbers:** </a>
  - Type: [Boolean](/config/overview#boolean)
  - Default: false
  - Details: Allow FluidNC to use line numbers in gcode. To use line numbers, set this to true. Put line numbers in the gcode with N\<line number\>, like N100. The line number that is currently being executed by the motion planner will be displayed in the status reports with Ln:100. If there is no line number information in the gcode, it will report Ln:0.

- <a id="planner_blocks">**planner_blocks:** </a>
  - Type: [Integer](/config/overview#integer)
  - Range: 10 - 120
  - Default: 16
  - Details: This sets the number of blocks used in the planner. You should leave it at the default unless you are tuning for a special application.



## Example
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