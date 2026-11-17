---
title: FluidNC Demonstration
description: Try FluidNC and its user interfaces in your web browser, without hardware
published: true
date: 2026-10-08T00:00:00.000Z
tags: 
editor: markdown
dateCreated: 2026-10-08T00:00:00.000Z
---

# FluidNC Demonstration

The [FluidNC Demonstration](https://fluidnc-demo.netlify.app) runs FluidNC in your web browser. It is not a mock-up or a recording: it is the real FluidNC firmware, built from the same source code that runs on the ESP32, but compiled to WebAssembly so your browser can run it. It cannot reach any real machine hardware, but it parses and executes G-code, plans and simulates motion, and answers commands just as a controller would.

That makes it a convenient way to:

- **Evaluate FluidNC** before you buy a controller board or flash any firmware
- **Compare the user interfaces** available for FluidNC, side by side with the same firmware
- **Learn the commands**, such as `$` commands, `$Config/Dump`, and the G-code dialect, without risk to a real machine
- **Try out a config file** to see whether FluidNC accepts it and how it reports errors

Nothing is installed on your computer. Close the tab and it is gone, except for the files and settings described in [Files and Settings](#files-and-settings).

## Getting Started

Open [https://fluidnc-demo.netlify.app](https://fluidnc-demo.netlify.app) in a recent desktop browser. After a moment FluidNC starts and prints its startup messages in the console, just as it would over a USB serial connection.

The console works like a serial terminal connected to a real FluidNC controller: type a command and press Enter. Line editing and command history work the same as they do on an ESP32. Some things to try:

- `$I` shows the firmware version and build information
- `?` reports the machine state and position
- `$H` homes the machine (the demo config has no limit switches, so see [Limitations](#limitations))
- `G0 X10 Y20` moves the simulated machine; send `?` while it is moving to watch the position change
- `$Config/Dump` prints the active configuration
- `$Help` lists the available `$` commands

See [Commands and Settings](/en/features/commands_and_settings) and [Supported GCodes](/en/features/supported_gcodes) for the full lists.

## Trying the User Interfaces

FluidNC can be controlled through several different user interfaces. The **WebUI** menu loads one of them into the page and connects it to the running FluidNC, as if you had browsed to a controller on your network. You can switch between them at any time to compare how each one handles the same machine.

| Choice | What it is |
|--------|------------|
| **Tablet UI** | The touchscreen interface used on FluidNC controllers that have a built-in display, such as the [CrowPanel](/en/hardware/displays/CrowPanel_7in). In the demo, click and drag with the mouse as you would tap and swipe on the screen. |
| **FigUI** | A modern alternative WebUI. See [FigUI](/en/features/webui#figui). |
| **ESP3D-WEBUI** | The WebUI that FluidNC's WiFi builds are based on. See [WebUI](/en/features/webui). |
| **Load local build file** | Loads a WebUI build from your own computer (an `index.html` or `index.html.gz` file). This is mostly for WebUI developers who want to test a change against real FluidNC without flashing a board. |

The WebUI talks to the demo the same way it would talk to a controller, so you can jog, run G-code files, edit the config file, and change settings from the WebUI while watching the results in the console.

## Files and Settings

Like a real controller, the demo has two places to keep files:

- **LocalFS** is the controller's built-in flash filesystem, which holds `config.yaml` and other small files. See [Local File System](/en/features/local_file_system).
- **SD card** is a simulated SD card. It starts with some sample files, including G-code you can run.

Choose **LocalFS** or **SD card** next to **Files on**, then use **Upload files...** to copy files from your computer, or **Download** to save a file from the demo. You can also manage files from the console (`$LocalFS/List`, `$SD/List`, `$SD/Run=filename`, and so on) or from a WebUI.

Files you upload or change, and settings you change, are saved in your browser. On your next visit they replace the built-in copies, so your work is still there. These saved files live only in that browser on that computer, and nothing is sent to a server.

**Reset files and settings** discards everything saved in this browser and reloads the demo with the original built-in files and settings.

## Trying Your Own Config File

The demo starts with a minimal `config.yaml`. To try your own:

1. Choose **LocalFS** next to **Files on**.
2. Use **Upload files...** to upload your config file. Name it `config.yaml` so it replaces the built-in one.
3. Reload the page. FluidNC reads `config.yaml` when it starts, exactly as it does after a reset on an ESP32.

The startup messages in the console show how FluidNC interpreted your config, including any errors. `$Config/Dump` shows the result. This is a quick way to check a config file before you upload it to a real controller. If anything goes wrong, **Reset files and settings** puts the built-in config back.

## Limitations

The demo runs the real firmware, but it has no real hardware, so:

- **Nothing physical moves or responds.** Pins don't drive anything. Stepper drivers, spindles, lasers, VFDs, limit and probe switches, and other devices that FluidNC talks to over pins, UARTs, I2C or SPI don't exist. Features that depend on them, such as Trinamic driver setup, VFD communication, probing, and homing with real switches, can't be tested meaningfully.
- **Motion is simulated.** Positions and status reports change as a real machine's would, but timing is not a reliable guide to how fast your real machine will run.
- **It is not a network device.** WiFi, Bluetooth, and Telnet aren't available, and other programs on your computer, such as G-code senders, can't connect to the demo. Use the console or one of the WebUIs in the page.
- **The demo may not match the newest release exactly.** It is built from the FluidNC source, but it may be a little ahead of or behind the current release.

## For Developers

The source code for the WebAssembly build and the demo page is in the [FluidNC repository](https://github.com/bdring/FluidNC) under `FluidNC/wasm/`. Its `README.md` explains how to build the demo and run it locally.
