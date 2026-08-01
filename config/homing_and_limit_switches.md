---
title: Config Homing and Limit Switches
description: 
published: true
date: 2026-08-01T19:33:11.101Z
tags: 
editor: markdown
dateCreated: 2022-07-21T21:43:19.529Z
---

# FluidNC Limit Switch and Homing Setup

## Overview

The setup of the limit switches in FluidNC is very flexible. This allows it  to be both feature rich and allows for very low input pin count. It supports basic axes as well as ganged axes with or without squaring. Some keys are under the **[homing:](http://wiki.fluidnc.com/en/config/axes#homing)** group for the axis and some are under the **[motor<0 or 1>:](http://wiki.fluidnc.com/en/config/axes#motor-types)** group.

An IO pin can only be used once. You can use parallel or series wiring for multiple switches, but you can never assign the input to more than one item in your config file.

## Placing limit switches on an axis.

You can place limit switches at either or both the positive or negative ends of travel. The positive end of travel is the end you move towards when the axis location is increasing. If you move from X0 to X10, you are moving in the positive direction. 

Typically, the negative end of the X axis is on the left side, and the positive end is on the right side. The positive end of the Z axis is the top.

You can assign switches to the ends with these keywords.

```
limit_neg_pin:
limit_pos_pin:
limit_all_pin:
```

The `limit_all_pin:` is used when a switch will be placed at both ends but wired to one input pin. These switches would be wired in series or parallel depending on the switch type. If a `limit_all_pin:` is triggered, FluidNC will not know which end was touched. This is OK for all scenarios except if a switch is triggered before homing. It does not know which way to move to clear the switch. You must manually clear the switch before homing.

Typically, you can use...
 - a neg switch
 - a pos switch
 - a neg and a pos switch
 - an all switch

Typically, you do not use an all switch with other switches.

Each axis is independent, and you can choose the best arrangement for that axis.

## Soft and Hard Limits

These features control whether you can move the axis past its endpoints. You can use neither, either or both features.

Hard limits use switches to stop the motion when you activate a limit switch. Ideally you have switches at both ends. If it hits a switch, motion is immediately stopped, an alarm is given, and accurate position is assumed to be lost. You must rehome. Since this feature is controlled by switches this is defined at the same level as the switches. Hard limits alarms will not occur during homing.

Soft limits are determined by the range of motion. If you send a command that would send it beyond the range, it blocks that command. It does a safe stop and position is not lost. You should home the machine, so the machine accurately knows where it is. The soft limit range of each axis is shown in the startup messages. These values are in machine coordinates, not work coordinates. Most gcode uses work coordinates. If you are getting unexpected soft limit errors, check your work offsets.


```
[MSG:INFO: Axis X (0.000,300.000)]
```

## Testing

You can view the real time switch status in a test mode by sending the `$limits` command. The status of the switches will be displayed on the serial console. Activate switches and you should see it in the reporting.  It uses lower case for motor0 and upper case for motor1. If you activate a **[limit_all_pin:](http://wiki.fluidnc.com/en/config/axes#limit_all_pin)** switch, it will report for a positive and negative end. Send `!` to exit this mode and return to normal control mode.

The best way to test the switches is to slowly push and release each switch individually. Watch the status being displayed. Be sure to give time for each update of the display. You should see a change in the status when you push and release each switch.

It will look like this:

```
$limits
Homing Axes: xyz
Limit  Axes: xyz
  PosLimitPins NegLimitPins Probe
: x            x
: x     X
```
Here is one with explanations added:
```
$limits                            (The command to start the reporting)
Homing Axes: xyz                   (Your config file has a homing section for motors x, y & z)
Limit  Axes: xyz                   (Axes x,y & z have limit switch pins defined in the config file)
  PosLimitPins NegLimitPins Probe  (A header for the reporting below it)
:                                  (No switches are currently active)
: x            x                   (motor0 has a positive x and negative x switch active. Could be an all switch)
: x     X                          (motor0 and motor1 [upper case] have positive switches active)
:                                  (No switches active)
:                           P      (Probe Switch is active)
!                                  (The command to stop the recording)
```

## Axis Squaring

Axis squaring uses 2 homing switches to make sure the axis is squared during homing. It requires 2 motors and a separate switch input for each side. If it sees this in the config file, squaring will be used. This enables a stress-free method. This means no side will move without the other if it does not have to. If your axis starts out square, it will never be pulled out of square (stressed) during the squaring.

The above method assumes your switches are mounted squarely. That is the ideal setup. If this is not the case, you can use [pulloff_mm:](http://wiki.fluidnc.com/en/config/axes#pulloff_mm) settings in the config file to compensate for this. This is the amount the motor reverses after touching the switch. By using different values for each motor, you can compensate for misaligned switches.

> It is very important that you do not mix up the switches and motors. Motor0 must activate its switches and Motor1 must activate its switches, or you will get crashes.
{.is-warning}

It is recommended that you set **[stepping/idle_ms: 255](http://wiki.fluidnc.com/en/config/axes#stepping)**. This will prevent the motors from disabling in the idle state. Machines that need squaring tend to go out of square when the motors disable. 

### Auto Squaring Example

Here is an example of auto squaring on the y axis. The important parts are that there are 2 motors defined for this axis and each motor has a switch defined at the homing end.


```yaml
  y:
    steps_per_mm: 100.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: true
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.26:low:pu
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      standard_stepper:
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: I2SO.7
        
    motor1:
      limit_neg_pin: gpio.33:low    
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      standard_stepper:
        step_pin: I2SO.10
        direction_pin: I2SO.9
        disable_pin: I2SO.8
```


## Multiple switches on one input

You can place a switch at each end of the axis and wire them both to the same input. You would wire them is series for a N.C. setup or in parallel for a N.O. setup. You would define the input as a `limit_all_pin:`.

> This has one disadvantage with homing. If a limit switch is touching before homing, FluidNC will do a small move away from the switch to deactivate it and then attempt to home. With a `limit_all_pin:`, FluidNC does not know which end is touching, so it does not know what direction to move to clear the switch. If it moves the wrong way, it could damage something. You must manually move the axis to clear the switch before homing.
{.is-warning}


## Examples

### Single Motor Axes

- One switch on the homed direction side

```yaml
x:
  motor0:
    limit_neg_pin: gpio:2
```

- Separate inputs for the positive and negative ends
```yaml
x:
  motor0:
    limit_neg_pin: gpio:2
    limit_pos_pin: gpio:2
```

### Ganged Motor Axes

 - 2 independent switches on the homed end of each side
```yaml
x:
  motor0:
      limit_neg: gpio:2
  motor1:
      limit_neg: gpio:3
```
 - 4 independent switches
```yaml
x:
  motor0:
      limit_neg_pin: gpio:2
      limit_pos_pin: gpio:3
  motor1:
      limit_neg_pin: gpio:4
      limit_pos_pin: gpio:5
```

 - One side with an all switch and the other with pos, neg or both

```yaml
x:
  motor0:
      limit_all_pin: gpio:2
  motor1:
      limit_neg_pin: gpio:4
      limit_pos_pin: gpio:5
```

## Ganged Motors with One Switch Input

This is supported, but the axis will not auto square during homing. The switch can be placed on either the motor0 or motor1 side.

## Normally Open (N.O.) vs. Normally Closed (N.C.)

You can use N.O. or N.C. switches. Both will require a pulling resistor for the open state. The closed state has lower impedance because the open state uses a resistor to set the voltage, and the closed state is a direct connection. This means N.C. is less likely to falsely trigger due to noise during normal operation.

# TroubleShooting

## Getting Debug Information

You can get additional feedback by showing the debug messages. This gives information for each phase of the homing cycle. If you are requesting support for homing problems, please provide this information.

```
$Message/Level=Debug
ok
$HX
[MSG:DBG: Homing Cycle X]
[MSG:DBG: Homing nextPhase FastApproach]
[MSG:DBG: Starting from 50.000,80.000,50.000]
[MSG:DBG: Planned move to -115.002,80.000,50.000 @ 800.000]
[MSG:DBG:  X Neg Limit 1]
[MSG:DBG: Homing limited X]
[MSG:DBG: Homing nextPhase Pulloff0]
[MSG:DBG: Starting from 36.042,80.000,50.000]
[MSG:DBG: Planned move to 39.042,80.000,50.000 @ 600.000]
[MSG:DBG: CycleStop Pulloff0]
[MSG:INFO: ALARM: Homing Fail Pulloff]
```

You can also see debug information if you manually activate the switches. 

```
[MSG:DBG:  X Neg Limit 1]
[MSG:DBG: Limit switch tripped for X motor 0]
[MSG:DBG:  X Neg Limit 0]
```

## <a id="floating_pins"></a>Floating pins

If you get strange behavior, you might need a pull up or pull-down resistors. External ones in the 3k-10k range work well. You can also apply ESP32 ones to many pins in firmware with the **:pu** or **:pd** [pin attribute](http://wiki.fluidnc.com/en/config/config_IO#input-pin-attributes). It is a good practice to put these in your config file even if you have external ones, so people reading your file will know.

## <a id="inverted_reporting"></a>Inverted Reporting
If the switches are [reporting](http://wiki.fluidnc.com/en/config/homing_and_limit_switches#testing)  backwards from what you want, you need to change the active state attribute of the switch (**:low** vs **:high**). If you don't have an active state attribute, it assumes **:high**

   - like  **limit_neg_pin: gpio.32:low** vs. **limit_neg_pin: gpio.32:high**
   
## Homing Direction and Configured Switches

> Before debugging any homing direction issues, make sure the directions are working with normal moves and jogs. 
{.is-info}


Homing direction is determined by config values like `axes/<axis>/homing/positive_direction:` If that value is true, you must have a `limit_pos_pin:` defined for at least motor0.

## Dual Motor Axis Problem

- If there is strange behavior after the initial switch contact while trying to home a dual motor axis, make sure each switch is associated with the right motor. Squaring will fail if it moves one motor, but the wrong switch activates.   

## Homing Fail Pulloff

If you get an error like this, it means the homing switch is active and did not deactivate when the machine tried to back off it. This could mean the switch is stuck in the active state, the machine did not pull off far enough, or the machine is not actually moving when pulling off.

With this issue the machine will try to pull away from the machine regardless if it is touching the switch. If you are using a `limit_all_pin` you will get an ambiguous limit switch alarm.  

```
[MSG:INFO: ALARM: Homing Fail Pulloff]
ALARM:8
```

## One axis pauses briefly during homing

If you have more than one axis on a homing cycle, like X and Y, both axes will stop when the first axis touches, then the untouched axis will continue until it touches the switch.

## Soft Limits and Homing

This diagram shows the relationship between `max_travel_mm`, `mpos_mm` (machine position after homing), and `positive_direction` in FluidNC.

### Key Variables:
- **`max_travel_mm`** (`_maxTravel`): Maximum travel distance for the axis in millimeters
- **`mpos_mm`** (`_mpos`): Final machine position after homing and pulloff completion
- **`positive_direction`** (`_positiveDirection`): Direction the axis moves during homing (true = positive, false = negative)
- **`pulloff_mm`** (`_pulloff`): Distance to pull away from the switch after it triggers (motor-level setting)

### Homing Process & Pulloff Mechanism

The homing process involves several phases, with pulloff being a critical safety feature:

1. **Approach**: Axis moves in the configured direction until the limit switch triggers
2. **Switch Triggers**: Physical switch activates at its physical location
3. **Pulloff**: Axis immediately moves away from the switch by `pulloff_mm` distance
4. **Final Position**: The `mpos_mm` value represents this final position after pulloff

**Why Pulloff?**
- Prevents the axis from resting directly on the limit switch
- Allows for mechanical tolerance and switch hysteresis
- Provides a small safe zone away from the physical limit
- Ensures repeatable homing position

**Key Insight**: `mpos_mm` is NOT the switch position, but the final position after pulloff!

### Visual Representation

#### Case 1: Positive Direction Homing (`positive_direction: true`)

<svg width="650" height="230" xmlns="http://www.w3.org/2000/svg">
  <!-- Main axis line -->
  <line x1="50" y1="120" x2="580" y2="120" stroke="#333" stroke-width="2" marker-end="url(#arrowhead)"/>
  
  <!-- Arrow marker definition -->
  <defs>
    <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#333"/>
    </marker>
  </defs>
  
  <!-- Min position line -->
  <line x1="100" y1="100" x2="100" y2="140" stroke="#e74c3c" stroke-width="2"/>
  <text x="100" y="95" text-anchor="middle" font-family="Arial" font-size="12" fill="#e74c3c">Min Position</text>
  <text x="100" y="155" text-anchor="middle" font-family="Arial" font-size="10" fill="#e74c3c">(mpos - max_travel)</text>
  
  <!-- Physical switch position -->
  <line x1="480" y1="100" x2="480" y2="140" stroke="#f39c12" stroke-width="3"/>
  <rect x="475" y="90" width="10" height="8" fill="#f39c12" stroke="#f39c12"/>
  <text x="480" y="85" text-anchor="middle" font-family="Arial" font-size="11" fill="#f39c12">Switch Position</text>
  <text x="480" y="75" text-anchor="middle" font-family="Arial" font-size="9" fill="#f39c12">(Physical switch triggers)</text>
  
  <!-- Final mpos position after pulloff -->
  <line x1="450" y1="100" x2="450" y2="140" stroke="#27ae60" stroke-width="3"/>
  <circle cx="450" cy="85" r="4" fill="#27ae60"/>
  <text x="450" y="75" text-anchor="middle" font-family="Arial" font-size="12" fill="#27ae60">Final mpos</text>
  <text x="450" y="155" text-anchor="middle" font-family="Arial" font-size="10" fill="#27ae60">Home Position</text>
  
  <!-- Pulloff distance -->
  <line x1="450" y1="175" x2="480" y2="175" stroke="#9b59b6" stroke-width="2" marker-start="url(#arrow-left)" marker-end="url(#arrow-right)"/>
  <text x="465" y="170" text-anchor="middle" font-family="Arial" font-size="11" fill="#9b59b6">pulloff_mm</text>
  
  <!-- Travel distance arrow -->
  <line x1="100" y1="190" x2="450" y2="190" stroke="#3498db" stroke-width="2" marker-start="url(#arrow-left)" marker-end="url(#arrow-right)"/>
  <text x="275" y="185" text-anchor="middle" font-family="Arial" font-size="12" fill="#3498db">max_travel</text>
  
  <!-- Additional arrow markers -->
  <defs>
    <marker id="arrow-left" markerWidth="10" markerHeight="7" refX="1" refY="3.5" orient="auto">
      <polygon points="10 0, 0 3.5, 10 7" fill="#3498db"/>
    </marker>
    <marker id="arrow-right" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#3498db"/>
    </marker>
  </defs>
  
  <!-- Coordinate axis label -->
  <text x="600" y="125" font-family="Arial" font-size="12" fill="#333">Machine Coordinates</text>
  
  <!-- Process explanation -->
  <text x="50" y="210" font-family="Arial" font-size="10" fill="#666">1. Axis moves + direction → 2. Hits switch at 302mm → 3. Pulls off 2mm to final mpos=300mm</text>
  <text x="50" y="222" font-family="Arial" font-size="11" fill="#666">Example: mpos=300mm, max_travel=300mm, pulloff=2mm → Range: 0mm to 300mm</text>
</svg>

#### Case 2: Negative Direction Homing (`positive_direction: false`)

<svg width="650" height="230" xmlns="http://www.w3.org/2000/svg">
  <!-- Main axis line -->
  <line x1="50" y1="120" x2="580" y2="120" stroke="#333" stroke-width="2" marker-end="url(#arrowhead2)"/>
  
  <!-- Arrow marker definition -->
  <defs>
    <marker id="arrowhead2" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#333"/>
    </marker>
  </defs>
  
  <!-- Physical switch position -->
  <line x1="70" y1="100" x2="70" y2="140" stroke="#f39c12" stroke-width="3"/>
  <rect x="65" y="90" width="10" height="8" fill="#f39c12" stroke="#f39c12"/>
  <text x="70" y="85" text-anchor="middle" font-family="Arial" font-size="11" fill="#f39c12">Switch Position</text>
  <text x="70" y="75" text-anchor="middle" font-family="Arial" font-size="9" fill="#f39c12">(Physical switch triggers)</text>
  
  <!-- Final mpos position after pulloff -->
  <line x1="100" y1="100" x2="100" y2="140" stroke="#27ae60" stroke-width="3"/>
  <circle cx="100" cy="85" r="4" fill="#27ae60"/>
  <text x="100" y="75" text-anchor="middle" font-family="Arial" font-size="12" fill="#27ae60">Final mpos</text>
  <text x="100" y="155" text-anchor="middle" font-family="Arial" font-size="10" fill="#27ae60">Home Position</text>
  
  <!-- Max position line -->
  <line x1="450" y1="100" x2="450" y2="140" stroke="#e74c3c" stroke-width="2"/>
  <text x="450" y="95" text-anchor="middle" font-family="Arial" font-size="12" fill="#e74c3c">Max Position</text>
  <text x="450" y="155" text-anchor="middle" font-family="Arial" font-size="10" fill="#e74c3c">(mpos + max_travel)</text>
  
  <!-- Pulloff distance -->
  <line x1="70" y1="175" x2="100" y2="175" stroke="#9b59b6" stroke-width="2" marker-start="url(#arrow-left2)" marker-end="url(#arrow-right2)"/>
  <text x="85" y="170" text-anchor="middle" font-family="Arial" font-size="11" fill="#9b59b6">pulloff_mm</text>
  
  <!-- Travel distance arrow -->
  <line x1="100" y1="190" x2="450" y2="190" stroke="#3498db" stroke-width="2" marker-start="url(#arrow-left2)" marker-end="url(#arrow-right2)"/>
  <text x="275" y="185" text-anchor="middle" font-family="Arial" font-size="12" fill="#3498db">max_travel</text>
  
  <!-- Additional arrow markers -->
  <defs>
    <marker id="arrow-left2" markerWidth="10" markerHeight="7" refX="1" refY="3.5" orient="auto">
      <polygon points="10 0, 0 3.5, 10 7" fill="#3498db"/>
    </marker>
    <marker id="arrow-right2" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
      <polygon points="0 0, 10 3.5, 0 7" fill="#3498db"/>
    </marker>
  </defs>
  
  <!-- Coordinate axis label -->
  <text x="600" y="125" font-family="Arial" font-size="12" fill="#333">Machine Coordinates</text>
  
  <!-- Process explanation -->
  <text x="50" y="210" font-family="Arial" font-size="10" fill="#666">1. Axis moves - direction → 2. Hits switch at -2mm → 3. Pulls off 2mm to final mpos=0mm</text>
  <text x="50" y="222" font-family="Arial" font-size="11" fill="#666">Example: mpos=0mm, max_travel=300mm, pulloff=2mm → Range: 0mm to 300mm</text>
</svg>

### Logic Summary

| positive_direction | Switch Position | Final mpos | Min Position Formula | Max Position Formula | Travel Direction |
|-------------------|----------------|------------|---------------------|---------------------|------------------|
| `true`            | mpos + pulloff | mpos       | `mpos - max_travel` | `mpos`              | Moves + to find switch, then - for pulloff |
| `false`           | mpos - pulloff | mpos       | `mpos`              | `mpos + max_travel` | Moves - to find switch, then + for pulloff |

### Example Configurations

Note that typical CNC machines home in the positive direction on all axes, but that is not a hard and fast rule.  Lasers often home in the negative direction.

#### X-Axis with Negative Homing
```yaml
x:
  max_travel_mm: 300.000
  homing:
    positive_direction: false  # Move - direction to home
    mpos_mm: 0                # Final position after pulloff
  motor0:
    pulloff_mm: 2.0          # Distance to pull away from switch
```
**Result**: Switch triggers at -2mm, pulls off to 0mm final position, travel range 0mm to 300mm

#### Z-Axis with Positive Homing (typical)
```yaml
z:
  max_travel_mm: 100.000
  homing:
    positive_direction: true   # Move + direction to home  
    mpos_mm: 0                # Final position after pulloff
  motor0:
    pulloff_mm: 1.0          # Distance to pull away from switch
```
**Result**: Switch triggers at +1mm, pulls off to 0mm final position, travel range -100mm to 0mm

## Notes
- `mpos_mm` defines the end of the travel envelope according to `positive_direction`
- `max_travel_mm` defines the full travel distance from that point
- `positive_direction` determines which direction the axis moves to reach the switch
- These values create soft limits that prevent moves outside the defined travel envelope
