---
title: Local File System (Flash Memory)
description: Using the File System on the ESP32
published: true
date: 2026-08-01T19:36:18.327Z
tags: 
editor: markdown
dateCreated: 2022-07-21T19:53:36.361Z
---

# Overview

The local file system is on the ESP32 device, in its FLASH memory. It is used to store the WebUI files, config files and small gcode files for macros. The space is very limited, so not much can fit on it. It works very similar to the SD card with the commands being prefixed with **LocalFS**, rather than **SD**.

> Note: The local file system is implemented with either **SPIFFS** or, going forward, **LittleFS**. Both are ways to store files in a FLASH device. If you see a reference to either SPIFFS or LittleFs, it is the same thing as LocalFS in this case.
{.is-info}

> By default the FluidNC webserver will refuse to fetch any files from the Flash filesystem (including reloading WebUI) unless your machine is idle. This prevents FS access from hogging FLASH bandwidth when the CPU might need to load more code to memory.
> This safety measure is controlled by the `$HTTP/BlockDuringMotion` setting (since **v3.6.8**).
{.is-warning}



# Console Commands

## Listing Files

Send **$LocalFS/List**. The results will look similar to the report below.

```
[FILE:/index.html.gz|SIZE:122477]
[FILE:/3axis_v4.yaml|SIZE:1762]
[FILE:/favicon.ico|SIZE:1150]
[Local FS Free:44.86 KB Used:124.52 KB Total:169.38 KB]
```

## Showing Text Files

Send **$LocalFS/Show=\<filename\>**. This is a good way to check the contents of things like config files.

**Example**

```
$localfs/show=fluidnc_pen_laser_2209.yaml
name: TMC2209 XY Servo Laser
board: FluidNC Pen/Laser 2209
meta:
stepping:
  engine: RMT
  idle_ms: 255
...

ok
```

## Running Files

Send **$LocalFS/Run=\<filename\>**. This is used to run gcode files.  Use this only for very short files like macros.  Running long files from the local FLASH filesystem can cause system crashes due to conflicts with the ESP32's use of FLASH for running CPU instructions.
## Formatting

Send **$LocalFS/Format**. This will reformat the LocalFS. If you are having trouble loading files when there should be enough space, try reformatting.

## Deleting Files

Send **$Localfs/Delete=\<filename\>**

## Renaming files.

Send `$Localfs/Rename=oldname>newname` to rename an existing file on the localfs. 

## Getting the Size

Send **$LocalFS/Size**. The results will look similar to the report below.

```
SPIFFS  Total:169.38 KB Used:124.52 KB
```

# WebUI Use

You can access the LocalFS on the FluidNC tab. Click the green icon.

<img src="https://github.com/bdring/FluidNC/wiki/images/localfs_dialog.png" width="500">

- Upload files with the upload button
- Download files by clicking on the filename in the list
- Delete with the trash can icon.