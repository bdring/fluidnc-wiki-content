---
title: Spindles
description: 
published: true
date: 2026-08-01T19:32:47.122Z
tags: 
editor: markdown
dateCreated: 2022-07-21T21:54:15.123Z
---

# Spindles

FluidNC supports multiple spindles on one machine. Spindles can be controlled by different hardware interfaces like relays, PWM, DACs, or RS485 serial interfaces to VFDs. Lasers are treated as spindles. 

Each spindle is assigned a range of tool numbers. You change spindles by issuing the GCode command "M6 Tn", where n is the tool number. Tool numbers within the assigned range for a given spindle will activate that spindle - and the detailed number within the range could be used to select the specific tool on the spindle. This lets you have, for example, a single machine with an ATC spindle and a laser. A single GCode file could allow you to etch and cut out a part. Most CAM programs support tool numbers. You could also have a gantry with both a low-speed high-torque pulley spindle and also a high-speed direct drive spindle.

## General config notes

Each spindle is defined at the top (zero indent) hierarchy level of the config file. There is no group `spindles:` config item like there is for `axes:`

## RS485 (Modbus Spindles) VFD Spindles

![vfd_spindle.png](/hardware/spindle/vfd_spindle.png =x250)

These are on a separate wiki page.

[RS485 Modbus VFD Spindles](http://wiki.fluidnc.com/en/config/modbus_vfd)

## 0-10V

<img src="https://github.com/bdring/FluidNC/wiki/images/10V_spin_example.png" width="300">

0-10V control is designed for spindle controllers that have a 0-10V control input as well as separate pins for forward and reverse direction.  The ESP32 cannot directly generate a 0 to 10V signal, but some FluidNC controllers have an adapter circuit that generates a 0 to 10V analog voltage from an ESP32 GPIO that is pulsed with a pulse-width modulation (PWM) waveform.  The [basic PWM](/config/config_spindles#pwm) spindle type can also be used with such hardware adapters, but it does not support separate forward and reverse direction pins.  If you don't need that style of direction control, you can use the PWM spindle type.

- <a id="pookie"></a>**forward_pin:**

  - Type: [Pin](/config/config_overview#pin)
  - Range: gpio or i2so
  - Default: NO_PIN
  - Detail: This is used to signal forward rotation if you have separate pins for forward and reverse. It may remain on after M5, but will turn off after M4.
- <a name="reverse_pin"></a>**reverse_pin:**

  - Type: [Pin](/config/config_overview#pin)
  - Range: gpio or i2so
  - Default: NO_PIN
  - Details: This is used to signal reverse rotation if you have separate pins for forward and reverse. It may remain on after M5, but will turn off after M3.
- <a name="pwm_hz"></a>**pwm_hz:**
  - Type: [Integer](/config/config_overview#integer)
  - Range: 1 to 20000000
  - Default: 5000
  - Details: This is the frequency of the PWM signal. The precision (number of bits) of the PWM signal is based on the frequency. 20000000 will give you only 4 bits of precision. Each time you divide the pwm_freq by 2, you get another bit of precision.
- <a name="output_pin"></a>**output_pin:**
  - Type: [Pin](/config/config_overview#pin)
  - Range: gpio
  - Default: NO_PIN
  - Details: This is the pin that the output PWM signal is put on. It turns off with M5. The [s0_with_disable](#s0_with_disable) value can affect this pin.
- <a name="enable_pin"></a>**enable_pin:**
  - Type: [Pin](https://github.com/bdring/FluidNC/wiki/FluidNC-Config-File-Overview#pin)
  - Range: gpio or i2so
  - Default: NO_PIN
  - Details: This pin can be used as an enable pin.  The [disable_with_s0](#disable_with_s0) value can affect this pin.
- <a name="direction_pin"></a>**direction_pin:**
  - Type: [Pin](/config/config_overview#pin)
  - Range: gpio or i2so
  - Default: NO_PIN
  - Details:
- <a name="disable_with_s0"></a>**disable_with_s0:**
  - Type: [Boolean](/config/config_overview#boolean)
  - Default: false
  - Details: By default disable is controlled by M5. If you also want it to disable when speed is set to 0 (S0), set this to true.
- <a name="s0_with_disable"></a>**s0_with_disable:**
  - Type:  [Boolean](/config/config_overview#boolean)
  - Default: true
  - Details: By default the speed signal is controlled by the speed value. It will stay on even in M5 mode. If you want it to go to the S0 value with M5, set this to true.
- <a name="spinup_ms"></a>**spinup_ms:**
  - Type:  [Integer](/config/config_overview#Integer)
  - Range: 0 to 20000 (milliseconds)
  - Default: 0
  - Details: This is the time that will be given for the spindle to spin up to maximum RPM as defined in the speed map. The gcode following the speed change will wait until the spin up has completed. The time is proportional to the RPM change. If the change in RPM is only half of the full scale, the delay will only be half of the spinup_ms value.
- <a name="spindown_ms"></a>**spindown_ms:**
  - Type:  [Integer](/config/config_overview#Integer)
  - Range: gpio
  - Default: 0 to 20000 (milliseconds)
  - Details: The action is the same as [spinup_ms](#spinup_ms) except that it applies when the RPM value goes down.
- <a name="tool_num"></a>**tool_num:**
  - Type: [Pin](/config/config_overview#pin)
  - Range: 0 to 255
  - Default: 0
  - Details:  This sets the range of tool numbers for this spindle. If you have multiple spindles you should set up a range for both spindles. When you specify a tool number with the M6 Tnnn gcode command it will switch to the tool that covers that range. The max value is 255.  [See more here](/config/config_spindles#using-multiple-spindles)
    - With 1 Spindle: It does not matter what the value is, but set it to 0.
    - With Multiple Spindles: Set the first spindle to 0 and the other spindles at higher values. Each spindle should have a unique number. If you have a relay spindle with **tool_num: 0** and a laser with **tool_num: 100**, all tool numbers from 0 to 100 will use the relay and all tool numbers from 100 to 255 will use the laser. Send M6T100 to use the laser. 
  - <a name="atc"></a>**atc:**
    - Type: String
    - Default: empty
    - Details: Use this to associate the spindle with an [atc defined in your config file](http://wiki.fluidnc.com/en/features/atc#atc-class-c).
  - <a name="m6_macro"></a>**m6_macro::**
    - Type: Macro
    - Default: empty
    - Default: Use this to associate a macro with the M6 command with the spindle. 
  - <a name="speed_map"></a>**speed_map:**
  - Type: Speed Map  
  - Details: This allows you to fine tune the speeds. You can linearize the RPM vs. PWM across the range and you can set things like minimum speeds. It is a very comprehensive feature that has its [own page.](http://wiki.fluidnc.com/en/config/spindle_speed_maps)
  - <a name="off_on_alarm"></a>**off_on_alarm:**
  - Type:  [Boolean](/config/config_overview#boolean)
  - Default: false (works like standard Grbl)
  - Details: Setting this to true will turn off the spindle whenever an alarm occurs. If you are using a safety door, you may want to enable this because the parking feature does not work in alarm mode.
  
Example

```yaml
10V:
  forward_pin: gpio.13
  reverse_pin: gpio.17
  pwm_hz: 5000
  output_pin: gpio.4
  enable_pin: NO_PIN
  direction_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 0
  speed_map: 0=0.000% 1000=0.000% 24000=100.000%
  off_on_alarm: false
```
  
### Huanyang Registers for 0-10V control
  
 - PD001 (Source of Run Commands) Value 1: (External Terminal)
 - PD002 (Source of Frequency) Value 1: (External potentiometer)

## DAC

The DAC uses the ESP32's built in DAC hardware. This can only be used on gpio.25 and gpio.26. It outputs a 0-3.3V analog voltage (not PWM). In most cases a PWM will be better. The DAC resolution is only 8 bit (0-255) and a PWM can be up to 16 bit (0-65535).

example
```yaml
DAC:
  output_pin: gpio.25
  enable_pin: NO_PIN
  direction_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 100
  speed_map: 0=0.000% 255=100.000%
  off_on_alarm: false
```
  


  



## PWM

The M4 (spindle reverse on) command will only be accepted if a direction pin is assigned to an I/O pin. 

<img src="https://github.com/bdring/FluidNC/wiki/images/pwm_spindle.png" width="300">

 - **[output_pin:](#output_pin)**
 - **[direction_pin:](#output_pin)**
 - **[enable_pin:](#output_pin)**
 - **[pwm_hz:](#pwm_hz)**
 - **[disable_with_s0:](#disable_with_s0)**
 - **[s0_with_disable:](#s0_with_disable)**
 - **[spinup_ms:](#spinup_ms)**
 - **[spindown_ms:](#spindown_ms)**
 - **[tool_num:](#tool_num)**
 - **[speed_map:](#speed_map)**

```yaml
pwm:
  pwm_hz: 5000
  direction_pin: NO_PIN
  output_pin: gpio.14
  enable_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 0
  speed_map: 0=0.000% 10000=100.000%
  off_on_alarm: false
```

## BESC

<img src="https://github.com/bdring/FluidNC/wiki/images/besc_example.jpg" width="300">

BESC means "Brushless Electronic Speed Controller" of the type used to power propeller motors for hobby-type radio-controlled planes, helicopters, and drones.  Those motors can be used for high-speed spindles on light-duty machines that do not have substantial tool side loads. They use the same type of PWM signal as an RC servo.  Conventional PWM controls power by adjusting the duty cycle between 0% and 100%, whereas RC servo PWM adjusts the pulse length between (typically) 1 ms (for motor off) and 2 ms (motor full on) within a pulse repetition period of about 20 ms.  Only one PWM-capable I/O pin is required.  It must be a digital output pin that presents the raw PWM waveform, not a PWM-to-analog output that creates a variable DC voltage by low-pass filtering the PWM waveform.

Earlier versions of FluidNC had a special **BESC** spindle type, but we realized that, with suitable config settings for **pwm_hz** and **speed_map**, the [**PWM**](#pwm) spindle type works perfectly for BESCs.

The usual pulse repetition rate for BESCs is 20ms which is 50 Hz in frequency units, so set the **pwm_hz** config item to 50 (some BESCs can operate with higher pulse repetition rates, up to perhaps 200Hz).  Let's assume that the minimum pulse time is the typical 1ms (motor off) and the maximum time is 2 ms (motor full on).  1ms is 5% of 20ms and 2ms is 10%.  Let's also assume that you wish to set the motor speed with GCode S values between 0 and 1000.  Therefore, the **speed_map** config item would have the value "0=5% 1000=10%".
 ```yaml
pwm:
  output_pin: gpio.4
  pwm_hz: 50
  speed_map: 0=5% 1000=10%
```
You can fine-tune those values as needed for your specific hardware.  If you want to use S values in units of RPM, and your motor runs at 20000 RPM at full power, just replace "1000" with "20000" in **speed_map**.  Most hobby RC motors do not have speed sensors so their speed control is not precise; the RPM value would just be an approximation.

The config settings shown above are the ones that are absolutely necessary for a BESC.  You can set other [**PWM**](#pwm) config items for things like spinup and spindown delays.

> This could also be used to control a hobby servo in an application like a pen plotter.  With this setup you could move the pen down with the GCode `M3 S1000` and lift it with `M5` or `M3 S0`.
Also see the [RC servo feature under motors axes](/config/axes#rc_servo).
{.is-info}
  
> Hobby BESCs often have a "programming mode" that can be entered by powering up the BESC with the radio control transmitter's throttle stick in specific positions, then moving the throttle to other positions after hearing beep patterns from the BESC.  It is sometimes possible to do that from GCode, using commands like "M3 S0" for minimum throttle, "M3 S1000" for full throttle, and "M3 S500" for mid-throttle.  Typically you would issue the first M3 command for the initial throttle position with the BESC powered off, then power it on and go through the specified sequence as the BESC responds with beeps or LED flashes.
{.is-info}


## HBridge

<img src="https://github.com/bdring/FluidNC/wiki/images/h-bridge.png" width="400">

This is like a PWM spindle except that you have separate PWM signals for clockwise (CW) and counterclockwise (CCW) rotation. This was specifically designed to directly control a H bridge circuit.

 - **output_cw_pin:**
    - Type: Pin
    - Range: gpio
    - Default: NO_PIN
    - Details: This is the pin that the output PWM signal is put on for CW rotation. It turns off with M5.
 - **output_ccw_pin:**
    - Type: Pin
    - Range: gpio
    - Default: NO_PIN
    - Details: This is the pin that the output PWM signal is put on for CCW rotation. It turns off with M5.
 - **[enable_pin:](#output_pin)**
 - **[pwm_hz:](#pwm_hz)**
 - **[disable_with_s0:](#disable_with_s0)**
 - **[s0_with_disable:](#s0_with_disable)**
 - **[spinup_ms:](#spinup_ms)**
 - **[spindown_ms:](#spindown_ms)**
 - **[tool_num:](#tool_num)**
 - **[speed_map:](#speed_map)**

```yaml
HBridge:
  pwm_hz: 5000
  output_cw_pin: gpio.4
  output_ccw_pin: gpio.16
  enable_pin: gpio.26
  disable_with_s0: false
  spinup_ms: 1000
  spindown_ms: 1000
  tool_num: 100
  speed_map: 0=0.000% 10000=100.000%
  off_on_alarm: false
```

## Laser

<img src="https://github.com/bdring/FluidNC/wiki/images/laser.png" width="300">

A laser is considered a spindle because gcode does not have laser specific codes. It uses the RPM value as a power level. Lasers also have special requirements.

- They always operate like the [advanced laser mode of Grbl](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Laser-Mode)
  - They will only operate in G1, G2, or G3 motion modes. They will not operate during G0, Jog, Homing etc. If you need it to operate in those modes, use a PWM spindle.
  - They turn off when idle or doing a rapid move.
  - M3 is constant power and M4 is dynamic power mode (scales linearly with speed during accel/decel)

- **speed_map:** final xxx=100% can be whatever you want, but it is typically 255 or 1000. This would need to be used in the CAM software as the max power number.
  
- **off_on_alarm: true**: is recommended from a safety point of view to ensure the laser is switched off when movement is stopped due to triggered alarm.
  
The 2 modes are quite different and each optimized for different types of work.
  
**M3 Mode**
  
This mode is primarily used for cutting through parts. The laser operates whenever you are in a feed rate controller mode (G1, G2 or G3). It will stay on at all times at the full Snnn value. This includes when there is no motion. To stop the laser you must send M5, G0 or S0. This gives you full control. For example, you may want to dwell a fraction of a second at the start or end of a cut. 
  
Here is an example of a macro to test the laser at minimal power

```gcode
M3 S1 ; lowest power
G1 F100  ; set G1 and an arbitrary feedrate to turn on the laser
G4 P0.50  ; wait 0.5 seconds
G0       ; turn off the laser
M5       ; keep it off.
```
  
**M4 Mode**
  
M4 mode is primarily used for engraving. It compensates to lower the power of the laser during acceleration and deceleration to prevent darkening those sections. It will stay off when there is no motion.

**Config example**  
  
```yaml
Laser:
  pwm_hz: 5000
  output_pin: gpio.4
  enable_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  tool_num: 0
  speed_map: 0=0.000% 255=100.000%
  off_on_alarm: true
```

## Relay

<img src="https://github.com/bdring/FluidNC/wiki/images/iot_relay.png" width="300">

This is like a PWM signal except that the pin will be full on for any speed above 0 that you select. PWM signals can quickly destroy a relay. 

The only item you need is the output_pin: It also has the several other default values.


```yaml
relay:
  output_pin: gpio.32
```
  
## Plasma
  
[See this page](http://wiki.fluidnc.com/en/development/plasma)

## NoSpindle

This is a default spindle that is automatically created if you did not specify a spindle in your config file.
  
```yaml
NoSpindle: 
```

# Using Multiple Spindles

You can define as many spindles as your hardware will support. They will act independently. You must use separate I/O pins for each spindle. Simply add each spindle definition to the config file.
  
  Here are the reasons why you must use separate I/O for each spindle. 

- The configuration file parser makes sure that pins are not used more than once as basic config file error validation. This check save us countless hours of support time.
- FluidNC needs to be able to safely control each spindle independently during tool changes and alarm conditions.

The active spindle is determined by the active tool number, each spindle must have its own range of tool numbers. The spindle `tool_num:` config file item determines the first tool in the spindle's range. The spindle's tool number range goes until the next defined spindles `tool_num:` config item. One of your spindle's tool_num: must be 0 to insure all tool numbers are valid.

> If you don't follow the tool numbering rules, you will get warnings and tool numbers will be temporarily assigned. The tool numbers will be assigned in the order that the spindles appear in the config file and have a range of 100.
{.is-warning}



You change tools with the gcodes `T<num> M6 `. The T value sets the next active tool and M6 makes the actual change. You can see the current T value by sending `$G` to get all the current modal values.

```
$G
[GC:G0 G54 G17 G21 G90 G94 M5 M9 T2 F0 S12000]
```

> Most people should put the the `T<num>` and `M6` on the same gcode line. If you send `T<num>` without an M6, the current T value will be set, but the tool change will not happen. $G will report the T value, but the spindle will still be using previous value. Some advanced ATC machines could use this feature to get the next tool ready while running the previous tool.
{.is-info}

**Here is what happens when the M6 command is received**

- When the M6 command is received and the T value does not change, nothing happens.
- When the M6 command is received and the T value changes to a value within the current spindle's range, the S value is set to 0. The spindle enable signal will remain on.
- When the M6 command is received and the T value is in the range of a different spindle, the old spindle will be stopped and disabled. The new spindle waits for an M3 or M4 and an S value.
  
# Multiple spindles of the same type
  
If you have 2 spindles of the same type, like 2 PWM spindles. They will have the same name in the config file. That is fine, but there is no way to access the second spindle with $ commands. It will always respond with the first spindle data. `$pwm/output_pin` will respond `$/pwm/output_pin=gpio.14` in the example below. `$CD` will show both spindles.


```yaml
PWM:
  pwm_hz: 5000
  direction_pin: NO_PIN
  output_pin: gpio.14
  enable_pin: gpio.13
  disable_with_s0: false
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 0
  speed_map: 0=0.00% 10000=100.00%
  off_on_alarm: false
  atc: atc_manual
  m6_macro:
  s0_with_disable: true

PWM:
  pwm_hz: 5000
  direction_pin: NO_PIN
  output_pin: gpio.15
  enable_pin: gpio.12
  disable_with_s0: false
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 10
  speed_map: 0=0.00% 10000=100.00%
  off_on_alarm: false
  atc:
  m6_macro:
  s0_with_disable: true
```

# Troubleshooting

- **I get Error 20 Unsupported command for M4** M4 will only work on spindles that support reversing or lasers. If there is a direction pin for the spindle type you are using it must be assigned a pin

