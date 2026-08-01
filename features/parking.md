---
title: Parking Feature
description: Using the Parking Feature
published: true
date: 2026-08-01T19:36:22.921Z
tags: 
editor: markdown
dateCreated: 2022-07-21T19:35:34.482Z
---

# Parking Feature

Parking is a feature that is associated with the [safety door](http://wiki.fluidnc.com/en/config/control#safety_door_pin) pin or the SafetyDoor realtime command (0x84). If you use parking, the machine will move to a safe location on a specified axis. It is typically used with the Z axis. Below is the sequence.

This requires you to home first. You should use hard limits on the parking axis in case the homing alarm was cleared without actually homing.

- Motion decelerates to a stop
- It does an initial pullout of **PARKING_PULLOUT_INCREMENT** mm from the work at a rate of **PARKING_PULLOUT_RATE** mm/sec
- The spindle is turned off.
- It waits for the spindle to stop
- It then moves to **PARKING_TARGET**, in machine space at a rate of **PARKING_RATE**

Use the cycle start or resume command, `~`, to return to motion.

- It moves to **PARKING_PULLOUT_INCREMENT** mm above the work.
- The spindle is turned on.
- It waits for the spin up
- It moves to the location before when the original parking motion started. It resumes the job.

## Configuration

 - <a id="enable">**enable:**</a>
   - Type: [Boolean](/config/overview#boolean)
   - Default: true
   - Details: Enables the parking feature.
 - <a id="axis">**axis:**</a>
   - Type: [String](/config/overview#string) 
   - Default: Z
   - Details: Which axis will move during the parking sequence.
 - <a id="pullout_distance_mm">**pullout_distance_mm:**</a>
   - Type: [Float](/config/overview#float)
   - Default: 5.0
   - Details: The distance of the pull out move. This is a relative to the location before the parking sequence was started.
 - <a id="pullout_rate_mm_per_min">**pullout_rate_mm_per_min:**</a>
   - Type: [Float](/config/overview#float)
   - Default: 250.0
   - Details: The rate of the initial pull out move.   
 - <a id="target_mpos_mm">**target_mpos_mm:**</a>
   - Type: [Float](/config/overview#float)
   - Default: -5.0
   - Details: Target of the final parking move. This is in machine space and is not affected by any current offsets.
 - <a id="rate_mm_per_min">**rate_mm_per_min:**</a>
   - Type: [Float](/config/overview#float)
   - Default: 800.0
   - Details: The rate of the movement to final park position.

Example

```yaml
parking:
  enable: true
  axis: Z
  pullout_distance_mm: 5.000
  pullout_rate_mm_per_min: 250.000
  target_mpos_mm: -5.000
  rate_mm_per_min: 800.000
```

## Status

The standard [status reporting](http://wiki.fluidnc.com/en/support/serial_protocol) tells you the state of the door sequence.

  - `Door:0` Door closed. Ready to resume. Use the cycle start command or button to resume.
  - `Door:1` Machine stopped. Door still ajar. Can't resume until closed.
  - `Door:2` Door opened. Hold (or parking retract) in-progress. Reset will throw an alarm.
  - `Door:3` Door closed and resuming. Restoring from park, if applicable. Reset will throw an alarm
```
<Door:1|MPos:151.000,149.000,-1.000|Pn:D|FS:0,0|WCO:12.000,28.000,78.000>
```

## Deactivating the parking feature

You can use the [deactivate_parking](https://wiki.fluidnc.com/en/config/start_group#deactivate_parking) config item to deactivate this feature

## Overriding the parking feature

The **M56** command can be used to toggle the feature. Use **M56 P0** to disable the feature and **M56 P1** to enable it.

## Special cases

### Before homing

Parking will not work before the machine has been homed. It would not know where to go. If you clear the homing alarm with $X, it will attempt to park. This could crash into ends of the Z that do not have limit switches and hard limits enabled. 

### Homing

If you interrupt homing by opening the door, homing will stop and you will get an alarm. The parking sequence will not run, because we assume that the machine position is not known if you are homing. You must close the door, issue a reset ctrl+x (0x18), then rehome.