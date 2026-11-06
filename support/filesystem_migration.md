---
title: File System Migration
description: 
published: true
date: 2026-08-01T19:38:59.698Z
tags: 
editor: markdown
dateCreated: 2022-09-22T13:37:37.652Z
---

# File System Migration

The local file system is the area of the ESP32's on-module FLASH that holds files such as your FluidNC config file and the WebUI's index.html.gz.  There are two formats for it: SPIFFS, the older one, and LittleFS, which is more reliable and supports real subdirectories.  FluidNC has supported LittleFS since release 3.6.2.

**FluidNC versions later than v4.1.1 support only LittleFS.**  If your controller still has a SPIFFS local file system, convert it to LittleFS *before* you install a later version.

### If you are not sure which file system you have

Convert anyway.  Both methods below are safe on either kind: on a file system that is already LittleFS they just rewrite it as LittleFS with the same files.

### Converting with an SD card

On your current firmware (v4.1.1 or earlier), send `$LocalFS/Migrate`.  It copies all the files on the local file system to the SD card, reformats the local file system as LittleFS, then copies the files back.  The copies stay on the SD card in `/localfs_copy`.

Then install the new version.

### Converting without an SD card

1. Save copies of your files, especially your config file, to a computer, using WebUI or FluidTerm.
2. On your current firmware, send `$LocalFS/Format=littlefs`.  This erases the local file system and creates an empty LittleFS one.
3. Upload your files again with WebUI or FluidTerm's CTRL-U upload.

Then install the new version.

### If you upgraded without converting

A later version will not erase a SPIFFS file system.  It starts without a local file system and reports:

```
[MSG:ERR: Local FS is not LittleFS (old SPIFFS?); $LocalFS/Format erases it]
```

Your files are still there.  You can either:

- Reinstall v4.1.1, convert as described above, then upgrade again; or
- Send `$LocalFS/Format` to erase the old file system and create a LittleFS one, then upload your files again (for example with install-fs from the installer, WebUI, or FluidTerm).

The same message appears if a LittleFS file system has been damaged.  `$LocalFS/Format` fixes that too.

### Other commands

These commands work on any version that supports LittleFS:

```
$LocalFS/Backup  - copies everything on the local fs to /sd/localfs_copy
$LocalFS/Restore - copies /sd/localfs_copy back to the local fs
$LocalFS/Format  - erases the local fs and creates an empty LittleFS file system
```

You should always keep copies of important files like your config file on a separate computer.
