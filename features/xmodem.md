---
title: XModem
description: XModem File Upload/Download
published: true
date: 2026-08-01T19:36:56.835Z
tags: 
editor: markdown
dateCreated: 2022-07-21T19:59:17.592Z
---

# XModem file upload

You can use xmodem via serial port to upload files to the localfs. This can be helpful to upload config or gcode files and other resources. The controller must be in the `Idle` or `Alarm` mode to be able to use the XModem feature.

FluidNC supports the [XModem-1K](https://en.wikipedia.org/wiki/XMODEM#XMODEM-1K) with CRC16. 

Here are some example implementations of the protocol in different programming languages. All of the existing libraries for this had some parts missing or did not implement the protocol correctly. These can be used as a reference:
* [TypeScript](https://github.com/breiler/fluid-installer/blob/master/src/utils/xmodem/xmodem.ts)
* [Java](https://github.com/winder/Universal-G-Code-Sender/blob/master/ugs-core/src/com/willwinder/universalgcodesender/connection/xmodem/XModem.java)

## Sending a File to FluidNC

Before files are sent to the FluidNC controller you must enter the `$Xmodem/Receive=<filename>` (or `$XR=<filename>`) command. You will see the 'C' character outputting on the terminal. You must then initiate the xmodem transfer on your terminal program. It will timeout if the transfer is not started after a period of time.

> The default location of the LocalFS, but you can specify it with **/sd/** or **/localfs/**, like `$Xmodem/Receive=/sd/test.gcode`
{.is-info}




```
?<Idle|WPos:0.000,0.000,-3.000|FS:0.000,0>

$XModem/Receive=new.yaml
[MSG:INFO: Receiving new.yaml via XModem]
C[MSG:INFO: Received 5433 bytes]
ok
?<Idle|WPos:0.000,0.000,-3.000|FS:0.000,0>
$localfs/list

[FILE:/foo.12|SIZE:0]
[FILE:/foo.1|SIZE:0]
[FILE:/foo.yam|SIZE:0]
[FILE:/test.yaml|SIZE:5]
[FILE:/favicon.ico|SIZE:1150]
[FILE:/index.html.gz|SIZE:116657]
[FILE:/new.yaml|SIZE:5433]
[Local FS Free:46.08 KB Used:123.29 KB Total:169.38 KB]
ok

```

## Downloading a file from FluidNC

Enter the `$XModem/Send=<filename>` command. Then start the xmodem receive on your terminal program.

```
?<Idle|WPos:0.000,0.000,-3.000|FS:0.000,0>
$XModem/Send=index.html.gz
[MSG:INFO: Sending index.html.gz via XModem]
[MSG:INFO: Sent 116736 bytes]
ok
?<Idle|WPos:0.000,0.000,-3.000|FS:0.000,0|WCO:0.000,0.000,3.000>

```

 

## Terminal Programs that support XModem

The easiest way is via Fluidterm. Use CTRL+T then CTRL+X to begin the upload. 

- Windows
  - Tera Term
- Mac
  - [screen with lrzsz](https://www.unixfu.ch/upload-firmware-to-a-switch-with-xmodem-from-a-mac/)
- Linux
  - [Minicom](https://launchpad.net/ubuntu/bionic/+package/minicom) with [lrzsz](https://launchpad.net/ubuntu/bionic/+package/lrzsz)