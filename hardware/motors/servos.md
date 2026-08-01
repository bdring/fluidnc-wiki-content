---
title: AC Servo and DC Servo motor drivers
description: Using AC Servo and DC Servo motor drivers
published: true
date: 2025-06-19T11:52:47.983Z
tags: en
editor: markdown
dateCreated: 2025-04-18T13:02:38.952Z
---

# Using AC Servo and DC Servo Motor Drivers

![ac_servo_1.png](/motors/ac_servo_1.png =x400)

## Can they be used with FluidNC like a stepper motor?

They can be used with FluidNC if they have a mode that supports simple step, direction and enable inputs. FluidNC can also connect and react to digital alarm signals.

Many have comm channels like, RS485, UART, CAN or Ethernet. FluidNC cannot use thes for setup or motion control.

Many people have used them. They setup and tune the motors using the manufaturer's software, then control them just like stepper motors on the CNC machine.

## Are they better than stepper motors?

The main advantage they have is power, efficiency and closed loop error detection.

Stepper motors do not scale well. Once you get above the 1000 oz/in torgue level you start having vibration and resonance issues. You rarely see motors above the NEMA34 size. They are very accurate if you do not overload them. 

The step signals set a target location and the servo uses a PID control loop track that location as it changes. If the servo postion ever fails to maintain position, it will stop and signal an alarm. The PID loop needs to be tuned to the enertia of your machine. Many servos have software and auto tuning features, but tuning is critical for accuracy.

If you have a small machine in the NEMA23 and smaller, stepper motors might be a better choice. If you have a larger machine that requires a lot of torque, servos might be a better choice.

## Can they be used as a spindle

Many AC Servo controllers support Modbus RTU communication, for use with, for example, PLCs. FluidNC supports Modbus RTU. We have "out-of-the-box" support for the specific Modbus messages that are used by a few particular VFD models, but it is unlikely that any given AC Servo controller uses exactly the same messages. We have a "[generic VFD](http://wiki.fluidnc.com/en/config/config_spindles#generic-modbusvfd-rs485)" module that can be configured with custom message formats. It is possible that, if you can find documentation about the message details for your particular controller, the generic VFD module would work with it.

 