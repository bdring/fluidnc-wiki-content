---
title: Using FluidTerm
description: Using the FluidTerm Console
published: true
date: 2026-08-01T19:37:01.336Z
tags: 
editor: markdown
dateCreated: 2022-07-21T19:56:47.294Z
---

# FluidTerm Usage

## Screenshot

![fluidterm_01.png](/fluidterm_01.png)

## Overview

Fluidterm is a very simple serial terminal that makes it a little easier to interact with FluidNC during setup and configuring. It is not a gcode sender or meant to be a good interface to control the machine. 

## Downloading FluidTerm

It is included with the [firmware releases](https://github.com/bdring/FluidNC/releases) at Github. Download and unzip the zip the files to your computer.

It a script file in the root folder of the downloaded files. The script is **fluidterm.bat** for Windows and **fluidterm.sh** for Mac and Linux.

## Character Echo

Fluidterm automatically puts FluidNC into character echo mode when started or resetting with **CTRL+R**. This is essential to use the [advanced terminal mode](http://wiki.fluidnc.com/en/features/serial_terminals#advanced-terminal-mode) of FluidNC.

If you restart the controller using a method other than sending **CTRL+R**, like  the **$Bye** command, via a CPU reset button or after a crash, you will need to send a key to restart the echo. Otherwise you will not see the typed characters. The tab key works well for this.

When Fluidterm is closed the echo will turn off to return the feature to it's default state. You can also use CTRL+L to turn off the echo.

## Reseting the ESP32

Send **Ctrl+R** to reset the ESP32 using the control lines of the serial port. 

## Uploading Files (Using XModem)

You can upload files to the local file system or the SD card.

- Send Ctrl+U to start the process.
- Select the file you want to upload.
- Enter the filename you want it saved as. 
  - If you just press enter it will use the same filename and save it to the local file system
  - If you prefix it with **/sd/**, like **/sd/foo.txt**, it will save to the SD card.
  
## Uploading via command line options.

You can use FluidTerm to upload files as part of a script.

`fluidterm -p COM3 -u files\myprog.gc -r /sd/program1.gc`

### Parameters

- `-p` This allows you to specify the COM port. If this parameter is not used, it will automatically select the COM port if only ose exist. If more than one exist, you will have to select if from a list.

- `-u` This indicates you want to upload a file.

- `-r` This is used to specify the filename on the remote device (the controller). If the filename is omitted, the uploaded file will be placed in localfs with a name the same as the tail name of the source file, for example /localfs/myprog.gc per above.

 

## Sending Realtime Characters

Realtime characters that can be sent from the key board are...

 - `!`  Cycle Stop
 - `~`  Resume
 - `?`  Status
 - `CTRL+X` Reset

The ones that are non printable and not on a keyboard can be sent with the CTRL+O key then the following 2 characters codes.

```
sd Safety Door
jc JogCancel
dr DebugReport
m0 Macro0
m1 Macro1
m2 Macro2
m3 Macro3
fr FeedOvrReset
f> FeedOvrCoarsePlus
f< FeedOvrCoarseMinus
f+ FeedOvrFinePlus
f- FeedOvrFineMinus
rr RapidOvrReset
rm RapidOvrMedium
rl RapidOvrLow
rx RapidOvrExtraLow
sr SpindleOvrReset
s> SpindleOvrCoarsePlus
s< SpindleOvrCoarseMinus
s+ SpindleOvrFinePlus
s- SpindleOvrFineMinus
ss SpindleOvrStop
ft CoolantFloodOvrToggle
mt CoolantMistOvrToggle
```

## Quitting

Send **Ctrl+Q** to quit 
