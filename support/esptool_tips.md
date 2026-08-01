---
title: esptool tips
description: 
published: true
date: 2026-08-01T19:38:44.232Z
tags: 
editor: markdown
dateCreated: 2023-04-22T19:35:20.632Z
---

# Using esptool with FluidNC 

## Overview

esptool is a program that comes from Espressif. It is what we use to program the ESP32 and is included in our releases. It can also do many other things that you might find useful. The full Espressif [documentation is here](https://docs.espressif.com/projects/esptool/en/latest/esp32/), but it can be a little overwheling. This page has simplified tips for FluidNC users.

It is available as a python program or a compiled exe. The examples here are using the exe in windows. It is located in the win64 folder of the release package and all examples were run from a command prompt that folder.

Wherever you see COM\<number\> use the one your computer is using.

## Getting information about your ESP32 chip.

This can be used to get the details of the chip and the RAM size.

`.\esptool.exe -p COM4 flash_id`

```
Detecting chip type... ESP32
Chip is ESP32-D0WDQ6 (revision 1)
Features: WiFi, BT, Dual Core, Coding Scheme None
Crystal is 40MHz
MAC: 30:ae:a4:1b:ef:b8
Uploading stub...
Running stub...
Stub running...
Manufacturer: c8
Device: 4016
Detected flash size: 4MB
```

## Completely erase the flash memory

To erase the entire flash chip (all data replaced with 0xFF bytes):

`.\esptool.exe --chip esp32 -p COM4 erase_flash`


```
Chip is ESP32-D0WD-V3 (revision 3)
Features: WiFi, BT, Dual Core, 240MHz, VRef calibration in efuse, Coding Scheme None
Crystal is 40MHz
MAC: d4:d4:da:1f:5a:6c
Uploading stub...
Running stub...
Stub running...
Erasing flash (this may take a while)...
Chip erase completed successfully in 4.8s
```
