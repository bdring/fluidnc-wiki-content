---
title: Commands and Settings
description: 
published: true
date: 2026-08-01T19:35:44.075Z
tags: 
editor: markdown
dateCreated: 2022-07-21T21:46:55.183Z
---

# FluidNC Commands and Settings

FluidNC commands and settings use a `$<text>` or `$<text>=<value>` format.
  
# Commands

Commands are used for actions (like homing or disabling motors) or retrieve information (like gcode offsets).  Many commands have a full name format as well as a shorter version. Like $Gcode/Mode and $G. Many of the command shortcuts are compatible with Grbl.

The use of commands is dependant on the current state. Many cannot be used in non idle or alarm states.
  
## $Alarm/Disable or $X

- Tries to clear the alarm state (unlock).

```
Grbl 3 [FluidNC v3.7,2 (wifi) '$' for help]
[MSG:INFO: '$H'|'$X' to unlock]
<Alarm|WPos:0.000,-80.000,-10.540|Bf:15,128|FS:0,0|WCO:0.000,80.000,10.540>
$X
[MSG:INFO: Caution: Unlocked]
ok
<Idle|WPos:0.000,-80.000,-10.540|Bf:15,128|FS:0,0|Ov:100,100,100>
```

## $Alarms/List or $A

- This lists the description of the alarm numbers. You can get a description of a specific number like this `$A=5`

## $Alarm/Send=<alarm_num>

