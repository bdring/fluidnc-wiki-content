---
title: 1. Config file Overview
description: General Information About Config Files
published: true
date: 2026-08-01T19:33:31.271Z
tags: example examples config
editor: markdown
dateCreated: 2022-07-21T13:21:08.885Z
---

# Overview
With FluidNC, everyone uses the same firmware. This is great, but everyone's machine could be different. You solve this problem by creating a machine configuration file that describes your machine.

The config file is a text file that you upload to FluidNC. FluidNC reads this file on startup to customize the firmware to your machine. If it does not find the config file, it will create a very simple default config file. This configuration enables just enough features so you can interact with FluidNC and upload your config file, so the serial port is the only way to see them.

During startup, it uses the serial port to notify you if there are any problems with your config file. With some problems, FluidNC will give up and create the same default file as described above. You should use [FluidTerm](http://wiki.fluidnc.com/en/fluidterm/fluidterm_usage) when testing new config files. The errors occur before the WiFi or Bluetooth can be connected.

You can load multiple config files if you like and switch between them. You tell FluidNC which one to use with the **$Config/Filename=<your_filename>** command.

There are many [example config files](https://github.com/bdring/fluidnc-config-files) .  It is unlikely that anyone will exactly match your machine because machines are so different.  Instead of loading an example and hoping it works, you should study the examples and understand how the various items relate to your situation, using the documentation below as a guide.

[FluidNC Web Installer](http://wiki.fluidnc.com/en/installation#fluidnc-web-installer) has a graphical setup utility to help you create and upload a config file.

> The config file must contain "plain text", not "rich text" that includes formatting hints like boldface and heading styling.  If you use FluidNC Web Installer to manage config files, it will do the right thing. If you use a text editor, you must choose one that can save in "plain text" mode.  On Windows, Notepad is suitable.  On Mac, the common TextEdit app can do plain text, but you have to tell it to do so, otherwise it will use rich text mode and will add junk to your config file.  [This article](https://support.apple.com/guide/textedit/open-documents-txte51413d09/mac) tells how to make TextEdit use plain text mode. Most editors that are intended for programmers use plain text.
{.is-warning}

## AI Config File Helpers

FluidNC's config file format has a lot of sections and fields to support a wide range of machines, so it's easy for both people and AI assistants (ChatGPT, Claude, etc.) to get details wrong. The [FluidNC repository](https://github.com/bdring/FluidNC) includes a set of tools under [`tools/`](https://github.com/bdring/FluidNC/tree/main/tools) to help generate and
check config files, aimed at both humans and AI assistants.

- **[`fluidnc-config-spec.md`](https://github.com/bdring/FluidNC/blob/main/tools/fluidnc-config-spec.md)** — A detailed, formal reference for the config file grammar, written specifically so an LLM can read it and generate a syntactically correct config. It documents every section, every field, valid ranges and defaults, and common mistakes -- verified directly against the FluidNC source code, not just wiki prose.
- **[`fluidnc-config-schema.json`](https://github.com/bdring/FluidNC/blob/main/tools/fluidnc-config-schema.json)** — A [JSON Schema](https://json-schema.org/) version of the same specification, for automated/machine validation of a parsed config file.
- **[`validate_fluidnc_config.py`](https://github.com/bdring/FluidNC/blob/main/tools/validate_fluidnc_config.py)** — A command-line tool that checks a `config.yaml` against the schema and reports any problems it finds. Run it with `python3 validate_fluidnc_config.py your_config.yaml` (it offers to install its own small set of dependencies automatically). Add `--permissive` to allow harmless mixed-case section/field names (FluidNC itself matches these case-insensitively) while still catching real mistakes.
- **[`fluidnc_config_mcp_server.py`](https://github.com/bdring/FluidNC/blob/main/tools/fluidnc_config_mcp_server.py)** — An [MCP](https://modelcontextprotocol.io/) server exposing the same validation as a tool call. AI assistants that support MCP (Claude Desktop, Claude Code, and others) can use this to check a config they're generating *before* handing it to you.
- **[`fluidnc_validate_core.py`](https://github.com/bdring/FluidNC/blob/main/tools/fluidnc_validate_core.py)** — Shared validation logic used by the CLI tool and the MCP server above; most people won't need to use this file directly.
- **[`.github/workflows/validate-fluidnc-configs.yml`](https://github.com/bdring/FluidNC/blob/main/.github/workflows/validate-fluidnc-configs.yml)** — Automatically validates config file changes submitted in a pull request to the `bdring/FluidNC` repo.

> **Instructions for AI assistants — read before writing any part of a FluidNC config, even a single section.** Whether you are generating a complete `config.yaml` or just one section/fragment on request (e.g. "add a relay spindle section"), do the following before presenting your answer:
> 1. Read [`tools/fluidnc-config-spec.md`](https://github.com/bdring/FluidNC/blob/main/tools/fluidnc-config-spec.md) in the `bdring/FluidNC` GitHub repo.
> 2. Validate what you produced against [`tools/fluidnc-config-schema.json`](https://github.com/bdring/FluidNC/blob/main/tools/fluidnc-config-schema.json) in the `bdring/FluidNC` repo — via the MCP server (`fluidnc_config_mcp_server.py`) if you have tool access, by running `validate_fluidnc_config.py` if you have code execution, or by manually checking the spec's rules if you have neither. **The schema and validator both work fine on a bare fragment** (e.g. just a `Relay:` block with nothing else) — you do not need a complete file to check your work.
> 3. Fix anything the validator flags before showing your answer to the user.
>
> **A specific, confirmed example of what goes wrong if you skip this:** three different AI assistants (Claude, GitHub Copilot, and Gemini), independently, have each invented a wrapper key around spindle content — `spindle:`, `Spindle:`, or `spindles:` — that does not exist in FluidNC's format. A spindle type name (`PWM`, `Relay`, `ModbusVFD`, etc.) is a direct top-level key, exactly like `axes:` or `control:`, never nested inside anything else. This is a strong, convergent mistake because it's how virtually every other config format (and FluidNC's own maintainers, in hindsight) would design it — so don't assume your own instinct here is correct just because it feels natural. Validating against the schema catches this immediately.

## File Format Specification

Our format is a very simple subset of [YAML](https://en.wikipedia.org/wiki/YAML). To keep the firmware simple, only the features we need are supported.

YAML uses space character indentation to create a multilevel structure. We recommend 2 space characters for each indent. It uses a **key: value** format. The value is optional and can have optional parameters like **key: value:param1:param2**. Blank lines between sections are encouraged to help readability. The format for every key is specified somewhere on this wiki.

```yaml 
name: "TMC2209 XY Servo Laser"
board: "FluidNC Pen/Laser 2209 V2"

stepping:
  engine: RMT
  idle_ms: 255
  dir_delay_us: 1
  pulse_us: 2
  disable_delay_us: 0
```



- **Comments** <a id="comments"></a> Comments are lines ignored by the firmware. They are used as notes to yourself or they can be used to tell the firmware to ignore the line. Each comment must be on its own line, and are made by starting the line with `#`. Comments after a key value pair are not supported.

```
# This comment will work
motor0:
   limit_all_pin: gpio.16:low:pu


motor0:  # This comment will cause an error
   limit_all_pin: gpio.16:low:pu
```

- **Non-supported keys** will be ignored and print an error on startup like `[MSG:ERR: Ignored key frodo]`. If you see this on what you think is a valid key, you probably have an indentation problem. The key must be supported for the section it is indented under.
- **Add a blank space** after the colon on the key, like `board: 6 Pack`
- **No blank spaces** after the colon for value parameters.` 
- **End file with at least one blank line.** The last line must have a line end, so have at least one blank line at the end of the file.
- **Indentation is critical.** All sub items in a section must have the exact same indent level. Use spaces **Do not use tabs.**
- **Length of the filename** including ".yaml" shall not exceed 30 characters.


 
 <a id="data_types"></a>
## Data Types

The detailed descriptions of each config file item will tell you what data type to use. In many cases the values will be limited to a range by the config item. For example: step_per_mm is a Float, but it must be positive. Using an invalid value could result in an error, or the value being constrained to the range.

 - <a id="boolean"></a>**Boolean** True or False
 - <a id="float"></a>**Float** A number with up to 3 decimal places.
 - <a id="integer"></a>**Integer** Do not use a decimal or you will get an error because the parser will think it is a float value. The spec for the item will tell you the valid range.
 - <a id="string"></a>**String** A string of characters. The general maximum length is 255, but specific instances may limit it to a smaller length.
 - <a id="pin"></a>**Pin** This is an I/O pin. See more about them [here](/config/config_IO).
 - <a id="uart"></a>**UartData** This is used to specify UART mode information, like "8N1"
 - <a id="enum"></a>**Enumeration** A list of acceptable values. Example "homing_mode" can be "StealthChop, CoolStep, or StallGuard""
 - <a id="speed_map"></a>**Speed Map** A specially formatted string for setting up spindle speeds. [read more](/config/spindle_speed_maps)
 


**Tip:** If you use an editor that highlights yaml syntax, it will highlight the config file keys and values. Some even allow you to collapse sections. When posting in Github issues, Discord posts, and anywhere Markdown is used, you can add **yaml** after the initial 3 backticks in code blocks to highlight the code.   

## Section Order

The order of sections is a little flexible, but if something is referencing another section, the referenced section should be placed first. For example: If a key is assigned `uart_num: 2`, `uart2:` should be placed before it.


<a id="uploading"></a>
## Uploading

You can upload a config file over WiFi by using the file upload button in the ESP3D tab. It is the green folder icon.

<img src="https://github.com/bdring/Grbl_Esp32/wiki/images/webui_localfs_upload_btn.png" width="400">

If you upload a file named "config.yaml" into the root folder of the local file system,
FluidNC will use it with no additional setup required.  If you want to use a different name, you must also change the `$Config/Filename` setting to the new name. For example the following command sent through the serial counsel will change the config file name to my_machine.yaml: `$Config/Filename=my_machine.yaml`

You can also upload using [Fluidterm](/fluidterm/fluidterm_usage). Press CTRL+U and select the file.

You can view the contents of the file in FLASH with `$LocalFS/Show=\<filename\>`

You can see all of the files in the local file system with `$LocalFS/List`

## Help with problems

See [Troubleshooting Config File Problems](/support/troubleshooting_config_files).


<a id="live_changes"></a>
## Live Changes (Tuning)

Many config values can be set when the firmware is running. This is typically done when tuning a machine. For example, if you are trying to determine the best acceleration for an axis, you might try out a few values to see what works best.

Some features cannot be changed when running. They only take effect after a restart. These are features like pin definitions. You must edit the config file to change those.

To view the current value of the setting send `$` plus the entire YAML hierarchy for that setting. For example send `$/axes/x/steps_per_mm` to see that value. You can see any branch of the hierarchy by sending the hierarchy for that section. For example, to see everything about the x axis send `$/axes/x`.

To change settings you send a `$` command that is the entire YAML hierarchy for that setting. For example send `$/axes/x/steps_per_mm=80` to change the x axis resolution. The changes only affect the values in volatile memory. You must change the YAML file if you want the changes to be permanent. If you send the `$Config/Dump` (or `$CD`) command you can see the complete definition in memory. `$CD=my_config.yaml` will save the current config to my_config.yaml.

If you are changing a setting in a trinamic motor driver setting like (TMC2209, etc) you should send [$Motors/Init (or $MI)](http://wiki.fluidnc.com/en/features/commands_and_settings#motorsinit-or-mi) after changing the setting so the settings are sent to all the motors.

The `$CD` will be displayed or saved in the order FluidNC stores it in memory. Therefore, the saved file may not look like the original file you created. Any keys that were ignored will not be saved. Any keys that you omitted, but have defaults, will be added to the file.


<a id="saving_live_changes"></a>
### Saving Live Changes

The `$CD` command can also save changes to a file. `$CD=\<filename\>` saves the current config to the file name specified. If you specify a new filename you should change your $Config/Filename to that file.

Be sure there is enough room for the file before saving. The ESP32 does not have a lot of space. It can only hold 2-3 YAML files at a time. Check the free space before saving by showing the contents of the local file system with a `$localfs/list` command. 

> There are some drawbacks to saving this way. It will not look much like your original file. If you have comments, they will not be in the saved file. The file will typically be a lot larger, because default values will be saved. You also will not have a backup outside the controller unless you download the file. Most experienced users tend **not to use** the `$CD=` method. They edit the file externally and re-upload. The Web Installer has a good workflow to do this.
{.is-warning}


<a id="saving_live_changes"></a>
### Names and Units

All config item names will include a suffix that describes the units or type. Examples...

- **step_pin:** The value should be a pin
- **pulse_us:** The value should be in microseconds.
- **max_travel_mm** The value should be in millimeters.
- **r_sense_ohms** The value should be in Ohms
- **run_amps** Run current in amps

Do not include the units in your value, just the number, string, etc.

<a id="default_values"></a>
### Default values

Most keys have default values. For pins this is usually NO_PIN. If you are not using a pin like an enable on a spindle, you do not have to specify it in your YAML file. If you do a $CD (config dump) you will see all the keys, even if you did not specify them in your YAML file.

<a id="documentation_sections"></a>
## Documentation of each section

- Top level items (no indent)
- [stepping:](/config/axes#stepping)
- [axes:](/config/axes)
  - [Motor](/config/axes#motors)
- [spi:](/config/sd_card)
- [sdcard:](/config/sd_card)
- [control:](/config/control)
- [coolant:](/config/coolant)
- [probe:](/config/probe)
- [macros:](/config/macros)
- [user_outputs:](/config/user_outputs)
- [spindles](/config/config_spindles)
- [start:](/config/start_group)
</br>
## Example Config Files

Starting with an existing config file that is close to what you want is highly recommended.

Here are some places to find them. Note: these all worked at the time they were posted, but are not actively maintained.

We have a [Github repo of example files](https://github.com/bdring/fluidnc-config-files)
Some 6 Pack Examples are in the 6 Pack [GitHub Repo](https://github.com/bdring/6-Pack_CNC_Controller/tree/main/FluidNC_configs)
Many other controllers have examples on their [wiki pages](http://wiki.fluidnc.com/en/hardware/existing_hardware).

```yaml
name: "ESP32 Dev Controller V4"
board: "ESP32 Dev Controller V4"

stepping:
  engine: RMT
  idle_ms: 250
  dir_delay_us: 1
  pulse_us: 2
  disable_delay_us: 0

axes:
  shared_stepper_disable_pin: gpio.13:low
  
  x:
    steps_per_mm: 800
    max_rate_mm_per_min: 2000
    acceleration_mm_per_sec2: 25
    max_travel_mm: 1000
    homing:
      cycle: 2
      mpos_mm: 10
      positive_direction: false
    
    motor0:
      limit_neg_pin: gpio.17:low:pu
      stepstick:
        direction_pin: gpio.14
        step_pin: gpio.12
    motor1:
      null_motor:

  y:
    steps_per_mm: 800
    max_rate_mm_per_min: 2000
    acceleration_mm_per_sec2: 25
    max_travel_mm: 1000
    homing:
      cycle: 2
      mpos_mm: 10
      positive_direction: false

    motor0:
      limit_all_pin: gpio.4:low:pu
      stepstick:
        direction_pin: gpio.15
        step_pin: gpio.26
    motor1:
      null_motor:

  z:
    steps_per_mm: 800
    max_rate_mm_per_min: 2000
    acceleration_mm_per_sec2: 25
    max_travel_mm: 1000
    homing:
      cycle: 1
      mpos_mm: 10
      positive_direction: true

    motor0:
      limit_all_pin: gpio.16:low:pu
      stepstick:
        direction_pin: gpio.33
        step_pin: gpio.27
    motor1:
      null_motor:

spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18

sdcard:
  cs_pin: gpio.5
  card_detect_pin: NO_PIN

coolant:
  flood_pin: gpio.25:high
  mist_pin:  gpio.21:low

        
probe:
  pin: gpio.32:low:pu

PWM:
  pwm_hz: 5000
  output_pin: gpio.2:low
  enable_pin: gpio.22
  direction_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 0
  speed_map: 0=0% 10000=100%

```

There is also a folder of [example configs](https://github.com/bdring/FluidNC/tree/main/example_configs) in the root folder of the repo.

<a id="developer_reference"></a>
## Developer Reference

To keep the config file consistent and relatively self describing the following naming rules should be followed.

1. All keywords for pins should have an **_pin** suffix. Example **direction_pin:**
2. Any keyword that is for a number with a unit should have the unit as the suffix. Example: **spinup_ms:**
   1. Use "per" as required, like "_mm_per_min"
   2. Use 2 for squared, like "_mm_per_sec2"

