---
title: Parallel Delta Kinematics
description: 
published: true
date: 2026-08-01T19:39:47.607Z
tags: 
editor: markdown
dateCreated: 2022-08-02T20:56:15.061Z
---

# Overview

This only applies to Firmware versions above 3.9.9

There are sereval types of Delta Robots. This kinematic covers the type with the rotating actuator arms. All three actuator assemblies must be exactly the same. See the images below.

Gcode works in cartesian space (XYZ). A simple gcode move in X will need all 3 motors to move. The kinematic system will convert the cartesian location to degrees on the motors. Therefore, there will be a few places in the config where you would normally use millimeters, but degrees should be used. Read the details on each setting to see what to use.

Degrees increase in a clockwise roation. The 0 angle is when the arm is completely horizontal. Positions above horizontal are negative and positions below the horizontal are positive.

This is currently designed for use with stepper motors. The documentation will be updated when other motor types are tested.

# Config

![delta_geo_01.png](/delta_geo_01.png =x500)

![delta_geo_02.png](/delta_geo_02.png =x500)

![axes_motor_labels.png](/axes_motor_labels.png =x500)

## Kinematics Section

<!-- config-item path="kinematics.ParallelDelta.crank_mm" -->
### crank_mm
- **Type:** Float
- **Range:** 20 to 500 millimeters
- **Default:** `70.0`

Length of the crank arm attached to each motor. See image.
<!-- /config-item -->

<!-- config-item path="kinematics.ParallelDelta.base_triangle_mm" -->
### base_triangle_mm
- **Type:** Float
- **Range:** 20 to 500 millimeters
- **Default:** `179.437`

Side length of the fixed base triangle (where the motors/cranks mount). See image.
<!-- /config-item -->

<!-- config-item path="kinematics.ParallelDelta.linkage_mm" -->
### linkage_mm
- **Type:** Float
- **Range:** 20 to 500 millimeters
- **Default:** `133.50`

Length of the linkage arm connecting each crank to the end effector. See image.
<!-- /config-item -->

<!-- config-item path="kinematics.ParallelDelta.end_effector_triangle_mm" -->
### end_effector_triangle_mm
- **Type:** Float
- **Range:** 20 to 500 millimeters
- **Default:** `86.603`

Side length of the moving end-effector triangle (where the tool mounts). See image.
<!-- /config-item -->

<!-- config-item path="kinematics.ParallelDelta.kinematic_segment_len_mm" -->
### kinematic_segment_len_mm
- **Type:** Float
- **Range:** 0.05 to 20 millimeters
- **Default:** `1.0`

To smooth out non linear machines the move is divided up into pieces. This indicates the maximum piece size. A big value will show the non linearity. A small value will be smoother, but increases processing time.
<!-- /config-item -->

<!-- config-item path="kinematics.ParallelDelta.use_servos" -->
### use_servos
- **Type:** Boolean
- **Default:** `false`

Set true when the arms are driven by servos rather than steppers -- servos use a different (self-contained) homing approach.
<!-- /config-item -->

<!-- config-item path="kinematics.ParallelDelta.up_degrees" -->
### up_degrees
- **Type:** Float
- **Range:** -90 (straight up) to 0 (horizontal)
- **Default:** `-30` degrees

This is the angle after homing. The kinematics expect homing to go in the negative (up) direction.
<!-- /config-item -->

### Config Example

```yaml
kinematics:
  parallel_delta:
    crank_mm: 70.00
    base_triangle_mm: 180.00
    linkage_mm: 133.500000
    end_effector_triangle_mm: 86.60
    kinematic_segment_len_mm: 1.00
    use_servos: false
    up_degrees: -29.000000
```

## Axes Section



Example:

```yaml
  x:
    steps_per_mm: 8.88
    max_rate_mm_per_min: 5000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 135.00
    soft_limits: false
    homing:
      cycle: 1
      positive_direction: false
      mpos_mm: 0.0
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: 'gpio.36:low'
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000000
 ```
 
   - **steps_per_mm:** 
    - Details: This is step/degree (motor_step_per_rev * microstepping / 360)
    - Type: Float
    - Positive: values
  - **max_rate_mm_per_min:**
    - Details: this rate is degrees/min
    - Type: Float
  - **max_travel_mm:** 
  - Details: This is the total travel in degrees.
  - **soft_limits:** 
    - Details: Use false. This does not really apply. The kinematics will catch reject any unreachable moves. 
  - homing:
    - **cycle:** 
      - Details: Typically this is 1 for all axes
    - **positive_direction:**
      - Detail: This should typically be negative for all axes
    - **mpos_mm:** 
      - This sets the axis machine position after homing. 

    
