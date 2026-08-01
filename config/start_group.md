---
title: Start (Start Options)
description: 
published: true
date: 2026-08-01T19:33:50.543Z
tags: 
editor: markdown
dateCreated: 2022-07-21T16:57:56.414Z
---

# Config File Start Group

This group controls optional things that happen at startup.

<!-- config-item path="start.must_home" -->
### must_home
- **Type:** [Boolean](/config/overview#boolean)
- **Default:** `true`

This controls whether you are required to home at startup or not. You will get a homing alarm at startup if this value is true. This prevents motion until you home the machine or clear the alarm. You can clear this with the [$X command](http://wiki.fluidnc.com/en/features/commands_and_settings#alarmdisable-or-x).
<!-- /config-item -->

<!-- config-item path="start.deactivate_parking" -->
### deactivate_parking
- **Type:** [Boolean](/config/overview#boolean)
- **Default:** `false`

Turns off the parking feature.
<!-- /config-item -->

<!-- config-item path="start.check_limits" -->
### check_limits
- **Type:** [Boolean](/config/overview#boolean)
- **Default:** `true`

If true this will report if any limit switches are active at startup if `hard_limits` are true for the axis.
<!-- /config-item -->

## Config Example

```yaml
start:
  must_home: true
  deactivate_parking: false
  check_limits: true
```
