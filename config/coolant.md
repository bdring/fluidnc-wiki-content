---
title: Coolant
description: Configuring Coolant Devices
published: true
date: 2026-08-01T19:32:56.230Z
tags: en
editor: markdown
dateCreated: 2022-07-21T17:41:21.470Z
---

# Coolant

These are output pins controlled by [M7](http://wiki.fluidnc.com/en/features/supported_gcodes#m7-m71-mist-coolant), [M8](http://wiki.fluidnc.com/en/features/supported_gcodes#m8-m81-flood-coolant) and [M9](http://wiki.fluidnc.com/en/features/supported_gcodes#m9-coolant-off). They are traditionally called mist and flood, but many people use them for other things like dust extraction, etc. M9 turns both off.

- <a id="mist_pin"></a>**mist_pin:**
  - Type: [Pin](http://wiki.fluidnc.com/config/config_IO) (output)
  - Range: gpio or I2SO
  - Default: NO_PIN
  - Details: This is used to control a mist coolant device. M7 turns mist coolant on and M9 turns it off.
- <a id="flood_pin"></a>**flood_pin:**
  - Type: [Pin](http://wiki.fluidnc.com/config/config_IO) (output)
  - Range: gpio or I2SO
  - Default: NO_PIN
  - Details: This is used to control a flood coolant device. M8 turns flood coolant on and M9 turns it off.
- <a id="delay_ms"></a>**delay_ms:**
  - Type: [Integer](http://wiki.fluidnc.com/en/config/overview#integer)
  - Range: 0 to 10000
  - Default: 0
  - Details: The delay in milliseconds after the turn on of M7 and M7. It will not delay if that coolant is already on. It does not delay with M9.

## Config Example:

```yaml
coolant:
  flood_pin: gpio.14
  mist_pin: NO_PIN
  delay_ms: 0
```