---
title: Macros
description: 
published: true
date: 2026-08-01T19:33:20.259Z
tags: en
editor: markdown
dateCreated: 2022-07-21T19:13:11.811Z
---

# Macros

"Macro" is a general name for a short series of gcodes and commands. There are many different ways to define and store macros and the precise behavior depends on which programs are managing them.  At a fundamental level, there is little difference between a general macro and a GCode program.  Both are just sequences of commands that are stored somewhere and executed based on some user input. The difference is mainly intent; a GCode program is typically focused on making something, whereas a macro is typically focused on a small administrative task that is not associated with making a specific part.

This page is mainly concerned with "config file macros" - very short command sequences defined in your config file.  The execution of config file macros is triggered by controller buttons, certain events like "startup" or "after homing", and during the execution of the M6 command.

Most user interface programs also have their own ways to define and invoke macros.  For example, [WebUI](http://wiki.fluidnc.com/en/features/webui#macros) lets you define macros whose text is stored in files, either on the local FLASH filesystem or in SD Card file. [pendants](http://wiki.fluidnc.com/en/hardware/pendants_displays) usually have ways to invoke those WebUI macros.  Many [gcode senders](http://wiki.fluidnc.com/en/support/gcode_senders) have their own macro facilities, often storing the macro text in files on the host system. See the documentation on those for help with that.

## Config file macro syntax

Config file macros must fit entirely on one line of the config file, which limits the total number of characters.  They can contain more than one GCode command or $ command, separated by the "&" command (but subject to the total line length).
**Separating GCode commands with "&" only works for config file macros; it is not a general GCode feature and does not work with macros managed by user interfaces like WebUI, senders, and pendants.**

If you need to do more than will fit on one line, you can store a longer sequence of commands in a file (on separate lines, not with "&" separators), and invoke that with `$SD/Run=filename` in the config file macro line.

## Example Macro

- **G90&G53G0Z-1&G0X0Y0** This moves the Z to machine space -1 (usually near the top) and then move to workspace X0 Y0

## Using commands and settings in macros

Macros are generally intended for use with gcode. Some $ commands can be used in macros, but you need to be careful when mixing it with gcode. $ commands typically require an Idle state. Otherwise, they will be rejected.

If you want to execute a $ command after a gcode command, it is best to add a short delay (G4) to ensure that motion completes before the next command is executed.

Some commands cannot be used in macros. These are typically things that change the configuration of FluidNC

## Using Realtime commands in macros

Realtime characters are single byte commands the FluidNC typically processed immediately. They are typically non-ASCII printable characters, so there is a special method to include them in macros.

Send the ***#*** character, then the 2-letter abbreviation for the command. Below is the list.

```
    "fr" Feedrate Override Reset
    "f>" Feedrate override Coarse Increase
    "f<" Feedrate override Coarse Decrease
    "f+" Feedrate override Fine Increase
    "f-" Feedrate override Fine Decrease
    "rr" Rapid Override Reset
    "rm" Rapid Override Medium
    "rl" Rapid Override Low
    "rx" Rapid Override Extra Low
    "sr" Spindle Override Reset
    "s>" Spindle Override Coarse Plus
    "s<" Spindle Override Coarse Minus
    "s+" Spindle Override Fine Plus
    "s-" Spindle Override Fine Minus
    "ss" Spindle Override Stop
    "ft" Flood coolant Toggle
    "mt" Mist coolant Toggle
```

## Using Parameters and Expressions in Gcode

Gcode can also be used as a simple programming language via [parameters and expressions](/features/gcode_parameters_expressions).  This will usually require storing the commands in a file due to the line length limit.

## Config Items

<!-- config-item path="macros.startup_line0" -->
### startup_line0
- **Type:** Macro
- **Default:** `""` (empty)

Legacy Grbl feature (formerly $N0). Runs once, the first time the firmware enters Idle after boot.
<!-- /config-item -->

<!-- config-item path="macros.startup_line1" -->
### startup_line1
- **Type:** Macro
- **Default:** `""` (empty)

Legacy Grbl feature (formerly $N1). Runs once, the first time the firmware enters Idle after boot, immediately after startup_line0.
<!-- /config-item -->

<!-- config-item path="macros.macro0" -->
### macro0
- **Type:** Macro
- **Default:** `""` (empty)

Runs when the associated [control switch](/config/control#macro0_pin) is activated. These switches must not be in the active state at startup. You need to deactivate the switch before you clear the alarm.
<!-- /config-item -->

<!-- config-item path="macros.macro1" -->
### macro1
- **Type:** Macro
- **Default:** `""` (empty)

Runs when the associated [control switch](/config/control#macro1_pin) is activated.
<!-- /config-item -->

<!-- config-item path="macros.macro2" -->
### macro2
- **Type:** Macro
- **Default:** `""` (empty)

Runs when the associated [control switch](/config/control#macro2_pin) is activated.
<!-- /config-item -->

<!-- config-item path="macros.macro3" -->
### macro3
- **Type:** Macro
- **Default:** `""` (empty)

Runs when the associated [control switch](/config/control#macro3_pin) is activated.
<!-- /config-item -->

<!-- config-item path="macros.after_homing" -->
### after_homing
- **Type:** Macro
- **Default:** `""` (empty)

Runs after a homing cycle completes -- i.e. once every axis with homing enabled has been homed. (as of v3.7.6)
<!-- /config-item -->

<!-- config-item path="macros.after_reset" -->
### after_reset
- **Type:** Macro
- **Default:** `""` (empty)

Runs after the system resets (power-on/startup, or a Ctrl-X real-time reset), but only if the system ends up in Idle state immediately after the reset. (as of v3.7.6)
<!-- /config-item -->

<!-- config-item path="macros.after_unlock" -->
### after_unlock
- **Type:** Macro
- **Default:** `""` (empty)

Runs after a $X unlock command. (as of v3.7.6)
<!-- /config-item -->

### Config Example

```yaml
macros:
  startup_line0:
  startup_line1:
  macro0: G90&G53G0Z-1&G0X0Y0
  macro1: $SD/Run=drill.nc
  macro2: 
  macro3: 
  after_homing: g0 x1 y1
  after_reset: g20
  after_unlock: g91
```

## M6 Macro

The M6 tool change command can trigger a config file macro to perform a user-specified sequence to implement a tool change procedure. These are configured in the spindle [config sections](http://wiki.fluidnc.com/en/config/config_spindles#m6_macro).

## Run via command

Send `$Macros/Run=<macro number>` or `$RM=<macro number>` like `$Macros/Run=0` or `$RM=0`. [See the commands page](http://wiki.fluidnc.com/en/features/commands_and_settings#macros_run).  Unnumbered macros cannot be run from a command, except by triggering the associated event (e.g. you could send `$x` to run `after_unlock`).

## Run via Switch

Setup a `macro<switch>_pin:` in the [control section](http://wiki.fluidnc.com/en/config/control).

