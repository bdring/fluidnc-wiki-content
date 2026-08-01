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

## Digital

`digital0_pin` through `digital7_pin` can be defined.

<!-- config-item path="user_inputs.digital0_pin" -->
### digital0_pin
- **Type:** [Pin](/config/overview#pin)
- **Range:** gpio or UART channel I/O
- **Default:** `NO_PIN`

The pin can be read by the [M66 command](http://wiki.fluidnc.com/en/features/supported_gcodes#m66-read-user-input) (`M66 P<digital input>`).
<!-- /config-item -->

## Analog

`analog0_pin` through `analog3_pin` can be defined.

<!-- config-item path="user_inputs.analog0_pin" -->
### analog0_pin
- **Type:** [Pin](/config/overview#pin)
- **Range:** gpio
- **Default:** `NO_PIN`

The pin can be read by the [M66 command](http://wiki.fluidnc.com/en/features/supported_gcodes#m66-read-user-input) (`M66 E<analog input>`).
<!-- /config-item -->

## Config Example

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
