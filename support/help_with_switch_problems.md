---
title: Help With Switch Problems
description: 
published: true
date: 2026-08-01T19:39:10.715Z
tags: 
editor: markdown
dateCreated: 2022-07-21T19:45:12.998Z
---

# Help with Switch Problems

## Checking Switch Status.

The active/inactive status of all switches can be checked with the `?` command. The status will look something like this...

```Boo
<Run|MPos:351.154,0.000,-135.983,10.477|FS:1200,0|Pn:X>
```

Active means the switch is in the position that reports the event. Normally closed and normally open will each have an active state.

The **Pn:X** part will only show if at least one switch is active. In this case, the X limit switch is currently being read in the active state. Every switch can be checked. These are the possible switches you could see:

- **P** = Probe
- **XYZABC** = The axis limit switches. The axis letter will show if any of the switches used for that switch are active.
- **D** = Door
- **R** = Reset
- **H** = Hold
- **S** = Start

Check all your switches in the active and inactive states and make sure the status query responses show the correct status in both states. 

There is also the `$Limits/Show` or `$Limits` command. This will send the limit switch status every 500ms. Send **!** to stop it. 

```
Send ! to exit
Homing Axes: xyz
Limit  Axes: xyz
  PosLimitPins NegLimitPins
: X
:  
:  Y
:  Y
:  
:   Z
```



## Inverted States

