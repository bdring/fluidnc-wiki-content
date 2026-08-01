---
title: Serial Terminals
description: 
published: true
date: 2026-08-01T19:36:28.145Z
tags: 
editor: markdown
dateCreated: 2022-08-18T21:26:40.117Z
---

## Sending data

FluidNC processes serial data a character at a time. With some special characters like ? (status) and CTRL+X (reset) it will act extremely fast. We call those immediate characters. With other characters, it stores them in a buffer until it sees a line end character. The line ending can be a carriage return (CR) or a line feed (LF). When it sees the line end character it processes the whole line. This is used for things like gcode, commands or settings. 

## Immediate characters.

Immediate characters get processed as soon as they are seen even if they are in the middle of a command. Example: if you try to set the AP SSID to "Hello?world", you will have trouble. It will strip out the ? (status command), send the status and then set the value to "Helloworld". See below. As soon as FluidNC saw the ?, it returned the status.

```
$AP/SSID=Hello<Idle|WPos:-26.000,-51.000,0.000|FS:0.000,0>
world
ok
$AP/SSID
$AP/SSID=Helloworld
```

There are only three immediate characters that are standard printable characters. This limits the number of characters that cause the problem listed above. These are ones you cannot send from the serial port for any other purpose. If you must use them in a WiFi password, etc, you should do that via the WebUI. That handles sending strings a little differently.

- ? - Status
- ! - Feed hold
- ~ Cycle Start (resume from feed hold)

The rest are non printing characters. They are usually sent by senders using the key code for that character. There is a list of them in [Serial.h](https://github.com/bdring/FluidNC/blob/main/FluidNC/src/Serial.h). The character for Reset can be sent with many serial terminals with the CTRL-X from the keyboard.

> Immediate characters do not respond with an ok. You can send them at any time. We recommend 10Hz as the max rate to send ? for status.
{.is-info}


## Commands, Settings and GCode

Everything except for immediate characters is a line-oriented command, which is a sequence of printable characters ending with a newline character. Line-oriented commands include standard GCode lines and FluidNC-specific commands which usually begin with '$'.  FluidNC processes line-oriented commands as they are received, responding with an "ok" when the line has been accepted. There is a buffer for gcode lines. If you send a command for a slow, long move, it will say 'ok' right away even though the move has not finished. It can store several commands. Eventually, if you send a lot of gcode commands before the motion is complete, FluidNC will wait for some of the earlier commands to complete before sending the 'ok'. You should wait for the OK to send another command, to prevent sending commands faster than FluidNC can accept them. Advanced gcode senders can internally count characters and track buffers, but that is beyond the scope of this wiki page.

## Serial Terminal Types

The best serial terminals for use with debugging FluidNC issue are the terminal in the [Web Installer](https://installer.fluidnc.com/) and [FluidTerm](http://wiki.fluidnc.com/en/fluidterm/fluidterm_usage).

There are many types of serial terminals. Some are stand alone programs and some are built into programs, like programming IDEs and gcode senders. Most stand alone serial terminals send characters as soon as you type them. The ones built into other programs often have you type the characters into a text box, then click the send button. The enter key also usually sends that line. It sends the whole line and adds a line ending. 

## Whole Line Sending Terminals

Some terminal programs, like FluidTerm, send each character as soon as you type it.  Others, like the Arduino IDE serial port monitor most gcode senders, collect characters into a line on the screen, and only send the complete line to FluidNC after you type the Enter key or hit the Send button.  For line-oriented commands, there is little difference in the way you use immediate-send programs and line-collecting programs.  But with immediate commands you will notice a difference.  On an immediate-send program, if you type '?', FluidNC will see it instantly and respond with a status report, even if you are in the middle of typing a line - and you will not see an "ok" because there was no newline character to trigger the line parser.  On a line-collecting program, if you type '?', nothing will happen until you type Enter or hit Send.  Then you will get the status report in addition to an "ok", because the program sent both the '?' immediate command and also a newline.

Line-collecting terminals typically have no way to send unprintable characters like CTRL-X, but GCode sender programs with built-in terminals usually have special buttons for sending unprintable immediate characters like CTRL-X (reset) and overrides.

## Character at a Time Terminals

These terminals send each character at a time and can also send compound keys like CTRL-X. The line ending that is sent with the enter key is usually configurable. This should be LF.

The character-at-a-time terminals recommended above do not need to be configured, since they are preset to work properly with FluidNC.

**Local Echo** FluidNC does not normally echo characters back to the sender, for compatibility with plain Grbl. See the advanced mode below for an alternate method with many convenience features. 

## Advanced Terminal Mode

A good serial terminal looks like a shell terminal of an operating system. Shell terminals have some nice features we tried to emulate with FluidNC, for example intra-line editing with arrow keys, and arrow up/down to recall commands you have already sent. In this mode FluidNC echo the characters and handles all the line editing. When FluidNC starts, the advanced mode is off to preserve Grbl compatibility. You can trigger the mode by sending any one of the special editing keys such as backspace.  If you reboot, advance mode will be off and you must reenter it if desired.

>  CTRL+L turns off local echo to revert to GRBL line mode.
{.is-info}

Below are the special keys for the advanced editing mode.

> Terminals like the one in VSCode do not send all of the non printing keys listed below, often mapping them to other functions such as controlling the window layout. It can only partially use the advanced mode features. FluidTerm supports them all.
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