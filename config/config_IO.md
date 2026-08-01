---
title: Configuring IO Pins
description: How to configure IO pins
published: true
date: 2026-08-01T19:32:42.040Z
tags: en
editor: markdown
dateCreated: 2022-07-21T16:43:02.416Z
---

# Configuring Pins

You must assign a pin number and attributes to each pin used in your configuration. FluidNC will know whether the pin is an input, output, etc. based on the feature it is assigned to. For example, it knows that GPIO assigned to a limit switch will always be an input. There are a few attributes for each type of pin. Each attribute has a default state, so they are all optional. Each attribute is preceded with a colon. They can be used in any order.

## Pin Numbers

There are currently two types of pins that can be used, **gpio** and **i2so**. You specify a pin with the type, followed by a period, followed by the pin number. For example, **gpio.14** or **i2so.24**

-  **gpio** These are native ESP32 pins. They are quite flexible and can be used for most features.
- **i2so** These are on external I2S chips. They are output only and cannot be used for advanced things like PWM. They are only available on controller hardware that implements them, like the 6 Pack. **Note:** At initial power on, these will often turn on briefly. Keep this in mind if you are using them to turn on devices. Consider powering those on after booting.

## i2so section

If you use i2so output pins you must have an **i2so** section in your config file. These are the control pins for the i2so chips.

<!-- config-item path="i2so.bck_pin" -->
### bck_pin
- **Type:** Pin
- **Default:** `NO_PIN`

I2S bit-clock line, wired to the external I2S output shift-register chain. Required (along with data_pin/ws_pin) if any i2so.N pin is used anywhere in the config.
<!-- /config-item -->

<!-- config-item path="i2so.data_pin" -->
### data_pin
- **Type:** Pin
- **Default:** `NO_PIN`

I2S serial data line, wired to the external I2S output shift-register chain.
<!-- /config-item -->

<!-- config-item path="i2so.ws_pin" -->
### ws_pin
- **Type:** Pin
- **Default:** `NO_PIN`

I2S word-select (latch) line, wired to the external I2S output shift-register chain.
<!-- /config-item -->

<!-- config-item path="i2so.min_pulse_us" -->
### min_pulse_us
- **Type:** Integer
- **Range:** You can only use 1, 2 or 4
- **Default:** `2`

This sets the minimum pulse length. Most people should use 2. You might need to use 4 for slower I2S chips like the ones on the Roots or MKS controllers. Use 1 for extremely fast step rates.
<!-- /config-item -->

<!-- config-item path="i2so.oe_pin" -->
### oe_pin
- **Type:** Pin
- **Default:** `NO_PIN`

Optional output-enable pin for the I2S shift-register chain.
<!-- /config-item -->

> Warning: The I2SO pins come on in an indeterminate state at power on. The firmware will quickly set them to the desired state if a valid `i2so:` section is loaded from the config file. This means the pin may be in the wrong state for a fraction of a second at power on. They will maintain the current state if the firmware is reset. If you have them controlling a spindle, laser or other dangerous items, you should apply power to them after the firmware is running.
{.is-warning}

### Config Example

```yaml
i2so:
  bck_pin: gpio.22
  data_pin: gpio.21
  ws_pin: gpio.17
  min_pulse_us: 2
```


## Input Pin Attributes

- **Active state** Each input feature has an active state. For example, the active state of a switch would be when the switch is pushed. Depending on your switch type and wiring the switch may be connecting to a low voltage (ground) or a logic high voltage to the CPU when the switch is pushed. You specify this in your configuration with the **high** or **low** attribute. Examples: **gpio:14:high** or **gpio.14:low** It will use the default of **high** if it is not specified. If your switch is reporting backwards from what you want, flip the **:high** to **:low** or the other way around. 
-  **Pulling resistor** You can add an internal pull-up or pull-down resistor to input pins that support them. This is done with the **pu** (pull-up) or **pd** (pull-down) attribute. Examples: **gpio.14:high:pd** or  **gpio.14:low:pu**. The default is no pulling resistor. The pin will be floating unless you have an external circuit that pulls it one way or the other. This typically causes incorrect pin readings when the circuit is in the open state. ***Note:*** [Some pins do not support](http://wiki.fluidnc.com/en/hardware/esp32_pin_reference) internal pulling resistors and you must provide an external one.

Example:
```yaml
  limit_all_pin: gpio.16:low:pu
```

## Output Pin Attributes

- **Active state** Each output feature has an active state. This usually means the feature is on. Depending on your circuitry, a low or high output signal will turn on the feature. You specify this in your configuration with the **high** or **low** attribute. Examples: **gpio:14:high** or **gpio.14:low** It will default  **high** if it is not specified.

If your feature is working backwards (inverted, wrong way, flipped) from what you want, like the direction pin for a motor, flip the hi to low, or the other way around.

Example:
```yaml 
  coolant:
    flood_pin: gpio.25:low
```

- **Drive Strength** Each gpio output pin can set its drive strength. 

Drive strength determines how much current a pin can source or sink, affecting signal integrity, power consumption, and electromagnetic interference (EMI). The ESP32 provides four drive strength levels:

- 0 (~10mA)
- 1 (~20mA)
- 2 (~40mA, **default**)
- 3 (~80mA, strongest)

There is a case study on drive strength affecting i2so and SPI pins [here](http://wiki.fluidnc.com/en/hardware/signal_quality). You specify the drive strength with the :ds\<num\> attribute. 

Example

``` yaml
spi:
  miso_pin: gpio.19:ds1
  mosi_pin: gpio.23:ds1
  sck_pin: gpio.18:ds1
```

> The :ds will only show on pin with $Config/Dump when it has been changed by your config file. Pins at the default strength level will not show the attribute. 
{.is-info}




## Pin Types and Their Uses

There are three basic pin types
* GPIO - a pin that is directly driven or sensed by the ESP32 chip.  As far as the ESP32 is concerned, a GPIO pin can be used for either input or output, but controller boards usually have circuitry between the ESP32's pin and the  connector on the edge of the board.  That circuitry often limits the use of the particular pin.  For example, if there is a buffer/driver chip to provide a 5V output, its GPIO cannot be used as an input.  Similarly, if there is an input conditioning circuit, its GPIO cannot be used as an output.  The only way to know is to consult documentation or schematics for the specific board.
* I2SO - an output-only pin that is driven by a shift register output.  The chain of shift registers is in turn driven by ESP32 pins that are configured to use the "I2S" bus.  This is only available on specific boards that include the shift registers.  I2SO pins are especially useful for driving the step, dir, and enable pins on stepper drivers.  They can be used for a few other purposes, such as chip select pins for SPI-configured TMC drivers and spindle output enables.  I2SO pins cannot be used for PWM outputs.  If a board supports I2SO, the stepper signals will always be wired as i2so pins.  It is not possible to drive some steppers from i2so and others from gpio.
* uart_channel - a pin that is driven or sensed by an external "IO Expander" device that communicates with the ESP32 via a serial UART channel. IO Expander pins can be used for inputs, outputs that control on/off devices, and PWM for controlling spindle speeds.  They cannot be used for stepper driver step/dir/enables.