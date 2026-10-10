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

The WebUI is a web browser based controller for FluidNC. It is a separate project from FluidNC. It can only be used via WiFi or Ethernet.

The webUI is served to a web browser from FluidNC. It is a file that in the localfs (local file system) called index.html.gz. You can upgrade or change it by uploading a new version of the file.

You can also keep several WebUIs on the SD card and choose between them in the browser. See [Multiple WebUIs](#multiple-webuis).

## Versions

There are currently 3 WebUI options to choose.

The locations of the files are [stored here](https://github.com/bdring/FluidNC/blob/9c690fb235eefa391affc614f2d40fe5fc5cec48/build-release.py#L89).

### WebUI2

This is the original version

![webui.png](/webui/webui.png)

### WebUI3

This is an upgraded version of the original WebUI

![webui.png](/webui/webui3.png)

### FigUI

This is an independent specifically targeting FluidNC

![webui.png](/webui/figui.png)

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

## Multiple WebUIs

Besides the WebUI in the local file system, FluidNC can serve any number of WebUIs from the directory given by `$HTTP/UIDir`, which is `/sd/ui` by default. Each WebUI goes in its own subdirectory, which holds its `index.html.gz` (or `index.html`):

```
/sd/ui/webui2/index.html.gz
/sd/ui/webui3/index.html.gz
/sd/ui/figui/index.html.gz
```

This lets you try another WebUI, or a newer version of yours, without replacing the one you use. It also gives a home to WebUI builds that are too large for the local file system.

Subdirectory names can contain letters, digits, `-`, `_` and `.`. Other subdirectories are ignored.

`$HTTP/UIDir` can name a directory on either file system, for example `/localfs/ui`. Set it to an empty value to turn this feature off.

### Opening a WebUI

- `http://fluidnc.local/ui/` lists the installed WebUIs. Click one to open it.
- `http://fluidnc.local/ui/webui3/` opens the WebUI in the `webui3` subdirectory. You can bookmark it.
- To open a WebUI from the plain address `http://fluidnc.local/`, set `$HTTP/DefaultUI` to its subdirectory name, for example `$HTTP/DefaultUI=webui3`. If that WebUI is not present, `/` serves the local file system's WebUI as before.
- `http://fluidnc.local/?forcefallback=yes` always shows the built-in file manager page, whatever is installed.

Different browser tabs can use different WebUIs at the same time.

### Installing a WebUI

Copy the WebUI's `index.html.gz` into a subdirectory of `ui` on the SD card, either with a computer or over the network. To upload it over the network:

```
curl -T index.html.gz http://fluidnc.local/ui/webui3/index.html.gz
```

The upload creates the subdirectory if it does not exist. You can also use [WebDAV](http://wiki.fluidnc.com/en/support/interface/http-rest-api#webdav), at `http://fluidnc.local/sd/ui/`.

### Preferences and macros

A WebUI that supports `/ui` keeps its preferences and macros in its own subdirectory, so WebUIs do not overwrite each other's settings. WebUI2 supports this. The first time such a WebUI opens from `/ui`, it starts from the preferences and macros in the local file system. Once you save them, it uses its own copies.

Other WebUIs keep using the files in the local file system, as they always have.

The same applies to connections. Two WebUIs that support `/ui` can be open in the same browser without interfering with each other. With other WebUIs, opening one can disconnect another that is open in the same browser. This is also what happens with two tabs of the same WebUI.

### While a job is running

When `$HTTP/BlockDuringMotion` is on, which is the default, FluidNC does not read WebUI files while the machine is moving. So during a job, a WebUI from `/ui` can only be reloaded if the browser already has a copy cached. Otherwise you see the "Cannot load WebUI while GCode Program is Running" page. The `/ui/` list and uploads are also unavailable until the machine stops.

### For WebUI developers

A WebUI served from `/ui/<name>/` works unchanged if it uses absolute URLs such as `/command`. To keep its own session and state files, it should address these relative to its page instead:

- **WebSocket**: connect to the page's own URL, `ws://<host>/ui/<name>/`, just as a WebUI served from `/` connects to `ws://<host>/`.
- **Commands**: `/ui/<name>/command` and `/ui/<name>/command_silent` take the same arguments as `/command` and `/command_silent`.
- **State files**: `GET /ui/<name>/<file>` reads a file in the WebUI's subdirectory, and `PUT /ui/<name>/<file>` writes one.
  - The body of a PUT is the file's contents, not a multipart form. Do not send it as `application/x-www-form-urlencoded`.
  - The PUT answers 201 if it created the file and 204 if it replaced it. It answers 503 when the machine is moving and `$HTTP/BlockDuringMotion` is on.
  - The file is written under a temporary name and renamed when complete, and missing subdirectories are created.

When the page is loaded from `/ui/<name>/`, FluidNC sets a `uiSession` cookie with `Path=/ui/<name>/`. The browser sends it only with requests under that path, and FluidNC uses it in place of the browser-wide `sessionId` cookie to route command output to the right WebSocket. The page has to be loaded from `/ui/<name>/` itself, not from `/ui/<name>/index.html`, for the cookie to be set.

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



