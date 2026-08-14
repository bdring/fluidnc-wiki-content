---
title: Machine Coordinates, Work Coordinates, Homing and Zeroing
description: Explains the difference between machine and work coordinates
published: true
date: 2026-08-14T23:42:16.032Z
tags: 
editor: markdown
dateCreated: 2026-08-14T22:38:45.437Z
---

# Machine Coordinates, Work Coordinates, Homing and Zeroing
Newcomers to CNC often assume there is only one XYZ coordinate system.  While some kinds of machines like 3D printers - with their special-purpose G-code interpreters - do have only one coordinate system, CNC machines with general-purpose G-code interpreters like FluidNC have multiple coordinate systems.  Some user interface programs present a simplified view, showing you only one coordinate system, but that simplification ultimately leads to confusion.

## Machine and Work Coordinates
G-code supports multiple coordinate systems - a special **Machine Coordinate System** representing the machine's physical limits (total work area) and up to nine **Work Coordinate Systems** (WCS) defined relative to stock you are working on.  That stock could be placed anywhere inside the machine's total work area.  By analogy, if you were making something on a workbench, the Machine Coordinate System would encompass the entire workbench.  The plan drawings for your part would be in Work Coordinates.  They would not refer to your bench or where you clamped the material on it; instead they would show features relative to the material or the part itself.

## Homing
**Homing** is the process of locating the physical boundary of the machine.  It establishes the origin (Machine Zero) of the Machine Coordinate System so the motion planner can prevent something from crashing into the frame if given a bad move command.  FluidNC lets you choose which corner of your machine is Machine Zero, but that choice rarely affects daily operations because standard G-code moves are relative to work coordinates, not Machine Zero.  You can temporarily force a move in machine coordinates using G53, but this is reserved for specific utility actions (like tool changes or parking), not normal machining. Homing is typically performed once when you power on the machine.

## G-code Uses Work Coordinates
For standard operations, the coordinate numbers in a G-code command are relative to the zero point of a Work Coordinate System — designated by **G54** through **G59.3**.  Having multiple work coordinate systems lets machinists set up several fixtures across the machine bed simultaneously and switch between them. For hobbyist use or single-part jobs, you will typically use just one, the default system **G54**. Most CAM-generated programs include an explicit **G54** near the beginning of the file to ensure the correct coordinate system is active.


[This video also explains work coordinate systems](https://www.youtube.com/watch?v=fGtbkVJBXyE) 
## Zeroing
**Zeroing** is the process of setting the reference origin (0,0,0) on your actual workpiece or fixture. This can be done manually by jogging the tool to the edge of the stock, touching off with a probe, or using a corner-finding macro.  Once the reference position is located, the current Work Coordinate System zero is set by pressing a UI *Zero* button (which then sends a G-code command like **G10 L20 P0 X0 Y0**). Regardless of method, zeroing establishes where **X=0, Y=0, Z=0** sits relative to your material, wherever it happens to be clamped on the bed. A subsequent G-code command like **G0 X10** will then move 10 mm (or inches) from that stock origin, rather than 10 mm from the machine corner.

Internally, the controller calculates and saves the distance between Machine Zero and Work Zero as a **Work Coordinate Offset** (WCO). While you rarely need to be concerned about WCO values in normal usage, checking them (via commands like **$#**) is helpful if your tool positions aren't matching what your sender UI displays.

## Work Coordinate Offsets (WCOs)
Internally, when you zero a Work Coordinate System, the software records the location of that relative zero point as a multi-dimensional offset (one number for each axis) from the machine coordinate system zero point.  That is called the Work Coordinate Offset, or WCO.  There is a separate one for each of FluidNC's nine work coordinate systems.  You can display the WCO set by sending **$#** .  Normally you do not have to worry about WCOs directly - you just zero to your stock and let the program take care of the rest - but if you are confused about the coordinates that your UI program is displaying, looking at the WCOs might explain what is going on.

## Homing is Recommended (but Optional)
Homing, using limit switches to find the machine boundaries, is highly recommended, but not strictly required to run G-code.  If a machine hasn't been homed (or lacks homing switches altogether), it powers up with its Machine Zero set at whatever physical position the tool happens to occupy at startup.

Without homing, the controller cannot enforce soft limits (software boundaries that block out-of-bounds moves). As a result, sending an invalid command or moving too far along an axis can cause the machine to crash into its physical frame. On lightweight desktop CNCs with small stepper motors that stall without damaging anything, this may be acceptable, but on larger or more powerful machines, it can cause physical damage.

Operating without true machine position does not break normal G-code execution. When you zero your Work Coordinate System (via touching off or probing), FluidNC calculates the Work Coordinate Offset relative to that arbitrary startup location. Because that reference point remains stationary as long as the controller stays powered on, your G-code programs will execute normally.

The critical requirement for this usage is that you absolutely must zero the WCS every time you power on the machine - but that is good practice in any case.
