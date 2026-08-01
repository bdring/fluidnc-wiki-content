---
title: GCode Senders
description: 
published: true
date: 2026-08-01T19:39:05.795Z
tags: 
editor: markdown
dateCreated: 2022-07-22T14:10:15.992Z
---

# Grbl GCode Senders

FluidNC is designed to have basic compatibility with Grbl senders using the USB/Serial connection. The compatibility is focused on running your machine and sending gcode.

It is not compatible with Grbl on how you set up parameters and options. FluidNC has a vastly more flexible and comprehensive system. The Grbl $$ settings and compile time options were far too limiting, so we created the config file system.

Below are some links to some gcode senders. They have not all been tested with FluidNC. If you want to add one to this list, let us know.

## AxioCNC

<img src="https://axiocnc.com/media/screen-setup.png" width="500">
AxioCNC is a free open source sender.  It's web-based with a modern and themeable UI and support for joysticks, webcams, a tool library, multiple probing methods, tool wear tracking, and more.

* [AxioCNC Website](https://axiocnc.com/)
* [AxioCNC Github](https://github.com/rsteckler/axiocnc)

## Universal GCode Sender (aka UGS)

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/ugs.png" width="500">

[Website](https://winder.github.io/ugs_website/)

## LaserGRBL

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/lasergrbl.jpg" width="500">

* [Website](https://lasergrbl.com/)

## LaserWeb4

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/LaserWebDec2016.png" width="600">

* [Github](https://github.com/LaserWeb/LaserWeb4)
* [Website](https://cncpro.yurl.ch/)

## Candle

<img src="https://github.com/Denvi/Candle/raw/master/screenshots/screenshot_heightmap_original.png" width="600">

* [Website](https://github.com/Denvi/Candle)

## CNCJS

After connecting, click the reset button to sync Grbl_ESP32 and CNCJS

<img src="https://cloud.githubusercontent.com/assets/447801/24392019/aa2d725e-13c4-11e7-9538-fd5f746a2130.png" width="600">

* [Website](https://cnc.js.org/) 

## Grbl-Plotter

<img src="https://github.com/svenhb/GRBL-Plotter/raw/master/doc/GRBLPlotter_GUI.png" width="400">

* [Website](https://github.com/svenhb/GRBL-Plotter)

## Focus - 6-Axis PC Based CNC Control System

<img src="https://cdn.sourcerabbit.com/Data/FluidNCWiki/Focus.png" width="600">

* [Website](https://www.sourcerabbit.com/Shop/pr-i-91-t-focus-cnc-control-software.htm)

## LightBurn (Lasers)

<img src="http://www.buildlog.net/blog/wp-content/uploads/2021/01/lightburn.png" width="600">

* [Website](https://lightburnsoftware.com/)
* [FluidNC wiki page](http://wiki.fluidnc.com/en/support/senders/lightburn)

## EstlCAM

* [Website](https://www.estlcam.de/)

## bCNC

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/bCNC.png" width="600">

- [Website](https://github.com/vlachoudis/bCNC)

## Chilipeppr

<img src="https://github.com/bdring/Grbl_Esp32/wiki/images/chilipeppr.jpg" width="600">

- [Website](http://chilipeppr.com/jpadie)

## OpenCNCPilot
<img src="https://github.com/bdring/FluidNC/wiki/images/senders/opencncpilot.png" width="600">

* [Github](https://github.com/martin2250/OpenCNCPilot)

## Grbl Panel

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/Grbl-Panel-Example.jpg" width="600">

- [Website](https://github.com/gerritv/Grbl-Panel/wiki)

## Ultimate CNC

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/ultimate_cnc.png" width="600">

- [Website](https://ultimatecnc.softgon.net/en/home)

## OpenBuilds CONTROL
<img src="/openbuilds_control.png" width="600" alt="OpenBuilds CONTROL screenshot" />

CONTROL connects to the websocket of the wifi build out of the box.

* [Website](https://software.openbuilds.com)
* [FluidNC Integration Issue](https://github.com/OpenBuilds/OpenBuilds-CONTROL/issues/283)

## Wing Hot Wire Gcode Sender

Create, edit, and send gcode for hot wire foam cutting.

![wing_hot_wire.jpg](/wing_hot_wire.jpg =x450)

- [Website](https://hackaday.io/project/205440-wing-hot-wire-cnc-foam-cutter-gcode-streamer)
- 

## Fluid Control
<img src="https://mitov84.github.io/images_fluid/Wiki_feature.png" width="600" alt="Fluid Control feature image" />

Fluid Control: 
- [Android app](https://artisans3d.com/projects/fluid-control-android-app/), connects to Telnet over Wi-Fi. Freemium.
- [iOS, iPadOS app](https://artisans3d.com/projects/fluid-control-pro-ios-application/), connects to Telnet over Wi-Fi. Subscription based.


# Developer Info

## Startup

Original Grbl was based on Arduinos which typically reboot when you connect to them. When a sender opens a connection it can immediately recognize Grbl by the initial messages it sends.

FluidNC prefers not to be rebooted when connected. FluidNC supports multiple connection types including Wifi and Bluetooth. Rebooting would break those connections and could kill a job that is already running. Those connections can take a long time to re-establish.

Here is a good flowchart to determine the version (FluidNC, Grbl, etc) in all cases.

![sender_flowchart.png](/support/sender_flowchart.png)

```
Grbl 3.4 [FluidNC v3.4.2 (wifi) '$' for help]
```

If your sender is very picky about the exact text and revision in the message you can change it with the **\$Start/Message** [command](/features/commands_and_settings#start_message).

We do not want any connection to arbitrarily reboot the firmware. This means some senders will not see the message. Most controllers or ESP32 modules will have a manual reset button.

If you have issues or questions about these, please consider contacting those developers before contacting us.
