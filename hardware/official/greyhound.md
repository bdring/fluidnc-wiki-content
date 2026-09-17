---
title: Greyhound 6x S3 Controller
description: The 2nd generation 6x controller
published: true
date: 2026-09-17T14:54:19.602Z
tags: 
editor: markdown
dateCreated: 2026-09-17T14:49:53.603Z
---

# Greyhound 6x-S3 Controller

> This page is a working progress. The first set of prototype controllers have not arrived yet.
{.is-info}


# Overview

This is the second generation of the popular 6x controller. This uses the ESP32-S3 controller to gain a few extra pins and features. Less features share pins vs. the original 6x

This is designed for people who prefer screw terminals over crimp connectors. If you prefer connectors, I suggest the very similar Doberman controller.

# Features

# Where to buy it

# Getting Started

# Config Files

It is strongly recommended that you use the configuration wizard to create config files.

# Asking for Help

# Power

# ESP32 Chip Type

# USB

# Programming

# Motor Driver Terminals

The motor drivers circuits use (2) [STMicro STP16CP05](https://item.szlcsc.com/datasheet/STP16CP05TTR/138548.html) chips. These are constant current, LED sink driver, shift register chips. We use the Is2o feature of the ESP32 to output the shift register signals. 

The constant current feature is setup for about 20mA. This means a 20mA or lower current will be driven constantly. This should be way more than the optos motors drivers use. This method was chosen to protect the pins from some accidental mis-wires, like a short to ground or a positive voltage. Anything attempting to pull more current will cause them to PWM to lower the average current, or shut off completely.

They sink current which means the signals must be connected to the minus side of the optos and the plus side should be connect to +5V. In the off state the pins are floating (not connected to any voltage)

> Any usused signal, plus the extra 6 i2so pins on the 8 pin header connector, can be used as outputs to control other features. Keep in mind that these current sync to ground in the active state and float in the inactive state.
{.is-info}

## Motor Wiring example

 

### Closed loop motors

Most closed loop motor drivers can be used. See [this wiki page](http://wiki.fluidnc.com/en/support/external_stepper_motor_drivers#closed-loop-steppers-and-servo-motors) for more details.

# Inputs

All inputs activate by closing the circuit to ground. You can use N.O. and N.C switch as long as one position closes to ground. 

You can use electronic switches like proximity or inductive switches as long as the output signal switches to ground (typically called NPN). If the switches require external power you need to connect that elsewhere on the controller or an external power supply that shares a common ground.

All of the inputs have external pullup resistors. You do not need to add :pu in the config file.

For normally open switches you need the **:low** attribute on all inputs. Normally closed are active high. You can add the ***:high*** attribute, but it is not needed because that is default in FluidNC.

# 5V Outputs



# Spindles

# MOSFETs

The (2) NPN MOSFETs are rated for 3A continuous and 5A peak. There are flyback diodes connected to Vin to make them safe for use with inductive loads, such as relays and solenoids.

The MOSFETs share pins with (2) 5V outputs. If you are using the wizard, please assign the MOSFET beforee the 5V outputs so you know which 5v pins are still available.

The VMot terminals are always connected to VMot. Terminals labeled with the io pin numbers switch to ground when the io pins are active. If you need to operate devices with other voltages than VMot, you can use a separate DC power supply as long as it shares a common ground with the controller.

# Expansion Module Socket

The expansion socket is compatible with all existing CNC I/O Module designs (4 I/O pins). It also adds (3) extra pins that are connected to the SPI bus that the SD card also uses.

![module_v2.png](/hardware/greyhound/module_v2.png =x300)

## Wired Ethernet Module


# Source Files

Source files will be provided when the controller is ready for sale,

# Pinout Reference

> The config wizard is also very good way to determine the pin numbers.
{.is-info}


