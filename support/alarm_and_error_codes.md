---
title: Alarm and Error Codes
description: 
published: true
date: 2026-08-01T19:38:30.549Z
tags: 
editor: markdown
dateCreated: 2022-09-17T12:24:10.206Z
---

# Error Codes

> You can get descriptions for the error codes using `$E` to see all the codes and `$E=<code number>` to get the text for a specific error number. 
{.is-info}


  - **0: No error**

  - **1: Expected GCodecommand letter**

  - **2: Bad GCode number format**

  - **3: Invalid $ statement**

  - **4: Negative value**

  - **5: Setting disabled**

  - **6: Step pulse too short**

  - **7: Failed to read settings**

  - **8: Command requires idle state**

  - **9: GCode cannot be executed in lock or alarm state**

  - **10: Soft limit error**

  - **11: Line too long**

  - **12: Max step rate exceeded** Your config value will exceed the max step rate. This could be caused by many factors, including speed, steps/mm and pulse lengths. See the [axes page](http://wiki.fluidnc.com/en/config/axes). 

  - **13: Check door**

  - **14: Startup line too long**

  - **15: Max travel exceeded during jog**

  - **16: Invalid jog command**

  - **17: Laser mode requires PWM output**

  - **18: No Homing/Cycle defined in settings**

  - **19: Single axis homing not allowed**

  - **20: Unsupported GCode command**

  - **21: Gcode modal group violation** See this on [modal groups](https://linuxcnc.org/docs/html/gcode/overview.html#_modal_groups)

  - **22: Gcode undefined feed rate** The gcode used requires a feed rate. You must have an F\<value\> on or before the line with the gcode.

  - **23: Gcode command value not integer**

  - **24: Gcode axis command conflict**

  - **25: Gcode word repeated**

  - **26: Gcode no axis words**

  - **27: Gcode invalid line number**

  - **28: Gcode value word missing** The gcode sent requires a specific parameter value. See the [supported gcodes page](http://wiki.fluidnc.com/en/features/supported_gcodes).

  - **29: Gcode unsupported coordinate system**

  - **30: Gcode G53 invalid motion mode**

  - **31: Gcode extra axis words**

  - **32: Gcode no axis words in plane**

  - **33: Gcode invalid target**

  - **34: Gcode arc radius error**

  - **35: Gcode no offsets in plane**

  - **36: Gcode unused words**

  - **37: Gcode G43 dynamic axis error**

  - **38: Gcode max value exceeded**

  - **39: P param max exceeded**

  - **40: Check control pins** (control pins cannot be active at startup)

  - 60: Failed to mount device

  - 61: Read failed

  - 62: Failed to open directory

  - 63: Directory not found

  - 64: File empty

  - 65: File not found

  - 66: Failed to open file

  - 67: Device is busy

  - 68: Failed to delete directory

  - 69: Failed to delete file

  - 70: Bluetooth failed to start

  - 71: WiFi failed to start

  - 80: Number out of range for setting

  - 81: Invalid value for setting

  - 82: Failed to create file

  - 90: Failed to send message

  - 100: Failed to store setting

  - 101: Failed to get setting status

  - 110: Authentication failed!

  - 111: End of line

  - 112: End of file

  - 120: Another interface is busy

  - 130: Jog Cancelled

  - 150: Bad Pin Specification

  - 152: Configuration is invalid. Check boot messages for ERR's.

  - 160: File Upload Failed

  - 161: File Download Failed

# Alarm Codes

> You can get descriptions for the error codes using `$A` to see all the codes and `$A=<code number>` to get the text for a specific error number. 
{.is-info}

This text was taken from `alarm_codes_en_US.csv` in the Github repo


  - **1: Hard limit** Hard limit has been triggered. You must send the reset command **0X18** or **ctrl+X** from the keyboard on FluidTerm. It may be a special button on your gcode sender. Machine position is likely lost due to sudden halt. Re-homing is highly recommended.
  - **2: Soft limit** Soft limit alarm. G-code motion target exceeds machine travel. Machine position retained. Alarm may be safely unlocked.
  - **3: Abort during cycle** Reset while in motion. Machine position is likely lost due to sudden halt. Re-homing is highly recommended.
  - <a id="alarm_4"></a>**4: Probe Fail Initial** Probe fail. Probe is not in the expected initial state before starting the probe cycle when G38.2 and G38.3 is not triggered and G38.4 and G38.5 is triggered.
  - <a id="alarm_5"></a>**5: Probe Fail Contact** Probe fail. Probe did not contact the workpiece within the programmed travel for G38.2 and G38.4
  - **6: Homing fail** Homing fail. The active homing cycle was reset.
  - **7: Homing fail** Homing fail. Safety door was opened during the homing cycle.
  - **8: Homing fail** Homing fail. Pull off travel failed to clear the limit switch. Try increasing the pull-off setting or check wiring.
  - **9: Homing fail** Homing fail. Could not find a limit switch within search distances. Try increasing max travel, decreasing pull-off distance, or check wiring.
  - **10: Spindle Control**
  - **11: Control Pin**
  - **12: Ambiguous Switch** There is a limit switch active, but FluidNC does not have enough info to clear the switch. [See this](http://wiki.fluidnc.com/en/support/help_with_switch_problems#ambiguous-limit-switch-messages).
  - **13: Hard Stop**
  - **<a id="Alarm14"></a>14: Unhomed** Your machine needs to be homed. See the [must_home item](http://wiki.fluidnc.com/en/config/start_group) in the config file. You home with [\$H](http://wiki.fluidnc.com/en/config/homing_and_limit_switches). You can clear the error with [\$Alarm/Disable or \$X](http://wiki.fluidnc.com/en/features/commands_and_settings#alarmdisable-or-x).
  - **15  Init**
