---
title: E Stop Buttons
description: E-Stops and Alternatives
published: true
date: 2026-08-01T19:35:48.808Z
tags: 
editor: markdown
dateCreated: 2022-07-21T16:33:43.347Z
---

# E Stop Buttons

![](https://github.com/bdring/FluidNC/wiki/images/e_stop.jpg)

An e-stop button generally should cut the primary power. Relying on firmware defeats one of the primary purposes of having an e-stop. With that said, you can define a [control pin](http://wiki.fluidnc.com/en/config/control) as an e-stop. 

> An E-Stop will likely result in the loss of position. You should rehome after you clear the alarms.
{.is-warning}


## Less Urgent Stops

If you want to stop quickly, but it is not a true emergency and the firmware is still running, you can use these [control input](http://wiki.fluidnc.com/en/config/control) alternatives. All of these can be sent via a gcode sender, the WebUI or a hardware button.

- **Feed Hold**. This very quickly stops the machine without loss of position. It can be resumed with cycle start. The feed hold command is the "!" character. The hardware pin is setup with **feed_hold_pin**.
- **Reset**. This immediately stops the machine and spindle, but position is lost and you will need to re-home. Motors will stay engaged if your **idle_ms** value is 255. The command is CTRL-X  (0x18).  The hardware pin is setup with **reset_pin**. This could be used in parallel with a true e-stop. The power will be cut and FluidNC will reset.
- **Door/Parking**. This feature is used for an enclosure door. If the door is opened during a job, the motion will quickly stop, the bit will retract, the spindle will stop and retract further from the work. The command is character 0x84. The hardware pin is setup with **safety_door_pin**. 

```yaml
control:
  safety_door_pin: NO_PIN
  reset_pin: NO_PIN
  feed_hold_pin: NO_PIN
```





