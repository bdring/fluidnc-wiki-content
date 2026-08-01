---
title: Frequently Asked Questions
description: 
published: true
date: 2026-08-01T19:38:54.488Z
tags: 
editor: markdown
dateCreated: 2022-07-21T19:39:12.775Z
---

# Frequently Asked Questions

## Is there an easy way to convert from Grbl_ESP32?

Yes, create a [new issue at the Grbl_ESP32 repo](https://github.com/bdring/Grbl_Esp32/issues/new/choose). Select the translate template and follow the instructions. Behind the scenes, a magic robot will create a config file based on your machine definition file. It will be returned as a reply to your issue.

The translator program converts the Grbl_ESP32 machine.h file into a FluidNC config.yaml file.  The machine.h file is used when compiling Grbl_ESP32 for your board and machine.  FluidNC does not need to be compiled; you install a precompiled program onto your ESP32, then upload the small [config.yaml](http://wiki.fluidnc.com/en/config/overview) text file into a local file on the ESP32 module.  Each time that FluidNC starts, it reads the config.yaml file and configures itself accordingly.

The translator does not handle all of the Grbl_ESP32 settings, only the ones that are set at compile time via that machine.h file.  Many of the Grbl_ESP32 $ settings, like those for per-axis steps_per_mm and the like, must be transferred to the config.yaml file by editing it with a text editor prior to uploading it to the ESP32.  You should inspect the config.yaml file and try to understand each line, making sure that it matches your machine.  The translator does a good job at assigning pins to functions and creating the overall structure, but numerical values like steps, acceleration, speeds, and the like will need to be adjusted.  Spend the time to understand config.yaml and you will have an easy transition.

FluidNC has a lot more features that cannot be set from Grbl_ESP32 information alone. Those will be added in a default state. Read through the created file to see if you want to change any of the defaults.

##  When loading firmware, I get a message like `Connecting .....___.....____.....` and it eventually times out.

The programming application needs to reboot the ESP32 while gpio.2 is in a low state to put it in bootloader mode. The USB/Serial control pins normally do this on well designed hardware. Some hardware, especially older dev kits, have trouble holding the boot pin in the low state long enough. 

> You might also have circuitry tied to that pin that is holding it in the wrong state. If you have a switch using that pin, try changing the state.
{.is-warning}


Most dev kit modules also have a boot button connected to gpio.2. If you hold this down while the ESP32 reboots, then release it when you see the `Connecting .....___`. It will usually fix the problem. 

Some poorly designed hardware cannot reboot the ESP32. If this is the case you should hold the boot button, click the reset button (often labeled EN) and then release the boot button when you see the `Connecting .....___`

If the above ideas do not help and you are using a removable module, try programming the module with it removed from the controller.

This is not an issue with our firmware or install scripts. Please don't vent your frustration on us. contact the supplier of your part.

## How do I manually activate bootloader mode?

You can manually enter bootloader mode by holding gpio.0 low (gnd), resetting the controller and then releasing gpio.0 to a floating or high (+3.3v) state. 

Most controllers have a boot and reset pushbutton switch, so hold boot, click reset and then release boot.

You should see text like this on a 11500 buad serial terminal. (This is an ESP32S3)

```
ESP-ROM:esp32s3-20210327
Build:Mar 27 2021
rst:0x1 (POWERON),boot:0x20 (DOWNLOAD(USB/UART0))
waiting for download
```

## Why do I get "esp_core_dump_flash" errors when booting?

Errors like this at the beginning of the boot messages are a result of recent changes to the Espressif library. There is no problem with your boot. We hope to hack the library to prevent these scary messages soon.

```
E (602) esp_core_dump_flash: Noÿ¼Kòüdump partition found!
E (602) esp_core_dump_flash: No core dump partition found!
```

## I get Error 152: Configuration is invalid.

This means there was an error during bootup due to your configuration file. You should [check your startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages) for errors.

## Limit switch and homing problems

Follow [this flowchart](http://wiki.fluidnc.com/en/support/setup/limit_switches) to figure out your problems before asking for help. 

## How do I invert a pin state?

This is done at the pin assignment using the **:high** or **:low** attribute. The default is **:high**.

For switches if your pin is defined as **gpio.32** or **gpio.32:high**, change it to **gpio.32:low** to invert it. If it is defined as **gpio.32:low**, change it to **gpio.32:high**.

This works the same for output pins. If your mist pin is working backwards, flip the **:high** **:low** attribute. A motor direction pin is another example. If your motor is running the wrong flip the high/low attribute on the direction pin.

This also works for PWM signals. If you want an inverted PWM signal, flip the high/low attribute.

[See this wiki page](http://wiki.fluidnc.com/en/config/overview#pin_declaration).

## Why do I get this error: I2SO bus must be configured for this stepping type.

If you use any I2SO pins you must have a valid i2so: section in your config file. This is a fatal error and will cause the ESP32 to reboot with a default configuration.

## Why am I loosing the USB connection

The firmware and ESP32 CPU have virtually nothing to do with that. We can only suggest good wiring practices. [See this page for more](https://github.com/bdring/FluidNC/wiki/Serial-Port-Usage#troubleshooting)

## Why do I see 2 "ok" responses when I send serial port commands?

All commands sent must be terminated with a carriage return (CR) or a line feed (LF) character. Your serial port terminal will add this when you press the enter key. You should be able to set whether it sends a CR, LF or both when the enter key is pressed. Ideally it is either a single CR or LF. If it sends both, FluidNC will assume it received 2 commands. One with some command and one empty one. It will ok both of them. It is ok to operate this way.

## Motor Moves Erratically

Check the wiring. If a motor stutters, moves in random directions or is very weak, that is the **classic symptom** for one of the 4 motor wires not having a good connection. Only one of the 2 coils is being used.

You can determine which wires belong to each coil by using a meter to measure the resistance. The resistance should be just a few ohms. Another way is to join 2 wires together and see if it makes it harder to spin the motor. If it is harder to spin the motor, those wires belong to the same coil. 

## Determining steps per mm.

For FluidNC, the term **steps_per_mm** is used because that is the generic term CNC builders use. The firmware is actually sending signal pulses per mm. That is the same as steps only if you are not using microstepping (1 pulse = 1 full step). 

You must calculate this value based on your machine. Typically, leads screws, pulley ratios, belts, etc need to go into this calculation. There are a lot of resources and calculators on the internet to help with this.

You should carefully test your calculation by jogging a small amount like 10mm and measuring the move. If you measure 20mm you should cut your **steps_per_mm** in half. If you moved 5mm you should double it. Basically divide the jog distance by the actual move distance and multiply it by your current step_per_mm value.

Example: steps_per_mm=160, jog amount=10, move=20

new step_per_mm = 10/20\*160 = 80

Note: If you measure very close, but not exactly the same as your calculation, it may be a measurement error or some slop in your system. "Tuning" these errors out is hard because they are typically not linear with distance. Try some longer moves to check this.

Note: The machine is always setup in mm even if you use inches.

If you end up with a high **steps_per_mm** (over 100) and you are using microstepping, you should consider using a lower microstepping value. High microstepping will limit how fast your machine can move and you will get configuration warnings if you exceed that.  Most DIY are not more accurate than 100 steps per mm anyway.
  
## Skipping Steps

 - Your [stepping/pulse_us](http://wiki.fluidnc.com/en/config/axes#pulse_us) value might be too fast. This might need to be as long a 10us for external drivers, especially cheap ones (TB6560, TB6600, etc.).

## Axes do not go exactly where I tell them to go.

FluidNC is designed to work in steps. It can be no more accurate than the steps per mm for the axis. If you have 100 steps per mm and you try to go to 0.333, it will probably only go to 0.33. This can be offset from what you might think it should be, depending on the axis range and where you zeroed it. There can be other rounding issues as well. You should only assume an accuracy of about +/- 1 to 2 steps. This error should not accumulate.
 
## Motors do not move

There could be countless reasons for this from power and configuration issues to users not understanding how to move motors. Follow these steps precisely in order to narrow down the problem.

- **Check your start messages** The steps below all assume there are no errors in the [start messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages). Fix the errors before moving on.

- **Listen to and feel your motors** Do they ever make a thump, click or buzzing sound or vibrate when you try to move? If so, try lowering your **max_rate_mm_per_min:** and **acceleration_mm_per_sec2:** by 50%.

-  **Enabling the motors**. Motor drivers can be enabled and disabled. Disabling the motors allows you to move them manually. You can also disable them automatically after each move, so they stay cool when not in use. If this is not working correctly the motors might not be enabled when you are trying to move them. A motor that is hard to turn manually is said to be "locked".  Often you can hear a "thunk" sound when a motor locks.
  - **Testing the enable** You can send commands in FluidTerm and on the WebUI console that enable and disable the motors. The **\$Motor/Enable** (or \$**ME**) enables all motors and **\$Motor/Disable** (or **\$MD**) disables all motors. Try turning the motor by hand. If it is hard to turn it is likely enabled. Send each command and try turning the motor afterwards.
    - **It does not lock after either command**
      - Is the power getting to the drivers?
      - Do you have the enable pin defined? Depending on your board, you need either a [shared one](http://wiki.fluidnc.com/en/config/axes#axes) under the axes section or [one under the driver for the axis](http://wiki.fluidnc.com/en/config/axes#pulloff_mm).
      - External Drivers. Most external drivers have an enable/disable terminal, but will default to enabled if you don't connect it, so the presence of an active  signal disables the driver. Try it without the connection.
    - **It is inverted** If it is locked with $MD and unlocked with $ME. You need to [invert the active state](http://wiki.fluidnc.com/en/support/faq#how-do-i-invert-a-pin-state) of the disable pin.
- **Motors lock and unlock correctly**

  - Check your step and direction wiring. Could the pins be reversed, check them and maybe swap them.

## Motors Run Backward

Change the [active state](http://wiki.fluidnc.com/en/config/config_IO#output-pin-attributes) attribute of the pin. You can also swap the **2** motor wires one **one** coil of a stepper motor to reverse it.

## Machine Space (Mpos)

Having trouble understanding machine space, [see this page](https://github.com/bdring/FluidNC/wiki/Machine-Space-and-Homing). 

## It crashes when the Wifi starts.

There is a big power spike when the radios turn on. This can cause a crash if the 3.3V cannot handle the spike. Try adding some capacitance between 3.3V and ground. Typically it is around 47uF. See if 100uF helps.

## Is wired ethernet supported

No. That is not supported and we have no plans to support at this time.

## Special Character Issue

The Grbl protocol requires some characters to do certain functions immediately regardless of the context. This includes the '?', '!', and '~' characters. The '?' character, for example, requests the current status. If you try to use this character when setting a password, it will use the character to get status instead. If you try to set the password to "Hello?World", it will set it to "HelloWorld" and send status.

This happens on the serial, Bluetooth and telnet connections. You **can** use these characters in WebUI fields. To set the password listed above, create an AP connection and use the WebUI to set the password. Then return to STA mode.

You can also escape the special characters in serial, BT and telnet...
- ! - %21
- ? - %3F
- ~ - %75

and the escape character % must itself be escaped:

- % - %25

(This encoding is the same that is used on the web for URIs/URLs.)

## International Characters and spaces in WiFi SSIDs

The GRBL line protocol only handles US ASCII; it cannot transmit international characters or spaces directly. 

If your WiFi SSID contains a non-ASCII character like, for example **ä**, there is a trick to enter that character when setting the SSID with **\$Sta/SSID=*something*** .  You can replace the character with a special "UTF-8 escape sequence".  [This online converter](https://onlineutf8tools.com/convert-utf8-to-hexadecimal) will help. 

If you paste the **ä** in the left box, the right box will show **0xc3 0xa4**.  Replace the **0x** with **%** and omit the intervening space to enter the sequence in the \$Sta/SSID value.  For example, if your SSID is **Säx**, you would write **S%c3%a4x** in the webUI Sta/SSID	field or **$Sta/SSID=S%c3%a4x** in the commandprompt.

For the usage of a (white)space character in your SSID, just replace it with **%20**. For example, if your SSID is **Flying Pinguin** you would write **Flying%20Pinguin** in the webUI Sta/SSID	field or  **$Sta/SSID=Flying%20Pinguin** in the commandprompt.

‘Smart Quotes’ like the ones enclosing the phrase at the beginning of this sentence can cause problems.  The "single quote" character (') is fine because it is a member of the plain-ASCII character set, but smart quotes with left and right versions must be encoded with a UTF-8 escape sequence.  The sequence for the left quote (‘) is **%E2%80%98**, while the sequence for the right quote (’) is **%E2%80%99**.

## Ignored config file items

If you get a message like **WARN: Ignored key \<keyname\>** it means that the name of the key is wrong or it is in the wrong place. It may be a valid key name, but if it is not under the right section with the proper indent level it will be ignored. Check the spelling, location and indent of the key in the message.

## Config file warning: \<Pin\> does not support \<something\>

The ESP32 pins are quite flexible but some have restrictions. If you get a warning like "[MSG:WARN: gpio.34 does not support :pu attribute]" it means you are asking a pin to do something it cannot do. In the example the pin does not support the pull up attribute. You can [see this page](https://github.com/bdring/FluidNC/wiki/ESP32-Pin-Reference) for details of the ESP32 pins.

I2SO expansion pins are very restricted and can only do digital (On/Off) output. 

## Why do I get weird errors uploading config files?

Try deleting unused config files. There may not be enough space. Use `$localfs/list` to see the contents of the local file system. Use `$LocalFS/Delete=<file>` to remove files.

## What does "No homing cycles defined" mean

You will get this error if you try to home with **\$H** and have no homing cycles in your config. [Homing cycles](http://wiki.fluidnc.com/en/config/axes#homing) are defined for each axis. The default is `cycle: 0`. You must have at least one that is not 0 to use **\$H**.

If you have a major error in your config file, it reboots with a very basic default config that has no homing cycles. The purpose of this config is to give you just enough usability to fix the problems.

## The ESP32 Panic'ed and rebooted.

This could be a normal reaction to a bad config file. FluidNC forces a reboot to enter a default state where you can fix the problem. If you look at the text before the panic, you will likely see an error [MSG:ERR:...].

You must use FluidTerm (or serial terminal) to see these messages because they are displayed before the WiFi or Bluetooth are enabled. 

In this case the config file had more than one use of gpio.35.

[MSG:ERR: ERR: gpio.35 - Pin is already used.]

Fix the problem, reload the file and reboot. Note: It reboots on the first error it sees, so the next error will not be displayed. It might take a couple fixes and restarts if you don't fix all the errors at one time.



```
Resetting MCU

[MSG:INFO: FluidNC v3.7.4 (NewAlarms-3b4cc9f5)]
[MSG:INFO: Compiled with ESP32 SDK:v4.4.4]
[MSG:INFO: Local filesystem type is littlefs]
[MSG:INFO: Configuration file:6P_ss_XYZ.yaml]
[MSG:ERR: ERR: gpio.35 - Pin is already used.]
Guru Meditation Error: Core  1 panic'ed (LoadProhibited). Exception was unhandled.

Core  1 register dump:
PC      : 0x4008d038  PS      : 0x00060430  A0      : 0x801d2d04  A1      : 0x3ffb1910
A2      : 0x00000007  A3      : 0x00000003  A4      : 0x000000ff  A5      : 0x0000ff00
A6      : 0x00ff0000  A7      : 0xff000000  A8      : 0x002e0455  A9      : 0x3ffb1be0
A10     : 0x00000003  A11     : 0x00060423  A12     : 0x00060420  A13     : 0x00000015
A14     : 0x00ff0000  A15     : 0xff000000  SAR     : 0x00000017  EXCCAUSE: 0x0000001c
EXCVADDR: 0x00000007  LBEG    : 0x4008d059  LEND    : 0x4008d069  LCOUNT  : 0xffffffff


Backtrace: 0x4008d035:0x3ffb1910 0x401d2d01:0x3ffb1920 0x401cf9fd:0x3ffb1c30 0x400ec686:0x3ffb1cf0 0x400d6daa:0x3ffb1e40 0x400e1331:0x3ffb1e70 0x400ee0a3:0x3ffb1ea0 0x400e25a6:0x3ffb1ec0 0x400e1abf:0x3ffb1f10 0x400e2124:0x3ffb1f30 0x400e25a6:0x3ffb1f60 0x400e2ad1:0x3ffb1fb0 0x400e3099:0x3ffb2030 0x400e31fd:0x3ffb2230 0x400e4574:0x3ffb2260 0x4011a2f6:0x3ffb2290

[MSG:INFO: FluidNC v3.7.4 (NewAlarms-3b4cc9f5)]
[MSG:INFO: Compiled with ESP32 SDK:v4.4.4]
[MSG:INFO: Local filesystem type is littlefs]
[MSG:ERR: Skipping configuration file due to panic]
[MSG:INFO: Using default configuration]
[MSG:INFO: Axes: using defaults]
[MSG:INFO: Machine Default (Test Drive)]
```

## The ESP32 is stuck in a boot loop and I cannot connect with FluidTerm

This could be a bad or under-powered PSU. In some cases, you might hear one of the motors making a thump or clicking noise. If unplugging one of the motors allows it to boot, this is probably the issue.

## Can I use a joystick for jogging?

You cannot connect a joystick directly to FluidNC. This would use a lot of i/o pins and there are many types of joystick, so the firmware would be bloated and complicated.

Many gcode senders support joysticks (The WebUI does not). You could put the joystick on the PC and use a gcode sender that supports joysticks, like UGS.

You can create a pendant with a joystick, This would require an external MCU and use the Grbl protocol over UART channels. Realtime joystick jogging is a complicated task and we cannot help you with that. There is some [good info at the Grbl repo](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Jogging) and you could also look at open source gcode sender's source code.

Most people are using dial encoders on pendants for jogging.