---
title: UART Sections
description: 
published: true
date: 2026-08-01T19:34:11.274Z
tags: 
editor: markdown
dateCreated: 2023-03-01T20:22:50.623Z
---

# UART Sections

You can define UART sections at the top level of the config file and refer to them where they are used. You can assign just about any pin to any UART. The start message will tell you if you selected one of the rare pins that do not support the UART.

```yaml
uart1:
  txd_pin: gpio.0
  rxd_pin: gpio.4
  rts_pin: gpio.13
  baud: 115200
  mode: 8N1

uart2:
  txd_pin: gpio.22
  rxd_pin: gpio.21
  baud: 115200
  mode: 8N1
```

## Config items details

- <a name=tx_pin></a> **txd_pin:**
  - Date Type: GPIO Pin
  - Default: NO_PIN
  - Details: The pin used to transmit data from the MCU
- <a name=rx_pin></a> **rxd_pin:**
  - Date Type: GPIO Pin
  - Default:  NO_PIN
  - Details:  The pin used to Receive data from the connected device
- <a name=rts_pin></a> **rts_pin:**
  - Date Type: GPIO Pin
  - Default: NO_PIN
  - Details:  The pin used for a Request To Send signal controlled by the MCU. This is often used for hardware flow control. Some UART to RS485 devices require this signal 
- <a name=cts_pin></a> **cts_pin:**
  - Date Type: GPIO Pin
  - Default: NO_PIN
  - Details: The pin used for a Clear To Send signal controlled by the MCU. This is often used for hardware flow control. This is rarely used.
- <a name=baud></a> **baud:**
  - Date Type: Integer (2400 to 10000000)
  - Default: 115200
  - Details: The data baud rate