This is used to manually create an [alarm](http://wiki.fluidnc.com/en/support/alarm_and_error_codes#alarm-codes) This can be used for testing or in [conditional gcode](http://wiki.fluidnc.com/en/features/gcode_parameters_expressions#flow-control) to stop a running job with an error. See the [alarms page](http://wiki.fluidnc.com/en/support/alarm_and_error_codes#alarm-codes) for descriptions of the numbers.

```
$H
[MSG:Homed:Z]
[MSG:Homed:XY]
ok
<Idle|WPos:-48.000,89.000,44.577,0.000|Bf:15,128|FS:0,0>
$Alarm/Send=5
ok
[MSG:INFO: ALARM: Probe Fail Contact]
ALARM:5
<Alarm|WPos:-48.000,89.000,44.577,0.000|Bf:15,128|FS:0,0>
```

## $Build/Info or $I

- This is an old Grbl command that will show you a bunch of info like:

```
[VER:3.4 FluidNC v3.4.8:]
[OPT:MPHS]
[MSG: Machine: TMC2209 XY Servo Laser]
[MSG: Mode=AP:SSID=FluidNC:IP=192.168.0.1:MAC=AC-0B-FB-24-EE-C9]
```

  ## $Bye

- Reboots the processor

## $Channel/Info or $CI

- Lists all communication channels primarily for developer use.

```
$CI
uart
macros
```

## $Commands/List or $CMD

- This shows all the commands

````
$cmd
$FakeLaserMode or $32
$FakeMaxSpindleSpeed or $30
```
````

## $GPIO/Dump

- Shortcut: `GD`
- Shows detailed information on all gpio pins. Pins configured as input have the prefix `I`, and pins configured as output have the prefix `O`. The status of the pin is either `0` (low) or `1` (high). In the example below, pin 2, `GPIO2 I0`, means gpio2 is configured as an input and was read as a logic 0, or low.

```none
0 GPIO0 I1
1 U0TXD
2 GPIO2 I0
3 U0RXD
4 GPIO4 I0
5 GPIO5 O1
6 SPICLK
7 GPIO7 O0 I1 SPIQ_out
8 GPIO8 O0 I0 SPID_out
9 GPIO9 O0 I1 SPIHD_out
...
Input Matrix
1 SPIQ_in 7
...
9 HSPIQ_in 19
10 HSPID_in 23
```

## $Errors/List or $E

- This lists the description of the error numbers. You can see specific number like $E=5

## $FakeLaserMode or $32

- This command is used for Grbl command compatibility, so senders can set this value. FluidNC is always in laser mode if a laser is configured and the active spindle.

## $FakeMaxSpindleSpeed or $30

- This command is used for Grbl laser compatibility, so senders can set this value. FluidNC is always in laser mode if a laser is configured and the active spindle

## $Firmware/Info or $ESP800


```
$firmware/info
FW version: FluidNC v3.7,2-pre3 (FaultPin-cd7ec064) # FW target:grbl-embedded  # FW HW:Direct SD  # primary sd:/sd # secondary sd:none  # authentication:no # webcommunication: Sync: 81:192.168.0.1 # hostname:fluidnc(AP mode) # axis:3
```

## $GCode/Check or $C

- This toggles the gcode check mode. This is an old Grbl feature that lets you run gcode virtually. The machine will run through all the gcode without actually moving and will tell you if anything would have caused an alarm or error. Be sure to toggle it back off to leave check mode.

## $Gcode/Echo

- This will echo gcode and FluidNC commands that you enter at a console or come from a gcode file. This can be helpful when debugging problems in files and macros.

```
$Gcode/Echo=on
ok
G17
[echo: G17]
ok
G91
[echo: G91]
ok
```

## $GCode/Modes or $G

- Shows the state of all of the modal gcodes.

```
$G
[GC:G0 G54 G17 G21 G90 G94 M5 M9 T0 F0 S0]
```

## $GCode/Offsets or $#

- This shows all the offsets saved in non-volatile memory

```
$#
[G54:0.000,80.000,10.540]
[G55:0.000,0.000,0.000]
[G56:0.000,0.000,0.000]
[G57:0.000,0.000,0.000]
[G58:0.000,0.000,0.000]
[G59:0.000,0.000,0.000]
[G28:6.000,77.000,30.000]
[G30:6.000,77.000,50.000]
[G92:0.000,0.000,0.000]
[TLO:0.000]
```

## $Gpio/Dump or $GD

This does a dump of the internal state of the ESP32 I/O. It is primarily for developer use only, because it requires a pretty deep knowledge of the ESP32. As an example `39 GPIO39 I1` means gpio.39 is configured as an input with a current state of high.

```
0 GPIO0 I1
1 U0TXD
2 GPIO2 I0
3 U0RXD
4 GPIO4 I1
5 GPIO5 O32
6 SPICLK
7 GPIO7 O0 I1 SPIQ_out
8 GPIO8 O0 I0 SPID_out
9 GPIO9 O0 I1 SPIHD_out
10 GPIO10 O0 I0 SPIWP_out
11 GPIO11 O0 I1 SPICS0_out
12 MTDI
13 GPIO13 O0
14 GPIO14 O0 ledc_hs_sig_out0
15 MTDO
16 GPIO16 O65536 I1 U1TXD_out
17 GPIO17 O131072 I2S0O_WS_out
18 GPIO18 O0 I0 HSPICLK_out
19 GPIO19 O0 I0 HSPIQ_out
21 GPIO21 O0 I2S0O_DATA_out23
22 GPIO22 O0 I2S0O_BCK_out
23 GPIO23 O0 I0 HSPID_out
25 GPIO25 O33554432 U2TXD_out
26 GPIO26 I1
27 GPIO27 I0
32 GPIO32 I1
33 GPIO33
34 GPIO34 I1
35 GPIO35 I1
36 GPIO36
37 GPIO37
38 GPIO38
39 GPIO39 I1
Input Matrix
1 SPIQ_in 7
2 SPID_in 8
3 SPIHD_in 9
4 SPIWP_in 10
8 HSPICLK_in 18
9 HSPIQ_in 19
10 HSPID_in 23
17 U1RXD_in 4
198 U2RXD_in 26
```

## $GrblNames/List or $L

- Shows the list of ESPxxx commands and the text equivalents. Typically for developers only

```
$10 => $Report/Status
$ESP116 => $WiFi/Mode
$ESP100 => $Sta/SSID
$ESP101 => $Sta/Password
$ESP102 => $Sta/IPMode
$ESP105 => $AP/SSID
$ESP106 => $AP/Password
$ESP107 => $AP/IP
$ESP108 => $AP/Channel
$ESP112 => $Hostname
$ => $HTTP/BlockDuringMotion
$ESP120 => $HTTP/Enable
$ESP121 => $HTTP/Port
$ESP130 => $Telnet/Enable
$ESP131 => $Telnet/Port
```

## $GrblSettings/List or $$

- This is an old Grbl command that shows the $$ settings. We only support $10 in the Grbl numeric style.

## $Grbl/Show or $GS

- This causes FluidNC to output the Grbl startup string. This could be needed for some senders.

## $Heap/Show or $Heap

- Displays the current amount of free space and the lowest amount of free space for the memory heap. This can be useful for debugging FluidNC problems.

## $Help or $

- This is basically the old Grbl `$` command that list all the Grbl commands.

```
$
HLP:$$ $+ $# $S $L $G $I $N $x=val $Nx=line $J=line $SLP $C $X $H $F $E=err ~ ! ? ctrl-x
ok
```

## $Home, $H, or $H\<xxx\>

Homing Commands. There are several forms

- `$Home or $H` This does a complete homing of you machine as define in the config file
- `$H<axis_letter>` This homes the axis specified
- `$H=<cycle_number(s)>` This homes by the cycle number specified as defined in the config file. You can give more than one cycle number and it will home them in the order given in the command, like **$H=21** to home cycle 2 then cycle 1.
- `$H=<letter(s)>` like $H=Z or $H=XY where X & Y are homed at the same time.

Useful links: [Homing Process](http://wiki.fluidnc.com/en/features/homing), [Config File Homing Details](http://wiki.fluidnc.com/en/config/homing_and_limit_switches)

<a name="http_command"></a>
## $HTTP/Command

This is a command to communicate with an external server to read and set value and execute commands. It can be used in gcode macros to use external data. This is an advanced feature that requires a lot of programming skills to use. It is documented in the `examples/http_command` folder of the FluidNC GitHub repo.

Here is an example.

```
$http/command=http://10.0.0.148:8000/api/read{"extract":{"_temperature":"temp","_humidity":"humidity"}}"
[MSG:INFO: HTTP: 200]
ok
$parameters/list
Named Parameters
[MSG:INFO: _HTTP_RESPONSE_LEN = 267.000]
[MSG:INFO: _HTTP_STATUS = 200.000]
[MSG:INFO: _HUMIDITY = 55.300]
[MSG:INFO: _TEMPERATURE = 22.300]
[MSG:INFO: No active jobs - no local parameters]
```

## $HTTP/Settings/Load or $HSL

Reloads /localfs/http_settings.json. See $Http/Commands


## $Jog or $J

- [Used for the special ](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Jogging)[Grbl Jog mode](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Jogging).

## $Limits/Show or $Limits

You can view the real time switch status. [More info on this page ](http://wiki.fluidnc.com/en/config/homing_and_limit_switches#testing)

## $LocalFS/Backup

Write files on the local file system to the SD card.

```
$LocalFS/Backup
[MSG:INFO: /localfs/config.yaml -> /sd/localfs/config.yaml]
[MSG:INFO: /localfs/favicon.ico -> /sd/localfs/favicon.ico]
[MSG:INFO: /localfs/index.html.gz -> /sd/localfs/index.html.gz]
[MSG:INFO: /localfs/macro1.g -> /sd/localfs/macro1.g]
[MSG:INFO: /localfs/macrocfg.json -> /sd/localfs/macrocfg.json]
```

## $LocalFS/Delete

- See the [LocalFS](http://wiki.fluidnc.com/en/features/local_file_system) page
## $LocalFS/Format

## $LocalFS/List

Display the files on flash memory.

```
$LocalFS/List
[FILE: config.yaml|SIZE:0]
[FILE: favicon.ico|SIZE:18450]
[FILE: index.html.gz|SIZE:116654]
[FILE: macro1.g|SIZE:3]
[FILE: macrocfg.json|SIZE:919]
[/littlefs/ Free:44.00 KB Used:148.00 KB Total:192.00 KB]
```

## $LocalFS/ListJSON =path

## $LocalFS/Run

## $LocalFS/Show

Display the contents of a file (similar to `cat`).

```
$LocalFS/Show=macrocfg.json
[]
 {
  "name": "$MD",
  "glyph": "remove",
  "filename": "/macro1.g",
  "target": "ESP",
  "class": "btn btn-danger",
  "index": 0
 },
 {
  "name": "",
  "glyph": "",
  "filename": "",
  "target": "",
  "class": "",
  "index": 1
 }
]
```

## $LocalFS/Size

Show the total and used local file storage sizes.

```
$LocalFS/Size
LocalFS  Total:192.00 KB Used:148.00 KB
```

## $LocalFS/Hashes

List the SHA-256 hash of all local files

```
$LocalFS/Hashes
[MSG:INFO: config.yaml: "E899A382F65B179A8FF5898C703A0B78C5C1DA8F5AD5DB343BF751DEFD66E101"]
[MSG:INFO: favicon.ico: "B8B2871A343CA0F9A7A130213226962AD2BE4DFD28D7D8B756C3557569CB876D"]
[MSG:INFO: index.html.gz: "1819A3FE628608006AAFF4D497F96373A88A2B9011D867E0FFB35551CF4EAF13"]
[MSG:INFO: preferences.json: "9E61574525CC8DC3F0766A30A073A230145E8784AEC71B5CA8ED499932D636A3"]
ok
```

## $LocalFS/Rename =path

## $LocalFS/Migrate =path

## $LocalFS/Restore =path

## $Log/Msg or $LM

Sends an error message to the console that sent the command

```
$log/MSG=Test Message
[MSG:Test Message]
ok
```
## $Log/Warn or $LW

Sends a warning message to the console that sent the command

## $Log/Info or $LI

Sends an info message to the console that sent the command

## $Log/Debug or $LD

Sends a debug message to the console that sent the command

## $Log/Verbose or $LV

Sends a verbose message to the console that sent the command


## $Macros/Run or $RM

- [Send $Macros/Run= to run the ](http://wiki.fluidnc.com/en/config/macros)[macro defined in your config file](http://wiki.fluidnc.com/en/config/macros)

## $Motor/Disable or $MD

- Manually disables motors. This allows you to manually move them. You can also disable a single [axis](http://wiki.fluidnc.com/en/config/axes#idle_ms) with $MD=. The motor(s) will behave the same as if the [idle_ms:](http://wiki.fluidnc.com/en/config/axes#idle_ms) time has expired. The motors will re-enable with the next motion command.

## $Motor/Enable or $ME

- **[since v3.6.3]** Manually enables motors. This locks the motors. You can also enable a single axis with $ME=\<axis\>. The motors will return to the idle_ms setting after the next move completes and you return to idle mode.

## $Motors/Init or $MI

- This is used to reinitialize motors. It is primarily for SPI and UART types. If you forget to have power on at startup or change a setting like run current. You can send $MI to reinitialize the motors.

## $Msg/Channel or $MC

Sends a message to a channel

```
$channel/info
uart_channel0
ok
$msg/channel=uart_channel0,Hello
[MSG:Hello]
```

## $Msg/Uart0 or $MU0

Sends a message to Uart0

## $Msg/Uart1 or $MU1

Sends a message to Uart1

## $Notification/Send or $ESP600

- Sends a notification using [configured way](#notification_type). $ESP600=Text.

## $Notification/Setup

<a name="parameters_list"></a>
## $Parameters/List or $PL

This list the gcode parameters currently defined. [See this for more info](http://wiki.fluidnc.com/en/features/gcode_parameters_expressions#PL).

## $Radio/State

- Gets or sets the on/off state of the radio. $Radio/State=On or Off.

## $Report/Interval or $RI

- [Controls ](http://wiki.fluidnc.com/support/interface/automatic_reporting)[Automatic Reporting](http://wiki.fluidnc.com/support/interface/automatic_reporting) on the issuing channel

## $SD/Delete


- See the [LocalFS](http://wiki.fluidnc.com/en/features/local_file_system) page

## $SD/List

List the files on the SD card.

```
$SD/List
[DIR:.fseventsd]
[FILE:  fseventsd-uuid|SIZE:36]
[FILE:  00000000096737f7|SIZE:56]
[FILE:  00000000096737f8|SIZE:72]
[DIR:localfs]
[FILE:  config.yaml|SIZE:225]
[FILE:  favicon.ico|SIZE:1150]
[FILE:  index.html.gz|SIZE:116654]
[FILE:  macro1.g|SIZE:3]
[FILE:  macrocfg.json|SIZE:919]
[/sd/ Free:61.90 MB Used:120.50 KB Total:62.01 MB]
```

## $SD/ListJSON

## $SD/Run

## $SD/Show

Display the contents of a file on the SD card (similar to `cat`).

```
$SD/Show=/sd/localfs/macro1.g
$MD
```

## $SD/Rename=current_name\>new_name

Rename a file on the SD card.

```
$SD/Rename=foo.gcode>foo.nc
```



## $SD/Status or $ESP200

## $Files/ListGcode=\<path>

- For use with uart pendants and displays. Lists only gcode files (.g .gc .gco .gcode .nc .ngc .ncc .txt .cnc .tap). The SD card root is assumed unless you include a path. Each line must be acked with 0xB2

```gcode
$Files/ListGcode ; Lists all gcode files in the root folder of the SD card

