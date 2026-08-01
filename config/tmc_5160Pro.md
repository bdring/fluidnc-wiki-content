---
title: TMC5160 Pro (Expert Mode)
description: 
published: true
date: 2026-08-01T19:34:01.093Z
tags: 
editor: markdown
dateCreated: 2022-12-28T15:52:29.719Z
---

# tmc_5160Pro & tmc_2160Pro Motors
The tmc_5160Pro and tmc_2160Pro motors are for advanced users who want direct control over the most important and commonly used registers of the driver. We can add more registers if they are needed.

Currently the driver uses the same register values for both normal and homing modes.

You will need the datasheet to understand these registers

- [Datasheet](https://www.analog.com/media/en/technical-documentation/data-sheets/TMC5160A_datasheet_rev1.17.pdf)
- [CHOPCONF](https://www.analog.com/media/en/technical-documentation/data-sheets/TMC5160A_datasheet_rev1.17.pdf#page=51)
- [PWMCONF](https://www.analog.com/media/en/technical-documentation/data-sheets/TMC5160A_datasheet_rev1.17.pdf#page=54)
- [COOLCONF](https://www.analog.com/media/en/technical-documentation/data-sheets/TMC5160A_datasheet_rev1.17.pdf#page=53)
- [GCONF](https://www.analog.com/media/en/technical-documentation/data-sheets/TMC5160A_datasheet_rev1.17.pdf#page=32)
- [IHOLD_IRUN](https://www.analog.com/media/en/technical-documentation/data-sheets/TMC5160A_datasheet_rev1.17.pdf#page=38)
- [THIGH](https://www.analog.com/media/en/technical-documentation/data-sheets/TMC5160A_datasheet_rev1.17.pdf#page=39)
- [TCOOLTHRS](https://www.analog.com/media/en/technical-documentation/data-sheets/TMC5160A_datasheet_rev1.17.pdf#page=39)

## Calculators

Most registers are a number built up from many smaller values. There is a [Google Sheet](https://docs.google.com/spreadsheets/d/1Ue5yI3-ZFgoVcz6nrzz_FpY7N90UyCm1wIMYn1uvC5k/edit?usp=sharing) that can help you create the register values from these values. Make your own copy of the sheet to get edit rights.You will still need to use the datasheet to determine what values to use.

> TMC5160 and TMC2160 work exactly the same. The only difference is the name in the config file. 
{.is-info}


[Google Sheet](https://docs.google.com/spreadsheets/d/1Ue5yI3-ZFgoVcz6nrzz_FpY7N90UyCm1wIMYn1uvC5k/edit?usp=sharing)

## Examples

```yaml
      tmc_5160Pro:
        step_pin: I2SO.2
        direction_pin: I2SO.1
        disable_pin: I2SO.0
        cs_pin: I2SO.3
        spi_index: -1
        use_enable: false
        CHOPCONF: 373326168
        COOLCONF: 0
        THIGH: 0
        TCOOLTHRS: 0
        GCONF: 4
        PWMCONF: 3289120798
        IHOLD_IRUN: 3852
```

```yaml
      tmc_2160Pro:
        step_pin: I2SO.2
        direction_pin: I2SO.1
        disable_pin: I2SO.0
        cs_pin: I2SO.3
        spi_index: -1
        use_enable: false
        CHOPCONF: 373326168
        COOLCONF: 0
        THIGH: 0
        TCOOLTHRS: 0
        GCONF: 4
        PWMCONF: 3289120798
        IHOLD_IRUN: 3852
```

> If you have a working config from the normal tmc_5160 config item, you can use that as a starting point. If you set **$message/level=debug**, it will show you the current values of the registers. 
{.is-info}


> If you are stuggling to use this type of config, this might not be for you. The registers are very complex and not for newbies. Even the developers of FluidNC do not fully understand how to use them. Please don't expect support on register values. Ask TMC directly.
{.is-warning}


## Tips

- Currents are set in IHOLD_IRUN
- Microstepping CHOPCONF