---
title: WebUI
description: A web browser based controller.
published: true
date: 2026-08-01T19:36:43.308Z
tags: 
editor: markdown
dateCreated: 2023-09-10T15:13:46.506Z
---

# WebUI

![webui.png](/webui/webui.png)

The WebUI is a web browser based controller for FluidNC. It is a separate project from FluidNC. It can only be used via WiFi.

## Development

The FluidNC team does not currently have a developer for the WebUI. We only do small tweaks and fixes at this time. We would welcome any help we can get on this project.  

## Source Code

It is a fork of [ESP3D](https://github.com/luc-github/ESP3D-WEBUI). The FluidNC fork is [located here](https://github.com/MitchBradley/ESP3D-WEBUI). The current active branch is [revamp](https://github.com/MitchBradley/ESP3D-WEBUI/tree/revamp).

FluidNC also works with WebUI version 3, via [this fork](https://github.com/michmela44/ESP3D-WEBUI/tree/3.0-FluidNCDev).

# Usage

> This page is a work in progress and very incomplete right now. Please help us or donate to the project.
{.is-info}


## Installation

The WebUI will automatically be installed with the firmware if you are using the **install-fs** program from a release. It is a file called **index.html.gz** that is installed in the [local file system](http://wiki.fluidnc.com/en/features/local_file_system). You can manually upload a different version at any time. The Web Installer allows you to pick WebUI version 2 or 3 when flashing FluidNC.

## Reporting

The flow of information can be controlled in 2 ways.

- **Auto**. In this mode FluidNC sends the status to the WebUI. It sends updates whenever status changes and at regular intervals during moves. This mode can make the status display appear to be more responsive.

- **Poll**. In this mode the WebUI sends requests to FluidNC.

These values can be saved in the preferences.

> Setting the update frequency too low can cause excessive load on the ESP which may affect operations. Proceed with care.
{.is-info}

![webui_reporting.png](/webui/webui_reporting.png)

## Controls Panel

![webui_ctrl.png](/webui/webui_ctrl.png)

This shows you the current positions of the axes in ["work" and "machine" coordinates](http://wiki.fluidnc.com/en/support/machine_space_and_homing). The number of axes displayed is based on how many you have in your config file.

The jog speeds are controlled at the bottom of the panel. There are only three axes shown in the jog section at a time, but the Z can be changed to A, B or C.

## Macros

The section to the right of the jog panel is used for creating macros.

![webui_macros.png](/webui/webui_macros.png =x400)

It stores your macro config in a file called macrocfg.json. This is the format of that file.

```json
[
 {
  "name": "M1",
  "glyph": "star",
  "filename": "/macro1.g",
  "target": "ESP",
  "class": "btn-default",
  "index": 0
 },
 {
  "name": "M2",
  "glyph": "star",
  "filename": "/macro2.g",
  "target": "ESP",
  "class": "btn-default",
  "index": 1
 },
 {
  "name": "M3",
  "glyph": "star",
  "filename": "/macro3.g",
  "target": "ESP",
  "class": "btn-default",
  "index": 2
 },
 {
  "name": "M4",
  "glyph": "star",
  "filename": "/macro4.g",
  "target": "ESP",
  "class": "btn-default",
  "index": 3
 },
 {
  "name": "M5",
  "glyph": "star",
  "filename": "/macro4.g",
  "target": "ESP",
  "class": "btn-default",
  "index": 4
 },
 {
  "name": "",
  "glyph": "",
  "filename": "",
  "target": "",
  "class": "",
  "index": 5
 },
 {
  "name": "",
  "glyph": "",
  "filename": "",
  "target": "",
  "class": "",
  "index": 6
 },
 {
  "name": "",
  "glyph": "",
  "filename": "",
  "target": "",
  "class": "",
  "index": 7
 },
 {
  "name": "",
  "glyph": "",
  "filename": "",
  "target": "",
  "class": "",
  "index": 8
 }
]
```

## FluidNC Tab

This allows you to view the config. You can change some of the settings, but many cannot be changed at run time. This feature will likely be completely changed or removed in the future.

The five buttons across the top are...

- **Show system status** This shows the system status (not CNC related stuff)
- **Manage local files** This allows you to manage the [local file system](http://wiki.fluidnc.com/en/features/local_file_system). The most common use for this is to update the [WebUI](http://wiki.fluidnc.com/en/features/webui).
- **Update the firmware** This allows you to do an OTA (over the air) firmware update. It requires a firmware.bin file. you can find the firmware.bin file in the github release zip files in the wifi and bt folders.
- **Restart FluidNC** This reboots the controller. You will lose the WiFi connection.
- **Refresh the settings** 

![webui_fnc_tab.png](/webui/webui_fnc_tab.png)

## Tablet Tab

This table is optimized for touch screen tablet usage. It has large buttons and scales to the display size.

![webui_tablet_tab.png](/webui/webui_tablet_tab.png)

## Preferences

You can control some of the features, like displaying the probing panel of the WebUI and save many settings in the preferences panel. You access this from the hamburger menu in the upper right corner of the WebUI.

![webui_prefs.png](/webui/webui_prefs.png)



