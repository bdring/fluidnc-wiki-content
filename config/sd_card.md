---
title: SD Card
description: 
published: true
date: 2026-08-01T19:33:41.276Z
tags: en
editor: markdown
dateCreated: 2022-07-21T19:12:02.483Z
---

# SD Card

![SD Card](http://www.buildlog.net/blog/wp-content/uploads/2018/08/pny_micro_sd_card-150x150.jpeg)

## Overview
By default, an SD card is not configured. If you want an SD card you need to set up **sdcard** and [**spi**](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface) in your [config.yaml](http://wiki.fluidnc.com/en/config/overview) . If you successfully setup both you will see messages like this:

```
[MSG:INFO: SPI SCK:gpio.18 MOSI:gpio.23 MISO:gpio.19]
[MSG:INFO: SD Card cs:gpio.5 detect:I2SO.27]
```

## Supported SD Cards

MMC cards are not supported.

2 GB SD cards are not supported, because they use a different internal block size compared to all other sizes.

SD cards 64 GB and larger are supported only if they are reformatted into FAT-32 format.  The factory format on large cards is ExFAT, which the libraries that we use do not handle.  See the [Card Formatting](http://wiki.fluidnc.com/en/config/sd_card#card-formatting) section below for more information.

We use an SPI interface. Not all SD cards support SPI. 

In general, old, small cards work well, except as noted above.

# Config File

## spi Section

Here is the config file section for **spi**:

<!-- config-item path="spi.miso_pin" -->
### miso_pin
- **Type:** Pin
- **Default:** `NO_PIN`

Must be a native pin to the microcontroller and have input capability.
<!-- /config-item -->

<!-- config-item path="spi.mosi_pin" -->
### mosi_pin
- **Type:** Pin
- **Default:** `NO_PIN`

Must be a native pin to the microcontroller and have output capability.
<!-- /config-item -->

<!-- config-item path="spi.sck_pin" -->
### sck_pin
- **Type:** Pin
- **Default:** `NO_PIN`

Must be a native pin to the microcontroller and have output capability.
<!-- /config-item -->

It is recommended that you use the [default pin numbers](http://wiki.fluidnc.com/en/hardware/esp32_pin_reference#default-pin), because these have been thoroughly tested, but other pins should work.

### Config Example

```yaml
spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18
```

## sdcard Section

You need a **sdcard** section with at least the **cs_pin** defined. The **card_detect_pin** is supported, but there are no features associated with it other than showing it in the startup messages.

<!-- config-item path="sdcard.cs_pin" -->
### cs_pin
- **Type:** Pin
- **Range:** native, output capability
- **Default:** `NO_PIN`

Chip select pin for the SD card. Required for the SD card to function -- an spi: section must also be configured.
<!-- /config-item -->

<!-- config-item path="sdcard.card_detect_pin" -->
### card_detect_pin
- **Type:** Pin (input)
- **Default:** `NO_PIN`

Optional card-detect switch input. Purely informational -- shown in the startup log, with no other feature attached to it.
<!-- /config-item -->

<!-- config-item path="sdcard.frequency_hz" -->
### frequency_hz
- **Type:** Integer
- **Range:** 400000 to 20000000
- **Default:** `8000000`

This sets the clock speed for the SPI bus used for this. If you have consistent problems with the SD card, try lower values for this.
<!-- /config-item -->

### Config Example

```yaml
sdcard:
  cs_pin: gpio.5
  card_detect_pin: NO_PIN
  frequency_hz: 8000000
```

# Fallback Configuration

For systems that use the default SPI pins, there is a way to access the SD Card without a config file.  That can be useful for testing and other situations where your config file gets lost.  See [$SD/FallbackCS](/config/sd_card#sdfallbackcs-access-sd-without-a-config-file) for more information.

# Control Commands

It is recommended you use the commands that start with **\$SD/**. The numeric versions like [ESP210] are still supported and used by some senders, but they may be removed some day and the **\$SD/** type are easier to remember and support. Send `$CMD` to list all commands and also show the numeric versions of each command.

Note: If you have [authentication](https://github.com/bdring/Grbl_Esp32/wiki/Settings#authentication) enabled (which is not the default), you will need to supply a password for some of the commands. Send `$SD/List pwd=admin` (this assumes you are using the default password of "admin") to list files authenticated with the password "admin".

## $SD/Status - Get SD Card Status

Sending `$SD/Status` will return the current status of the SD card. 

## $SD/List - Get SD Card Content

Sending `$SD/List` will list all the files. This is recursive and will search all subdirectories. Here is an example. It lists the files first, then lists each subdirectory with its contents.

```
$sd/list
[FILE: test.yaml|SIZE:5275]
[DIR: System Volume Information]
[FILE: WPSettings.dat|SIZE:12]
[FILE: IndexerVolumeGuid|SIZE:76]
[DIR: foo]
[FILE: minimal.cps|SIZE:3569]
[FILE: m.yam|SIZE:3508]
[DIR: bar]
[FILE: fnc.cps|SIZE:88730]
[/sd Free:119.57 MB Used:112.00 KB Total:119.68 MB]
```

If you want to list just a subdirectory, do it like this.

```
$sd/list=/foo
[FILE: minimal.cps|SIZE:3569]
[FILE: m.yam|SIZE:3508]
[/sd/foo Free:119.57 MB Used:112.00 KB Total:119.68 MB]
ok
```

The number following **SIZE:** is the file size. 

## $SD/Rename=oldname\>newname

Renames existing files on the SD card.

Example: `$SD/Rename=foo.nc>bar.nc` will rename existing file `foo.nc` to `bar.nc`.

## $SD/Run - Run File from SD Card

Sending `$SD/Run=/Foo.nc` will run file **/Foo.nc**

**Notes:**

- If in alarm mode, this command will fail with error 9
- To **Pause/Restart** Just use the normal grbl cycle start and feedhold commands
<!-- todo: what are the "normal grbl cycle start and feedhold commands" or where do I find them? -->
- To **Stop/Quit a file** Use Grbl Reset. The best way to do this is to do a feed hold then a Grbl Reset. The last line will be reported. Keep in mind that the feedhold will have stopped a move in progress and there will be more moves in the buffer. Restarting and resetting all the modal things is very tricky and left to the sender.
<!-- todo: what is the "Grbl Reset" text-to-type? -->
- **Errors** Any gcode errors in the SD card file will terminate the job. The offending line number of the file will be reported.
<!-- todo: an example line here would be great as in Status below. -->
- **Status** When an SD card job is running, the percent of bytes completed  is appended to the status string, shown in the following example as **SD:45.5**:

  <Idle|WPos:195.000,144.000,19.000|Bf:15,128|FS:0.000,0.000|Pn:P|WCO:-195.000,-144.000,-19.000|SD:45.5> 

## $SD/Show=Foo.nc - View an ASCII Textt File

Sending `$SD/Show=Foo.nc` will display the contents of file **Foo.nc**

To view a file in a subdirectory send it like this `sd/list=/foo/test.nc`

# Adding or Uploading Files to SD Card

From a terminal program such as [Fluidterm](http://wiki.fluidnc.com/en/fluidterm/fluidterm_usage) prefix the local name with **/sd** and it will upload to the SD card. Sending `/sd/Foo.nc` will upload **Foo.nc** to the root directory.

Or you can add files by moving the SD card to a PC, or [via the WebUI](http://wiki.fluidnc.com/en/config/overview#uploading).

To add a file to a subdirectory, add the subdirectory like this /sd/foo/text.nc`

## $SD/Delete - Delete a File

Sending `$SD/Delete=/Foo.nc` will delete **/Foo.nc**.

## $SD/FallbackCS - Access SD without a config file

Sending `$SD/FallbackCS=5` will set up **GPIO 5** as the SD Card chip select pin to use in case the config file does not define *cs_pin* in the sdcard section (for example if the config file is missing).  The default SPI pins will be used. After sending that command, you will need to reboot to apply it and thus enable the SD Card.  Subsequently, any time that the system cannot configure the SD Card via the config file, it will set up the SD Card with the default SPI pins and that CS pin.  GPIO 5 is the most commonly used GPIO for SD Card chip select, but of course you should use whatever is correct for your hardware.

If *$SD/FallbackCS* is set to its default value of -1, there will be no fallback behavior.  In that case, missing information in the *spibus:* and *sdcard:* sections will result in no SD Card being configured, so the default pins for those functions will not be initialized.

# Card Formatting

FluidNC uses third party libraries to access SD cards. In general, the smallest, oldest and slowest cards tend to work best.  As cards get larger, more and more RAM memory is needed to keep track of where files are located.  That can be a problem on an ESP32, whose RAM is limited compared to, say, PCs.

Some people have trouble when SD cards have been formatted by Windows, but were able to solve the problem by formatting with [SD Card Formatter](https://sd-card-formatter.en.uptodown.com/windows)

The filesystem format must be FAT-32.  ExFAT is not supported.  Modern cards larger than 32GB usually come with ExFAT.  To use such a card, you must use a partitioning tool to create a partition no larger than 32GB and format that as FAT32.


# File Names

The maximum length of a filename or subdirectory name is 30 characters.  That limit applies to each component of the path.  The overall path can be longer, but it is best to keep the overall length down to 100 characters or so, lest it exceed the length of a command line or some other internal buffer.  

## File Sizes

FAT-32 has a limitation of a maximum individual file size of 4GB.  That should not be a problem, as individual GCode files rarely exceed a few megabytes.


# Help & Troubleshooting

- **SD Card Size** Make sure it is less than 64GB and not 2GB (due to a block size issue). Generally, the smaller, low speed cards work best.

- **Card Format** Format the card with FAT32.

- **Files** Try testing with only a few files. Use filenames with [8 bit ASCII printable characters](https://www.ascii-code.com/) and less than 30 characters.

 - **Getting responses with "No SD Card"** Check your startup messages with `$SS` to see if the card has any configuration errors or other information about the SD Card setup. Many controllers do not support a physical card detect pin of the socket, so a ***card not found*** type message means the card did not respond.
 
- **Try using a simple terminal** Try using a simple terminal like [FluidTerm](http://wiki.fluidnc.com/en/fluidterm/fluidterm_usage) or the terminal with the [Web Installer](https://installer.fluidnc.com/). This simplifies things and can help diagnose the problem. Send **$SD/List** to in the terminal to show the contents. The response should look something like this, with your files listed.

```
$sd/list
[DIR:System Volume Information]
[FILE:  WPSettings.dat|SIZE:12]
[FILE:  IndexerVolumeGuid|SIZE:76]
[FILE: myfile_1.nc|SIZE:38]
[FILE: myfile_2.nc|SIZE:13425]
[/sd/ Free:14.83 GB Used:128.00 KB Total:14.83 GB]
ok
```

- **Try lowering the SPI frequency** In the [**sdcard:** section](http://wiki.fluidnc.com/en/config/sd_card#sdcard-section) of your config file use a lower frequency than the default.

```yaml
sdcard:
  cs_pin: gpio.5
  card_detect_pin: NO_PIN
  frequency_hz: 400000
```

- **Try changing the pin drive strengths** [See this page on signal quality](http://wiki.fluidnc.com/en/hardware/signal_quality#spi-bus).


 
 - **It does not work with my DIY setup or adapter** SD cards are very layout (connections) and timing sensitive. Many people have reported that their hand made circuits do not work. Some of these will work with example programs but not FluidNC. The examples use a different Espressif (ESP32 company) library than the Arduino style examples. The Arduino library uses a slower speed, so you can try to lower the [frequency_hz:](http://wiki.fluidnc.com/en/config/sd_card#frequency_hz) setting to 10000000 or 1000000. We are sorry, but we cannot help you if your hand made circuit does not work. 