- <a name=mode></a> **txd_pin:**
  - Date Type: A three character code
  - Default: N81
  - Details: Parity (N (None),E (Even), or O (Odd)
  
**Notes:**

The Grbl command protocol uses an OK response for flow control, so hardware flow control is not needed.

All items are optional and have a default. The only requirement is that you need at least a rx_pin or a tx pin.

- A tx_pin only UART example would be a read only display
- An rx_pin only UART example would be a button panel. You need to be careful because the OK response will not be sent with rx only UARTs. You can safely use [realtime commands](http://wiki.fluidnc.com/en/features/commands_and_settings#realtime-commands). Other commands will be problematic.  

## uart0

uart0 is the USB serial console one; you cannot define or change it because it is so important for startup messaging.

## Other uarts

Within a Spindle class, you can still use the old syntax where there is a subordinate "uart:" subsection, or, alternatively, you can refer to an externally-defined uart section with:
```yaml
NowForever:
  uart_num: 1
  modbus_id: 1
```

Trinamic UART devices like TMC2208 and TMC2209 no longer support the subordinate "uart:" subsection (making that work was just too hard); you must use the external UART section with "uart_num: N":

```yaml
axes:
  x:
    motor0:
      tmc_2209:
        uart_num: 2
        addr: 2
        ... 
  z:
    motor0:
      tmc_2209:
        uart_num: 2
        addr: 1
        ...
```
With this scheme it should be possible to use, say, 5 TMC UART devices by using two UARTs, getting around the limitation of 4 device addresses.

Dynamixel2 is like Trinamic; you must use "uart_num: N":
```yaml
axes:
  x:
    motor0:
      dynamixel2:
        uart_num: 1
        id: 3
```
The Dynamixel driver, as currently written, can use only one UART for all the Dynamixels.

# UART Channels

UART channels create a new Grbl interface on a UART. This is designed for displays, pendants and external controllers. It can use a report interval so the client does not need to query status. You will get a prompt status update when anything major changes and regular updates when the axes are moving.

We have some [starter code](https://github.com/bdring/PendantsForFluidNC) if you want to make your own display or interface.

```yaml
uart_channel1:
   uart_num: 2
   report_interval_ms: 75
   message_level: info
```

- <a id="uart_num"></a>**uart_num:** 
  - Type: [Integer](/config/overview#integer)
  - Range: See details
  - Default: 0
  - Details: This connects it to a previously defined uart section.
  
- <a id="report_interval_ms"></a>**report_interval_ms:** 
  - Type: [Integer](/config/overview#integer)
  - Range: 50 - 5000 (milliseconds)
  - Default: 0
  - Details: This sets the reporting interval during motion. It is generally used to update DROs. If you set it to zero it will be off. Ideally it should be 0 or 50-5000 to prevent overloading the processor.
  
- <a id="message_level"></a>**message_level:** 
  - Type: [Enumeration](/config/overview#enum) 
  - Range: None|Error|Warn|Info|Debug|Verbose
  - Default: Verbose
  - Details: This allows you to limit the messages that will be sent to this channel. It is useful for displays and pendants that do not need the messages and would rather not have to process them.  Only messages at levels less than or equal to the chosen value will be sent to the channel.  The global configuration value **\$Message/Level** also applies, limiting messages to all channels.  The channel-specific **message_level** item is an additional restriction, so only messages at levels at or below the lesser of **\$Message/Level** or **message_level** will go to this channel.
  
The new channel will accept input just like the USB serial channel, the Telnet channels, the WebSocket channels, etc.

You can also do uart_channel1 or uart_channel2.  uart_channel0 is the implied USB serial channel and is always on by default

There are only three physical UART engines on ESP32, so if you try to do too much you will run out of UARTs.  If you are using a UART for a VFD spindle and another for TMC drivers, you can't make another uart_channel .  UARTs can only be shared among like devices, such as multiple TMC drivers or multiple modbus VFD spindles.


## Auto Reporting

[See this page](http://wiki.fluidnc.com/en/support/interface/automatic_reporting)

# Channel I/O

## Overview

This covers ways of adding I/O over a UART channel. For example: An MCU with inputs (switches, etc.) and outputs could be connected via UART. This could potentially be used by senders, the WebUI, or WebSockets. 

The [Airedale](/en/hardware/official/airedale) is an example of a channel based I/O extender.

## Input Pin State Reports

When an input pin changes state, or immediately after the pin is initialized, the new value will be reported via a two-character sequence that encodes the pin number and its state.  The sequence is as follows:

For pins that are inactive, the first character is 0xc4 and the second is 0x80+pin_number.  For pins that are active, the first character is 0xc5 and the second is 0x80+pin_number.

(This encoding is a UTF8 representation of 0x100+pin_number for inactive pins and 0x140+pin_number for active pins.)

## Commands

The following commands are currently defined.  An IO Expander should either ignore commands that it does not recognize, or if the expander implements serial passthrough, should forward them to the passthrough port.

### EXP Command

The EXP command initializes a pin and defines its characteristics.  The parameter for **EXP:** is **pin_spec=key,key,...**, with key values as described.  If the pin can be initialized with the given characteristics, the expander must respond with **Expander_ACK**; otherwise it must respond with **Expander_NAK**.  After the ACK or NAK, if the pin is an input, the expander must send a pin value report with the pin's current value.

The EXP command format is **[EXP:<pin_spec>=<pin_type>\<attributes\>]**
**<pin_spec>** is the name of a pin in the form **io.N**, where **N** is a number from 0 to 63.
**<pin_type>** is one of **in**, **out**, or **pwm**
**\<attributes\>** is zero or more values from the list below, each preceded by a comma.  The order of attributes does not matter.

- Active level - **low, high** (default: high) - applies to all pins
- Pullup control - **pu, pd** (default: no pull resistor) - applies to input pins
- PWM Frequency - **hz:N** (default: 5000) - applies to PWM pins

For example:
```
[EXP: io.1=in,low,pu]        ; Initialize io1 as an input with pullup, active low
[EXP: io.2=out]              ; Initialize io2 as an output, active high (default)
[EXP: io.3=pwm,hz:5000,low]  ; Initialize io3 as pwm at 5000 Hz, active low

```

EXP commands from FluidNC to the expander are acknowledged with **Expander_ACK**(0xB2) if the command succeeded or **Expander_NAK** (0xB3) if the command failed.  Failure to initialize an expander pin results in a FluidNC configuration alarm.

### SET Byte Code Sequence

Similarly to the code sequence used for input pin state reports, an output or PWM pin's state can be set with a short UTF-8 code sequence.  Whereas input reports go from the expander to FluidNC, SET sequences go in the opposite direction, from FluidNC to the expander. For ordinary output pins with two states, the sequence **0xC4, 0x80+pin_number** sets a pin to the inactive state, while **0xC5, 0x80+pin_number** sets it to the active state.  This is the UTF-8 encoding of the numbers `0x100+pin_number` for inactive, `0x140+pin_number` for active.

Setting a PWM pin's duty cycle requires a longer sequence to accommodate not only the 6 pin_number bits but also the extra bits for the duty cycle.  The duty cycle is represented by a number from 0 to 1000 inclusive, where 0 is always-inactive, 1000 is always-active, and intermediate values represent proportional duty cycles.  The encoding is the UTF-8 representation of the number `0x10000 + pin_number * 0x400 + duty_cycle` which is a 4-byte sequence.  In binary, that is `1ppppppdddddddddd` where `p` is a pin number bit and `d` is a duty cycle bit.  The byte sequence per UTF-8 encoding rules is, in binary, `11110000 1001pppp 10ppdddd 10dddddd`.  In hex, it is `0xf0, 0x90+(pin_num>>2), 0x80+((pin_num&3)<<4)+(duty_cycle>>6), 0x80+(duty_cycle&0x3f)`.  A UTF-8 encoder routine would generate the sequence with `utf8_encode(0x10000 + (pin_number << 10) + duty_cycle)`.

The 10-bit duty_cycle representation directly encodes one-decimal-point percentages from 0.0% to 100.0%.

A SET sequence that succeeds is not acknowledged.  A failing SET (due to, say, a pin number that is not initialized) responds with **Expander_NAK** (0xB3).

### Expander Startup

When the Expander starts, it sends **Expander_RST** (0xB4) to FluidNC.  If FluidNC receives **Expander_RST** after it has already configured the Expander (by sending EXP commands), FluidNC should assume that the Expander crashed and will no longer handle SET sequences or send Input Pin State reports, so FluidNC should enter Alarm state with Alarm code "ExpanderReset".  If the expander and FluidNC boot simultaneously, for example if they are powered at the same time, it is likely that the expander will boot much faster than FluidNC and FluidNC will not see the **Expander_RST** because the corresponding uart_channel is not yet ready to receive characters.  That is correct behavior, because FluidNC should only alarm if it sees **Expander_RST** after FluidNC has configured the expander.

### Example config (partial)

```yaml
# For 6x Controller
uart1:
  txd_pin: gpio.27
  rxd_pin: gpio.25
  baud: 921600
  mode: 8N1

uart_channel1:
  report_interval_ms: 75
  uart_num: 1

user_outputs:
  digital0_pin: uart_channel1.0
  digital1_pin: uart_channel1.1
  digital2_pin: uart_channel1.2
  digital3_pin: uart_channel1.3
  digital4_pin: uart_channel1.4
  digital5_pin: uart_channel1.5
  digital6_pin: uart_channel1.6
  digital7_pin: uart_channel1.7

coolant:
  mist_pin: uart_channel1.8
  flood_pin: uart_channel1.9
```
### Errors

The device should report an error via NAK if it cannot comply.

### Forwarding

It is possible to make an IO expander with a second UART channel that can be used for a downstream pendant.  In that case, the expander should forward everything that it receives on its primary UART to the downstream UART, and similarly should send everything that it receives on its downstream UART to its primary UART.  To avoid bottlenecks and buffer overrun, both UARTs should use the same baud rate.
