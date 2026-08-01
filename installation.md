---
title: FluidNC Installation
description: Uploading and Compiling FluidNC
published: true
date: 2026-08-01T19:32:20.209Z
tags: 
editor: markdown
dateCreated: 2022-07-21T12:53:08.421Z
---

# FluidNC Basics

To use FluidNC, you need to do three things:
1. Install the FluidNC firmware on a FluidNC compatible controller.  The program is precompiled and released in binary form, so you do not need to compile it yourself.
2. Configure it for your specific machine by creating/modifying a "config.yaml" file that adapts the controller hardware to your specific machine.
> You will be tempted to find an existing config.yaml and use it for your machine, without looking carefully at its contents.  That **never works**.  Every machine is different, so it is virtually guaranteed that any example will not be exactly correct for your system.  Example files show how a given controller's pins correspond to its functions, but there are many other things that you must personalize, including spindle type, motor assignment to axes, motor tuning, etc.
{.is-warning}
3. Select a user interface program to serve as your "view" of FluidNC's features.  FluidNC includes a default "WebUI" interface program that runs in a browser, but you can instead use one of the many different "Grbl Sender" programs that are available.


## FluidNC Web Installer

![installer1.png](/config/installer1.png =x400)

The [Web Installer](https://installer.fluidnc.com/) is now the recommended way to install, debug, maintain and upgrade FluidNC. It includes features for installing the firmware, for [setting up WiFI](/en/features/wifi-quick-start), and for creating and modifying the config file. See below if you want alternate installation methods.

## Installing from a Release Package

WebInstaller usually works, but there are infrequent cases where it has trouble connecting to a controller board.  In those cases, it is often possible to use an alternative method whereby you download a release package and run a script inside it.

 - Go to the [FluidNC project page](https://github.com/bdring/FluidNC) on Github
 - Click on the [releases link](https://github.com/bdring/FluidNC/releases) on the right side of the page.
 - Click on the release that you want. You should generally use the latest non "Pre" release.
 
 - Download the zip file for your operating system (**win64** for Windows and **posix** for Linux and Mac) from the **Assets** section of the release. You **do not** need to download the source code to use pre-compiled files.
 - Unzip it in a folder on your computer. Do not try to run from inside the zip file. Make sure it is fully extracted before you start. On some operating systems, like Windows, the folder should be on local drives, not a networked folder.
 - Connect the ESP32 via USB. It is best to remove all other USB/Serial devices while installing it because it might try the wrong one.
 - Run either **install-wifi.bat** or **install-bt.bat** (.sh on other OS's). Make sure you are running the script while in that folder. It will run FluidTerm after it does the install. There are likely to be a few warnings, but they should go away after you do the next step. Close FluidTerm and do the next step. 
 - If you are doing a first time install, run **install-fs.bat** (or .sh) to install the file system, including the WebUI. If you already have a config file or other files on an ESP32, they will be deleted, so this is not recommended for upgrading firmware.
 - You may notice a message like this `E (38) SPIFFS: mount failed, -10025` on the first run of the firmware. This is normal. It only happens on the first boot and is formatting the flash file system. It could take a long time on ESP32s with larger flash memories.
 - You now need to load a config file. The instructions on how to do this [are here](http://wiki.fluidnc.com/en/config/overview).
 
 - ## Using Windows

  Download the file that looks like this **fluidnc-v3.9.9-win64.zip** from the assets section of the [release](https://github.com/bdring/FluidNC/releases). The version number, v3.9.9 in this example, will vary. Unzip it into a folder on your computer.

  There are a bunch of files and folders in the release. You typically you only need to use these batch files in the top level folder. The S3 versions are for ESP32-S3 chips. If you choose the wrong chip type, you will get an error.

  - **erase.bat** or **erase_s3.bat** This will erase the entire ESP32. In most cases you do not need to do this unless your ESP32 is crashing or stuck in a weird loop.
  - **install-wifi.bat**,  **install-bt.bat** or **install-wifi_s3.bat** This installs the firmware with the wireless option you want.
  - **install-fs.bat** or **install-fs_s3.bat** This creates a memory partition where you can store files, like config files and macros. You only need to do this once. Do not do it if you are upgrading because it will erase any existing files.

Double click on the batch files to run them. Generally, you install the firmware first. If this is a first time install, then install the file system. Each batch file will run in a terminal window. After each batch file, it should start the serial terminal called **FluidTerm**. 

Close each terminal window before running the next batch file. Otherwise, the next batch file will not be able to access the COM port. You can run FluidTerm, by running the **fluidterm.bat** program.  

Keep the folder on you computer. If you have support questions we may ask you to run **FluidTerm**.

## Troubleshooting

 - If you get a message like `Connecting .....___.....____.....` and it eventually times out [see this FAQ entry](http://wiki.fluidnc.com/en/support/faq#when-loading-firmware-i-get-a-message-like-connecting-_______-and-it-eventually-times-out).
 - Some people have solved issues by lowering the upload speed. Try editing the file install-wifi.bat (or -bt) and changing **--baud 921600** to **--baud 115200**, then running the script.
 - Windows 11. There are some unconfirmed reports that some USB/Serial drivers are not working correctly with the DTR and RTS pins used to start the bootloader. Most people have no issue. If you have some communication with the ESP32, but it will not load the firmware, try using a PC with another OS. You could also research the driver for the USB chip. The chip is typically a CP2102 (Silicon Labs) or CH340 (Jiangsu Qin Heng). The CH340 might be the one with issues.
 
If you get a strange repeating response like this. Try using the **erase** script in the release files.

```
rst:0x10 (RTCWDT_RTC_RESET),boot:0x13 (SPI_FAST_FLASH_BOOT)
invalid header: 0xffffffff
...
```

## Fluidterm

Fluidterm is a serial console that automatically loads when you are uploading firmware. This will show you the startup messages and allow you to interact with FluidNC. To close it you can send CTRL+] or close the window. You can run it at any time in the future with the **fluidterm.bat (or .sh) program in that folder.

## Upgrading Firmware.

- To upgrade, run the first few steps above, but **do not** install the file system.
- If the release notes say that the WebUI has been updated, you need to upload **index.html.gz** from the wifi folder. Do this using the local file system panel.

<img src="/webui_local_files.png" width="400">

<hr>

<img src="/webui_local_files2.png" width="400">

## Over the air (OTA) Updates

If you have Wifi and the WebUI running, you can update via the FluidNC tab. This will not overwrite your config file. Click the yellow cloud icon to upload your compiled binary (.bin) file. The compiled `firmware.bin` binaries are located in the **bt**, **wifi** or **wifi_s3** folders of the [fluidnc-vVERSION-PLATFORM.zip releases](https://github.com/bdring/FluidNC/releases).

<img src="https://github.com/bdring/FluidNC/wiki/images/ota_icon.png" width="400">

If the upgrade affects the WebUI, you will need to upload **index.html.gz** from the [FluidNC/data](https://github.com/bdring/FluidNC/tree/main/FluidNC/data) folder of the repo by clicking on the green folder icon in the image above. 

# Compiling (Reference only. You do not need to compile)

## Use VS Code & PlatformIO to Compile

VS Code & PlatformIO is the only method we offer support for compiling. It allows us to control a lot more things than something like the Arduino IDE. We need to control libraries and the versions. Advanced users can use other methods, but please don't expect detailed help with that.

* Install VsCode on your computer
* Install the PlatformIO extension into VsCode
* Use VsCode to clone the FluidNC repo from Github (or, if you have already cloned it, open that folder in VsCode)
* The PlatformIO extension  will  notice that  there  is a platformio.ini  file  in the  folder  and will  automatically  install the necessary libraries and tools.  This  step takes  awhile the  first time.
* When  things  settle down,  you can use icons  at the bottom  of the window to select the build environment (the   most common one is "wifi"), build, upload, and monitor.
* Other operations like uploading a filesystem image  are available  in the PlatformIO extension sidebar
## Compile time options

FluidNC supports both WiFi and Bluetooth connectivity. These libraries have a big impact on firmware size. By default only WiFi is enabled. You can use either one, both or none by changing the **platformio.ini** file.

Please use git to acquire the firmware source files. This will ensure the version displayed is accurate and there is a way for us to see any changes you may have made. **If you do not use Git, we cannot support you.**

There is a line near the top **default_envs = wifi** Change it per below.

- For Bluetooth only **default_configs = bt**
- For WiFi and Bluetooth **default_configs = wifibt**
- For neither **default_envs = noradio**

## Using ESP32s with Larger More Memory

> **Advanced users only**. If you need help, you are probably not an advanced user yet.
{.is-warning}

> The standard install method works fine for all chips 4M and larger. You just don't get access to the extra memory.
{.is-info}


Most ESP32 modules have 4Meg of memory. We use a standard partition scheme to allocate this memory. FluidNC expects certain sections in the partition table, so we have a few recommended types for modules with larger memories.

The only way to do this is by compiling yourself with changes to the platformio.ini file. We would need to make major changes to our release system and install scripts to allow people to choose the memory size. We don't see this as a higher priority than many other things on our list at this time.

Find this section of the platformio.ini file and uncomment one of these three lines.

 

```ini
board_build.partitions = min_spiffs.csv ; For 4M ESP32
; board_build.partitions = FluidNC/ld/esp32/app3M_spiffs1M_8MB.csv  ; For 8Meg ESP32
; board_build.partitions = FluidNC/ld/esp32/app3M_spiffs9M_16MB.csv ; For 16Meg ESP32
```

You can get information about your memory size by running `esptool.exe flash_id` (Win64 syntax). esptool is included with FluidNC releases and PlatformIO with ESP32 framework. This data is also shown when you use our install scripts.

```
Detecting chip type... ESP32
Chip is ESP32-D0WD (revision 1)
Features: WiFi, BT, Dual Core, 240MHz, VRef calibration in efuse, Coding Scheme None
Crystal is 40MHz
MAC: 4c:11:ae:ea:7a:8c
Uploading stub...
Running stub...
Stub running...
Manufacturer: 20
Device: 4016
Detected flash size: 4MB
```

## Configuring

You need to create and upload a [config file](http://wiki.fluidnc.com/en/config/overview) to tailor the firmware to your machine. If you do not do this, you will see this message **[MSG:WARN: Cannot open config file:config.yaml]**. That says it cannot find the default file called config.yaml. In this mode you can play with a virtual 3 axis machine. You can jog it and try a few things. You cannot do anything that requires feedback from a real machine like homing, probing or reading from an SD card.

If you have a working machine definition from Grbl_ESP32, you can use an automated method. [See this FAQ entry](/support/faq#is-there-an-easy-way-convert-from-grbl_esp32).



The easiest way to upload a config file is via **FluidTerm**. 
- Use the **CTRL+U** key to start the process
- Select the file you want to upload
- Confirm the filename you want to store it as (default is the same name)
- After the upload is done, you need to tell FluidNC to use it with **$Config/Filename=<yourfile.yaml>** Example: **\$Config/Filename=my_cnc.yaml**

You can also upload a file via the WebUI. Be sure to send **$Config/Filename=<yourfile.yaml>** at the console and restart FluidNC. Make sure there is no space in front of the filename.

<img src="https://github.com/bdring/FluidNC/wiki/images/WebUI_upload.png" width="400">

You can see all files that have been uploaded to the local file system with the **$LocalFS/List** command. This is a good way to check to see if the files have been uploaded.

## Versioning

When you compile yourself the versioning is meaningless because we do not know if any changes were made. The version string will look something like this 
```
[FluidNC v3.1.4 (Devt-a39e92c-dirty) (wifi) '$' for help]
```
Whatever `v3.x.x` is does not mean anything significant. `(Devt-a39e92c-dirty)` indicates the git branch and last commit you pulled the source code from. dirty means there has been a change. 

## Submitting Changes

We have [pull request guidelines](/development/pull_request_guidelines) that must be followed.

## Backtrace Decoding (Windows)

If you get a crash you typically get a **backtrace** report printed on the serial port before it reboots with a default config. This lists the memory address where the crash occurred and all the calling functions on the stack. It looks like this.

```
Backtrace:0x400EE971:0x3FFB2540 0x400E40D1:0x3FFB26C0 0x40081B4A:0x3FFB26F0 0x400FCC78:0x3FFB2710 0x400E05F2:0x3FFB2730 0x401A823B:0x3FFB2750 0x400DAA6B:0x3FFB2770 0x400DA48A:0x3FFB2790 0x400DA6CE:0x3FFB27B0 0x400DDAE7:0x3FFB27E0 0x4010BF1E:0x3FFB2820
```

In the FluidNC release package, we include files called **wifi-firmware.elf** (Executable and Linkable Format) and **bt-firmware.elf** that can decode the addresses to functions, files and line numbers.

You need a program called **addr2line** to do the decoding. This is installed with PlatformIO and is the best way to get it.

For most people addr2line is located in the location listed below. You may need to search for it if it is not in that folder. 

``` 
..\Users\<user>\.platformio\packages\toolchain-gccmingw32/bin/
```

In the folder that contains the elf file, send this command line with \<user\> replaced with your username and \<addresses\> replaced with the backtrace addresses

```
C:\Users\<user>\.platformio\packages\toolchain-gccmingw32/bin/addr2line.exe -a <addresses> -e wifi-firmware.elf
```

In my case the command line would look like this.

```
C:\Users\barto\.platformio\packages\toolchain-gccmingw32/bin/addr2line.exe -a 0x400EE979:0x3FFB2540 0x400E40D1:0x3FFB26C0 0x40081B4A:0x3FFB26F0 0x400FCC80:0x3FFB2710 0x400E05F2:0x3FFB2730 0x401A8243:0x3FFB2750 0x400DAA6B:0x3FFB2770 0x400DA48A:0x3FFB2790 0x400DA6CE:0x3FFB27B0 0x400DDAE7:0x3FFB27E0 0x4010BF26:0x3FFB2820 -e firmware.elf
```

## Backtrace Decoding (macOS)
**addr2line** does not come packaged with the macOS PlatformIO installer, but it is available via both **macports** and **brew** as part of the GNU Binutils package.

### Brew Installation
```
brew install binutils
```
### Macports Installation
```
port install binutils
```
Please note where **binutils** get installed as it may vary between the two packaging tools.  Brew installs it in `/usr/local/opt/binutils/bin/`.

Following the example **backtrace** shown above, the syntax for running **addr2line** would look like so (assumes your cwd is the root FluidNC directory and you are running a wifi build):
```
/usr/local/opt/binutils/bin/addr2line -a 0x400EE979:0x3FFB2540 0x400E40D1:0x3FFB26C0 0x40081B4A:0x3FFB26F0 0x400FCC80:0x3FFB2710 0x400E05F2:0x3FFB2730 0x401A8243:0x3FFB2750 0x400DAA6B:0x3FFB2770 0x400DA48A:0x3FFB2790 0x400DA6CE:0x3FFB27B0 0x400DDAE7:0x3FFB27E0 0x4010BF26:0x3FFB2820 -e .pio/build/wifi/firmware.elf
```

## Understanding Backtraces

A backtrace looks like this. The first line caused the error. The next line after that is what was called the line before. You can trace the error all the way back to the beginning.

In this case it starts at Main.cpp and finally errors in strlen. You can look at the source code to see what each line does.

```
/builds/idf/crosstool-NG/.build/HOST-x86_64-w64-mingw32/xtensa-esp32-elf/src/newlib/newlib/libc/machine/xtensa/strlen.S:43
0x4010f61a
C:/Users/barto/.platformio/packages/framework-arduinoespressif32/cores/esp32/Print.h:67
0x40119511
C:/Users/barto/.platformio/packages/framework-arduinoespressif32/cores/esp32/Print.cpp:89
0x400e4662
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Configuration/../MyIOStream.h:33
0x400e481d
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Machine/Macros.cpp:15
0x400f1e61
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Protocol.cpp:1110
0x400f1ee9
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Protocol.cpp:805
0x400f2266
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Protocol.cpp:339
0x400f2515
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Protocol.cpp:269
0x400e55ed
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Main.cpp:147
0x4011af91
C:/Users/barto/.platformio/packages/framework-arduinoespressif32/cores/esp32/main.cpp:50
```

# Getting Pre-releases

Pre-releases are often made to allow people to try recent fixes or the latest new features. We hope that people can help us test the new firmware. To get access to the pre-releases in on the Web Installer, click the option to "Show pre-releases"

![webinst_pre_rel.png](/webinst_pre_rel.png =x240) 

# Getting firmware from Github actions

Many actions we do in Github create "artifacts" of the compiled firmware. You must be logged into Github to have access to the artifacts.

Go to the [actions page](https://github.com/bdring/FluidNC/actions) of the Github repo. Find the action you want. Look at the descriptions of each action to find the PR or commit you are looking for. Click on the action, then scroll down the artifacts section. Click on the firmware you want, like wifi-firmware) and download the zip file. Unzip that to get the firmware.

You can install it from the Web Installer. Follow the regular install procedure, but select "Install a custom image" and then select the firmware.bin file you just unzipped.

![install_custom_firmware.png](/install_custom_firmware.png =x600)

You can also use the OTA firmware upgrade in the WebUI to load the firmware.bin file.