$File/ListGcode=/Folder1 ; List all gcode files in Folder1 of the root.

$File/ListGcode=/localfs/ ; List all gcode files in the root of the localfs

```

## $File/ShowHash

```
$File/ShowHash=index.html.gz
[JSON:{"signature":{"algorithm":"SHA2-256","value":"1819A3FE628608006AAFF4D497F96373A88A2B9011D867E0FFB355]
[JSON:51CF4EAF13"},"path":"index.html.gz"}]
ok
```

## $File/SendJSON


## $File/ShowSome=\<lines>,\<path>

- For use with uart pendants and displays. Shows the lines of a file. The SD card root is assumed unless you include a path. Each line must be acked with 0xB2 

```gcode
$File/ShowSome=10,frodo.nc  ; show first 10 lines

$File/ShowSome=10,20,frodo.nc ; show lines 10 through 20
```

## $Settings/Erase or $NVX

- Clears the NVS (settings)

## $Settings/List or $S

- Shows the value of all settings

## $Settings/ListChanged or $SC

- This shows you all NVS settings that have changed from the default. You can use this to save them if you plan to erase the ESP32.

## $Settings/Restore or $RST

- This restores things to defaults values.
  - RST=$ will restore settings
  - RST=# Will restore the system offsets G54, etc
  - RST=* Restores everything above.

## $Settings/Stats or $V

- This shows you the status of the NVS (non volatile storage ) system. It looks like this.

```
[MSG:INFO: NVS Used:191 Free:439 Total:630]
```

## $Sta/Setup or $ESP103

## $Startup/Show or $SS

- [This command allows you to see the ](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages)[startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages) at any time. If you did not have a serial port connected at boot time, this is an alternate way to see those messages. Works from WebUI or any interface.

```
[MSG:INFO: FluidNC v3.7,1]
[MSG:INFO: Compiled with ESP32 SDK:v4.4.4]
[MSG:INFO: Local filesystem type is littlefs]
[MSG:INFO: Configuration file:6P_ss_XYZ.yaml]
[MSG:INFO: Machine 6 Pack StepStick XYZ]
...
ok
```



## $State or $T

- Send $System/Control=RESTART to reboot the processor

```
$state
State 1 (Alarm)
```



## $System/Control or $ESP444

- Send $System/Control=RESTART to reboot the processor

## $System/IP or $ESP111

## $System/Sleep $SLP

## $System/Stats or $ESP420

Displays information about the microcontroller state and FluidNC settings.

```
$System/Stats
Chip ID: 26773
CPU Cores: 2
CPU Frequency: 240Mhz
CPU Temperature: 57.8°C
Free memory: 109.79 KB
SDK: v4.4.4
Flash Size: 4.00 MB
Sleep mode: Modem
Available Size for update: 1.88 MB
Available Size for LocalFS: 192.00 KB
Web port: 80
Data port: 23
Hostname: fluidnc
Current WiFi Mode: AP (08:3A:F2:22:3B:69)
SSID: FluidNC
Visible: Yes
Radio country set: 01
                       (channels 1-11, max power 20dBm)
Authentication: WPA2-PSK
Max Connections: 4
DHCP Server: Started
IP: 192.168.0.1
Gateway: 192.168.0.1
Mask: 255.255.255.0
Connected channels: 0
Disabled Mode: STA (08:3A:F2:A9:95:68)
Notifications: Disabled
FW version: FluidNC v3.7.11
```

There is also a possibility to get this information encoded as a JSON object by sending the command `[ESP420]json=yes` which will result in a response like this:

```
[JSON:{"cmd":"420","status":"ok","data":[{"id":"Chip ID","value":"30743"},{"id":"CPU Cores","value":"2"},{]
[JSON:"id":"CPU Frequency","value":"240Mhz"},{"id":"CPU Temperature","value":"51.7°C"},{"id":"Free memory]
[JSON:","value":"135.17 KB"},{"id":"SDK","value":"v4.4.7-dirty"},{"id":"Flash Size","value":"4.00 MB"},{"i]
[JSON:d":"Sleep mode","value":"Modem"},{"id":"Available Size for update","value":"1.88 MB"},{"id":"Availab]
[JSON:le Size for LocalFS","value":"192.00 KB"},{"id":"Web port","value":"80"},{"id":"Data port","value":"]
[JSON:23"},{"id":"Hostname","value":"fluidnc"},{"id":"Current WiFi Mode","value":"STA (48:E7:29:A3:17:78)"]
[JSON:},{"id":"Connected to","value":"WifiName"},{"id":"Signal","value":"78%"},{"id":"Phy Mode: ","va]
[JSON:lue":"11n"},{"id":"Channel: ","value":"1"},{"id":"IP Mode: ","value":"DHCP"},{"id":"IP: ","value":"1]
[JSON:92.168.1.30"},{"id":"Gateway: ","value":"192.168.1.1"},{"id":"Mask: ","value":"255.255.255.0"},{"id"]
[JSON::"DNS: ","value":"192.168.1.1"},{"id":"Disabled Mode","value":"AP (48:E7:29:A3:17:79)"},{"id":"FW ve]
[JSON:rsion","value":"FluidNC v3.9.2-pre2"}]}]
ok
```

## Uart/Passthrough or $UP

## $WebUI/Help or $ESP0

- Gives detailed information about WebUI commands.

## $WebUI/List $ESP400

## $WebUI/Set or $ESP401

## $WiFi/ListAPs or ESP410

  - This will show all the Wifi access points the ESP32 can see along with the strengths of the signals

```
$wifi/listaps
{"AP_LIST":[

    {"SSID":"Temp wifi",

      "SIGNAL":"86",

      "IS_PROTECTED":"1"

    },

    {"SSID":"Barts-WLAN",

      "SIGNAL":"62",

      "IS_PROTECTED":"1"

    }

  ]

}
```



## $Xmodem/Receive or $XR

- [Receive a file sent to FluidNC](http://wiki.fluidnc.com/en/features/xmodem#sending-a-file-to-fluidnc)

## $Xmodem/Send or $XS

- [Send a file from FluidNC](http://wiki.fluidnc.com/en/features/xmodem#downloading-a-file-from-fluidnc)


# Settings

Settings are used to set saved values. Most settings are now in the config file, but there are a few like **$Confg/Filename** that need to be outside the config file. You can see all of them with **\$S**.

## Grbl Setting Compatibility

 We only support a few standard Grbl $<number> settings. We tried to support any setting that might be used during normal operation like **$10**. Standard Grbl settings that are used to setup a machine are not supported. This is because FluidNC has many times more settings than Grbl.

**Here is a rough mapping of Grbl settings to to FluidNC)** 

- $0 Step Pulse Microseconds ([in the stepping: section of the config file](http://wiki.fluidnc.com/en/config/axes#stepping))
- $1 Step idle delay, milliseconds ([[in the stepping: section of the config file](http://wiki.fluidnc.com/en/config/axes#stepping))
- $2 Step port invert, mask (set per motor [in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $3 Direction port invert, mask (set per motor [in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $4 Step enable invert, boolean (set per motor [in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $5 Limit pins invert, boolean (set per switch per motor[in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $6 Probe invert ([in probe section of config file](http://wiki.fluidnc.com/en/config/probe))
- $10 Status Report Mask (Supported)
- $11 junction deviation, mm ([see in the top of the config file](http://wiki.fluidnc.com/en/config/top_level_config_items#fluidnc-top-level-keys))
- $12 Arc tolerance, mm ([see in the top of the config file](http://wiki.fluidnc.com/en/config/top_level_config_items#fluidnc-top-level-keys))
- $13 Report inches, boolean ([see in the top of the config file](http://wiki.fluidnc.com/en/config/top_level_config_items)
- $20 Soft limits, boolean (can be set per axis [in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $21 Hard limits, boolean (can be set per motor [in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $22 Homing Cycle ([in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $23 Homing Dir invert mask ([in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $24 Homing Feed ([in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $25 Homing Seek ([in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $26 Homing debounce (hard coded in firmware)
- $27 homing pulloff (can be set per motor [in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $30 Max Spindle ([see speed maps](http://wiki.fluidnc.com/en/config/spindle_speed_maps), FNC will fake a response)
- $31 Min Spindle Speed ([see speed maps](http://wiki.fluidnc.com/en/config/spindle_speed_maps), FNC will fake a response) 
- $32 Laser Mode ([use a laser spindle](http://wiki.fluidnc.com/en/config/config_spindles), FNC will fake a response)
- $100-$102 Steps/mm ([set per axis in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $110-$112 Max Rates ([set per axis in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $120-$122 Accelerations ([set per axis in config file](http://wiki.fluidnc.com/en/config/axes#axes))
- $130-$132 Max Travels ([set per axis in config file](http://wiki.fluidnc.com/en/config/axes#axes))

## How to use them

You set the value by setting a value like this `$Config/Filename=test.yaml`. You can see the current value by just sending the setting name like `$Config/Filename`. If you send just a part of the setting name like `$STA`, all settings with STA in the name will be shown with their current values.

Settings have different types like integer, float, String and Enum. Enum is one of a list of values. You can see the valid type by sending something like `$Wifi/Mode=*`. It will respond with the valid values **[MSG:INFO: Valid options: Off AP STA STA>AP]**.

The list of settings depends whether your firmware was compiled for WiFi or Bluetooth. Below is a list of all settings.

## $Start/Message

**[since v3.4.8]** This sets the start message. Some Grbl Gcode senders expect a very specific value and revision, so this allows you to set whatever you want.

Accepts these substitution sequences:
\V - expands to version info like: 3.4
\B - expands to build info like: v3.4.6 (Devt-827770e-dirty)
\R - expands to radio info like: wifi
\H - expands to: '' for help

The default value is: Grbl \V [FluidNC \B (\R) \H] for **Grbl 3.4 [FluidNC v3.4.8 (wifi) '' for help]**
Start/Message=Grbl 1.1g [\H] would give \**Grbl 1.1g ['' for help]**

## $Firmware/Build

Additional information for the [VER: ... :] report that is issued in response to $I. The default value is the empty string, so nothing will be added after the final : in the [VER: ... :] report. If you were to set $Firmware/Build to "test", the report would say [VER: ... :test]

## $Report/Status

Controls the format of status reports issued in response to '?'. This is the same as GRBL's $10 setting. The values are
**0** - Report positions in work coordinates, without buffer status
**1** - Report positions in machine coordinates, without buffer status
**2** - Report positions in work coordinates, with buffer status
**3** - Report positions in machine coordinates, with buffer status

## $Config/Filename

This sets the name of the file to be loaded for the configuration.

## $Message/Level

This sets the level information that is reported. The default level is **Info**. The valid levels are **None**, **Error**, **Warning**, **Info**, **Debug**, and **Verbose**. **Debug** can be used to give additional info when solving problems. It is best to use **Info** for normal operation.
  
```
$Message/Level=Debug
$HX
[MSG:DBG: Homing Cycle X]
[MSG:DBG: Homing nextPhase FastApproach]
...
```

<a id="notification_type"></a>
## $Notification/Type

The valid types are:
- **NONE** - no notifications will be sent
- **EMAIL** - notification will be sent as an email
- **LINE**
- **PUSHOVER**

## $Notification/T1

In the case of email notification, there is a login name for the smtp server.

## $Notification/T2

In the case of email notification, there is a password for the smtp server.

## $Notification/TS

 In the case of email notifications, there is an email address, SMTP server address, and port in the format `email_address#smtp_server:port`. The email address is used for both the sender and the recipient.
For example, to send an email notification to [fluidnc@fluidnc.com](mailto:fluidnc@fluidnc.com) using [brevo.com](http://brevo.com/), please enter here:
`fluidnc@fluidnc.com#smtp-relay.brevo.com:465`
If sending notifications does not work, try to enter the IP address of the smtp server instead of its name. For sending via [brevo.com](http://brevo.com/) you should enter:
`fluidnc@fluidnc.com#1.179.115.1:465`

## $Telnet/Enable

True to enable connections via TCP on port 23

## $HTTP/Enable

True to enable HTTP connections on the port given by $HTTP/Port

## $HTTP/Port

Port number for HTTP connections, default 80

## $HTTP/BlockDuringMotion

**[since v3.6.8]** Prevents serving files from LocalFS when the machine is running

## $WiFi/Mode

Value is one of:

- **Off** - WiFi radio off
- **STA** - Station mode (connected to external access point)
- **AP** - ESP32 is the access point (use only for initial setup; not recommended for production use)
- **STA>AP** - Try Station mode but fallback to AP mode if that fails

## $WiFi/FastScan

## $Wifi/PsMode
  
This sets the WiFi power savings mode. The options are `None`, `Max` and `Min`. The default is `None` and recommended for most people unless there are overheating issues. [Details about the modes are here](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-guides/wifi.html#esp32-wi-fi-power-saving-mode). Ask on ESP32 forums for more details. We are not experts on this.

## $Sta/SSID

SSID of the external access point for STA mode. [See this regarding the use of non-ascii characters like accents](http://wiki.fluidnc.com/en/support/faq#international-characters-in-wifi-ssids).

## $Sta/Password

Password for the external access point for STA mode. [See this regarding the use of non-ascii characters like accents](http://wiki.fluidnc.com/en/support/faq#international-characters-in-wifi-ssids).

## $Sta/IPMode

**DHCP** or **Static**

## $Sta/IP

If $Sta/IPMode is **Static**, the IP address to use for FluidNC

## $Sta/Gateway

If $Sta/IPMode is **Static**, the IP address for the gateway

## $Sta/Netmask

If $Sta/IPMode is **Static**, the subnet mask (typically 255.255.255.0)

## $AP/SSID

The IP address to use for AP mode (default "FluidNC")

## $AP/Password

 The password for AP mode (default "12345678")

## $AP/IP

The IP address to use for AP mode (default 192.168.0.1)

## $AP/Country

**[since v3.6.7]** The regulatory domain configured for the AP. Affects available channels and maximum transmit power.

## $Hostname

The host name for this FluidNC instance (default "FluidNC"). Affects access via an MDNS name like "fluidnc.local".

## $Bluetooth/Name

The name of this FluidNC instance for Bluetooth scanning (default "FluidNC").

## $SD/FallbackCS




 

# Realtime Commands
  
Realtime commands can be sent at any time. They are processed immediately and not put in the commands buffer. 

If you need to send a real time command character as a part of another command (for instance when setting a Wifi password) you need to encode it using a URL encoding. To test the encoding you can use https://www.urlencoder.org/.
  
## Realtime ASCII Commands  
  
There are 4 ASCII commands that can be sent from the keyboard.
  
  - <a id="reset"></a>`0x18` (CTRL+X) **Soft Reset**
    - Immediately halts and safely resets Grbl without a power-cycle.
    - If reset while in motion, Grbl will throw an alarm to indicate position may be lost from the motion halt.
    - If reset while not in motion, position is retained and re-homing is not required.
    - If in hold mode, the motion buffer is cleared and position is not lost.
    - A control pin can be used for this feature.
  - `?` **Status Query**
  - `!` **Feed Hold**
    - Places Grbl into a suspend or HOLD state. If in motion, the machine will decelerate to a stop and then be suspended.
    - Command executes when Grbl is in an IDLE, RUN, or JOG state. It is otherwise ignored.
    - If jogging, a feed hold will cancel the jog motion and flush all remaining jog motions in the planner buffer. The state will return from JOG to IDLE or DOOR, if it was detected as ajar during the active hold.
    - A feed hold does not disable the spindle or coolant. Only motion.
    - A control pin can be used for this feature.
  - `~` **Cycle Start / Resume**
    - Resumes a feed hold, a safety door/parking state when the door is closed, and the M0 program pause states.
    - If the parking compile-time option is enabled and the safety door state is ready to resume, Grbl will re-enable the spindle and coolant, move back into position, and then resume.
    - A control pin can be used for this feature.
 
## Realtime Extended ASCII Commands
  
  - `0x84` **Safety Door**
      - This triggers the safety door feature. It works like the [control switch feature](/config/control#safety_door_pin)
  - `0x85` **Jog Cancel**
    - Immediately cancels the current jog state by a feed hold and automatically flushing any remaining jog commands in the buffer.
    - Command is ignored, if not in a JOG state or if jog cancel is already invoked and in-process.
    - Grbl will return to the IDLE state or the DOOR state, if the safety door was detected as ajar during the cancel.
  - **Overrides** [See this page](http://wiki.fluidnc.com/en/features/speed_feed_overrides) for realtime commands related to override commands.