---
title: Control (Inputs)
description: Configure Control Inputs
published: true
date: 2026-08-01T19:32:51.907Z
tags: en
editor: markdown
dateCreated: 2022-07-21T17:39:39.767Z
---

# Control

This section is used for control inputs. These are typically used with switches.

<!-- config-item path="control.safety_door_pin" -->
### safety_door_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

This is typically used with an enclosure door. If the machine is running, it will quickly stop and enter a `Door` mode ([see available modes](http://wiki.fluidnc.com/en/support/serial_protocol#mode-section)). It is often used with the [parking feature](http://wiki.fluidnc.com/en/features/parking). You must deactivate the switch to use the machine. If the door opening pauses a running job, after the door is closed again the job can be resumed by a cycle_start. cycle_start can be done via a play/resume button in the sender user interface (which sends the cycle start/resume real time character `~`), or by pressing a switch connected to a cycle_start_pin.
<!-- /config-item -->

<!-- config-item path="control.reset_pin" -->
### reset_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

Performs a "soft reset", the same as sending the Ctrl-X real time character via the user interface.
<!-- /config-item -->

<!-- config-item path="control.feed_hold_pin" -->
### feed_hold_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

Pauses a job that is running, the same as sending the '!' real time character via the user interface. Paired with "cycle_start_pin" it will allow a machine to be paused and resumed with physical buttons.
<!-- /config-item -->

<!-- config-item path="control.cycle_start_pin" -->
### cycle_start_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

Resumes a job that is paused, the same as sending the '~' real time character via the user interface. Paired with "feed_hold_pin" it will allow a machine to be paused and resumed with physical buttons.
<!-- /config-item -->

<!-- config-item path="control.macro0_pin" -->
### macro0_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

Runs macro0 [configured in this section](http://wiki.fluidnc.com/en/config/macros), the same as sending the 0x87 real time character via the user interface.
<!-- /config-item -->

<!-- config-item path="control.macro1_pin" -->
### macro1_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

Runs macro1 [configured in this section](http://wiki.fluidnc.com/en/config/macros), the same as sending the 0x88 real time character via the user interface.
<!-- /config-item -->

<!-- config-item path="control.macro2_pin" -->
### macro2_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

Runs macro2 [configured in this section](http://wiki.fluidnc.com/en/config/macros), the same as sending the 0x89 real time character via the user interface.
<!-- /config-item -->

<!-- config-item path="control.macro3_pin" -->
### macro3_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

Runs macro3 [configured in this section](http://wiki.fluidnc.com/en/config/macros), the same as sending the 0x8a real time character via the user interface.
<!-- /config-item -->

<!-- config-item path="control.fault_pin" -->
### fault_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

Performs a hard stop, causing all motion to cease at once without deceleration, thus possibly losing position accuracy. Stops the spindle if off_on_alarm is true in the active spindle configuration. Enters critical alarm state, which can only be exited via a soft reset.
- (since v3.7.5) This can be used with an e-stop. A true [e-stop should also cut the power](http://wiki.fluidnc.com/en/features/e_stop_button).
- Since (v3.9.3) Critical alarm state blocks homing and unlock.
- The actions of fault_pin and estop_pin are identical. fault_pin is intended to be used for machine-detected faults like stepper driver alarm signals.
<!-- /config-item -->

<!-- config-item path="control.estop_pin" -->
### estop_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

Performs a hard stop, causing all motion to cease at once without deceleration, thus possibly losing position accuracy. Stops the spindle if off_on_alarm is true in the active spindle configuration. Enters critical alarm state, which can only be exited via a soft reset.
- (since v3.7.5) This can be used with an e-stop. A true [e-stop should also cut the power](http://wiki.fluidnc.com/en/features/e_stop_button).
- Since (v3.9.3) Critical alarm state blocks homing and unlock.
- The actions of fault_pin and estop_pin are identical. estop_pin is intended to be used for user-activated switches.
<!-- /config-item -->

<!-- config-item path="control.homing_button_pin" -->
### homing_button_pin
- **Type:** [Pin](/config/config_IO#configuring-pins) (input)
- **Range:** gpio
- **Default:** `NO_PIN`

This will do a home all ($H) when activated.
<!-- /config-item -->

## Initial State

All control inputs must be in the non active state at turn on. This is to prevent you from using a machine with a stuck switch. The active state can be changed using the [high/low attributes](http://wiki.fluidnc.com/en/config/config_IO#Input-Pin-Attributes). You will get an "active at startup" alarm if you restart or reset with an active switch.



## Reporting

The status of the pins is available via the '?' status command.

## Compatibility notes:


The first 4 pins shown below are the same as standard Grbl (v1.1) pins. They trigger the same actions as real time characters [as defined here](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Commands#grbl-v11-realtime-commands). 

Standard Grbl only supports Door, Reset, Feed Hold and Cycle start pins. If you use the other pins, Grbl gcode senders will not be helpful with the reporting or use of these pins.

## Config Example

```yaml
control:
  safety_door_pin: NO_PIN
  reset_pin: NO_PIN
  feed_hold_pin: NO_PIN
  cycle_start_pin: NO_PIN
  macro0_pin: NO_PIN
  macro1_pin: NO_PIN
  macro2_pin: NO_PIN
  macro3_pin: NO_PIN
  fault_pin: gpio.34
  estop_pin: gpio.2
  homing_button_pin: NO_PIN
```

