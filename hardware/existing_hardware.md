---
title: Existing Hardware
description: Hardware that runs FluidNC
published: true
date: 2026-08-11T15:32:21.416Z
tags: 
editor: markdown
dateCreated: 2022-07-21T12:57:33.399Z
---

# Overview

Here is some hardware that runs FluidNC. Some are open source and some are available for purchase.

> Please don't buy a cheap controller that you know is not supported by the supplier or manufacturer and expect free support from the FluidNC develpers.
{.is-warning}

If you want to add something to this page, [read this first](http://wiki.fluidnc.com/en/hardware/existing_hardware#how-do-i-add-a-new-controller-to-this-page). 


***

# Controllers still in production

These are controller that are still available for purchase as far as we know.

##  6x CNC Controller

- **Open Source:** [Yes](https://oshwlab.com/bdring/6-pack-2-0_copy_copy_copy)
- **Wiki Page:** [Yes](http://wiki.fluidnc.com/en/hardware/official/6x_CNC_Controller)
- **FluidNC Supporter:** Yes (project founder)
- **Discord Name** @bartdring 
- **For Sale:** [With ESP32 on board](https://www.tindie.com/products/33366583/6x-cnc-controller-for-fluidnc-integrated-esp32/) or [Uses ESP32 Module](https://www.tindie.com/products/33366583/6x-cnc-controller-for-fluidnc/) or via my [International Distributor Elecrow](https://www.elecrow.com/6x-cnc-controller-for-fluidnc.html)
- **Description:** 6 Axis external driver controller that supports many spindle types.


![6x_cnc_controller.jpg](/hardware/6x_cnc_controller.jpg =x500)

## Doberman ESP32-S3

![doberman_top_view.jpg](/hardware/doberman/doberman_top_view.jpg =x500)

- **Open Source:** [Yes](https://oshwlab.com/bdring/doberman)
- **Wiki Page:** [Yes](http://wiki.fluidnc.com/en/hardware/official/doberman)
- **FluidNC Supporter:** Yes (project founder)
- **Discord Name** @bartdring 
- **For Sale:** [At Elecrow](https://www.elecrow.com/doberman-esp32-s3-8-axis-cnc-controller.html) and [Tindie USA](https://www.tindie.com/products/33366583/doberman-cnc-controller-for-esp32-s3-and-fluidnc/)
- **Description:** 8 Axis external driver controller that supports many spindle types.

## Corgi

- **Open Source:** [Yes](https://oshwlab.com/bdring/corgi-cnc-controller)
- **Wiki Page:** [Yes](http://wiki.fluidnc.com/en/hardware/official/corgi)
- **FluidNC Supporter:** Yes (project founder)
- **Discord Name** @bartdring 
- **For Sale:** Coming very soon to Elecrow (8/2025)
- **Description:** This is the newest controller from Bart Dring. It has all the features of a 6x controller plus a lot of user suggested features. See the [wiki page](http://wiki.fluidnc.com/en/hardware/official/corgi) for a complete description.

![corgi_1p1.jpg](/hardware/corgi_1p1.jpg =x500)

## 6 Pack Universal Controller

- **Open Source:** [Yes](https://oshwlab.com/bdring/6-pack-2-0)
- **Wiki** [Newest version](http://wiki.fluidnc.com/en/hardware/official/6_Pack_Integrated_ESP32#cnc-io-modules) -   [Original Version](https://github.com/bdring/6-Pack_CNC_Controller/wiki)
- **FluidNC Supporter:** Yes (project founder)
- **Discord Name** @bartdring 
- **For Sale:** [Yes](https://www.tindie.com/products/33366583/6-pack-universal-cnc-controller/)
- **Description:** This uses [plug in modules](http://wiki.fluidnc.com/en/hardware/cnc_io_modules) to support multiple spindles, motor drivers and accessories.

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/6_Pack.png" width="500">

***

## 6 Pack External Driver CNC Controller

- **Open Source:** [Yes](https://oshwlab.com/bdring/6-pack-2-0_copy)
- **Wiki Page** [Yes](http://wiki.fluidnc.com/en/hardware/official/6_Pack_External)
- **FluidNC Supporter:** Yes (project founder)
- **Discord Name** @bartdring 
- **For Sale:** [Yes](https://www.tindie.com/products/33366583/6-pack-external-driver-cnc-controller/)
- **Description:** This is the external driver only version of the 6 Pack controller. This uses [plug in modules](http://wiki.fluidnc.com/en/hardware/cnc_io_modules) to support multiple spindles, motor drivers and accessories.

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/6-pext_clipped_rev_1.png" width="500">






***
## FluidNC Pen Laser Controller TMC2209 V2

- **Open Source:** [Yes](https://oshwlab.com/bdring/tmc2130-2-axis_copy_copy_copy_copy)
- Wiki Page: [Yes](http://wiki.fluidnc.com/en/hardware/official/TMC2209_Pen_Laser_V2)
- **FluidNC Supporter:** Yes
- **Discord Name** @bartdring
- **For Sale:** [Elecrow](https://www.elecrow.com/tmc2209-pen-laser-fluidnc-cnc-controller.html)  or [Tindie](https://www.tindie.com/products/33366583/tmc2209-penlaser-cnc-controller/)
- **Description:** 2 on board TMC2209 stepper drivers, RC Servo, multiple inputs and 5V outputs. Stallguard supported

![2x_1.jpg](/hardware/2x_1.jpg =x450)

***

## 4x CNC Controller (Integrated ESP32 and TMC2209)

- **Open Source:** Yes [OSHW Labs](https://oshwlab.com/bdring/tmc2130-2-axis_copy_copy_copy_copy_copy)

- **Wiki Page:** [Yes](http://wiki.fluidnc.com/en/hardware/official/new-page/4x_CNC_with_esp32)

- **FluidNC Supporter:** Yes (project founder)
- **Discord Name** @bartdring 

- **For Sale:** [Tindie (USA only)](https://www.tindie.com/products/33366583/4x-cnc-controller-integrated-esp32-and-tmc2209/) and [Elecrow](https://www.elecrow.com/4x-cnc-controller-integrated-esp32-and-tmc2209.html)

- **Description:**
  - (4) TMC2209 Stepper Drivers in UART Mode
  - Can use stallguard for sensorless end stops
  - (6) inputs
  - (4) 5V Outputs
  - (2) 3A MOSFET Outputs
  - (1) 0-10V Spindle output
  - (1) RS485 interface for spindle VFDs 
  - (1) I/O Expansion Module Socket
  - SD Card
  
![4x_cnc_ctrlr_01.jpg](/hardware/4x_cnc_ctrlr_01.jpg =x400)

***

## PiBot FluidNC grblHAL CNC Controller V5.88 Ultra
- **Open Source:** NO
- **[Wiki Documentation](https://wiki.pibot.com/doku.php?id=pibot_cnc_laser_series:v588_ultra:introduction:start)**
- **FluidNC Supporter:** Yes
- **Discord Name** @abcpibot
- **For Sale:** [Yes](https://www.pibot.com/cnc-laser-electronics/pibot-fluidnc-grblhal-esp32-s3-6-1-axis-cnc-controller-v5-88-ultra) (Use coupon code **fluidncpbt**)
- **Description:** 6+1 axis controller based on the ESP32-S3. Provides both on-board plug-in driver sockets and external connectors, with SPI driver support and a galvanically isolated RS485 for Modbus VFD spindle control. Supports the PiBot pendant, I/O expander, and SPI TMC5160 driver modules running simultaneously, on a 4-layer PCB.

<img src="https://raw.githubusercontent.com/abcpibot/PiBot-V5.88-Docs/refs/heads/main/images/v588-1.jpg" width="650">

## PiBot FluidNC grblHAL CNC Controller V4.96 Pro

- **Open Source:** NO ([PDF on PiBot Wiki](https://www.pibot.com/image/catalog/V496/sch496.png))
- **[Wiki Documentation](https://wiki.pibot.com/doku.php?id=pibot_cnc_laser_series:v496_pro:start)**
- **FluidNC Supporter:** Yes
- **Discord Name** @abcpibot
- **For Sale:** [Yes](https://www.pibot.com/pibot-fluidnc-grbl-cnc-controller-v4-9) (Use coupon code **fluidncpbt**)
- **Description:** Compatible with the FluidNC “6x CNC Controller” pinmaps, added support for A4988 and other direct-plug stepper motors driver, Support SPI Driver TMC2130 or TMC5160, as well as a relay. We provide a yaml configuration file for a 6 Axis external driver controller that supports a spindle, 0-10V adjust on board, Relay on board, RS485 on board, Lasers with PWM and SD card ect.

![pibotv496.png](/hardware/pibotv496.png =x500)

## PiBot FluidNC grblHAL CNC Controller V5.77 Carrier

- **Open Source:** NO
- **[Wiki Documentation](https://wiki.pibot.com/doku.php?id=pibot_cnc_laser_series:v577_carrier:introduction:start)**
- **FluidNC Supporter:** Yes
- **Discord Name** @abcpibot
- **For Sale:** [Yes](https://www.pibot.com/pibot-fluidnc-grblhal-esp32-s3-8-axis-cnc-controller-v5-77) (Use coupon code **fluidncpbt**)
- **Description:** **Description:** An 8-axis FluidNC CNC controller with a replaceable ESP32-S3 module, featuring onboard 0–10V spindle control, RS485, PWM, MOSFET outputs, SD card support, an RJ12 pendant interface, and I/O expander support.

![pibot-577-900.jpg](/hardware/pibot-577-900.jpg =x500)

## PiBot FluidNC grblHAL CNC Controller V4.7B

- **Open Source:** [Yes](https://oshwlab.com/pi3d14/pibot-fluidnc-grbl-cnc-controller-v4-7a)
- **[Wiki Documentation](https://wiki.pibot.com/doku.php?id=pibot_cnc_laser_series:v47b:introduction:start)**
- **FluidNC Supporter:** Yes
- **Discord Name** @abcpibot
- **For Sale:** [Yes](https://www.pibot.com/pibot-fluidnc-grbl-cnc-controller-v4-7) (Use coupon code **fluidncpbt**)
- **Description:** A clone of the original [6x controller](http://wiki.fluidnc.com/en/hardware/existing_hardware#h-6x-cnc-controller) with a plug in ESP32 module and an additional pendant interface.

![pibot-47b-900.jpg](/hardware/pibot-47b-900.jpg =x500)

***

## Fysetc E4

- **Open Source:** No
- **FluidNC Wiki Page** [Yes](http://wiki.fluidnc.com/en/hardware/3rd-party/fysetc_e4)
- **FluidNC Supporter:** No. They do not even support thier own product very well.
- **Discord Name**
- **For Sale:** AliExpress
- **Description:** 4 Axis TMC2209
- **Documentation:** [Schematic](https://github.com/FYSETC/FYSETC-E4/blob/main/hardware/FYSETC%20E4_V1.0%20SCH.pdf)

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/fysetc_e4.png" width="400">

***


## Makerbase XY DLC32 V1.0

- **Open Source:** No
- **[FluidNC Wiki Page](http://wiki.fluidnc.com/en/hardware/3rd-party/XY_DLC32_V10)**
- **FluidNC Supporter:** No. We have no relationship with Makerbase. It ships with a modified version of Grbl_ESP32, a link to the repository is on the wiki page.
- **Discord Name:** michael.huepkes
- **For Sale:** Ali Express
- **Description:** This is the predecessor of the [MKS DLC32](/hardware/existing_hardware#makerbase-mks-dlc32) typically found in older Sculpfun laser engravers.

![makerbase_xy_dlc32_v10.png](/hardware/makerbase_xy_dlc32_v10.png =x500)

***

## Makerbase MKS DLC32

- **Open Source:** No ([PDFs on Github](https://github.com/makerbase-mks/MKS-DLC32))
- **[FluidNC Wiki Page](http://wiki.fluidnc.com/en/hardware/3rd-party/MKS_DLC32)**
- **FluidNC Supporter:** No. We have no relationship with Makerbase.  It appears it ships with a modified version of Grbl_ESP32. They have not shared those modifications. FluidNC users have reported success loading FluidNC.
- **Discord Name**
- **For Sale:** Ali Express
- **Description:** It is typically sold with a display. FluidNC does not support the display.

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/makerbase_mks_dlc32.png" width="500">

***


## Makerbase MKS DLC32 Max

- **Open Source:** No ([PDFs on Github](https://github.com/makerbase-mks/MKS-DLC32))
- **[FluidNC Wiki Page](http://wiki.fluidnc.com/en/hardware/3rd-party/MKS-DCL32-MAX)**
- **FluidNC Supporter:** No. We have no relationship with Makerbase.  It appears it ships with a modified version of Grbl_ESP32. They have not shared those modifications. This board is inexpensive and thus quite popular and we spend a lot of our time supporting it, The vendor does not support the FluidNC project in any way, so we hope you will contribute to FluidNC in partial compensation for all our time.
- **Discord Name**
- **For Sale:** Ali Express
- **Description:** Requires FluidNC version 4 that supports ESP32-S3. It is often sold with a display. FluidNC does not support the display.
![motherboard-makerbase-mks-dlc32-max-4-tmc2209_big.jpg](/hardware/motherboard-makerbase-mks-dlc32-max-4-tmc2209_big.jpg =x400)

### Makerbase MKS LS Pro

- **Description:**
- **Open Source:** No
- **Wiki** [Yes](http://wiki.fluidnc.com/en/hardware/3rd-party/MKS_LS_ESP32_PRo)
- **FluidNC Supporter:** No. They do not even support thier own product very well.
- **Discord name:** 
- **For Sale:** 

![esp32-pro-1.png](/hardware/esp32-pro-1.png =x240)

***

## Makerbase MKS Tinybee

- **Open Source:** No ([PDFs on Github](https://github.com/makerbase-mks/MKS-TinyBee/tree/main/hardware))
- **[FluidNC Wiki Page](http://wiki.fluidnc.com/en/hardware/3rd-party/MKS_TinyBee)**
- **FluidNC Supporter:** No. They do not even support thier own product very well.
- **Discord Name**
- **For Sale:** Ali Express
- **Description:**

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/MKS_Tinybee.png" width="500">

## Root Controller ISO

- **Open Source:** [No, but schematic PDF is on Github](https://github.com/RootCNC/Root-Controller-ISO)
- **FluidNC Supporter:** No
- **Discord Name** Root CNC
- **For Sale:** [Yes](https://www.rootcnc.com/product/root-controller-rev-3/)
- **Description:** Fully isolated 6 Axis motion controller specifically designed to drive external stepper motor drivers. includes isolated inputs (x8), USB, RS485, MOSFETs Output (x2), Relay outputs (x2) and a non isolated Laser port. SD card. Wide input voltage range (9-36V)

![controllerr3_1.png](/hardware/controllerr3_1.png =x500)
                                                                                                 

***

## xPro V5

- **Open Source:** No
- **FluidNC Supporter:** No
- **Discord Name**
- **[FluidNC Wiki Page](http://wiki.fluidnc.com/en/hardware/3rd-party/xPro_V5)**
- **For Sale:** [Yes](https://www.spark-concepts.com/cnc-xpro-v5/) 
- **Description:** 4 Axis TMC5160 controller
- **Support** [Supplier Github Wiki](https://github.com/Spark-Concepts/xPro-V5/wiki) [This wiki page](http://wiki.fluidnc.com/en/hardware/3rd-party/xPro_V5)

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/xPro_v5.png" width="500">

***



## Gecko Blaster

- **Open Source:** [Yes](https://github.com/MitchBradley/GeckoBlaster)
- **FluidNC Supporter:** Yes
- **Discord Name**
- **For Sale:** No
- **Description:** Easiest way to use a Gecko G540 controller

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/parallel_port2.png" width="500">

***

## Parallel Port Adapter

- **Open Source:** TBD
- **FluidNC Supporter:** No
- **Discord Name**
- **For Sale:** Unknown
- **Description:** Allows the use of CNC hardware that has a parallel port input, like the Gecko G540

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/parallel_port1_clipped_rev_2.png" width="500">

***

## Nighthawk CNC

- **Open Source:** No
- **FluidNC Supporter:** No
- **Discord Name**
- **For Sale:** Yes
- **Description:**:

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/nighthawk.png" width="500">

***



## ESP32 Ramps Adapter

- **Open Source:** Unknown
- **FluidNC Supporter:** No. They do not even support thier own product very well.
- **Discord Name**
- **For Sale:** Unknown
- **Description:** Allows use of a RAMPS Shield

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/ramps.png" width="500">

## Source Rabbit 4 Axis

- **Open Source:** No
- **FluidNC Supporter:** No
- **Discord Name**
- **For Sale:** [Yes](https://www.sourcerabbit.com/Shop/pr-i-86-t-4-axis-cnc-motherboard.htm)
- **Description:** 4 Axis CNC Controller

![sr86.webp](/sr86.webp =x500)

## Zbaitu Laser

- **Open Source:** No
- **Project Supporter:** No
- **Discord Name**
- **For Sale:** With a laser on AliExpress
- **Description:** 3 Axis laser controller. The design quality looks poor.
- **[Wiki Link:](http://wiki.fluidnc.com/en/hardware/3rd-party/zbaitu_laser)**

<img src="/hardware/zbaitu_00.png" width="500">

***
## Jackpot CNC Controller

- **Open Source:** [Yes GPLv3](https://oshwlab.com/allted?tab=project&page=1)
- **Wiki** [Local](/hardware/3rd-party/jackpot), [External](https://docs.v1e.com/electronics/jackpot/)
- **FluidNC Supporter:** Yes
- **Discord Name** @ryanv1engineering 
- **For Sale:** [Yes](https://www.v1e.com/products/jackpot-cnc-controller)
- **Description:** 6x TMC2209 driver ports, 7 inputs, 2x 5V outputs, 2x input level outputs, one expansion module socket.

![jackpot_cnc(1).png](/hardware/jackpot_cnc(1).png =x500) 

***

## BigTreeTech Rodent

![1020000476-rodent_1000_1.webp](/hardware/1020000476-rodent_1000_1.webp =x400)

- **Open Source:** No
- **Wiki** [Local](http://wiki.fluidnc.com/en/hardware/3rd-party/btt_rodent)
- **FluidNC Supporter:** Yes
- **Discord Names to ask for help** @Cruz @RatRigMig 
- **Wiki** [Local](/hardware/3rd-party/jackpot), [External](https://docs.v1e.com/electronics/jackpot/)
- **Where to buy:** [BTT](https://biqu.equipment/collections/new-arrival/products/bigtreetech-rodent) and  [Rat Rig](https://ratrig.com/products/bigtreetech-rat-rig-rodent-cnc-controller-tmc2160)



***
## ESP32 laser Controller

- **Open Source:** [Yes GPLv3](https://hackaday.io/project/193893-retrofitting-an-old-laser-engraver)
- **Wiki** [Local], [External](https://hackaday.io/project/193893-retrofitting-an-old-laser-engraver/log/226681-fluidnc-laser-control-board)
- **FluidNC Supporter:** [No]
- **Discord Name** @freedom2000
- **For Sale:** [No] but bare pcb exists (DIY)
- **Description:** 3x stepper motors (step/dir), 3x independant home switches, 1x PWM to control laser, 1x interlock door switch, 4x relays, 3x more digital inputs.

![ESP32 laser controller](https://cdn.hackaday.io/images/4249081701872224079.jpg =x500) 

***

## ESP32 "parallel port" CNC Controller

- **Open Source:** [Yes GPLv3](https://hackaday.io/project/194302-convert-a-mach3-cnc-controller-to-grbl-or-fluidnc)
- **Wiki** [Local], [External](https://hackaday.io/project/194302-convert-a-mach3-cnc-controller-to-grbl-or-fluidnc/log/226944-the-controller-pcb)
- **FluidNC Supporter:** [No]
- **Discord Name** @freedom2000
- **For Sale:** [No] but bare pcb exists (DIY)
- **Description:** 4x stepper motors (step/dir), 3x independant home switches, 1x probe, 4x outputs, 4x inputs, compatible with "Mach3" parallel port controllers. And cheap, so cheap!

![ESP32 laser controller](https://cdn.hackaday.io/images/4856991705392835310.jpg =x500) 

## AvaShield - K40 plug and play controller for Lightburn

- **Open Source:** No
- **Wiki:** [Link](https://lasercutting.avataar120.com/en/2024/01/14/k40-lightburn-plug-play-controller-v9-xx/) / [Troubleshooting](https://lasercutting.avataar120.com/en/2022/07/04/troubleshooting-with-your-fluidnc-k40-shield/)
- **FluidNC Supporter:** Yes
- **Discord Name:** @Avataar120
- **For Sale:** [Yes](https://lasercutting.avataar120.com/boutique/)
- **Description:** Plug and play controller for **K40 with Lightburn** (or other GCODE senders). 4 stepper motors, 4 independent home switches, 2 multi purpose IO, SSD1306 OLED port, Air Assist relay, Stock K40 connector headers (incl. **Ribbon cable** one). SD-Card slot
-  
-  
<img src="https://lasercutting.avataar120.com/wp-content/uploads/2024/01/AvaShield_9.X_K40_Lightburn_Plug_Play.jpg" align="center" width="560" height="497" >

## Macrobase 6 axis

![macrobase_6axis.png](/hardware/macrobase_6axis.png =x400)

- **Open Source:** [No, but some info at Github](https://github.com/Macrobase-tech/CNC-Software/tree/main/6%20Axis%20Upgrade)
- **Wiki:** No
- **FluidNC Supporter:** No. They do not even support thier own product very well.
- **For Sale:** Aliexpress
- **Description:** 6 Axis controller

***

## ESP32 4 axis foam cutter controller

- **Open Source:** [Yes GPLv3](https://hackaday.io/project/199287-fluidnc-4-axis-foam-cutter-controller)
- **Wiki** [Local], [External](https://hackaday.io/project/199287-fluidnc-4-axis-foam-cutter-controller)
- **FluidNC Supporter:** [No]
- **Discord Name** @freedom2000
- **For Sale:** [No] but bare pcb exists (DIY), [PCBWay shared project](https://www.pcbway.com/project/shareproject/FluidNC_foam_cutter_controller_bad9d318.html)
- **Description:** 4x stepper motors (step/dir), 2x independant home switches, 1x PWM to control hotwire, 4x polulu DRV8825 drivers, 8x more digital inputs/outputs.

![ESP32 foam_cutter_controller](https://cdn.hackaday.io/images/790441733216508657.jpg =x500) 

## MillingStation

- **Open Source:** No
- **FluidNC Supporter:** Yes
- **Contact, support and sales:** Discord
- **Discord:** Pablo Meinardo
- **Description:** MillingStation is an innovative project that offers easy-to-implement solutions for enthusiasts of CNC carving, engraving, and laser cutting.
- **[Original software link](https://github.com/Meina88/MillingStation)**
- **[Wiki Link](https://github.com/Meina88/MillingStation/wiki)**
- **[Instagram](https://www.instagram.com/luthierpro.cnc/?hl=es)**

<img src="/hardware/millingstation.jpg" width="500">	


## Anolex A-X5.7.3 Controller Board

- **Open Source:** No
- **Wiki Page:** [Yes](http://wiki.fluidnc.com/en/hardware/3rd-party/anolex-A-X5_7_3)
- **FluidNC Supporter:** Anolex: No
- **Discord:** @teletypeguy
- **Description:** Board used in Anolex Evo Ultra 2 (and other models).

<img src="/hardware/anolex/anolex-pcb.png" width="500">	

## FigCNC Pro

- **Open Source:** [Yes](https://github.com/figamore/FigCNC)
- **FluidNC Supporter:** No
- **Discord Name** @fig
- **For Sale:** No
- **Description:**
  - Input voltage: 12 V to 36 V DC.
  - Four stepper channels: X, Y1, Y2, and Z step/direction outputs on a single 12-pin Phoenix-style screw terminal. The second Y channel enables dual-motor gantry operation with independent homing.
  - Isolated limit switch inputs
  - Tool-length probe
  - MicroSD card socket
  - Pendant interface: UART2 exposed on a JST-XH connector for connecting a wired pendant.
  - RS485 VFD spindle control: Modbus RTU control for most Variable Frequency Drives.
  - Compact form factor

<img src="https://github.com/figamore/FigCNC/raw/main/FigCNC-Pro/images/FigCNC-Pro.jpg" width="550">	

## Sculpfun DLC32-S9

- **Open Source:** No
- **FluidNC Supporter:** No
- **Discord Name**
- **For Sale:** with Lasers and Maybe AliExpress
- **Description:** Shipped with some lasers. See this [Discord post](https://discord.com/channels/780079161460916227/1533826663845073118) for more info. Note: There are some other similar versions.
![sculpfun_dlc_s9.png](/hardware/sculpfun/sculpfun_dlc_s9.png)

# Not in production

These are older controllers that are not longer available.

## 4X TMC2209 Controller

- **Open Source:** Yes [OSHW Labs](https://oshwlab.com/bdring/tmc2130-2-axis_copy_copy)

- **Wiki Page:** [Yes](http://wiki.fluidnc.com/en/hardware/official/TMC2209_4_Axis)

- **FluidNC Supporter:** Yes (project founder)
- **Discord Name** @bartdring 

- **For Sale:** No

- **Description:** (4) TMC2209 built in stepper drivers. (2) CNC I/O Module Sockets.

  <img src="https://github.com/bdring/FluidNC/wiki/images/hardware/4x_2209_v2p0.png" width="450">
  
 ## 4 Axis SPI Daisy Chain Controller

- **Open Source:** [Yes](https://github.com/bdring/4_Axis_SPI_CNC)
- **FluidNC Supporter:** Yes
- **Discord Name** @bartdring 
- **For Sale:** Not currently
- **Description:** 4 Axis controller for Trinamic SPI drivers

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/4x_SPI_Controller.png" width="500">

## TMC2209 Pen/Laser Controller 

- **Open Source:** [Yes](https://github.com/bdring/TMC2209_Pen_Laser)
- **FluidNC Supporter:** Yes
- **Discord Name** @bartdring 
- **For Sale:** Not currently
- **Description:** Designed for low cost pen machines and lasers.

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/TMC2209_Laser.png" width="500">

## 4 Axis External Stepper Driver Controller

- **Open Source:** [Yes](https://github.com/bdring/4_Axis_External_Driver)
- **FluidNC Supporter:** Yes
- **Discord Name** @bartdring 
- **For Sale:** Not currently
- **Description:** Designed for use with external stepper drivers. Outputs 5V signals. Has an RS485 for VFDs

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/4x_external.png" width="500">

## FluidNC Pen Laser Controller (SPI)

- **Open Source:** [Yes](https://oshwlab.com/bdring/tmc2130-2-axis)
- **Wiki Page:** [Yes](http://wiki.fluidnc.com/en/hardware/official/FluidNC_Pen_Laser_CNC_Controller_SPI)
- **FluidNC Supporter:** Yes (project founder)
- **For Sale:** [Yes](https://www.tindie.com/products/33366583/fluidnc-penlaser-cnc-controller-spi-v11/)
- **Discord Name** @bartdring 
- **Description:** 2 TMC2130 or TMC5160 stepper drivers, RC Servo, multiple inputs and 5V outputs. Stallguard supported
<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/FluidNC_Pen_laser.png" width="600">

## TMC2130 Pen/Laser Controller

- **Open Source:** [Yes](https://github.com/bdring/Grbl_ESP32_TMC2130_Plotter_Controller)
- **FluidNC Supporter:** Yes
- **Discord Name** @bartdring 
- **For Sale:** Not currently
- **Description:** Designed for low cost pen machines and lasers.

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/20200321_144747.png" width="500">

# Not recommended for use

These are controller have have design issues. The developers will not help you with support issues. These are problematic and unreliable and a waste of time to support. 

## ESP32Duino with a Cheap Shield

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/esp32duino_shield.png" width="300">

- Why not: The shield is not 100% compatible with the ESP32. We are tired of answering endless questions on this controller.

- That said,[this video](https://www.youtube.com/watch?v=_uPIW6oP7i4&ab_channel=FuzzyLogic) has tips from a user who has  succeeded  with this combination.

## ESP32 on a terminal block board.

<img src="https://github.com/bdring/FluidNC/wiki/images/hardware/esp32_terminals.png" width="300">

- Why not: Some input pins need pullups and filtering. Ok to play with, but don't ask for support on this one. 

## ESP32 6 axis breakout board



- **Open Source:** No
- **FluidNC Supporter:** No
- **For Sale:** AliExpress
- **Description:** 6 Axis laser controller. Design quality looks good.
- **[Original software link:](https://github.com/Macrobase-tech/CNC-Software?spm=a2g0o.detail.1000023.17.18a21591c8x2FW)** Fluidnc works wonderfully. You might want to check out the intended software.
- **[Wiki Link:](http://wiki.fluidnc.com/en/hardware/3rd-party/ESP32_6_axis_breakout_board)**

<img src="/hardware/esp32_cnc_board_6axis.jpg" width="500">	

- Why not: There have been reports of serious build quality problems, it has no SD card slot, it has power supply problems, and it does not reset properly from the USB port.

## Badgerlab's Vexor_A 6-axis controller

- **Open Source:** No (full electrical schematics available)
- **FluidNC Supporter:** No
- **For Sale:** Yes, at www.badgerlab.io
- **Description:** 6-axis universal controller for external stepper drivers. Designed for use with FluidNC. Operates on 8–36 V DC. Has 6 opto-isolated high-voltage endstop pins powered from the filtered controller supply voltage. All data pins are 5 V TTL ready. Additional 5V output fused @ 3A. EMI protected. RoHS compliant.  
- **Discord name:** @badgerlab.io

<img src="https://cdn.shopify.com/s/files/1/0939/4969/0200/files/Vexor_A_fluidNC_wiki_photo.jpg" width="500">	

# How do I add a new controller to this page

We prefer that the original designer of the controller add or approve adding it to this page. We want to encourage them to join and support this community. We are not fond of offering free support to other people's stuff especially if they are selling it.

To get access to edit the wiki [read this page](http://wiki.fluidnc.com/en/wiki_contributions) completely.

Do not add controllers that do not have some support information. You need at least a link to a place to buy it, the source files or a wiki page.

Add the following items for your entry. (Note: some older entries do not comply with all of this). Place your entry below existing entries. If you want to move up in the order, contact us.)

Photo. A photo roughly the size of the other photos should be at the of top of your entry. Renderings are not allowed. 

- **Description:** A brief description of the feature of your controller.
- **Open Source:** Yes or no. Open source means the original source files (not just PDFs or Gerbers) are available, up to date and usable.
- **Wiki** If there is a link to a page on our wiki add it. If not, link to your support pages.
- **FluidNC Supporter:** Yes or no. Yes means you are either a major contributor to the development of FluidNC or you regularly donate to the project
- **Discord name:** Your name on the FluidNC discord. If you are adding someone else's controller, then add your name.  In either case, we ask that you monitor Discord for questions about the controller and provide first-line support for it - since you presumably have the controller and the FluidNC developers probably do not.
- **For Sale:** Answer yes with a link if people can buy it online.