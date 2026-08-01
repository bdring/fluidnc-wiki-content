---
title: How to Request Help
description: 
published: true
date: 2026-08-01T19:39:20.172Z
tags: 
editor: markdown
dateCreated: 2022-07-21T19:41:05.546Z
---

# Requesting help with hardware issues.

The developers spend most of their time with development and support of FluidNC firmware. Support of hardware issues is a lower priority for us. The priority is even lower if you are not a project supporter or are not using [supported hardware](/hardware/existing_hardware).

You can still ask the question on our Discord and GitHub, but the developers may let the rest of the community answer them.
 
# Requesting help for FluidNC

When you request help via a "Problem Report" [GitHub Issue](https://github.com/bdring/FluidNC/issues/new?assignees=&labels=triage&template=problem.yml&title=Problem%3A+) (preferred) or [Discord](https://discord.gg/MDsRDeNsTE) we would like you to provide the following information.

## Use the latest release.

We only support the latest release of the firmware. Make sure you are using that before requesting help. If you bought a controller for FluidNC, a newer revision has probably been released since the controller was manufactured.

## FluidNC Startup Messages

> Do not request any help until you have read the startup messages. **With most issues, the root of your problem is shown in the startup messages.** [If you don't understand the errors and warning read to this page](http://wiki.fluidnc.com/en/support/troubleshooting_config_files).
{.is-success}


When FluidNC starts, it sends out a bunch of messages that describe the firmware version and configuration. This is very helpful for someone trying to help you with your problem. The messages are sent to the [USB/Serial](https://github.com/bdring/FluidNC/wiki/Serial-Port-Usage) port when FluidNC starts up. Use [FluidTerm](http://wiki.fluidnc.com/en/fluidterm/fluidterm_usage) or the terminal in the [Web Installer](https://installer.fluidnc.com/) to connect to the serial port.

> If using the USB/Serial port is not possible, you can get a copy of the startup messages from the WebUI console with the `$Startup/Show` or `$SS` command.
{.is-info}


You can click the reset button on the ESP32 module (preferred) or send `$Bye` via the serial monitor to force a reset to see the startup messages. It will look something like the text below. Please do not include any other text besides the [MSG .....] lines.


> Look for errors and warning in these messages. Try to fix these problems **before asking for help**.
{.is-info}

It should only contain INFO line. No ERR or WARN lines.

```
[MSG:INFO: FluidNC v3.2.4]
[MSG:INFO: Compiled with ESP32 SDK:v3.3.4-432-g7a85334d8]
[MSG:INFO: Configuration file:soft_liim.yaml]
[MSG:INFO: Kinematics: using defaults]
[MSG:INFO: Increasing stepping/pulse_us to the IS2 minimum value 4]
[MSG:INFO: Defaulting to Cartesian kinematics]
[MSG:INFO: Machine Root V4]
[MSG:INFO: Board Root Controller V1]
[MSG:INFO: I2SO BCK:gpio.22 WS:gpio.21 DATA:gpio.12]
[MSG:INFO: SPI SCK:gpio.18 MOSI:gpio.23 MISO:gpio.19]
[MSG:INFO: SD Card cs_pin:gpio.5 dectect:NO_PIN]
[MSG:INFO: Stepping:I2S_stream Pulse:4us Dsbl Delay:5us Dir Delay:5us Idle Delay:255ms]
[MSG:INFO: User Digital Output:0 on Pin:I2SO.21]
[MSG:INFO: Axis count 3]
[MSG:INFO: Axis X (0.000,490.000)]
[MSG:INFO:   Motor0]
[MSG:INFO:     Standard Stepper Step:I2SO.5 Dir:I2SO.6 Disable:I2SO.7]
[MSG:INFO:     All Limit gpio.2]
[MSG:INFO: Axis Y (0.000,736.000)]
[MSG:INFO:   Motor0]
[MSG:INFO:     Standard Stepper Step:I2SO.2 Dir:I2SO.3 Disable:I2SO.4]
[MSG:INFO:     Pos Limit gpio.15]
[MSG:INFO:   Motor1]
[MSG:INFO:     Standard Stepper Step:I2SO.15 Dir:I2SO.0 Disable:I2SO.1]
[MSG:INFO:     Pos Limit gpio.26]
[MSG:INFO: Axis Z (-158.000,0.000)]
[MSG:INFO:   Motor0]
[MSG:INFO:     Standard Stepper Step:I2SO.12 Dir:I2SO.13 Disable:I2SO.14]
[MSG:INFO:     All Limit gpio.27]
[MSG:INFO: Kinematic system: Cartesian]
[MSG:INFO: Using spindle NoSpindle]
[MSG:INFO: Probe Pin: gpio.32]
[MSG:INFO: Connecting to STA SSID:Barts-WLAN]
[MSG:INFO: Connecting.]
[MSG:INFO: Connecting..]
[MSG:INFO: Connected - IP is 192.168.1.16]
[MSG:INFO: WiFi on]
[MSG:INFO: Start mDNS with hostname:http://fluidnc.local/]
[MSG:INFO: SSDP Started]
[MSG:INFO: HTTP started on port 80]
[MSG:INFO: Telnet started on port 23]

Grbl 3.2 [FluidNC v3.2.4 (wifi) '$' for help]
[MSG:INFO: '$H'|'$X' to unlock]
```

You should look over the messages before requesting help. If you see errors (ERR) like `[MSG:ERR: Ignored key direction]`, you might notice that you spelled direction wrong in your config file. Also look for warnings (WARN). 


## Controller Type

What controller hardware are you using? If it is a custom designed controller, please describe it and include pictures and schematics.

We have wiki pages for most popular controllers. Search the wiki for your controller's page.

## ESP32 Boot Messages

The ESP32 outputs a bunch of text at boot. This is pretty esoteric stuff, and we typically don't need to see it when you are requesting help. The rst: part tells the reason for boot.

- 0x1,  Vbat power on reset
- 0x3,  Software reset digital core
- 0x4,  Legacy watch dog reset digital core
- 0x5,  Deep Sleep reset digital core
- 0x6,  Reset by SLC module, reset digital core
- 0x7,  Timer Group0 Watch dog reset digital core
- 0x8,  Timer Group1 Watch dog reset digital core
- 0x9,  RTC Watch dog Reset digital core
- 0xa,  Instrusion tested to reset CPU
- 0xb,  Time Group reset CPU
- 0xc,  Software reset CPU
- 0xd,  RTC Watch dog Reset CPU
- 0xe,  for APP CPU, reseted by PRO CPU
- 0xf,  Reset when the vdd voltage is not stable
- 0x10, RTC Watch dog reset digital core and rtc module

Here is an example.

```
ets Jun  8 2016 00:22:57

rst:0xc (SW_CPU_RESET),boot:0x13 (SPI_FAST_FLASH_BOOT)
configsip: 0, SPIWP:0xee
clk_drv:0x00,q_drv:0x00,d_drv:0x00,cs0_drv:0x00,hd_drv:0x00,wp_drv:0x00
mode:DIO, clock div:1
load:0x3fff0018,len:4
load:0x3fff001c,len:1044
load:0x40078000,len:10124
load:0x40080400,len:5856
entry 0x400806a8
```  

## Released Versions

This message shows the version. A typical released version will look like this.

```
Grbl 3.2 [FluidNC v3.2.4 (wifi) '$' for help]
```

- **Grbl 3.2** This is used because many Grbl gcode senders use that to recognize a Grbl compatible firmware. 
- **FluidNC v3.2.4** This is version. you can compare it to the current version [here](https://github.com/bdring/FluidNC/releases).
- **(wifi)** What radio mode this was compiled for.

## Unreleased Git Version

If you are using firmware that was not compiled through our release system, the message will look like this.

```
Grbl 3.2 [FluidNC v3.2.1 (Devt-865526c-dirty) (wifi) '$' for help]
```
 - **(Devt-865526c-dirty)** Devt refers to the git branch, 865526c refers to the commit id. dirty means this code has been altered.

If you are asking for support, please let us know what changes you have made.

## Version not using Git.

This is not recommended, and we do not support it. The version info will not tell us anything.


## Showing the config file.

You can display the config file as saved on the ESP32 with `$Localfs/Show=\<filename>` like `$Localfs/Show=config.yaml`

You can display the config as it is stored in the ESP32 RAM with `$Config/Dump` or `$CD`. The file in RAM will likely be different from the saved one, because missing sections and corrected values might be used. **Do not post this.** It will not help us fix your problem.

### Pasting the Config file on Github

Be sure to use markdown code blocks with the 3 backticks and yaml keyword. Otherwise, it is hard to read and the required indenting is lost. It should look like this when writing the issue.

````
```yaml
name: "ESP32 DM556 Plasma 3 Axis"
board: "ESP32 Dev Controller V4"

stepping:
  engine: RMT
  idle_ms: 250
  dir_delay_us: 0
```
````
 
...and this when previewing the issue. Color may be different based on the web server used.

 ```yaml
name: "ESP32 DM556 Plasma 3 Axis"
board: "ESP32 Dev Controller V4"

stepping:
  engine: RMT
  idle_ms: 250
  dir_delay_us: 0
```


## Settings

Send $S via the serial terminal to get all of your settings. The settings look like this.

```
$Config/Filename=tmc2209_huanyang.yml
$Message/Level=Info
$Report/Status=1
$Firmware/Build=
```

## Custom changes to FluidNC.

If you made any code changes to FluidNC please tell us exactly what was changed and why.

## GCode

If the problem happens when you are sending gcode, please attach the gcode file and say what program generated the gcode.

## How are you interfacing with FluidNC

Please tell us if you are using a gcode sender, the WebUI, etc.

## Read the frequently asked questions page

[FluidNC FAQ](/support/faq)

## Viewing Debug Text

FluidNC sends a lot of debugging messages that are filtered out by default. You can see them by setting **$Message/Level=Debug** The options are...

- None
- Error
- Warning
- Info
- Debug
- Verbose

Whatever level you select you will also see the lower-level messages above that too. Info is the default level.

## Give a detailed description of the problem

Do not say "The X axis goes backwards". Say something like X axis moves normally with jogging, but goes the wrong way when I try to home it"

The version is shown at the top of the startup messages. You can also get a more detailed version with the **$I** command.

`[VER:FluidNC 3.0-main-8dd3f6a:]` This says version **3.0** from branch **main** and commit **8dd3f6a

Tell us what commands you are sending. Just saying "when I move the axis" could mean a dozen things, like jogging, homing, etc.