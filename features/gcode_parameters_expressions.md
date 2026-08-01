---
title: GCode Parameters and Expression
description: 
published: true
date: 2026-08-01T19:35:54.646Z
tags: 
editor: markdown
dateCreated: 2024-06-03T18:30:08.565Z
---

# GCode Parameters and Expressions

Parameters and expressions allow you to use gocde as a programming language. It has a lot of limitations, but should be able to allow you to create more powerful macros and things like simple tool changers. It is based on [LinuxCNC](https://linuxcnc.org/docs/stable/html/gcode/overview.html#sec:overview-parameters) and [NIST RS274NGC](https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=823374) 

> Note: This is an advanced feature for advanced users. You should be an expert in gcode before you attempt using gcode parameters. Please consider become a project supporter before asking for support on this feature. 
{.is-info}


# Parameters

There are three kinds of syntactic appearance:

- numbered - #4711 ([see this list](http://wiki.fluidnc.com/en/features/gcode_parameters_expressions#numbered-parameters))
- user named local - #\<localvalue\>
- FluidNC named global - #\<_globalvalue\> and config values #</axes/x/max_rate_mm_per_min> ([See this list](http://wiki.fluidnc.com/en/features/gcode_parameters_expressions#named-local-parameters))

The value of a parameter is a floating point number.  A parameter reference can appear in GCode in place of any number.  So for example you could say
```
G0 X#<saved_x>
```
instead of
```
G0 X5
```

You cannot combine with numbers outside the expression.

```
#<_foo>=5
ok
G0 X#<_foo> ; this is correct
ok
G0 X2#<_foo> ; This is not allowed. You will not get G0 X25
[MSG:DBG: Missing =]
[MSG:ERR: Bad GCode: G0 X2#<_foo>]
error:2
[MSG:ERR: Bad GCode number format]
G0 X-#<_foo> ; This is not allowed. You will not get G0 X-5
[MSG:ERR: Bad GCode: G0 X-#<_foo>]
error:2
[MSG:ERR: Bad GCode number format]
```

## Setting Parameters

The value of a parameter can be assigned with =, as in
```gcode
#<myparam>=5
```
The new value can be a number, another parameter value, or an expression
```gcode
#<saved_wco_x>=#5221
```
You can put multiple assignments on one line
```gcode
#<saved_wco_x>=#5221 #<saved_wco_y>=#5222
```
You can put ordinary GCode on the same line with parameter assignments, but if you do so, the new parameter values will not take effect until **after** the GCode has been executed.  So if you say
```gcode
#<x>=4
#<x>=5 G0 X#<x>
```
the target of the G0 is X4, and the value of parameter `#<x>` will not change to 5 until after the `G0 X4` command has been issued.

You can set named global parameters.

```gcode
#<_feed>=1500
; or
#<my_feed>=1500      ; set a local parameter
#<_feed>=#<my_feed>  ; set the feed rate with a local paramter
```

## Numbered Parameters

These numbers come from the GCode standard and LinuxCNC. Not all are supported yet.

System defined numbered parameters are read only. The proper way to change them is via gcode. This will insure the change is properly synchronized with the motion.

[Reference](https://linuxcnc.org/docs/stable/html/gcode/overview.html#sub:numbered-parameters)

- **31-5000** - G-code user parameters. These parameters are global in the G code file, and available for general use. Volatile.
- **5061-5069** - Coordinates of a G38 probe result (X, Y, Z, A, B, C). **Currently it is always reported in machine coordinates.** The LinuxCNC spec says "Coordinates are in the coordinate system in which the G38 took place. Volatile." We are reviewing whether to change FluidNC. 
- **5070** - G38 probe result: 1 if success, 0 if probe failed to close. Used with G38.3 Volatile.
- **5161-5169** - "G28" Home for X, Y, Z, A, B, C. Persistent.
- **5181-5189** - "G30" Home for X, Y, Z, A, B, C. Persistent.
- **5211-5216** - "G92" offset for X, Y, Z, A, B, C. Volatile by default; persistent if DISABLE_G92_PERSISTENCE = 1 in the [RS274NGC] section of the INI file.
- **5220** - Coordinate System number 1 - 9 for G54 - G59.3. Persistent.
- **5221-5226** - Coordinate System 1, G54 for X, Y, Z, A, B, C Persistent.
- **5241-5246** - Coordinate System 2, G55 for X, Y, Z, A, B, C Persistent.
- **5261-5266** - Coordinate System 3, G56 for X, Y, Z, A, B, C Persistent.
- **5281-5286** - Coordinate System 4, G57 for X, Y, Z, A, B, C Persistent.
- **5301-5306** - Coordinate System 5, G58 for X, Y, Z, A, B, C Persistent.
- **5321-5326** - Coordinate System 6, G59 for X, Y, Z, A, B,  Persistent.
- **5399** The result of the most recent [M66](http://wiki.fluidnc.com/en/features/supported_gcodes#m66-read-user-input-in-development) command, Volatile
- **5400** - Tool Number. Volatile.
- **5401-5409** - Tool Offsets for X, Y, Z, A, B, C. **Only Z (5403) is supported in FluidNC**. Volatile.
- **5420-5425** - Current relative position in the active coordinate system including all offsets and in the current program units for X, Y, Z, A, B, C volatile.

Example

```
D#5400  ; Get current tool number
[MSG:INFO: Value is 2.000]
ok
#<my_tool_num>=#5400
ok
D#<my_tool_num>
[MSG:INFO: Value is 2.000]
ok

```

### Using math on parameter numbers.

You can use math expressions to calculate the numbered parameter you want

```
D#5422
[MSG:INFO: Value is 38.987]
ok
D#[5420+2]
[MSG:INFO: Value is 38.987]
ok
```

Say, for example, you want to know the current coordinate offset of the Z axis. You can get the current coordinate system with 5220. The values of the offsets start at #5221 and are 20 apart.

```
$#
[G54:48.000,-89.000,-44.577]
[G55:70.000,-10.000,-31.657]
...
[TLO:4.590]
ok
D#[5221 + [#5220 * 20] + 2]
[MSG:INFO: Value is -31.620]
ok
```


## Named Local Parameters

[More Information](https://linuxcnc.org/docs/stable/html/gcode/overview.html#gcode:named-parameters)

Local named parameters are ones whose names you choose, that do not begin with an underscore (_) character. They have "local scope", which means that they only exist within the context of a single file or macro. A local named parameter that is defined in one file is not visible within another file.  That means that you can use the same name within multiple files without conflict, even if one file invokes another.

```gcode
#<i>=123.4 (create a variable with the name i and give it a value of 123.4
```

## Named Global Parameters

If a parameter name begins with an underscore character (_), it has "global scope".  The same parameter can be set or read from any context, and the current value can be "seen" from anywhere.  Thus global parameters can be used to pass information between files.

You can define your own named global parameters, and there are also some system-defined global parameters that give information about the operation of FluidNC.

[More Information](https://linuxcnc.org/docs/stable/html/gcode/overview.html#gcode:predefined-named-parameters)
- Global current values like `#<_x>`
- Config File Items `#</axes/x/steps_per_mm>`

### System-defined global named parameters

System defined parameters are read only. The proper way to change them is via gcode. This will insure the change is properly synchronized with the motion.

#### _x, _y, _z, _a, _b, _c

These are the current work coordinates with all offset applied (i.e., MPos, $10=1 and G53) for the axes. They are  in the current unit as defined by G20 or G21.

#### _abs_x, _abs_y, _abs_z, _abs_a, _abs_b, _abs_c

These are the current machine coordinates (i.e., MPos, $10=1 and G53) for the axes. They are  in the current unit as defined by G20 or G21.

#### _spindle_on
#### _spindle_cw
#### _spindle_m
- This is not in LinuxCNC. Its value is either 3, 4, or 5 according to the current spindle state M3 (on clockwise), M4 (on counterclockwise), or M5 (off). It is useful when you want to turn off the spindle then later restore restore its previous state, as with this example
```gcode
#<s>=#<_spindle_m> (set local parameter s to the global parameter _spindle_m
M5  ( turn off spindle
... do something with the spindle off
M#<s> (Restore the spindle to its previous mode, like M3
```

#### _mist
#### _flood
#### _speed_override
#### _feed_override
#### _feed_hold
#### _feed

Returns the current value of F, not the actual feed rate.

#### _rpm
#### _current_tool and _selected_tool
  By gcode standard the gcode T value starts at 0, but the actual tool in unknown. FluidNC has the _current_tool parameter that starts at -1. 
  - You can use this to determine if the tool has ever been set by testing for -1
  - This value only changes with an M6, so if this value and the gcode T value are not the same, you probably received a T command with an M6 command.
  
  - _selected_tool is the current T value. Same #5400
  
```
Grbl 4.0 [FluidNC v4.0.2 (esp32-wifi) '$' for help]
D#<_current_tool>
[MSG:INFO: Value is -1.000]
ok
T2
ok
D#<_current_tool>
[MSG:INFO: Value is -1.000]
ok
D#<_selected_tool>
[MSG:INFO: Value is 2.000]
ok
```  
 
#### 


#### _vmajor
#### _vminor
#### _line
#### _motion_mode
  - Seek               = 00,   // G0 Default
  - Linear             = 10,   // G1
  - CwArc              = 20,   // G2
  - CcwArc             = 30,   // G3
  - ProbeToward        = 382,  // G38.2
  - ProbeTowardNoError = 383,  // G38.3
  - ProbeAway          = 384,  // G38.4
  - ProbeAwayNoError   = 385,  // G38.5
  - None               = 800,  // G80
#### _plane
  - XY = 170,  // G17
  - ZX = 180,  // G18
  - YZ = 190,  // G19
    
#### _coord_system
  - G54 = 540
  - G55 = 550
  - G56 = 560
  - G57 = 570
  - G58 = 580
  - G59 = 590
  
#### _metric
#### _imperial
#### _absolute (G90)
- Values: 0 or 1
#### _incremental (G91)
- Values: 0 or 1

Example: Save and restore the distance mode.

```gcode
#<my_incremental>=#<_incremental> ; save the distance mode
... do something that changes the distance mode, like perhaps G91
G[90+#<my_incremental>]           ; restore the distance mode
```
#### _inverse_time
#### _units_per_minute
#### _units_per_rev

## Displaying Parameter Values

The D word in GCode can be used show the value of a parameter, for debugging purposes.  The number (or parameter value, or expression result) follwing D will be displayed in an INFO message.

> D is a standard GCode word that is normally used for cutter diameter in the context of "Dynamic Cutter Compensation" - G41.1 and G42.1 - which FluidNC does not support.  We have abused D for this debugging use.  If FluidNC ever supports dynamic cutter compensation, the D word might be reassigned its standard meaning, so you should not use this debugging feature in production programs.  Use it only for exploration.
{.is-warning}
```gcode
#<s>=#<_spindle_m> (set local parameter s to the global parameter _spindle_m
D#<s> (Display the value of local parameter s
[MSG:INFO: Value is 5.000] 
```

There is also a <a name="PL"></a>`$Parameters/List command`. That can be used at the console or within a job, like a gcode file.

Here is an example of it being used in a gcode file.

Also see this about [formatted print messages](http://wiki.fluidnc.com/en/features/gcode_parameters_expressions#print-and-debug-messages).

```
$localfs/run=param1.nc
ok
Named Parameters
[MSG:INFO: _BOB = 2.000]
[MSG:INFO: Job depth 0 - Local Parameters]
[MSG:INFO: FRED = 1.000]
```

 - **_BOB** is a global parameter
 - **FRED** is a local parameter in the gcode file



## Expressions
[More Information](https://linuxcnc.org/docs/stable/html/gcode/overview.html#gcode:expressions)
Expressions let you perform computations on numbers and parameter values.  As with parameter references, they can appear in place of any GCode number.

#### ABS[arg]
Absolute value
#### ACOS[arg]
Inverse cosine
#### ASIN[arg]
Inverse sin
#### ATAN[arg]/[arg]
Four quadrant inverse tangent
#### COS[arg]
cosine
#### EXP[arg] 
e raised to the given power
#### FIX[arg] 
Round down to integer
#### FUP[arg] 
Round up to integer
#### LN[arg] 
Base-e logarithm
#### ROUND[arg] 
Round down to integer
#### SIN[arg]
sine
#### SQRT[arg]
Square root
#### TAN[arg]
#### EXISTS[arg] 
Return 1 if the parameter exists, 0 if not

```
#<foo>=5
ok
D[EXISTS[#<foo>]]
[MSG:INFO: Value is 1.000]
ok
```

> Note: SIN, COS, TAN, etc use degrees, not radians
{.is-info}


```gcode
G0 X[#<saved_x> + 5.3] F[#</axes/x/max_rate_mm_per_min * 0.5]
G0 Y[#<saved_y> * 0.9  + 1.2]
G0 A[SIN[30] * #<a_scale_factor>]
```
In the expressions - and in fact in all of GCode - spaces are ignored, so you can use them for readability or omit them, as you prefer.



## Flow Control

 

Flow control allows branching and looping in gcode. 

> Currently, this is only fully supported in gcode files stored on an SD card or the LocalFS. This is because FluidNC needs a way to move freely up and down through the file when branching and looping. This is not possible from a gcode sender or a console. 
{.is-warning}

### o codes
  

o (the letter, not the number) codes are used to define code blocks. Use matching numbers to define the code block. Based on the [LinuxCNC implementation](https://linuxcnc.org/docs/stable/html/gcode/o-code.html).

Numerical value of 0 is equivalent to logical false. Any nonzero value is considered to be logical true.

```
; check for probe success
o100 if [#5070]
  G53G0Z-1 ; move to top of Z
o100 endif
```

### Conditionals (if)

```
(if parameter #2 is greater than 5 set F100)
o102 if [#2 GT 5]
  F100
o102 elseif [#2 LT 2]
(else if parameter #2 is less than 2 set F200)
  F200
(else if parameter #2 is 2 through 5 set F150)
o102 else
  F150
o102 endif
```

### Looping

repeat example

```
#<_times>=4
o101 repeat[#<_times>]
  G91 G1 X5 F500
  (MSG: Repeat)
o101 endrepeat
```

while example:

```
G91
F500
#<_x> = 0
o101 while [#<_x> LT 10]
  G1 X5  
  #<_x> = [#<_x>+1]
o101 endwhile
```

do example 

```
G91
F500
#<_x> = 0
o102 do
  G1 X5  
  #<_x> = [#<-x>+1]
o102 while[#<_x> LT 5]]
```

Inside a while loop, **o\<num\> break** immediately exits the loop, and **O\<num\> continue** immediately skips to the next evaluation of the while condition. If it is still true, the loop begins again at the top. If it is false, it exits the loop.

### Alarms

If you want create your own alarm via macro logic, you can use the `$Alarm/Send-\<alarm_num>` [command](http://wiki.fluidnc.com/en/features/commands_and_settings#alarmsendalarm_num).

Alarm 3 (Abort during cycle) is a good one to use. Others like 13 (Hard stop) will assume loss of steps and require a full reset and home.


```
#<my_tool>=5
#<max_tool_num>=4
o101 if [#<my_tool> GT #<max_tool_num>]
$Alarm/Send=3
o101 endif
```


### Binary Operators

Listed in precedence order

| **Operator** | **Description** |   |
|---------------|-----------------|---|
| **            | Power           |   |
| *             | Multiply        |   |
| /             | Divide          |   |
| MOD           | Modulus         |   |
| +             | Add                |   |
| -             | Subtract                |   |
| EQ            | Equal                |   |
| NE            | Not equal                |   |
| GT            | Greater than                |   |
| GE            | Greater than or equal                |   |
| LT            | Less than                |   |
| LE            | Less than or equal                |   |
| AND           | And                |   |
| OR            | Or                |   |
| XOR           | Exclusive or      |   |


## Print and Debug Messages

[LinuxCNC reference](https://linuxcnc.org/docs/html/gcode/overview.html#gcode:debug).

This allows you to print messages from gcode with formatted parameters. There are 2 types

- (print, )
- (DEBUG, )

### Formatting

- %lf is default if there is no formatting string.
- %d = 0 decimals
- %f = four decimals
- %.xf = x (0-9) number of decimals

```
#<foo>=123.456789
ok
#<BAR>=54321
ok
(print,foo is #<foo>, bar is %d#<bar>, fooint is %d#<foo>, bar2 is %.2f#<bar>, foo4 is %f#<foo>)
[MSG:INFO: PRINT,foo is 123.456779 bar is 54321 fooint is 123 bar2 is 54321.00 foo4 is 123.4568]
ok
(debug,foo is #<foo>, bar is %d#<bar>, fooint is %d#<foo>, bar2 is %.2f#<bar>, foo4 is %f#<foo>)
[MSG:DBG: DEBUG,foo is 123.456779 bar is 54321 fooint is 123 bar2 is 54321.00 foo4 is 123.4568]
ok
```

```
G91
F500
#<_foo> = 0
o102 do
  G1 X5
  (print, foo=%d#<_foo>)
  #<_foo> = [#<_foo>+1]
o102 while[#<_foo> LT 5]]
```

## Scope, Context and Usage

Parameters and Flow Control are dependant on scope. There is a global scope (includes the console) and job scopes. Jobs are typically gcode files stored on the SD card or LocalFS.

Parameters that start with a leading underscore `#<_myparam>` are global in scope, They can be created, accessed and modified from any scope. Paramters without a leading underscore `#<myparam>` have a scope that is local to the job. This means you can have independent parameters with the same name in different scopes.

Flow control should only be used in job scopes. Gcode coming from the console or streamed from gcode senders is executed and forgotten. Looping will not work because the contents of the loop was never saved.

o\<numbers\> are local in scope. You can safely use the same number in multiple scopes.

  
# Examples

```gcode
; dual speed probe macro

; set parameters 
#<fast_rate>=160
#<slow_rate>=80
#<probe_dist>=100
#<probe_offset>=0
#<retract_height>=5

G38.2 G91 Z[-#<probe_dist>] F#<fast_rate> ; probe fast
G0 Z3  ; retract a little
G38.2 G91 Z[-#<probe_dist>] F#<slow_rate> P#<probe_offset> ; probe slowly
G0 Z[#<retract_height>+#<probe_offset>] ; retract
; be careful you are still in G91 mode
```

```gcode
; Get the range of the x axis from config values.

o100 if [#</axes/x/homing/positive_direction>]
  #<x_max>=#</axes/x/homing/mpos_mm>
  #<x_min>=#<x_max> - #</axes/x/max_travel_mm>
o100 else
  #<x_min>=#</axes/x/homing/mpos_mm>
  #<x_max>=[#<x_min> + #</axes/x/max_travel_mm>]
o100 endif
(print, X Range is %.2f#<x_min>, - %.2f#<x_max>)
```

 # Debugging Tips
 
 - If you have errors or are just starting out, try manually typing gcode into a serial console.  You will get instant feedback and errors message. We recommend [FluidTerm](http://wiki.fluidnc.com/en/fluidterm/fluidterm_usage) or the [Web Installer](https://installer.fluidnc.com/) terminal. Using a gcode sender could cause you to miss some of the messages or add extra commands.
 

 
 - Use the ["D" word](http://wiki.fluidnc.com/en/features/gcode_parameters_expressions#displaying-parameter-values) and/or [print features](http://wiki.fluidnc.com/en/features/gcode_parameters_expressions#print-and-debug-messages) to print values.
 - With macros, be careful to consider of the gcode modes like units, incremental/absolute motion, plane select, coordinate systems. In many cases you should restores these modes if they are changed in the macro. 
 - When asking for help, show a simple example of the problem from a console session. 
 
  ```
 #<_foo>=#5062
ok
D#<_foo>
[MSG:INFO: Value is -14.734]
D[#<_foo> + 10]
[MSG:INFO: Value is -4.734]
ok
 ```

