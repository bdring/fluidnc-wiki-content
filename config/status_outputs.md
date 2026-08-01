---
title: Status Outputs
description: 
published: true
date: 2026-08-01T19:33:55.437Z
tags: en
editor: markdown
dateCreated: 2023-09-10T19:03:59.984Z
---

# Status Outputs
This feature allows you to tie an output to a status state. This allows you to have something like a stack light on your machine.

![stack_light.png](/config/stack_light.png)

## Config Items

- **report_interval_ms** 
  - Type: Integer
  - Range: (100 to 5000) milliseconds
  - Default: 500
  - Details: This is the update rate of the status. You also get an automatic update after status changes, so this does not need to be fast.
 - **run_pin:**
   - Type: Pin (input)
   - Range: gpio or i2so
   - Default: NO_PIN
   - Details: Active when status is run. 
- **hold_pin:**
   - Type: Pin (input)
   - Range: gpio or i2so
   - Default: NO_PIN
   - Details: Active when status is hold. 
- **alarm_pin:**
   - Type: Pin (input)
   - Range: gpio or i2so
   - Default: NO_PIN
   - Details: Active when status is alarm.
- **door_pin:**
   - Type: Pin (input)
   - Range: gpio or i2so
   - Default: NO_PIN
   - Details: Active when [safety door input](http://wiki.fluidnc.com/en/config/control#safety_door_pin) is active. 
  
## Config Example

```yaml
status_outputs:
  report_interval_ms: 500
  idle_pin: gpio.26
  run_pin: gpio.4
  hold_pin: gpio.16
  alarm_pin: gpio.27
  door_pin: NO_PIN
```

# FAQ

## Can you invert the state?
  
  Yes, just add `:low` after the pin.
  
## Can you add more states?

Yes, just add them to the code and submit a PR or donate and ask us to do it. 