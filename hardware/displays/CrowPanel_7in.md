---
title: CrowPanel 7 Inch Display
description: CrowPanel 7 Inch Display
published: true
date: 2024-08-21T19:22:38.627Z
tags: 
editor: markdown
dateCreated: 2024-08-21T19:22:32.772Z
---

# Elecro CrowPanel 7.0 inch Display

![crowpanel_7.0_.png](/hardware/displays/crowpanel_7.0_.png)

## Display Info

- Where to buy
  - [Elecrow](https://www.elecrow.com/esp32-display-7-inch-hmi-display-rgb-tft-lcd-touch-screen-support-lvgl.html)
- Resolution: 800x480 RGB
- Controller: ESP32-S3 4Meg



## Version Info

- Version 1.x 
    - You need to manually enter boot mode when the uploaded starts sending `Connecting...........` . The button sequence is this. Boot down, Reset Down, Reset Up, Boot up.
    - After programming you must click the reset button  
- Version 2
  - Automatically enters boot mode and resets automatically.
  - It also has an I2C connector
- Version 3
  - This has some special screen init timing code requirements.

[See this video](https://www.youtube.com/watch?v=Y31AEXCWI4M) for more version info.

## Connection

Use the UART0 connection





