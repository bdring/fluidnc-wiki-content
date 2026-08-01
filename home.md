---
title: FluidNC Wiki Home Page
description: FluidNC CNC Firmware Wiki Homepage
published: true
date: 2026-08-01T19:32:15.226Z
tags: 
editor: markdown
dateCreated: 2022-07-20T23:05:11.393Z
---

# Overview
![fluidnc.svg](/fluidnc.svg)

## Introduction

**FluidNC** is a CNC firmware optimized for the ESP32 controller. It is the next generation of firmware from the creators of Grbl_ESP32. It includes a web based UI and the flexibility to operate to a wide variety of machine types. This includes the ability to control machines with multiple tool types such as laser+spindle or a tool changer.

See [Installation](/en/installation) for a quick start guide to installing FluidNC on your machine.

## Wiki Search

> **Wifi Search:** Not all wiki content is linked via the navigation panel. Please use the search feature if you are not finding what you are looking for. You can also change the navigation panel to a file browser type interface to see all pages. 
{.is-info}


## Firmware Architecture

- Object-Oriented hierarchical design
- Hardware abstraction for machine features like spindles, motors, and stepper drivers
- Extensible - Adding new features is much easier for the firmware as well as gcode senders.

## Machine Definition Method

There is no need to compile the firmware. You use an installation script to upload the latest release of the firmware and then create a [config file](/config/overview) text file that describes your machine.  That file is uploaded to the FLASH on the ESP32 using the USB/Serial port or Wifi.  There are many example config files for different setups that you can use as starting points.  [FluidNC Web Installer](http://wiki.fluidnc.com/en/installation#fluidnc-web-installer) has a graphical setup feature that guides you through the process.

There are some tools to help you or an AI assistant generate and validate config files;  see [AI Config File Helpers](http://wiki.fluidnc.com/en/config/overview#ai-config-file-helpers).

## Grbl Compatibility

FluidNC is compatible with Grbl for day-to-day operations like running GCode programs from a sender.  FluidNC's GCode flavor is upward-compatible with Grbl's, so CAM post programs for Grbl generate code that FluidNC will run correctly.

FluidNC configuration, however, is very different from Grbl.  Grbl is configured in two ways - with **\$number** commands and by editing C source/header files and then recompiling.  Grbl's **\$number** commands (for example **\$100**) let you set motion parameters like maximum speeds and a few aspects of limits and homing.  For deeper settings like controller pin assignments and spindle types, you must recompile Grbl after changing C language header files.  FluidNC is instead configured with a text file as described in the previous section.


Some Grbl senders have "setup wizards" providing a user-friendly interface to Grbl's **$number** commands.  Those wizards will not work with FluidNC because FluidNC does not implement all of the **\$number** commands - and even if it did, those old wizards would not know about the many, many new FluidNC configuration possibilities that go far beyond conventional Grbl capabilities.  But the older senders will still be able to control FluidNC and run GCode programs after the setup and configuration has been done by other means.

FluidNC does implement a very small number of **\$number** commands that mimic Grbl's.  You can see a list of them by sending **$$**.  They are not used for configuring FluidNC, but instead to report a very limited amount of information to old senders that do not have FluidNC support.  There are a few senders that issue such commands at startup in order to discover whether, for example, homing is enabled.  FluidNC implements them as read-only, so the old senders can start up properly, but does not let you use them to make changes (the config file is for changes).

## WebUI

FluidNC includes a built-in browser-based Web UI ([ESP3D-WebUI](https://github.com/luc-github/ESP3D-WEBUI)) so you control the machine from a PC, phone, or tablet on the same Wifi network.  WebUI is a separate project, but the FluidNC team maintains a separate fork with some enhancements - notably an alternative tablet mode that is optimized for use on a tablet computer, including a GCode visualizer - and with support for some FluidNC-specific features.  The source code for our fork is at https://github.com/MitchBradley/ESP3D-WEBUI/tree/revamp

To use the WebUI, install the wifi version of FluidNC, set FluidNC to connect to your local WiFi network, and browse to `fluidnc.local`

WebUI now has two main versions, 2 and 3.  The standard FluidNC installation gets you version 2, but you can replace it with version 3 by going to https://github.com/michmela44/ESP3D-WEBUI/tree/3.0-FluidNCDev .

## Credits

The original [Grbl](https://github.com/gnea/grbl) is an awesome project by Sungeon (Sonny) Jeon. I have known him for many years and he is always very helpful. I have used Grbl on many projects.

The Wifi and WebUI is based on [this project.](https://github.com/luc-github/ESP3D-WEBUI)

The FluidNC team thanks the following people for game-changing contributions to the code base:

https://github.com/odaki - wrote the I2S driver that enables output expansion.  That feature was crucial for creating flexible controller boards that support multiple axes and different use scenarios, instead of having to make different boards to allocate the limited number of ESP32 GPIOs to different functions.

https://github.com/atlaste - wrote the code to configure FluidNC from a yaml text file, and taught us to use C++ effectively.  The yaml-file configurability eliminates the need for every user to compile their own private version of FluidNC.

## Discussion

![discord-logo_trans.png](/discord-logo_trans.png =x80) 
We have a [Discord server](https://discord.gg/j29vtknJnU) for the support and development of this project.


## Donations

This project requires a lot of work and often expensive items for testing. Please consider a safe, secure and highly appreciated donation via the PayPal or Github Sponsor links below. 

When we provide support for cheap Chinese or DIY controllers it takes time away from FluidNC development. Those controllers are cheap because those sellers don't support them. You really should donate if we helped you.

Feel free to choose any person below. We work together and are happy for whoever receives the donation.

---

To Mitch Bradley for FluidNC firmware and support

![paypal-logo.png](/paypal-logo.png =x80)[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=8DYLB6ZYYDG7Y)

---

To Bart Dring for FluidNC firmware and support

![github-logo.png](/github-logo.png =x78)[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://github.com/sponsors/bdring)

---

To Joacim Breiler (Web Installer, UGS and lots of FluidNC support help)

![github-logo.png](/github-logo.png =x78)[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://github.com/sponsors/breiler)

---

To Luc for WebUI firmware

![paypal-logo.png](/paypal-logo.png =x80)[![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FQL59C749A78L)

 


> If you donate and are on our Discord server, please let us know your Discord username. We can tag you as a sponsor. This gives you a sponsor badge next to your name and hopefully encourages others to sponsor FluidNC. 
{.is-info}

## Follow Us

[![instagram_icon.png.webp](/logos/instagram_icon.png.webp =x50)](https://www.instagram.com/fluidnc_cnc_firmware/#)
