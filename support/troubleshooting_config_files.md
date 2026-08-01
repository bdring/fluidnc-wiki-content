---
title: Troubleshooting Config File Problems
description: 
published: true
date: 2026-08-01T19:39:42.356Z
tags: ignored key, en
editor: markdown
dateCreated: 2022-07-21T19:43:23.510Z
---

# Troubleshooting Config File Problems

## Sorry you are here

We know creating your first working config file can be frustrating. We are continuously trying to make it easier. We want the error messages to be more helpful. We are also looking into a web based editor and validator. Your feedback is helpful. If you have anything you think would help our documentation, please let us know.

## Editing the file

You should edit with a fixed width font, so you can see the alignment. It helps to have an editor that color codes the config file. Some even allow you to collapse levels. Here are some editors that are good.

- VS Code
- Notepad++ 

If you have problems look for [MSG ERR...] type statements in the [startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages). 

Some errors may cause a crash or reboot. Look for the messages before the crash. 

## Check the startup messages

The config file is read at startup. If there are any errors or warnings they will be displayed on the serial port with **MSG:ERR** or **MSG:WARN** lines.

[FluidTerm](http://wiki.fluidnc.com/en/fluidterm/fluidterm_usage) will show the startup messages automatically, every time that you restart the FluidNC controller, and will highlight problems in a different color.  Other UIs might or might not show startup messages automatically.  For example, WebUI does not show them because it cannot connect until after the startup messages have already been issued.  You can get around this by sending the command `$SS` in the WebUI command pane, or in any other UI program's console.  Other UIs might not highlight problems with different colors, so you should look carefully for **MSG:ERR** or **MSG:WARN** prefixes.

Here is a problem free example.

![fluidterm.png](/support/fluidterm.png =x450)

## Cannot open configuration file

If you get a message like this (filename may be different)...

```
[MSG:WARN: Cannot open configuration file: config.yaml]
```

FluidNC cannot open the config file. The name of the file is set with `$Config/Filename=<yourfile>`. If you have not set this, `config.yaml` is used as the default filename. The most likely problem is that it cannot find the file on the ESP32. 

No config files are installed during the firmware installation process. You must upload one yourself. **Note:** If the firmware was pre-installed on your controller a config file may have been installed. You can list all files on the controller with `$LocalFS/List`.

Checklist...


  - Make sure you have set `$Config/Filename=<yourfile>` to your filename.
  - Check to see if the file is present on your local file system with `$LocalFS/List`
  - You can check to see the file has good and uncorrupted contents with `$LocalFS/Show=<yourfile>`

> Be careful when upgrading firmware. If you do a full install it will erase all files. Follow the instructions to only upgrade the firmware.
{.is-info}

## Start with the first errors reported

A problem with one key can cause the following keys to appear to be bad. Fixing the first error may fix other errors.

Example of multiple errors caused by one misplaced key.

```yaml
name: "TMC2209 XY Servo Laser"
board: "FluidNC Pen/Laser 2209 V2"

# bad indenting
  stepping:
  engine: RMT
  idle_ms: 255
``` 
These errors will occur

```
[MSG:WARN: Ignored key stepping]]
[MSG:WARN: Ignored key engine]]
[MSG:WARN: Ignored key idle_ms]]
```

In this case the `stepping` is indented when it should not be. The file says `stepping:` belongs to the item it is indented under which is `board:`. `board:` does not have a key called `stepping:`, so the key is ignored.

since `stepping:` is wrong, `engine:` also appears to be under `board:`. Fixing stepping will fix the other 2 errors. 


## Ignored Keys

If you see ignored keys there can only be 2 reasons

1. The key does not exist. Search the wiki for the key name shown in the messages. Check the spelling. 
2. The key is not valid for the item it is indented under.




```
[MSG:ERR: Ignored key badkey]
[MSG:ERR: Ignored key pulloff_mm]
```
- **badkey** is not a valid key in the section being parsed
- **pulloff_ms** is a valid key but not where it was found in the file

## Indent Issues

```yaml
item: value

group:
  item: value
  group:
    item0: value
    item1: value
```

The animation below shows you how indenting changes the structure. An item can be at the root level, be a sub item of the group or have its own sub items. The indent level is extremely important. Using an editor that highlights indenting (Notepad++ shown) can help a lot. 

![indenting.gif](/config/indenting.gif =x160)

The hierarchy of the config file represents the hierarchy of the machine. There are items or groups of items. Each group may consist of several items and sub groups. This is designated by indenting. Items indented under a group name belong to that group. If the indenting is wrong, the items will not be applied to the right group. When you see errors or warnings about indenting fix them in the order they appear in the [startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages). If an error occurs near the beginning it can cause a lot of problems later because a large part of the hierarchy can be broken with a single problem.

Only use spaces to indent. Do not use tabs.

If you see something like this in your [startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages).

```
[MSG:ERR: Skipping key motor0 indent 5 this Indent 4]
```

This is telling you that there is a key `motor0` at indent 5 and the current indent is 4. Look at all the `motor0` keys for one at indent 5 (5 spaces). It is likely at the wrong indent level.


## Message/Level

You can change the message reporting level. The default is "Info" if you change it to "Debug" with $Message/Level=Debug, you will see a lot more messages. These are not errors, but could give some help to what might be causing the problem. Note: There will be hundreds of them.

```
[MSG:DBG: Setting up pin gpio.25:high]
[MSG:DBG: Attempting to set up pin: gpio index 25]
[MSG:DBG: Setting up pin gpio.35:low]
[MSG:DBG: Attempting to set up pin: gpio index 35]
```

## View the Pin Status

Use the [`$GPIO/Dump` or `$GD` command](http://wiki.fluidnc.com/en/features/commands_and_settings#gpiodump) to view the I/O pin status. `I0` means the pin is configured as an input pin reading low (or logic 0), while `I1` means the pin is reading high (or logic 1). `O0` means the pin is configured as an output in reading low (or logic 0), while `O1` means the pin is reading high (or logic 1). You may need to run the `$GD` command several times to read the status of all the pins.

```
$GD
0 GPIO0 I1
1 U0TXD
2 GPIO2 O0 ledc_hs_sig_out2
3 U0RXD
4 GPIO4 O1 I1 U2TXD_out
5 GPIO5 O1
6 SPICLK
7 GPIO7 O0 I0 SPIQ_out
8 GPIO8 O0 I0 SPID_out
9 GPIO9 O0 I1 SPIHD_out
10 GPIO10 O0 I0 SPIWP_out
11 GPIO11 O0 I1 SPICS0_out
12 MTDI
13 GPIO13 I1
14 MTMS
15 GPIO15 O0 ledc_hs_sig_out0
16 GPIO16 I1
17 GPIO17 I1
18 GPIO18 O0 I0 HSPICLK_out
23 GPIO23 O0 I0 HSPID_out
25 GPIO25 O0 I2S0O_BCK_out
26 GPIO26 O1 I2S0O_WS_out
27 GPIO27 O0 I2S0O_DATA_out23
32 GPIO32 I1
33 GPIO33 I1
34 GPIO34 I0
35 GPIO35 I1
36 GPIO36 I1
4 SPIWP_in 10
8 HSPICLK_in 18
9 HSPIQ_in 19
ok
```



 

## Constrained to range

If you get a message like this...

```
[MSG:WARN: frequency_hz value 0 constrained to range (1000000,20000000)]
```
It means that the value you have for the config item is not in the valid numeric range for that config item. In this case the range is 1000000 to 20000000 and you have 0. If you show the current config with `$CD` it will show a value of 1000000. Update your config file to get rid of this message.

## View the config file on the ESP32

Use the **\$localfs/Show=\<filename\>** command to view the file. The name of the file being used for the config is shown in the startup messages. You can also get it with the **\$Config/Filename** command.
  
You can also see the current config with the **\$Config/Dump** command. This will probably look a little different from the file. It dumps the config items in the order it stores them internally and it may show some default config items/values of items not in your file.   

## Pin is already used

Each pin can only be used once. Search for the pin in the file.

## Major Issues

If the problem is really bad, the firmware will load a default config. This cannot be used to control your machine, but you should still be able to see the networking and WebUI to help you fix the problems.

## Reboots

If critical errors occur when processing the config file, FluidNC will force a restart and fall back to a rudimentary "safe" configuration so you
can interact with the system to fix problems. Note: Other bugs, etc, that cause a restart could accidentally trigger Fluid to load a safe configuration.
Critical errors typically occur if you have a correct key, but the value of that key is not valid. 

Look at the data on the serial port for clues to what happened.

```
[MSG:ERR: Configuration parse error: Expected a float value like 123.456 @ 1:8 near : 1.000foo]
Guru Meditation Error: Core  1 panic'ed (LoadProhibited). Exception was unhandled.
Core 1 register dump:
PC      : 0x400f710c  PS      : 0x00060f30  A0      : 0x800da284  A1      : 0x3ffb1f20
A2      : 0x3ffc1a64  A3      : 0x3f4044f0  A4      : 0x3ffb30f4  A5      : 0x00000000
...
```

This shows that a float value was expected, but it read **1.000foo**. Look for that value in your config file and fix it. Trailing spaces can also cause errors.

Be sure to look at the rest of the [startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages), well above the crash point. You may see some [MSG:ERR...] messages about other things that could be contributing to the crash. There can also be errors in your config file that do not force a reset, but must be fixed before you can use the affected feature.

## Asking for help

If the information on this page has not helped your problem, you can ask for help on [Discord](https://discord.gg/FeNc6teAzy) or the [Github issues](https://github.com/bdring/FluidNC/issues). Please provide all of the information below.

- A copy of your [startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages).
- Your config file.



