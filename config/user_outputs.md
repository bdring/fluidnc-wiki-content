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

`analog0_pin` through `analog3_pin`, and the matching `analog0_hz` through `analog3_hz`, can be defined.

<!-- config-item path="user_outputs.analog0_pin" -->
### analog0_pin
- **Type:** [Pin](/config/overview#pin)
- **Range:** gpio
- **Default:** `NO_PIN`

A PWM signal is output on this pin. It is controlled by the [M67 command](http://wiki.fluidnc.com/en/features/supported_gcodes#m67-analog-output). **M67 E0 Q23.87** would turn on analog0 with a 23.87% percent duty cycle. **M67 E0 Q0** would turn off analog0.
<!-- /config-item -->

<!-- config-item path="user_outputs.analog0_hz" -->
### analog0_hz
- **Type:** [Integer](/config/overview#integer)
- **Range:** 1 to 20000000
- **Default:** `5000`

The frequency of the PWM signal.
<!-- /config-item -->

>   The analog signal can be used to control RC Servos. Consider a 50Hz (typical) servo with pulse range of 1ms to 2ms. 50Hz has a period of 20ms, so 5% is 1ms and 10% is 2ms. 
{.is-info}


## Digital
  
`digital0_pin` through `digital7_pin` can be defined.

<!-- config-item path="user_outputs.digital0_pin" -->
### digital0_pin
- **Type:** [Pin](/config/overview#pin)
- **Range:** gpio or i2so
- **Default:** `NO_PIN`

The output is on this pin. It is controlled via [M62, M63, M64 and M65 commands](http://wiki.fluidnc.com/en/features/supported_gcodes#m62-m63-m64-m65-digital-output). **M62 P0** Would turn digital0 pin on. **M63 P0** Would turn digital0 pin off. Like all output pins, you can set the [active state](http://wiki.fluidnc.com/en/config/config_IO#output-pin-attributes) with the `:high` or `:low` attribute.
<!-- /config-item -->

## Config Example

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
