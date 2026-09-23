---
title: Serial Terminals
description: 
published: true
date: 2026-09-23T23:19:54.834Z
tags: 
editor: markdown
dateCreated: 2022-08-18T21:26:40.117Z
---

# Serial Terminals
The most basic way to interact with FluidNC is via a USB-Serial connection to a host computer.  A USB cable plugs into a USB port on the host and the micro-USB or USB-C connector on the FluidNC system.  A program running on the host computer sends and receives characters from the USB serial port, using a device driver system component that supports the USB Serial chip on the FluidNC system.  That serial chip is usually a variant of either CP2102, CH340, or a "USB-CDC virtual COM port" from an built-in USB block on the MCU.  Sometimes it is necessary to install a driver for that chip on your host system.

There are many programs that can interact with FluidNC over such a serial connection, as described below.  They include standalone terminal emulator programs, GCode senders, and serial monitor components of programming IDEs.

## Line-oriented Commands

FluidNC receives serial data a character at a time. Most characters are entered into a line buffer (possibly edited by arrow keys and other control characters; see [Advanced Terminal Mode](#Advanced_Terminal_Mode) below) for execution when the line is finished by the receipt of a linefeed or carriage return character. Most commands are line-oriented, including GCode and FluidNC-specific commands (which usually begin with **$**).

When a line-oriented command is accepted, FluidNC acknowledges it by responding with **ok** if it was handled correctly or **error: N** (N is a numeric error code) otherwise.

GCode commands can take awhile to execute - for example a long move at a slow rate might take several seconds to finish.  The **ok** for such commands is issued as soon as the command is accepted, not after the motion is complete.  FluidNC can accept some number of GCode commands in advance, allowing it to coordinate smooth motion across the boundary between moves.  If the buffer for pre-sent commands fills up, FluidNC will delay the **ok** until it has space for the new command. GCode senders use this to adjust their sending to avoid losing data by sending faster than FluidNC can process.

## Realtime characters

A few special characters are acted on immediately without waiting for a complete line. They are called realtime characters or realtime commands.  Realtime commands include status reports (?), reset (Ctrl-X), feedhold (!), cycle start (~), and overrides to adjust spindle speed and feedrate dynamically when a job is running.  The overrides are 8-bit characters with the high bit set, which are difficult to enter directly from a keyboard.

Realtime characters are not acknowledged with **ok** or **error:N**, although some of them like **?** (status report) do cause output.

If a realtime character is entered in the middle of a line, it will not go into the line.  Instead, FluidNC will process it instantly, possibly producing output that could be interspersed with the input line.  This can cause confusion if you are trying to enter a WiFi SSID that contains such a character, as shown below. In the attempt to set the AP SSID to "Hello?world", FluidNC acted on the **?**, sent status and then set the value to "Helloworld".
```
$AP/SSID=Hello<Idle|WPos:-26.000,-51.000,0.000|FS:0.000,0>
world
ok
$AP/SSID
$AP/SSID=Helloworld
```
If you need to enter a realtime character into a line, you can use the HTTP quoting method, replacing **?** by **%3f**, **!** by **%21** and **~** by **%7e**.  For example `$AP/SSID=Hello%3fworld`

Most senders and graphical UI have buttons to send realtime characters, including the non-printing overrides that are difficult to type on a keyboard.  Most terminal emulator programs do not an easy way to send them (but FluidTerm does).

## Serial Terminal Types

Most host computer operating systems have several choices for standalone serial terminal programs, either preinstalled or downloadable.  Most work with FluidNC, but there are two serial terminal programs that we recommend because of their FluidNC-specific features. The browser-based [Web Installer](https://installer.fluidnc.com/) has a Terminal pane with good FluidNC integration. Web Installer requires no downloads or installation; you simply browse to its URL.

The other is [FluidTerm](http://wiki.fluidnc.com/en/fluidterm/fluidterm_usage), which does require downloading (it is included in the FluidNC release .zip files), but it can be used from an ordinary command/terminal/shell window, without a browser.

Serial terminal features are often included in other programs like programming IDEs (e.g. Arduino IDE Serial Monitor and VSCode's monitor pane) and GCode senders, which usually have a "Console" window that behaves like a serial terminal.

### Character Terminals

Standalone terminal programs usually send characters one at a time, as soon as you type them.  They depend on the device at the other end to echo the character and implement intra-line editing.  Programs like this do not have a separate "Send Line" box; the characters that you type are interspersed with device output in the same display area.

With a character terminal, if you type a printable realtime character like **?**, **!** or **~**, FluidNC will handle it immediately, without you having to type Enter.

### Line Terminals

GCode senders and things like Arduino Serial Monitor usually have a separate area for entering a line to be sent, editing it locally before sending the complete line with a Send button.

With a line terminal, to send a printable realtime character, you must also type Enter or hit Send, because line terminals do not know that **?**, **!** and **~** are special.  FluidNC acts on the realtime character and also sees an end-of-line character which it interprets as a separate empty line, acknowledging that line with **ok**.

### Echoing and Intra-line Editing

Historically, Grbl accepted characters without echoing them back to the sending program, and had no facilities for correcting typing mistakes within a line.  That worked well with line-oriented terminals that display and edit locally in the send line box.  It was very difficult to use with character terminals, since you had to type "blind" and could not correct mistakes.

FluidNC supports two modes - no-echo Grbl-compatibility mode and advanced mode.  FluidNC starts in compatibility mode to avoid confusing old senders that do not expect echoing.

### Advanced Terminal Mode

In Advanced Terminal Mode, FluidNC behaves like the shell terminal of an operating system.  It echos printable characters as soon as you type them, and lets you edit the line with arrow keys, Backspace and Delete.  Previous lines can be recalled with up-arrow.  If you type the first few characters of a $ command, the tab key cycles through a list of matching commands.

FluidNC starts in no-echo Grbl compatibility mode, but you can enable advanced mode by typing any editing key like right-arrow.  Line terminals only send printable characters and end-of-line, so they do not trigger advanced mode.  If you are in advanced mode and want to go back to compatibility mode, send Ctrl-L.  Senders can use this preemptively in case they connect to a FluidNC session that is already in advanced mode.

The special keys for advanced editing mode are shown below:

> Some terminals in multi-pane IDEs like VSCode might not send all of the non printing keys listed below, often mapping them to other functions such as switching between  windows. FluidTerm supports them all.
{.is-warning}

```
## Line Editing Keys (the caret ^ symbol means hold the control key)

Left Arrow  or ^B - backward character
Right Arrow or ^F - forward character
Up Arrow    or ^P - recall previous line from history
Down Arrow  or ^N - recall next line from history
Home        or ^A - beginning of line
End         or ^E - end of line
Delete      or ^D - delete character under cursor (forward)
Backspace   or ^H - delete character backward
       ESC then b - move backward to word boundary
       ESC then f - move forward to word boundary
               ^W - delete backward to word boundary
               ^U - erase entire line
               ^K - delete rest of line after cursor and save
               ^Y - insert previously saved text from last ^K
Tab               - Completes words for commands and settings

Words are delimited by space, /, =, or comma
```

# FAQ

## Why is there a double echo?

If you see 2 of the same character each time you press a key, it means you probably have a local echo on in your terminal and FluidNC is in the advanced editing mode. Turn your local echo off. In Fluidterm and miniterm (vscode) send Ctrl+T and Ctrl+E to toggle the echo mode) 