---
title: CAM Post Processors
description: How to choose and configure a CAM post processor for use with FluidNC
published: true
date: 2026-09-12T00:00:00.000Z
tags: 
editor: markdown
dateCreated: 2026-09-12T00:00:00.000Z
---

# CAM Post Processors

A CAM (Computer-Aided Manufacturing) program converts a toolpath design into GCode - a "post processor" (or "post") is the piece of the CAM software that does that conversion for a specific type of controller. Since different controllers support somewhat different GCode dialects, using the right post matters for getting code that runs correctly and safely on your machine.

## Which Post Should I Use?

FluidNC's GCode interpreter is upward-compatible with Grbl's, so in general a post that produces good GCode for Grbl will also work well with FluidNC. Use the following priority order when choosing a post in your CAM software:

1. **A dedicated FluidNC post**, if the CAM program offers one.
2. **A Grbl post**, if there is no FluidNC-specific post. This is the most common choice, since most popular CAM programs support Grbl.
3. **A LinuxCNC post**, if neither a FluidNC nor a Grbl post is available. FluidNC GCode is close to the LinuxCNC GCode dialect and will often work, though you should check the resulting file for anything unusual before running it, especially around canned cycles, tool changes, and units.

Avoid posts written for controllers with substantially different GCode dialects (for example, older Fanuc- or Haas-style posts intended for industrial machine tools), since those can include vendor-specific codes and conventions that FluidNC does not support.

Whichever post you use, check the generated GCode file for:

- Correct units (inches vs. millimeters) matching your machine configuration.
- Sensible retract heights that clear clamps, fixtures, and the workpiece.
- Spindle/laser control commands (`M3`/`M4`/`M5`) appropriate for your tool.
- No unsupported codes specific to other controller families.

## Fusion 360

Fusion 360 does not currently have a dedicated FluidNC post processor, so use its **Grbl** post.

> **Important:** In the Fusion 360 post processor options, set **Safe Retracts** to **Clearance Height**. The other two choices, **G28** and **G53**, retract to a fixed machine-coordinate position instead of a height defined relative to your stock/fixture setup. **G28** is the default setting, and it causes a lot of problems - it can send the tool out of bounds or through clamps, fixtures, or the workpiece on the way to its retract position. **Clearance Height** is the safe choice, since it retracts to a height that you define above your setup before making moves between operations.
{.is-warning}

To find this option, open the post-processing dialog (the "Post Process" action after generating a toolpath), select the **grbl** post, and look in the **Safe Retracts** setting in the **General** section.
