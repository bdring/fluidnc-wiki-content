---
title: Supported Gcodes
description: 
published: true
date: 2026-09-05T21:46:26.956Z
tags: 
editor: markdown
dateCreated: 2022-07-31T14:26:24.935Z
---

# Overview

Our GCode is strongly based on [LinuxCNC](http://linuxcnc.org/docs/stable/html/) ([G](https://linuxcnc.org/docs/2.8/html/gcode/g-code.html) and [M](https://linuxcnc.org/docs/2.8/html/gcode/m-code.html) codes). If you are thinking about suggesting a new command, look to see what LinuxCNC does. Saying "...like Marlin" will get you nowhere.

> Fun fact: G generally refers to Geometery/Motion commands and M refers to Machine specific commands, like spindles and coolant.
{.is-info}


It is very close to the [RS274NGC Interpreter](https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=823374) definition of the codes.

Some [gcode parameters and expressions](http://wiki.fluidnc.com/en/features/gcode_parameters_expressions) are supported.

# Comments

You can place comments in gcode using two methods.

## Semicolon

Anything after a semicolon will be considered a comment and ignored by the gcode parser.

```gcode
G0 G53 Z-1 ;move to top of Z
```

## Parentheses 

Anything within parentheses will be considered a comment and ignored by the gcode parser. This can be between gcode commands.,

```gcode
M3 (Spindle CCW) S1000 (Speed 1000)
```

If the comment has 'MSG ' in it, it will echo the comment back to the console in the `[MSG:INFO: GCode Comment...My Message]` format. It will strip the `MSG` and the following character (typically a space) from your comment.

```gcode
M3 (MSG Spindle CCW) S1000 (MSG Speed 1000)
```

Response

```
[MSG:INFO: GCode Comment...Spindle CCW]
[MSG:INFO: GCode Comment...Speed 1000]
```

## Synchronized vs. Unsynchronized Commands.

The planner tries to maintain accurate, fast and smooth motion. It does this by loading multiple motion commands and combining them. It will not accelerate and decelerate between all motion commands. The simplest example is straight motion. 
This snippet contains 2 separate move commands, but it will combine then into one smooth move to X200

```gcode
G1 F100 X100
X200
```

If the motion commands create an angle, the planner will insert the minimum amount of decel/accel into the corner that it needs to maintain its accuracy (junction_deviation_mm:)

Unsynchronized commands are things like spindle commands or delays. The same code as above with a tiny delay will cause the machine to stop between the moves.

```gcode
G1 F100 X100
G4 P0.5 ;delay 0.5 seconds
X200
```

> This can affect when line comments are displayed by FluidNC. They are displayed when they are read into the planner. This means you will likely see comments displayed early when motion commands are being combined.
{.is-info}


# Parameters

## XYZABC

Machine axes XYZ are linear and affected by the G20/G21 unit mode. ABC are rotational and not affected by G20/21. You can use them as linear if you use millimeters.

## IJK

Arc Parameters

## E

Output pin number with M67 

## L

Parameter for G10

## N

Line number. Optionally a line number can be used with each gcode line.

```Gcode
N100 G0 Z23.4
```

## P

  - Dwell time with G4
  - Used to indicate coordinate system with G10

## Q

  - Used to indicate analog level with M67


## T Tool Number

This is used with the M6 command. It is used to change the current tool number. With FluidNC it can also be used to change the spindle if multiple spindles are used.

# Gcode Words

## S Spindle Speed

Used to set spindle speed or laser power. It can be used by itself on a line or with other gcodes. The value is modal and remains in effect until changed. The unit is traditionally RPM, but is also used for laser power level in FluidNC.

```gcode
S12000 ;set speed to 1000
M3 ;run spindle CW. It uses speed 12000
M5 ;turn of spindle
M3 S2000 ;turn on spindle CW with speed 2000

```

> When speed is set to 0 you can optionally disable your spindle. See the spindle config documentation. 
{.is-info}

The S-word value can also be a :-separated sequence of numbers according to [GCode Clustering](/en/features/gcode-clustering) (first implemented in release v4.1.0).  That is useful for laser rasters that need to change the power setting rapidly. 

## F Feed Rate

  - Used to set the feed rate per the current units.

```gcode
F1000 ; set feed rate to 1000
G1 X20 ;move to x20 at 1000
G1 X0 F3000 ;move to 0x0 at 3000
```

>  At startup feed rate is 0. You will get an error if you try to use a motion command like G1, G2, G3, etc. if you do not have a feed rate above 0.
{.is-warning}


## T Tool Number

Prepare to change to tool number. When the M6 command comes the actual tool will be changed. It can be used on its own line or with M6. Standard FluidNC uses tool numbers for multiple spindles. It is the way to change to another spindle.

> Actual ATCs must be implemented by adding code to the firmware. This is a very advanced topic and only limited help can be given.
{.is-warning}


```gcode
M6 T2 ;change to tool 2 now
T7 ;prepare to change to tool 7
M6 ; change to tool 7
```

## G0 Rapid Motion

Rapid motion. Move will occur at the maximum feed rate possible. Multiple axis motion is coordinated, so the actual rate in the resulting direction may be more or less than any specific axis. 

Note: Some spindles, like lasers may disable during this move

## G1 Motion at Feed Rate

Motion at current feed rate. It will use the current feed rate (F value). This can come from a previous value specified or on the same line that the G1 is on. If no F value has been received, you will get an error. 

Example

```
F100 (set the feed rate)
G1 X5.5 (move to X5.5 at 100)
G1 X0 F500 (move to X0 at 500)
X1.5 (Move to X1.5 at 500. It uses the current modal G1 and F values)
```

## G2 (clockwise), G3 (counter clockwise) Arc or Helical Move at Feed Rate

### Center Format Arcs

This is the most common form. It uses a `G2 or G3 <center...> <offsets...> <turns>` format.

It creates an arc move from the current location to the point determined by the offsets using the provided center. The x offset is `I` and y offset is `J`. If you provide a Z value it will create a helix move. Add a `P` parameter for the number of turns.

```
G0 X0 Y0
F500
G02 X10 Y10 I0 J10
```

This creates a clockwise move from (0,0) to (0,10) with the center at X10, Y10.

> If is impossible to fit an arc to the points provided, you will get an `error:33
[MSG:ERR: Gcode invalid target]`
{.is-warning}

If you want to create an arc in the XZ or YZ plane you must do a G18 or G19 plane select.

Hand coding arcs is complicated. If you want more information do an internet search.

### Radius Format Arcs

## G4 Dwell

  - `Pn.n` This is the delay in seconds.

```
G4 Px.x
```


> It is a synchronized command. This means all buffered gcode is completed before the dwell starts.
{.is-info}




## G10 Set Coordinate System Offset

```
G10 Lx Px axes
```

- `L2` This sets the work coordinate offset to the value of axes
- `L20` This sets the work coordinate in the specified system number to the value of the axes

- `Pn` This specifies the coordinate system to change. P0 is used to change the current G54-G59 system. P1 through P6 selects G54 through G59

```gcode
G10 L2 P0 X0 ; change the X offset in the current coordinate system to 0
G10 L20 P1 X0 ; set the X work coordinate value in G54 to 0
```

You see all saved values with the `$#` command.

## G17, G18, G19 Plane Select

Arcs only work on 2D planes. The default is the XY plane. If you want an arc on an alternate 2D plane, you must select that plane first.

- `G17` XY (default)
- `G18` ZX
- `G19` YZ

Linear moves ignore G18 or G19 modes and work the same as G17.

## G20, G21 Units

This sets the units. The native units of FluidNC are millimeters. It will start in millimeters. If it sees a G20, it will start converting the axis and speed values into millimeters. It only does this for axes X, Y, and Z. The A, B, and C axes are considered rotary and unitless. No conversion will be used for these.

Config values are never converted.

- `G20` - Use inches for length and speed values
- `G21` - Use millimeters for length and speed values



## G28 Predefined Position

G28 is a machine coordinate location stored in non volatile memory. It will go to the same location regardless of the coordinate system or G92 offsets. You can view the current setting via the `$#` command.

- `G28` This does a rapid move to the location. 
- `G28 axes` If you specify axis values it will first do a rapid move to that location in your current work coordinate system. Then it will do a rapid to the stored G28 location. It will only move on axes specified. 
  - `G28 Z10` will move to work Z10 then move to the Z location stored in G28. No motion on X or Y.
  - `G28 X10 Y20` will move to work X10 Y20 then to the G28 location for X and Y. There will be no motion on Z or any other axes you have defined.
  - `G28 G91 X0` This is a way to move only to the X stored in G28. G91 X0 is a relative move of 0 so there will be no move before the G28 move.  Again, only the X axis will move. **Note:** You will remain in G91 after the move. If you were in G90 before the move, you may want to send a G90 to return to that mode.
- `G28.1` Use this to set the G28 offset to the current location in machine coordinates. 


```
<Idle|MPos:0.000,-10.000,-30.000|FS:0,0|Ov:100,100,100>
G28.1
ok
$#
[G54:0.000,-150.000,0.000]
[G55:0.000,0.000,0.000]
[G56:0.000,0.000,-30.000]
[G57:0.000,0.000,0.000]
[G58:0.000,0.000,0.000]
[G59:0.000,0.000,0.000]
[G59.1:3.000,0.000,0.000]
[G59.2:0.000,0.000,0.000]
[G59.3:0.000,0.000,0.000]
[G28:0.000,-10.000,-30.000]
[G30:5.000,-5.000,-1.000]
[G92:0.000,0.000,0.000]
[TLO:0.000]
ok
```

> You should only use G28 after you have fully homed a machine. It needs an accurate machine position or it will move to inaccurate locations. 
{.is-warning}

> Many people set G28 to the home position. After homing, send G28.1 to set G28 to the homed position. You can then send G28 to go to that position.
{.is-info}



## G30 Predefined Position

This is the same as G28, but uses 30 instead of 28.

## G38 Probing

```gcode
G38.n axes Pnn.nnn
```
 - Standards compliant
   - `G38.2` Probe towards the workpiece. Stop on contact. Error on failure.
   - `G38.3` Same G38.2, but no error on failure.
   - `G38.4` Probe away from the workpiece. Stop on loss of contact. Error on failure.
   - `G38.5` Same as G38.4, but no error on failure.
 - (since v3.7.6) FluidNC Only (same as above except always incremental and in millimeters) this does not change the current G20/G21 or G90/G91 state 
   - `G38.6` like G38.2
   - `G38.7` like G38.3
   - `G38.8` like G38.4
   - `G38.9` like G38.5

The move will use the existing feed rate and distance mode (for G38.2-G38.5) if none is provided

The P parameter is optional. It is used to set the work location of the Z with the P parameter being the offset from a plate etc. Use this to set your touch plate thickness (ideally measured with a micrometer). The G43 tool length offsets and G92 system coordinate offsets are accounted for when using the P parameter.

> You will get an error if the probe is touching before the probe command on G38.2 and G38.3. You will get an error if the probe is not touching before the command on G38.4 and G38.5
{.is-info}

   

```gcode
G91 G38.2 Z-20.0 F80.0 ;probe an absolute amount of -20 in Z with a feedrate of 80 until probe is triggered, then set the probe location to 0. (Maximum travel is 20.)
```

```gcode
G53 G38.2 Z-40 F80 ;probe to a machine position of Z-40 with a feedrate of 80 until probe is triggered, then set the probe location to 0. (Maximum travel is 40.)
```

```gcode
G38.2 Z-40 F80 P4.985 ;probe to a work position of Z-40 with a feedrate of 80 until probe is triggered, then set the probe location to 4.985 (the thickness of your touch plate). (Maximum travel is 40.)
```

## G40 Cutter Compensation Off

## G43.1 Dynamic Tool Length Offset

```gcode
G43.1 axes
```

This command is used to adjust for different length tools. It creates an offset from the current coordinate system. It does not create any motion. If your work Z value is 1.00 and you send `G43.1 Z0.250`, the work Z value will now be 1.25.

You can see the current value with the `$#` command.

```
[G54:0.000,0.000,0.000]
...
[G92:0.000,0.000,0.000]
[TLO:0.000]
[PRB:0.000,0.000,0.000:0]
```

> We do not support the `G43 H<tool number>` format. FluidNC does not store a table of tool offset values.
{.is-info}


## G49 Cancel Tool Length Offset

Resets the TLO to 0's.

```gcode
G49
ok
$#
...
[TLO:0.000]
ok

```

## G53 Use Machine Coordinates

Format

```gcode
G53 axes
```

This moves to a specific point in machine coordinates. G53 does not consider G90/G91, because it moves to an absolute machine position. G53 coordinates are the coordinates reported as MPos with the `?` status command in `$10=1` reporting mode. G53 mode is only active for the line it is on (not modal). The selected coordinate system (G54, etc) never changes.

***Examples:***

```gcode
G0 G53 Z-1 (move to Z-1 in MPos)
G53 X20 (G0 move to Mpos X20)
```

## G54 through G59 &  G59.1, G59.2 and G59.3 Select Coordinate System

This is used to set the current coordinate system. Coordinate systems store work coordinate system offsets. This allows you to set 6 different work offsets. The system always starts in G54. You set the value of the offsets with the G10 command. The offsets are stored in non volatile memory and are automatically restored at startup. You can read the offset values with the `$#` command. 


***Examples:***

```
G54
G10 L2 P1 Y5
$#
(response)
[G54:0.000,5.000,0.000]
[G55:0.000,0.000,0.000]
[G56:0.000,0.000,0.000]
[G57:0.000,0.000,0.000]
[G58:0.000,0.000,0.000]
[G59:0.000,0.000,0.000]
[G59.1:3.000,0.000,0.000]
[G59.2:0.000,0.000,0.000]
[G59.3:0.000,0.000,0.000]
[G28:0.000,0.000,0.000]
[G30:0.000,0.000,0.000]
[G92:0.000,0.000,0.000]
[TLO:0.000]
```
## G90, G91 Distance Mode

- G90 - Absolute distance mode. The axis values are used as locations. The move will go to the location specified in the current G54-G59 coordinate system or G53 when specified.
- G91 - Incremental distance mode. The axis values are used as distances to move.

***G90 Example:***

```gcode
G90 ;(set absolute mode)
G0 X10.5 ;(move to X10.5 including any G54-G59 and G92 offsets)
```

```gcode
G91 ;(set incremental mode)
G0 X-10.5 ;(move -10.5 in on the X axis)
```

## G92 Coordinate System Offset

```gcode
G92 axes
```

G92 makes the current work position have the desired location specified. It creates an additional offset from the current [G54-G59](http://wiki.fluidnc.com/en/features/supported_gcodes#g54-through-g59-select-coordinate-system) to achieve this. The value of the offset can be read with the `$#` command. The offset is volatile and will be lost at reboot.

This should only be used by advanced users. Many newbies use it as a simple way to set a work 0. The desired effect is lost if the system restarts, you change to a different [G54-G59](http://wiki.fluidnc.com/en/features/supported_gcodes#g54-through-g59-select-coordinate-system) system or the current G54-G59 offset is changed.  Most people should use [G10](http://wiki.fluidnc.com/en/features/supported_gcodes#g10-set-coordinate-system-offset). Most gcode senders will use [G10](http://wiki.fluidnc.com/en/features/supported_gcodes#g10-set-coordinate-system-offset).

For example: If you are using `G92 X0 Y0 Z0` the equivalent would be `G10 L20 P0 X0 Y0 Z0` 

It is left over from the hand coding days. If you hand code a bunch of gcode for a part and want to cut a second part off to the side you can use the gcode to make the first part, then use G92 to offset over to the side and start a second part with the exact same gcode. You still need to use a G54 (etc) offset on the first part. Otherwise everything is lost after power off. If you are using G92 without using G10 before it you are suffering a bad case of RepRap poisoning.

Modern CAM does everything for you. If you want 2 parts, just copy the part in CAM.

G92 Does not affect soft limits. Soft limits work in machine space and are not affected by any offsets (G92, G54-G59)

## G93, G94 Feedrate Modes

G93 is Inverse Time Mode. In inverse time feed rate mode, an F word means the move should be completed in one divided by the F number minutes. For example, if the F number is 2.0, the move should be completed in half a minute.

When the inverse time feed rate mode is active, an F word must appear on every line which has a G1, G2, or G3 motion, and an F word on a line that does not have G1, G2, or G3 is ignored. Being in inverse time feed rate mode does not affect G0 (rapid move) motions.


```gcode
G93
ok
G1 X50 F10 ;move will take 1/10=0.6 minutes
ok
G1 X0 ;missing feedrate
error:22
$e=22  ;get the error text
22: Gcode undefined feed rate
ok
```

G94 (Default) is Units per Minute Mode. In units per minute feed mode, an F word is interpreted to mean the controlled point should move at a certain number of inches per minute, millimeters per minute, or degrees per minute, depending upon what length units are being used and which axis or axes are moving.


# Mcodes

## M0 Pause

This will put the machine into hold mode. You must send the resume (cycle start) command `~` or via a [control input](http://wiki.fluidnc.com/en/config/control#control) `cycle_start_pin:`

## M2, M30 Program End

These end the current job. They should only be used at the end of a gcode file. Use of them is not required. (also see the % character info near the bottom of this page) 

**Note:** Because they do the things listed below, it is probably a bad idea to use them in a macro or a file that is run from another file.

Both of these commands have the following effects:

- Origin offsets are set to the default (like G54).
- Selected plane is set to XY plane (like G17).
- Distance mode is set to absolute mode (like G90).
- Feed rate mode is set to units per minute (like G94).
- Feed and speed overrides are set to ON (like M48).
- Cutter compensation is turned off (like G40).
- The spindle is stopped (like M5).
- The current motion mode is set to feed (like G1).
- Coolant is turned off (like M9).

## M3 Spindle CW

Turn on the spindle in clockwise mode. With a laser, this is constant power mode

## M4 Spindle CCW

Turn on the spindle in counter-clockwise mode. With a laser, this is dynamic power mode

## M5 Spindle Stop

This disables the spindle. You can define what happens during disable via your spindle section of the config file.

## M6 Tool Change

```gcode
M6 T1
```

```gcode
T2 ; Tool #2 will be next
G0 X0 Y0
M6 ; now change to tool #2
```

This will change to tool T. You can specify the T number anywhere before the line with M6 or on the same line as M6.

> With FluidNC: If you have multiple spindles, this command can be used to change spindles. See the spindles section. 
{.is-info}


## M7, M7.1 Mist Coolant

Turn the mist coolant on. This is just a digital signal that can be used for any function (vacuum, etc).

M7.1 will turn mist coolant off.

> Standard gcode uses M9 to turn off coolant. M7.1 will work in FluidNC to turn off mist coolant. No M commands in the standard have a .\<number\>. This could cause confusion to people reading your gcode or gcode senders streaming your code. 
{.is-warning}


## M8. M8.1 Flood Coolant

Turn the flood coolant on. This is just a digital signal that can be used for any function (vacuum, etc).

M8.1 will turn mist flood off. (See M7.1 note above) 

## M9 Coolant Off

This turns both M7 and M8 off. See M7.1 and M8.1 for a way to turn them off individually.

## M61 Set Current Tool

- `M61 Qn` Changes to the tool in `Qn` without doing a tool change. This would be used if there is a tool installed without FluidNC knowing about it. It does not affect the TLO ([G43](http://wiki.fluidnc.com/en/features/supported_gcodes#g43-tool-length-offset)). You would need to set that separately.

## M62, M63, M64, M65 Digital Output

  - `M62 Pn` Turn on [digital output](http://wiki.fluidnc.com/en/config/user_outputs#digital) synchronized with motion. The P word specifies the digital output number.
  - `M63 Pn` Turn off [digital output](http://wiki.fluidnc.com/en/config/user_outputs#digital) synchronized with motion. The P word specifies the digital output number.
  - `M64 Pn` Turn on digital output immediately. The P word specifies the digital output number.
  - `M65 Pn` Turn off digital output immediately. The P word specifies the digital output number.

```gcode
M62 P0 ;turn on digital0_pin in your config file
M63 P0 ;turn it off.
```

> We recommend you avoid M64 and M65. These unsynchronized commands are unpredictable when they will occur.
{.is-info}

## M66 Read User Input

This is a partial implementation of the M66 LinuxCNC gcode. **Only the immediate mode 0 is supported**. Immediate mode is useful for conditional tests in gcode programming.

- **P**  specifies the digital input number from 0 to 7.
- **E**  specifies the analog input number from 0 to 3.
- **L**  specifies the wait mode type.
- **Q**  specifies the timeout in seconds for waiting. If the timeout is exceeded, the wait is interrupt, and the variable #5399 will be holding the value -1. The Q value is ignored if the L-word is zero (IMMEDIATE). A Q value of zero is an error if the L-word is non-zero.

Mode 0: IMMEDIATE - no waiting, returns immediately. The current value of the input is stored in parameter #5399

``` gcode
M66 P0 L0
ok
o100 if [#5399]
  G53G0Z-1 ; move to top of Z
o100 endif
```


## M67 Analog Output

This is used to set the PWM level of an [analog output](http://wiki.fluidnc.com/en/config/user_outputs#analog). It uses the following parameters. These are set up in the user output section of the config file.

  - `E` The the number of the output
  - `Q` The percentage of the duty cycle 0% - 100%

  ```GCode
  M67 E0 Q23.76
  ```

# Modal States and Modal Groups

There are certain gcode that set a persistent state, like G21 (metric mode). Once this commands occurs the rest of the gcode stays in G21 mode. If you send G1 X20, you are in G1 mode. From now on if you just send X20, it will assume G1.

You can put multiple commands on a single line of gcode as long as no two, or more, of the commands are in the same modal group. For example G20 (inch mode) and G21 (millimeter mode) both belong to the units group. You cannot put both G20 and G21 on the same line.

  - G Word Modes
    - Motion (Group 1) G0, G1, G2, G3, G38.2
    - Plane Selection (Group 2) G17, G18, G19
    - Distance Mode (Group 3) G90, G91
    - Arc IJK Distance Mode (Group 4)
    - Feed Rate Mode (Group 5) 
    - Unit Mode (Group 6) G20, G21
    - Coordinate System (Group 12) G54, G55, G56, G57, G58, G59
  - M Word Modes 
    - Stopping mode (Group 4) M0, M2, M30
    - Spindle (Group 7) M3, M4, M5
    - Coolant (Group 8) M7, M8, M9 (M7 and M8 can be active at the same time)
     
    
    

# Current Modal Status

Once you set a value in a modal group it stays in effect.

```gcode
G1 F100 X100
X200 ; we are still in G1 and F100
G0 ; switch to G0 mode
X100 ; move to X100 in G0 mode
G1 X200 ; switch to G1 mode and use existing speed of F100

```

You can see what modes are in effect with the `$G` command.

```
$G
OK
[GC:G0 G54 G17 G21 G90 G94 M0 M5 M9 T0 S0.0 F500.0]
```

# Best Practices

## Reset modal values

The first line of your gcode files should reset all of the modal values. You need to make sure things like G90/G91 are in the expected state or your gcode could behave unexpectedly. Here is an example line that returns several modal values to the FluidNC defaults.

```gcode
G0 G54 G17 G21 G90 G94
```

> If you create macros, you should also keep this in mind. You might want to return the modal values to defaults.
{.is-info}

# % Character support

FluidNC basically uses it just like LinuxCNC

- You can have a % at the beginning (does nothing)
- You can have one at the end (does nothing)
- You can one at the beginning and end 
- You cannot have one in between beginning and end of the file (ends the running file)
