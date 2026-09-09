---
title: Single Block Mode
description: Step through a job one GCode line at a time
published: true
date: 2026-09-09T00:00:00.000Z
tags: 
editor: markdown
dateCreated: 2026-09-09T00:00:00.000Z
---

# Single Block Mode

Single block mode (also called "block mode" or "single step mode") runs a job one
GCode line at a time. Before each line of a running job, FluidNC finishes all
buffered motion, reports the line it is about to run, and then pauses in `Hold`
state. The line does not execute until you issue a cycle start. After that line
finishes, FluidNC pauses again before the next line.

It behaves as though an `M0` (program pause) were inserted ahead of every line of
the program, except that nothing in the file is modified and no look-ahead
blending occurs across the pause.

This is useful for:

- Dry-running a new program file or a new setup, checking each move before it happens
- Debugging a macro or a hand-written program file
- Carefully approaching the work when touching off or proving out fixturing

Single block mode only affects lines that come from a **running job**: a file
started with [`$SD/Run`](http://wiki.fluidnc.com/en/features/local_file_system) or
`$LocalFS/Run`, or a [macro](http://wiki.fluidnc.com/en/config/macros).

It does **not** affect GCode that a sender streams line by line, nor commands you
type at a console. As far as FluidNC is concerned those are the same thing - plain
lines arriving on a channel, with no job on the job stack - and there is nothing
to step through. If you want to prove out a program one line at a time with single
block mode, put it in a file and run it with `$SD/Run` or `$LocalFS/Run`.

Single-stepping a job that is streamed from a sender is entirely up to the sender:
it would have to send one line, wait for the `ok`, wait for the user to say
"continue", then send the next line. That is a sender feature, and nothing FluidNC
does can add it to a sender that lacks it.

## Turning it on and off

There are three independent ways to control single block mode. Any of them turns
the same internal switch on or off; you can mix them freely.

### `$GB` command

`$GB` (long form `$GCode/BlockMode`) toggles single block mode from a console or
sender.

| Command | Effect |
| --- | --- |
| `$GB` | Toggle: on if it was off, off if it was on |
| `$GB=On` | Enable |
| `$GB=Off` | Disable |

```
$GB=On
[MSG:INFO: Single Block Mode Enabled]
ok
```

Single block mode can only be **enabled** with `$GB` while the machine is `Idle`.
Once a job is running, the console is no longer polled for line commands, so `$GB`
would never be seen. Use a pin or a WebUI/pendant button (below) to toggle it
mid-job.

### `single_block_pin`

You can assign a physical switch or expander input to
[`control: single_block_pin`](http://wiki.fluidnc.com/en/config/control#single_block_pin).
When the pin becomes active it toggles single block mode. This pin is optional -
the feature works without it - and, unlike the other control pins, it does **not**
raise an "active at startup" alarm.

```yaml
control:
  single_block_pin: gpio.16:low:pu
```

### WebUI / pendant button

Single block mode is always reachable through the FluidNC pin-event mechanism on
every channel (UART, USB, Telnet, WebSocket, pendant), whether or not
`single_block_pin` is configured. A sender or pendant that supports it can present
a "single block" button that toggles the mode with no config entry required.

## Running a job in single block mode

1. With the machine `Idle`, send `$GB=On` (or flip your switch / press the
   button).
2. Start the job with `$SD/Run=myfile.nc` (or `$LocalFS/Run=...`, or run a
   macro).
3. FluidNC drains the planner, prints a preview line, and enters `Hold`:

   ```
   [MSG:INFO: Step /sd/myfile.nc:12 G1 X10.0 Y10.0 F30...]
   ```

   The preview shows the job channel name, the line number within the file, and
   the first 20 characters of the line (`...` if it was longer).
4. Issue a **cycle start** to run that one line: the `~` real time character, the
   play/resume button in your sender or the WebUI, or a switch on
   [`cycle_start_pin`](http://wiki.fluidnc.com/en/config/control#cycle_start_pin).
5. The line runs, motion completes, and FluidNC pauses again before the next
   line. Repeat from step 4.

To finish the rest of the job at full speed, send `$GB=Off` (or toggle the
pin/button) and then issue one more cycle start. The change takes effect at the
next line.

## Status reporting

While single block mode is enabled, the `?` status report includes `Q` in the
`Pn:` (pin) field, regardless of how it was enabled:

```
<Hold:0|MPos:10.000,10.000,-1.000|FS:0,0|Pn:Q>
```

`Pn:Q` disappears when the mode is turned off.

## Interaction with other features

- **Check mode (`$C`)** - When [GCode check mode](http://wiki.fluidnc.com/en/features/commands_and_settings) is
  active, single block mode still forces each line to be parsed on its own, but it
  does **not** pause, so a check-mode run completes without needing cycle starts.
- **Reset** - A soft reset (Ctrl-X) issued while paused in single block mode
  discards the pending line, just like a reset at any other time. That line is
  not run when you next start a job.
- **Feed hold / cycle start** - The pause is an ordinary feed hold, so anything
  that responds to `Hold` state (overrides, jogging is not available in `Hold`,
  etc.) behaves normally. The same cycle start that resumes a feed hold advances
  to the next line.
- **Spindle and coolant** - These are not turned off at each pause. Only motion
  is stopped. If you want the spindle off between steps, that is not what this
  feature does - use `M0` breaks in the program instead.

## Notes

- Because the planner is drained before every line, there is no look-ahead
  cornering between lines while single block mode is on. Surface finish and cycle
  time on a stepped-through job will not match a normal run.
- The mode is a runtime switch only. It is not saved in NVS and always starts
  **off** after a restart or reset.