If your switches are reporting inverted from what you expect you can change the active state using the [active state (high/low) attribute](http://wiki.fluidnc.com/en/config/config_IO#input-pin-attributes) for each switch.

## Switch Pull Ups

A switch that is connected to an ESP32 GPIO typically requires a pull-up resistor in order for the circuit to work.  Search the web for "pull-up resistor" for more information on that topic.  Most commercial FluidNC controller boards already have suitable pull-up resistors (and often other signal-conditioning circuitry) on connectors that are primarily intended for switches - like limit inputs.  If you are making your own board, or repurposing a GPIO pin that does not already have input-conditioning circuitry, you will need to provide a pull-up resistor if you intend to connect a switch.

There are two choices for how to provide a pull-up resistor.  Many ESP32 pins have an internal pull-up resistor than can be connected or disconnected from the pin under software control.  If the pin you are using has an internal pull-up, you can connect it by adding ":pu" to the pin specification.  If not, or if you would rather not use the internal pull-up, you can add an external pull-up resistor.  10K is a typical value.  The "high side" of the resistor should be connected to 3.3V.  In general, external pull-up resistors are better than using the internal ones, because the internal ones have poorly-controlled resistance values that, even in the best case, are too high for good noise rejection.  The ESP32 pins from 34 through 39 do not have internal pullups, so external is the only choice for those pins.

## Startup Issues

On startup many switches are checked by default while others are optionally checked. The control and macro switches are always checked. The machine cannot run with these active. There is no reason for them to be on continuously and they must not be active before using the machine. Other switches such as the probe and limits are optionally checked. See these settings.

- **check_limits:** (under **start** section)
- **check_mode_start** (under **probe** section)

## Homing

Homing is controlled by a lot of settings. Don't expect a home all `$H` to work as soon as you hook up the motors. If you reduce the homing and switch features, you are more likely to have success and understand any problems. You can add features after basic homing works. Use a [standard serial port](https://github.com/bdring/Grbl_Esp32/wiki/Serial-Port-Setup-and-Usage) rather than a gcode sender if you can.

Here is how the basic homing cycle works. It first looks at the state of the switch. If the switch is not active it starts moving towards (seek) the switch. If the switch is active, it assumes it is touching the switch and it will attempt to pull off the switch (opposite of the intended homing direction). If it still has not de-activated the switch after the full **[pulloff_mm](http://wiki.fluidnc.com/en/config/axes#pulloff_mm)** distance, it issues an  alarm 8: (Homing Fail Pulloff). If the switch was not active at the beginning the machine will move towards the switch until it touches. It will move a maximum of **max_travel_mm** to seek the switch.

## Here is a good plan to setup homing.

> Make sure all motors and switches are working correctly **before attempting homing**. Motors must move in the correct amounts (verify accurate move distances) and in both directions. Switches must show correct states in both the active and inactive positions.
{.is-warning}


Config settings. Most of these must be set for each axis. If you don't see them in your config file, the system will be using defaults. Check the wiki

- **hard_limits: false** (This will prevent alarms while testing)
- **soft_limits: false** (soft limits only work after homing is set up)
- **allow_single_axis: true** (allows you to test one axis at a time)
- **[pulloff_mm](http://wiki.fluidnc.com/en/config/axes#pulloff_mm): 5.00** (this is a large value that will clear most switches)
- **feed_mm_per_min: 100.000** (A safe speed)
- **seek_mm_per_min: 200.000**  (A safe speed)
- **positive_direction: true or false**  (Set to true if you want it to home in the positive direction of travel)
- Make sure switches are defined for each axis at least at ends indicated in the item above.

## Testing

Here is a  test plan. Read **all** the items before you try anything.  Do each step in order and correct problems before moving on. Ideally you do all of these commands from a keyboard using the fluidterm serial terminal. It makes sure you are sending exact commands rather than clicking on buttons and you can send Ctrl+X to immediately stop all motion. Be ready to stop the machine because it will likely crash a few times.

- Restart the controller with CRTL+R in Fluidterm or click the reset button on the ESP32.

- Make sure you have no errors or warnings in the [startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages). Send `$Startup/Show` at any time to see the saved [startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages). If there are problems fix them before moving on.

- Send  `?` to get the status. If you are not in **Idle** mode, send `$X` to get into that mode.

- Send the `$Limits` command to see the limit switch status. It should not show any switches active. Now activate each switch. You should see the switches indicated when the switches are activated. Fix any problems before moving on. Each switch should be correct in the active and not active state. Ideally you would manually move the machine to the switch to make sure the machine can activiate the switch. You can disable motors with the `$MD` They will automatically reactivate. After the switches are working send the `!` character to exit the `$limits` reporting mode.

- Test the motion on each axis. Send short jogging commands like this `$J=G91 X10 F100` this would move axis X 10mm in the positive direction. `$J=G91 X-10 F100` would move X negative direction. It is very important that the motion moves exactly the amount specified and in the correct direction. If it is not moving the correct direction, [fix it](http://wiki.fluidnc.com/en/support/faq#motors-run-backward).

- Start with the X axis. Manually move it to the middle of travel before you try homing. Be ready to stop the motion with `CTRL-X` or by resetting the controller. 

- Send `$HX`. The machine should slowly move in the direction of travel towards the switch.

  - If it moves only 5mm and stops with an alarm, you most likely had the switch active before you started to home. It was trying to pulloff the switch
  - If it moves the wrong direction, more than 5mm it means your homing direction is wrong. Change the value of the `positive_direction:` config item for the axis.
  - If it is moving towards the switch, let it continue. If you can safely touch the switch by hand, try it by quickly touching and releasing the switch. The motion should stop and pull off. If that worked, try it again and allow the machine to activate the switch.
  
## Debug Mode

It you change the [$Message/Level](http://wiki.fluidnc.com/en/features/commands_and_settings#message_level) setting to **Debug** you can see a lot of extra information that can help. If you are asking for help with the problem, please include this information with your request. Here is an example of what that looks like.

```
$HZ
[MSG:DBG: Homing Cycle Z]
[MSG:DBG: Starting from 0.000,0.000,8.000]
[MSG:DBG: Planned move to 0.000,0.000,3.000 @ 300.000]
[MSG:DBG:  Z Pos Limit 0]
[MSG:DBG: CycleStop PrePulloff]
[MSG:DBG: Homing nextPhase FastApproach]
[MSG:DBG: Starting from 0.000,0.000,3.000]
[MSG:DBG: Planned move to 0.000,0.000,58.000 @ 600.000]
[MSG:DBG:  Z Pos Limit 1]
[MSG:DBG: Homing limited Z]
[MSG:DBG: Homing nextPhase Pulloff0]
[MSG:DBG: Starting from 0.000,0.000,6.780]
[MSG:DBG: Planned move to 0.000,0.000,1.780 @ 300.000]
[MSG:DBG:  Z Pos Limit 0]
[MSG:DBG: CycleStop Pulloff0]
[MSG:DBG: Homing nextPhase SlowApproach]
[MSG:DBG: Starting from 0.000,0.000,1.780]
[MSG:DBG: Planned move to 0.000,0.000,7.280 @ 300.000]
[MSG:DBG:  Z Pos Limit 1]
[MSG:DBG: Homing limited Z]
[MSG:DBG: Homing nextPhase Pulloff1]
[MSG:DBG: Starting from 0.000,0.000,6.765]
[MSG:DBG: Planned move to 0.000,0.000,1.765 @ 300.000]
[MSG:DBG:  Z Pos Limit 0]
[MSG:DBG:  Z Pos Limit 1]
[MSG:DBG:  Z Pos Limit 0]
[MSG:DBG: CycleStop Pulloff1]
[MSG:DBG: Homing nextPhase Pulloff2]
[MSG:DBG: mpos was 0.000,0.000,1.765]
[MSG:DBG: mpos becomes 0.000,0.000,0.000]
[MSG:DBG: mpos transformed 0.000,0.000,0.000]
[MSG:DBG: Homing done]
```

## Ambiguous Limit Switch Messages

`[MSG:ERR: Ambiguous limit switch touching. Manually clear all switches]`

If you are using limit switches at both ends using a `limit_all_pin:` input you might get this message. It occurs when FluidNC cannot determine which end of travel is activating the switch.

This typically happens when a switch on the axis is active before homing starts. FluidNC does not know which way to move to pulloff from the switch. You must manually move (or jog) the axis away from the switch.

You can check which switch is active by sending the `?` status command.

## Hard Limits

Hard limits protect your machine from overtravel using switches. Typically you place them at both ends of the axis, but this is not required.

The hard limits feature requires very robust wiring and circuitry. Most CNC have high electrical noise and often generate power spikes. These can generate false signals. If you get a false signal, it will stop your job and likely ruin the work piece.

We also recommend that you do not use hard limits when you first set up a machine. Make sure your motors are going the right way and the switches are reporting correctly first. Otherwise hard limits might keep getting in the way of setting up the machine correctly.  

## False Readings

If you are getting false readings, you could have noise on the circuit. Here are some things that can help eliminate noise problems.

- Consider using normally closed switches. Mechanical switches use a weak pull up resistor to set to pin voltage in the open state. This is more susceptible noise than the closed state which is typically directly connected to ground or a strong reference voltage.
- R/C filters can help eliminate noise and switch bounces.
- Opto isolators can block noise.
- Schmitt triggers can help by raising the threshold of the on vs. off state.

## NPN Switches (Inductive, Proximity, 3-wire, etc)

Many controllers can use electronic switches like proximity or inductive switches as long as the output signal switches to ground when active (typically called NPN).

This is how to wire a typical proximity switch. Make sure your Vcc is compatible with the switch. If you don't have a compatible voltage on the controller, you can use an external power supply as long as there is a common ground.

![npn_pinout.png](/hardware/npn_pinout.png =x200)
  