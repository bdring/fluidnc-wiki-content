---
title: Displays
description: 
published: true
date: 2026-08-01T19:33:00.604Z
tags: en
editor: markdown
dateCreated: 2023-02-22T20:21:38.972Z
---

# Displays

All future development of displays should be done using [UART Channels](http://wiki.fluidnc.com/en/config/uart_sections#uart-channels). 

Everyone uses the same compiled file of FluidNC. This means all options for everyone need to be compiled into the same file. This would force us to severely limit the number of displays and languages we could support.

Using UART Channels allows people to use any smart display. We also do not need to limit languages due to limited memory. 

This concept is similar to gcode sender support. We do not use a different protocol for each sender. Everyone uses the common Grbl protocol.

## Legacy Small OLEDs

![oled_display.jpg](/config/oled_display.jpg =x200)

> Support for this display was added before the UART Channels feature. This is the only display we directly support in firmware and we will likely remove it at some point.
{.is-info}


These are small 1 or 2 color OLED displays using I2C communications. They use the SSD1306 display control IC. These are typically 128x64 or 64x48 resolution displays. They are used for basic status and to show WiFi or Bluetooth parameters when a USB connection is not used.

### Config File

You must first define an I2C interface section

 See this wiki page (TBD)

Then define an **oled:** section

 - **i2c_num:**
   - Type: [Integer](http://wiki.fluidnc.com/en/config/overview#integer)
   - Range: 0 or higher
   - Default: 0
   - Details: This indicates which I2C interface you defined (see above)
 - **i2C_address:**
   - Type: [Integer](http://wiki.fluidnc.com/en/config/overview#integer)
   - Default: 60
   - Details: The address of the I2C IC. This is typically 60.
  - **width:**
    - Type: [Integer](http://wiki.fluidnc.com/en/config/overview#integer)
    - Default: 64
    - Details: The width of the display. This is typically 128 or 64. This is used for screen formatting.
  - **height:**
    - Type: [Integer](http://wiki.fluidnc.com/en/config/overview#integer)
    - Default: 48
    - Details: The height of the display. This is typically 64 or 48. This is used for screen formatting.
  - **radio_delay_ms:**
    - Type: [Integer](http://wiki.fluidnc.com/en/config/overview#integer)
    - Range: 0-65535
    - Default: 0
    - Details:  Delays an amount in milliseconds after displaying WiFi and BT info, so you have time to look at, for example, the IP address.

```yaml
i2c0:
   sda_pin: gpio.14
   scl_pin: gpio.13
        
oled:
   i2c_num: 0
   i2c_address: 60
   width: 128
   height: 64
   radio_delay_ms: 1000
```



