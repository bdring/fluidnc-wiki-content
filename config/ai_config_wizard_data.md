---
title: AI Assistants and the Config Wizard Data
description: How AI assistants can use the Config Wizard's board data to get pin assignments right
published: true
date: 2026-11-17T00:00:00.000Z
tags: config ai wizard
editor: markdown
dateCreated: 2026-11-17T00:00:00.000Z
---

# AI Assistants and the Config Wizard Data

The [AI Config File Helpers](/config/overview#ai-config-file-helpers) section of the Config Overview covers the *file format*: the grammar, every field, and a validator that checks a config against them. That catches a misspelled key or an out-of-range value. It cannot tell whether a pin exists on your board, can be used as an output, or is already taken by a motor socket. Those are facts about the hardware, and an assistant that guesses them produces a config that is valid YAML, passes the validator, and is wrong for the board.

The [FluidNC Config Wizard](https://mitchbradley.github.io/FluidNC-config-wizard) stores those hardware facts as plain data files. This page describes them and how an AI assistant (or a person) should use them.

## Where the data lives

The files are served from `https://mitchbradley.github.io/FluidNC-config-wizard/` and live in the [wizard's GitHub repository](https://github.com/MitchBradley/FluidNC-config-wizard).

| What | Where | Contains |
|---|---|---|
| Board list | `boards/index.json` | Ids of every supported board |
| Board | `boards/<id>.board.yaml` | The board's connectors: motor sockets, generic I/O pins, RS485 channels, expansion UARTs, I2C, module sockets; their pins and labels; `notes:` saying how well each fact is confirmed |
| Chip | `chips/<chip_id>.chip.yaml` | Per-GPIO capabilities: input, output, pull-up, pull-down, reserved. The board names its chip in `board.mcu_chip` |
| Module | `modules/<id>.module.yaml` | Add-on modules that plug into a board's module socket |
| Expander | `expanders/<id>.expander.yaml` | UART I/O expanders |
| Schemas | `schema/*.schema.json` | JSON Schemas for all of the above |

A short machine-oriented index of the same links is at [`llms.txt`](https://mitchbradley.github.io/FluidNC-config-wizard/llms.txt).

## Rules an assistant should follow

1. **Use the board file for every pin.** If the user's board has a board file, take pins from it and never from memory. Pin assignments on FluidNC boards are not guessable, and similar-looking boards differ.
2. **One function per pin.** A GPIO can do one thing in a config. Some boards put two resources on the same pin on purpose (for example a pin that is both a plain 5V output and a MOSFET driver). Only one of them can be used.
3. **Respect the chip.** The chip file says which GPIOs can be inputs, outputs, or have pull-up/pull-down resistors, and which are reserved (such as the flash pins on the original ESP32). Input-only pins cannot be outputs and cannot have pull options.
4. **Respect UART sharing.** The number of free UARTs is limited. A board whose onboard TMC drivers talk over UART uses `uart1` for them, so only `uart2` is left for RS485 or an expansion connector, and only one of those can use it at a time. A board without UART-addressed drivers has both `uart1` and `uart2` free.
5. **Modules attach to sockets, not pins.** A module's pins are numbered relative to the module socket and come from the board's socket definition. Some modules also require specific pins on the socket (for example the Ethernet module needs the socket's SPI pins).
6. **Ethernet is SPI.** FluidNC's `ethernet:` section drives SPI Ethernet chips (`w5500`, `ksz8851`, `dm9051`). It needs `cs_pin` and `phy_type`, and uses the board's shared `spi:` section. If a board already has onboard Ethernet, an Ethernet module on the socket is not used.
7. **UART I/O expanders use virtual pins.** An expander on a UART appears as pins named `uart_channel<N>.<name>`, and the UART link must use the expander's baud rate. Check the expander file for which of its pins are inputs, outputs, or PWM capable.
8. **Spindle tool numbers must be unique.** Each spindle's `tool_num` must differ from every other spindle's.
9. **Unlisted board? Say so.** Do not fill in pins for a board that has no board file. Ask for the board's wiki page or schematic, or write a board file using the [board file guide](https://github.com/MitchBradley/FluidNC-config-wizard/blob/main/BOARD_FILE_GUIDE.md), which also has advice for assistants. The wizard can load a local board file.
10. **Pay attention to `notes:`.** A note saying a fact was inferred, or that a board is `unverified` or `community_documented`, means the wiring should be confirmed before the config is used.

## Checking the result

There are three levels of checking, and they catch different problems:

1. **File format**: run [`validate_fluidnc_config.py`](https://github.com/bdring/FluidNC/blob/main/tools/validate_fluidnc_config.py), or use its MCP server, as described in the [AI Config File Helpers](/config/overview#ai-config-file-helpers) section. This is the check for typos and invalid values.
2. **Hardware plausibility**: load the config into the Config Wizard with its load config button. The wizard shows which connector each pin was matched to, and lists anything it could not place under "Failed to import". Look for pins that landed on the wrong connector, or that were not recognised at all. This is a cross-check, not a proof: it does not know how your machine is actually wired.
3. **Wiring**: you. Compare the pins in the generated config to your own wiring before powering the machine, especially for motors, spindles and limit switches. A wrong pin assignment can, at worst, drive hardware the wrong way.

## Instructions for AI assistants

> Before assigning any pin in a FluidNC config:
> 1. Identify the user's board. Check `boards/index.json` at `https://mitchbradley.github.io/FluidNC-config-wizard/`.
> 2. If it is listed, read `boards/<id>.board.yaml` and the chip file named in `board.mcu_chip`. Use only the pins in them. If it is not listed, say so, and ask the user for its wiki page or schematic instead of guessing.
> 3. Apply the rules on this page. Also read `config_items.yaml` and `fluidnc-config-spec.md` as described in the [AI Config File Helpers](/config/overview#ai-config-file-helpers) section, and run the validator.
> 4. Tell the user to load the config into the Config Wizard as a cross-check, and to verify the wiring themselves before powering the machine.
{.is-warning}
