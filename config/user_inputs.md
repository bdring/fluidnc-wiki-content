---
title: User Input
description: 
published: true
date: 2026-08-01T19:34:15.681Z
tags: en
editor: markdown
dateCreated: 2025-03-20T15:08:06.615Z
---

# User Inputs
User inputs allow you to have pins that can be read by the gcode [M66 command](http://wiki.fluidnc.com/en/features/supported_gcodes#m66-read-user-input)

> Only digital inputs are supported currently.
{.is-warning}

## Digital
  
  `digital0_pin` through `digital7_pin` can be defined.
  
 - <a name="digital0_pin"></a>**digital0_pin:**
   - Type: [Pin](http://wiki.fluidnc.com/config/overview#pin)
   - Range: gpio or UART channel I/O
   - Default: NO_PIN
   - Details: The pin can be read by the [M66 command](http://wiki.fluidnc.com/en/features/supported_gcodes#m66-read-user-input).

```yaml
user_inputs:
  analog0_pin: NO_PIN
  analog1_pin: NO_PIN
  analog2_pin: NO_PIN
  analog3_pin: NO_PIN
  digital0_pin: gpio.12:low
  digital1_pin: NO_PIN
  digital2_pin: NO_PIN
  digital3_pin: NO_PIN
  digital4_pin: NO_PIN
  digital5_pin: NO_PIN
  digital6_pin: NO_PIN
  digital7_pin: NO_PIN
```