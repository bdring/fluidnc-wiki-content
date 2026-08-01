---
title: Grbl Compatibility
description: 
published: true
date: 2026-08-01T19:35:59.303Z
tags: 
editor: markdown
dateCreated: 2022-07-21T19:47:41.294Z
---

# Grbl Compatibility

## Overview

Our goal was to have enough Grbl compatibility to allow use of gcode senders designed for Grbl. This is for the gcode sender (running a job) portion only. We did not try to make it compatible with any setup wizards that some senders have.

## Serial Line Protocol

FluidNC implements the GRBL line protocol per [Classic Grbl Line Protocol](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Interface) and [serial_protocol](/support/serial_protocol). As with Plain Old Grbl, commands are sent line-by-line, with flow control via acknowledgments of either "ok" or "error...". There are a few single-character "realtime commands" that are not line-oriented; they are used for immediate actions like status requests, program pause/resume, and overrides.

In addition to Grbl's status report requests via **?**, `$G`, and `$#`, FluidNC also has an optional [Automatic Reporting](/support/interface/automatic_reporting) feature

FluidNC has quite a few additional "$..." commands beyond the Grbl set, as described in [FluidNC Commands_and_Settings](/features/commands_and_settings).  FluidNC implements very few of the Grbl $nnn (nnn is a number) settings. Those numbered settings are for machine configuration. FluidNC configures the machine via an hierarchical configuration scheme that is much more extensive than would be practical with numeric "names".

## Sender / GCode Compatibility

Anything you would do during a normal job is compatible with Grbl

- Gcodes. We support every gcode Grbl does and more
- Homing
- Axis zeroing
- Jogging
- Feed/Speed overrides
- Reporting
- Laser Mode switching
- Realtime commands (Hold, Resume, Reset)

## Setup Compatibility

FluidNC has many more features and options than Grbl. Grbl uses numeric $ settings. It was not practical to try to emulate or expand that system. For example: Grbl has one homing pull off value, where FluidNC has one for every motor. This adds a lot of flexibility, but breaks the setup compatibility. 

We are planning on creating our own wizards. Our settings are text based and self describing. The WebUI has features for setting many of them.

Do not try to use Grbl setup wizards

## Custom Start message

Some senders require an exact startup message like **Grbl 1.1f ['$' for help]** You can set it to be anything you like with the **\$Start/Message** command. [See the details here.](http://wiki.fluidnc.com/en/features/commands_and_settings#firmware_build)




  

 