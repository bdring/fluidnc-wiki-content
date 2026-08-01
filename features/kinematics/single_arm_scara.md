---
title: Single Arm SCARA Kinematics
description: Single Arm SCARA Kinematics
published: true
date: 2026-08-01T19:39:52.164Z
tags: 
editor: markdown
dateCreated: 2024-05-17T21:29:07.423Z
---

# Single Arm SCARA Kinematics

![scara_01.png](/features/kinematics/scara_01.png =x400)

> **Note:** The Scara kinematics code is in a [branch](https://github.com/bdring/FluidNC/tree/Scara) that has not yet been released.  It is not included in the precompiled release packages. To use it, you must compile a firmware image from that branch.  Support is limited.
{.is-warning}


## Machine overview

This is for a machine with a single arm with motor at the shoulder and a motor for the elbow. The elbow motor can be mounted at the elbow or at the shoulder, like a coaxial SCARA

Currently the machine must be in this orientation. The machine 0,0 is at the shoulder axis and positive X is to the right.


## Config File

Example

```yaml
kinematics:
  SingleArmScara:
    upper_arm_mm: 110.000000
    forearm_mm: 72.000000
    segment_mm: 1.000000
    elbow_motor: false
    orientation: 0.000000
```

- **segment_mm:**
	- The kinematics divides moves into smaller segment to deal with the non linearity of the motion and speed. This is not used for rapid moves.
- **elbow_motor:**
  - Set to true if there is a motor in the elbow. If not, the motor needs to compensate for shoulder movement. Currently pulley ratios must be 1:1
- **orientation:**
  - What angle does the machine operate at? This would be the angle at which the arms are from the motor when fully extended in positive X. Currently this is not used.