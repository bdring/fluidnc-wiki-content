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
As of release 3.6.2, we support LittleFS as an alternative to SPIFFS for the local filesystem.  The local filesystem in an area in the ESP32's on-module FLASH that stores files like the FluidNC YAML config file and the index.html.gz file that implements WebUI.  SPIFFS and LittleFS are different ways of managing that region of FLASH so it can contain files.  SPIFFS is the older of the two, with some well-known deficiencies and reliability issues.  LittleFS is a more modern and better way of doing it.  LittleFS is less prone to strange failures, and also supports real subdirectories (with SPIFFS it was possible to simulate subdirectories with a hack that did not work very well).

From a day to day usage standpoint, there is no difference in the commands and procedures that you use.  But if you switch to LittleFS, it should be more reliable, especially if you do a lot of uploads to the local filesystem.  Also you will be able to put subdirectories on the local filesystem - although most people have little or no need for that feature.

At some point we might drop SPIFFS support entirely, but for now we support them both so you can migrate from SPIFFS to LittleFS with ease, and also revert to SPIFFS if necessary.

When you install the FluidNC filesystem for the first time with "install-fs", the format will be SPIFFS.  It has always worked that way and will continue until some (well in the) future release.

All of the code that uses local files works the same way with either filesystem.  When you do something that refers to "localfs", the code knows which filesystem (SPIFFS or LittleFS) is present and does the right thing.  Long ago we named the relevant command names as "localfs/something" instead of "spiffs/something" in anticipation of this changeover.

### Switching Filesystems

Versions 3.6.2 and later have commands to switch between SPIFFS and LittleFS.  The primary command is `$localfs/migrate`.  It saves a copy of all the files on your existing SPIFFS filesystem on the SD card, reformats the localfs area into LittleFS format, then copies the saved files back to the new LittleFS filesystem.

If you want to go back you can send `$localfs/migrate=spiffs`.

Obviously this only works if you have an SD card.

### Recovery and Other Unusual Cases

If you have migrated to LittleFS but then install an old firmware version that does not recognize the LittleFS layout, one the first boot it will automatically reformat to SPIFFS, losing all the files that were there.  If that happens, you will need to reload those files, either from WebUI or FluidTerm's CTRL-U upload or with install-fs from the installer.

You should always keep copies of important files like your config file on a separate computer.  If you converted to LittleFS with the migrate command, there will also be copies of the files, as of when you did the migrate, on the SD card in the /localfs directory.  

In addition to the "do it all" migrate command, there are lower-level commands that perform the individual steps.

```
$localfs/backup  - copies everything on the local fs to /sd/localfs/*
$localfs/format=littlefs - reformats the local fs to LittleFS
$localfs/format=spiffs - reformats the local fs to SPIFFS
$localfs/restore - copies /sd/localfs/* to the local fs
```
If you do not have an SD card, you could use the format command to establish an empty filesystem, then populate it with WebUI or FluidTerm uploads from a host computer.

The commands above are not present in old firmware versions; they first appeared in the first release that supports LittleFS.
