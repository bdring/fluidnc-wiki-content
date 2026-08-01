---
title: ATCs (Automatic Tool Changers)
description: Using ATCs with FluidNC
published: true
date: 2026-08-01T19:35:32.821Z
tags: en
editor: markdown
dateCreated: 2023-11-01T15:11:03.576Z
---

# Using ATCs with FluidNC


![atc_5.png](/features/atc_5.png =x320)

Here is a [video of an example](https://www.youtube.com/watch?v=3ikLcC5NidU). This was originally done in Grbl_ESP32, but the machine was updated to FluidNC.


> ATCs are a very advanced feature and not recommended by newbies. Most of the developers cannot afford ATC machines to help test and develop this feature. Please become a sponsor of the project if you need help and support. **Please be respectful of our time.**
{.is-warning}

ATCs are a very complex topic. Setting one up is usually done by the machine supplier or by an expensive, highly trained CNC millwright.

If you are just getting started, just use your machine in manual tool change mode for a while. Make sure the machine is reliable, accurate, works perfectly and you are very comfortable using FluidNC and gcode. 

Note: FluidNC also has a feature where it can handle [multiple spindles](http://wiki.fluidnc.com/en/config/config_spindles#using-multiple-spindles). You can can change spindles with M6 and use the T number ranges to select the new spindle. Mixing ATCs and multiple spindles is possible, but another layer of difficulty. **Please donate heavily before asking about this.** 

The core of FluidNC does not know how ATCs work. There are countless types and setups so you have to program it yourself. There are 3 basic ways.

- You can add a new ATC class to FluidNC. This requires modifying the firmware by programming in C++. We do have one built in ATC class for [assisted manual tool changes](http://wiki.fluidnc.com/en/features/atc_manual).
- You can create a custom spindle class. This is very advanced stuff for expert programmers only.
- Using the m6_macro feature of spindles. This should be the preferred method for most people.

## Safety

There are a lot of safety issues with ATCs. If your machine opens the ATC while spinning, it is likely to throw that tool across the room with a razor sharp bit. That could kill you. It will also likely do serious damage to your spindle. Be careful and never trust your machine or the firmware. **You are the sole person responsible for your safety.**


# Overview of ATC types supported.


## ATC Class (C++)

You can create advanced ATC classes. Spindles can use these classes via the `atc:` config item. This allows any spindle to use any of the existing classes. 

[See this wiki page for an example](http://wiki.fluidnc.com/en/features/atc_manual)

## Special Spindle Classes

If you have an ATC that requires special interaction between the spindle and ATC, you can write a custom spindle class. All information about the tool change goes through the spindle, so you can act upon it at that level if you like.

```yaml
my_spindle:
  pwm: 5000
  ...
  atc:
  M6_macro:
  my_config_item1: 
  my_config_item2:

```
This is an advanced topic that should only be attempted by experienced programmers with deep knowledge of the FluidNC code.

## m6_macro

Each spindle in the config file can have an `m6_macro:`. This can be direct gcode (though it is unlikely due to line length limitations) or you can specify a GCode file to run with $SD/Run=myfile.gcode. You can use parameters and expressions in the gcode. This gives you access to the tool number, probe values and other information.

```yaml
pwm:
  pwm_hz: 5000
  ...
  atc:
  m6_macro: $sd/run=my_m6_mac.nc

```

## How gcode tool numbers work

The standardized gcode concept of "tool number" basically means "next tool". If the current modal value of T is 5 and you send T3, then the modal value of T is now 3. Your spindle still has tool 5 installed. The system will report T as 3. You can access the current value (i.e. the new tool number) with the `#<_current_tool>` value. The machine will continue to use the old tool with the new tool number until the M6 command is received.

## Handling different tool lengths.

Your macro needs to handle this.  Typically you zero the first tool manually or via probing. Some people use a electronic probe as tool 1 in the rack. Most people will use an electronic toolsetter to set the rest of the tools. 

## Your Gcode

You must make sure your CAM postprocessor outputs tool change gcode. The gcode will typically work like this

- Select the first tool, like T1M6. If that tool is already installed your macro should not do anything
- Turn on the spindle and set the spindle speed. Each tool should have its own speed
- Run the tool path
- Select the next tool like this T2M6. 
- Optional: M6T0 return the last tool

### Gcode behavior


These are the gcodes you will be using. This is how the machine will react to each one when using this feature.

- **M61 Q\<num\>** Used to set the tool number already installed. Typically done at startup if the tool number is not right.
  - Sets the current tool.
  - Macro is not run
  - This will change the spindle if Q<tool_num> is in the range of another spindle
- **T\<anything\>**
  - Preselects the tool. Nothing happens until an M6 comes.
  - Macro is not run
- **M6**
  - Runs the macro
- **M6 T\<current tool\> to T\<current tool\>**
  - Does nothing
- **M6 T\<outside current [spindle tool](http://wiki.fluidnc.com/en/config/config_spindles#using-multiple-spindles-and-tool-numbers) range\>**
  - Changes spindle and uses new spindles ATC config.
  
## Helpful info and hints for writing the M6 Macro

- Machine startes with _current_tool=-1, _selected_tool=0
- Be careful about [modal states](http://wiki.fluidnc.com/en/features/supported_gcodes#modal-states-and-modal-groups). If is best practice to read and restore any states that you might change. For example if you change to G91, gcode after your macro completes could be affected.
- Don't assume any modal values. For example: If you are using metric values include a G21. 
- Do a lot of testing in a safe mode (spindle locked out, etc)  before running a real job.
- If you set the tool to the same tool, the macro will still run, so be sure your macro deals with that correctly
- You should use T0 to represent a spindle without a tool in it.
- Use M61 Qx to change the _current_tool parameter.
- Nothing is stored in NVRAM. All parameters are lost at reboot. The machine offsets (G28, G30, G54-G59) are saved. It is common practice in gcode macros to save numeric values in these. They are all accessible parameters in macros. You cannot write to them directly. You should use gcode to set them in macros like `G10 L2 P5 Z<#my_val> to store a value in a work offset.

## Example Macro

This is just here to show the basic concpets and flow of an m6_macro. You will have to totally rewrite it to deal with the geometry of your machine and how you intend to deal with tool length offsets.

```
; B. Dring 3/2026
; Ths is a sample macro to demo basic tool changing using an ETS (Electronic Tool Setter)
; This assumes a simple pnuematic chuck ATC.

; TODO, things a user might add
;   - Fast then slow probing
;   - Some machines with a short Z travel, may need to alter the travel path if a tool in the
;       spindle cannot clear a tool in the rack.

; ETS Method. Compare the first tool ETS with other tool ETS and apply the delta as TLO
; This allows any type of work zeroing, Auto Probe, Touch Plate, Manual, etc
; You can use an automatic probe as one of the tools if the probe will properly trigger the ETS (see wiki)
; Set the ETS z location, so an empty collet will fail to touch the ETS.

; Work flow
;   Turn on machine
;   Home the machine
;   Tell the machine what tool is installed M61Q0 for no tool, M61Q1 for tool 1. etc
;   Zero the installed tool or auto probe
;   retract and run your gcode file
;   M6T0 will return the last tool clear the TLO

; ========================================= Macro ===========================

; all these values are in G53 (machine coords) and millimeters
#<safe_z>= -1 ; top of z (this is my safe height for XY motion)
#<tool_grab_z> = -25 ; this is the height where the collet should grab tools. 
#<ets_x> = 3    ; X location of ETS
#<ets_y> = 139  ; Y location of ETS
#<ets_z> = -42  ; max depth of probing on ETS. (just before an emtpy collet would touch)
#<ets_feedrate> = 200
; define the tool range
#<min_tool> = 1
#<max_tool>= 2
; define the tool rack locations
#<tool1_x> = 43
#<tool1_y> = 139
#<tool2_x> = 83
#<tool2_y> = 139

(print, m6_macro...Current tool:%d#<_current_tool>, Selected tool:%d#<_selected_tool>)

; create some static parameters if this is the first time through
o100 if [EXISTS[#<_have_offset>] EQ 0]
  #<_have_offset> = 0
  #<_ets_primary_z> = 0 ; ets Z of the zero'd tool
  #<_zeroed_tool> = 0; what tool was used to set the ETS 
o100 endif

; store the current toolpath location. we will return here after the tool change
#<toolpath_x> = #<_abs_x>
#<toolpath_y> = #<_abs_y>
#<toolpath_z> = #<_abs_z>
#<tool_path_motion_mode> = #<_motion_mode> ; store the motion mode to restore after ATC

; Check to see that the current tool has been set. -1 means unknown (like at turn on)
; Hint use M61Q<tool num>
o101 if [#<_current_tool> EQ -1]
  (print, Current tool is not known, Use M61Qx to set current tool)
  $Alarm/Send=10 ; spindle control alarm
o101 endif

#<was_metric> = #<_metric>
G21 ; change to metric
#<was_G91> = #<_incremental>
G90 ; work in absolute mode

o110 if [#<_current_tool> NE 0]
  (print, Return tool:%d#<_current_tool>)
  G53 G0 Z#<safe_z>
  
  o121 if [[[#<_current_tool> LT #<min_tool>] OR [#<_current_tool> GT #<max_tool>]]]
      (print, Current tool outside of range)
      $Alarm/Send=10 ; spindle control alarm. Macro ends
  o121 endif
  
  o102 if [#<_have_offset> EQ 0] ; do I need an offset?
    (print, Measuring tool:%d#<_current_tool>)
    G53 G0 X#<ets_x> Y#<ets_y>
    G53 G38.2 Z#<ets_z> F#<ets_feedrate>
    ; if probe fails the Alarm ends this macro
    #<_ets_primary_z> = #5063
    G53 G0 Z#<safe_z>
    #<_have_offset> = 1
    #<_zeroed_tool> = #<_current_tool>
  o102 endif
  
  o116  if [#<_current_tool> EQ 1]
    G53 G0 X#<tool1_x> Y#<tool1_y> ; move over tool 1
  o116  endif
  
  o118  if [#<_current_tool> EQ 2]
    G53 G0 X#<tool2_x> Y#<tool2_y> ; move over tool 2
  o118  endif
  
  G53 Z#<tool_grab_z> ; move down
  M62P0 ; open the chuck  
  G53 G0 Z#<safe_z>
  M63P0 ; close the chuck
o110 endif

o120 if [#<_selected_tool> EQ 0]
  #<_have_offset> = 0 ; work 0 is no longer valid
  G43.1 Z0 ; reset the TLO
o120 else
  (print, Pick up tool:%d#<_selected_tool>)
  G53 G0 Z#<safe_z>
  
  o121 if [[[#<_selected_tool> LT #<min_tool>] OR [#<_selected_tool> GT #<max_tool>]]]
      (print, Selected tool outside of range)
      $Alarm/Send=10 ; spindle control alarm. Macro ends
  o121 endif

  o124  if [#<_selected_tool> EQ 1]
    G53 G0 X#<tool1_x> Y#<tool1_y> ; move over tool 1
  o124  endif
  o126  if [#<_selected_tool> EQ 2]
    G53 G0 X#<tool2_x> Y#<tool2_y> ; move over tool 2
  o126 endif
  
  M62P0 ; open the chuck
  G53 Z#<tool_grab_z> ; move down  
  M63P0 ; close the chuck
  G53 G0 Z#<safe_z>  
  
  ; if the old tool was 0, we do not have a valid work Z0
  o127 if [#<_current_tool> NE 0]
    o128 if [#<_selected_tool> EQ #<_zeroed_tool>]
      (print, reset TLO)
      G43.1 Z0 ; remove the offset
    o128 else    
      ; probe the new tool
      G53 G0 X#<ets_x> Y#<ets_y>
      G53 G38.2 Z#<ets_z> F#<ets_feedrate>
      ; if probe fails the Alarm ends this macro
      G53 G0 Z#<safe_z>

      ; determine TLO (Tool Length Offset)
      #<this_touch_z> = #5063
      #<new_tlo> = [ #<this_touch_z> - #<_ets_primary_z>]
      (print, TLO set to %f#<new_tlo>)
      G43.1 Z#<new_tlo>
    o128 endif
  o127 endif
  
  M61Q#<_selected_tool> ; success, set the current tool number
  
o120 endif

(print, return to toolpath)
; return to toolpath
G53 X#<toolpath_x> Y#<toolpath_y>
G53 Z#<toolpath_z>

; restore units mode G20/G21
G[20+#<was_metric>]
; restore units mode G90/G91
G[90+#<was_G91>]

(print, Tool change complete)

```
  