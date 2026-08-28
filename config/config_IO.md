---
title: Configuring IO Pins
description: How to configure IO pins
published: true
date: 2026-08-28T00:08:46.387Z
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

### Active State

Every input has an active condition — the real-world situation it is meant to detect. A limit or homing switch is active when it is engaged; a probe is active when it contacts the workpiece; a touchless (proximity) sensor is active when its target is in range.

The circuit between the switch and the ESP32 sets the active-condition GPIO voltage. Depending on the sensor type, normally-open vs. normally-closed wiring, and input circuit details, the pin may be at a high voltage when active, or at a low voltage when active.

The **:high** (default) and **:low** pin attributes tell FluidNC which voltage counts as active:

- **gpio.14 or gpio.14:high** — active when the pin voltage is high.
- **gpio.14:low** — active when the pin voltage is low.

It is never necessary to explicitly say :high.

This is a purely logical inversion done in software. It is independent of the :pu / :pd (pull-up / pull-down) attributes, which change the pin's electrical behavior rather than its interpretation.

If an input reads as active when it shouldn't — homing stops the instant it starts, or a switch/probe shows as triggered when it is not physically engaged — the configured active level is backwards; add or remove :low.
### Pulling resistor
When a GPIO pin is used as an input, its electrical state is typically "floating". If nothing (or just an open switch) is connected to it, the voltage is indeterminate, so the detected input level is not reliable. Typical CNC control boards have circuitry outside the MCU to establish a defined pin voltage.  The most common choice is an external resistor connected to 3.3V (usually in conjunction with a capacitor to reduce noise).  That lets you connect an ordinary switch between the input and ground.  When the switch is open, the resistor "pulls up" the GPIO input voltage to 3.3V.  When the switch is closed, the switch overcomes the resistor and "pulls down" the GPIO input voltage to 0.

If you need to use a GPIO that does not have an external resistor or other similar circuit as an input, you can use the MCU's internal pullup or pulldown resistors instead.  They are switchable.  By default they are not connected to the input pin, but can be enabled by adding **:pu** (pullup) or **:pd** (pulldown) to the pin specification, as with **gpio.14:pu**.

Pulldown resistors are rarely used for CNC controllers, so it is unlikely that you will actually need to use **pd**.

If you have a choice between an internal and external pullup resistor, external is nearly always better.

***Note:*** [Some ESP32 pins do not support](http://wiki.fluidnc.com/en/hardware/esp32_pin_reference) internal pulling resistors and you must provide an external one.

Example:
```yaml
  limit_all_pin: gpio.16:low:pu
```

## Output Pin Attributes

### Active state
When an output is active, it means that the device it controls is supposed to be on. To turn on the device, the MCU IO pin might need to be either high or low, according to the circuit between it and the device, You specify this in the config file with the **high** (default) or **low** attribute.

- **gpio:14:high or gpio.14** to turn on the device when the pin is high
- **gpio.14:low** to turn on the device when the pin is low

If your device is off when it should be on, or vice versa, either add or remove **:low** from the pin specification.

This also applies to motor direction pins.  If the motor is moving in the wrong direction, add or remove **:low** from the direction pin spec.  (If the motor always moves in the same direction, regardless of what you asked for, the problem is something else -  the direction signal is not getting to the driver at all.)

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