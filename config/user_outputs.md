---
title: User Outputs
description: Configure User Output Signals
published: true
date: 2026-08-01T19:34:20.080Z
tags: en
editor: markdown
dateCreated: 2022-07-21T17:54:18.051Z
---

# Overview

User outputs allow you to output digital (on/off) and analog (PWM) signals via gcode. The code is synchronized. This means the change on the output pin occurs after all earlier gcode in the buffer has completed.

# Configuration

## Analog

Pins 0 through 3 can be defined

 - <a name="analog0_pin"></a>**analog0_pin:**
   - Type: [Pin](http://wiki.fluidnc.com/config/overview#Pin)
   - Range: gpio
   - Default: NO_PIN
   - Details: A PWM signal is output on this pin. It is controlled by the [M67 command](http://wiki.fluidnc.com/en/features/supported_gcodes#m67-analog-output). **M67 E0 Q23.87** would turn on analog0 with a 23.87% percent duty cycle. **M67 E0 Q0** would turn off analog0.

- <a name="analog0_hz"></a>**analog0_hz:** 
  - Type: [Integer](http://wiki.fluidnc.com/config/overview#integer)
  - Range: 1 to 20000000
  - Default:
  - Details: The frequency of the PWM signal.
  
>   The analog signal can be used to control RC Servos. Consider a 50Hz (typical) servo with pulse range of 1ms to 2ms. 50Hz has a period of 20ms, so 5% is 1ms and 10% is 2ms. 
{.is-info}


## Digital
  
  `digital0_pin` through `digital7_pin` can be defined.
  
 - <a name="digital0_pin"></a>**digital0_pin:**
   - Type: [Pin](http://wiki.fluidnc.com/config/overview#pin)
   - Range: gpio or i2so
   - Default: NO_PIN
   - Details: The output is on this pin. It is controlled via [M62, M63, M64 and M65 commands](http://wiki.fluidnc.com/en/features/supported_gcodes#m62-m63-m64-m65-digital-output). **M62 P0** Would turn digital0 pin on. **M63 P0** Would turn digital0 pin off. Like all output pins, you can set the [active state](http://wiki.fluidnc.com/en/config/config_IO#output-pin-attributes) with the `:high` or `:low` attribute.

Config Examples:


```yaml
user_outputs:
  analog0_pin: gpio.13
  analog1_pin: gpio.14:low
  analog2_pin: NO_PIN
  analog3_pin: NO_PIN
  analog0_hz: 5000
  analog1_hz: 5000
  analog2_hz: 5000
  analog3_hz: 5000
  digital0_pin: gpio.26
  digital1_pin: gpio.4
  digital2_pin: i2so.5
  digital3_pin: i2so.6:low
  digital4_pin: NO_PIN
  digital5_pin: NO_PIN
  digital6_pin: NO_PIN
  digital7_pin: NO_PIN
```

