---
title: Pin Extenders
description: 
published: true
date: 2026-08-01T19:33:05.344Z
tags: 
editor: markdown
dateCreated: 2022-07-25T21:31:37.878Z
---

# Extenders


## Overview

> The [UART Channel based protocol](http://wiki.fluidnc.com/en/config/uart_sections#channel-io) has replaced this.
{.is-warning}


***Experimental!*** See [PR337](https://github.com/bdring/FluidNC/pull/337)



Pin extenders add pins via external chips. They are more limited than standard ESP32 GPIO.

## PCA9539 & PCA9555

  - **i2c:**
    - **sda:** I2C data signal
      - **Type:** Pin
      - **Range:** Native ESP32 gpio
    - **scl:** I2C clock signal
      - **Type:** Pin
      - **Range:** Native ESP32 gpio
    - **bus:**
      - **Type:** Integer
      - **Range:**
    - **frequency:** I2C clock frequency
      - **Type:** Integer
      - **Range:**


---


  - **extenders:**
    - **pinextender0:**
      - **i2c_extender:**
        - **device:**
          - **Type:** Enum 
          - **Range:** PCA9539 or PCA9555
        - **device_id:** Use this to set the address of the chip.
          - **Type:** Integer
          - **Range:** See chip data sheet (typically (0-2)
          - **interrupt:**
            - **Type:** Pin
            - **Range:** Native ESP32 only


## Example Configuration

```yaml
i2c:
  sda: gpio.14
  scl: gpio.13
  bus: 0
  frequency: 100000
  
extenders:
  pinextender0:
    i2c_extender:
      device: pca9555
      device_id: 0
      interrupt: gpio.16
```

## Using an extended pin

```yaml
      limit_neg_pin: pinext0.0
```

## [Example hardware](https://oshwlab.com/bdring/pca9555)

![20220725_163005.jpg](/20220725_163005.jpg =x300)

## Links

  - [PCA9555 Datasheet](https://www.nxp.com/docs/en/data-sheet/PCA9555.pdf)