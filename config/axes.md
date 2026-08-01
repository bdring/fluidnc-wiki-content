---
title: Axes
description: 
published: true
date: 2026-08-01T19:32:32.463Z
tags: en
editor: markdown
dateCreated: 2022-07-21T17:00:13.765Z
---

# FluidNC Axes Setup

FluidNC supports 12 motors on 6 axes. This page details the different ways steps are generated, settings and integration with different hardware. 

<a id="stepping"></a>
## Stepping:

This is an important section for the motors. 

- <a id="stepping_engine"></a>**engine:** 
  - Type: [Enumeration](/config/overview#enum) 
  - Range: **RMT**| **TIMED**| **I2S_STATIC** | **I2S_STREAM**
  - Default: RMT
  - Details: This determines the method used to generate the steps in firmware. Controller board hardware is designed for either RMT or I2S stepping so you must choose a method that your controller board hardware uses.  It is not possible to mix and match stepping types on different motors. The supported types are: 
  
    - <a id="RMT"></a>**RMT** results in simpler hardware for projects that are not limited by GPIO pin count. It is typically used on controller boards with no more than 4 independent motor ports. It uses the [RMT](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/peripherals/rmt.html) feature of the ESP32 chip to handle step pulse generation  without wasting time in delay loops. It does so  by planning a sequence of voltage transitions in advance and then triggered for each step pulse. The step and direction pins are native GPIO pins. So, if there are lots of motors, few GPIOs will be left for other uses.
    - <a id="TIMED"></a>**TIMED** has the same pin limitations as RMT but is less efficient so there is no reason to use it . It uses the CPU to drive steppers directly which requires delays that waste CPU cycles.
    - <a id="I2SO"></a>**I2SO** (I2S Output Only) Is a way to drive motors with fewer GPIO pins by using the ESP32's I2S bus interface hardware. It requires specific external hardware on the controller board ([read more](/hardware/controller_design_guidelines#IS2O_Chips)). If using I2SO hardware, there must be a valid I2SO definition in your config file. The [6-pack controller](https://www.tindie.com/products/33366583/6-pack-universal-cnc-controller) was the original board to utilize this engine. Others have since used the core design for different boards such as MKS DLC32 and TinyBee. <a id="I2S_STATIC"></a>**I2S_STATIC** and <a id="I2S_STREAM"></a>**I2S_STREAM** are identical.  The two distinct names exist for historical reasons, when there were two variants with different trade-offs for speed vs latency.  Now, choosing either will invoke the same code, giving high-speed, low-latency, jitter-free stepping.

> People often ask if the I2S method could be used for input expansion.  While it is theoretically possible, there are complications that make it less attractive than other input expansion methods.  We do not plan to implement I2S input.  For input expansion, we recommend and support using an auxiliary MCU that communicates with the FluidNC ESP32 over a UART connection.
{.is-note}

- <a id="idle_ms"></a>**idle_ms:** 
  - Type: [Integer](/config/overview#integer)
  - Range: 0-4294967295
  - Default: 250
  - Details: A value of 255 will keep the motors enabled at all times (preferred for most projects). Any other value, either between 0-254 or from 256- 4294967295, will disable all the motors that many milliseconds after the last step on any motor. **Note:** Motors can be manually disabled at any time with the **[$MD](http://wiki.fluidnc.com/en/features/commands_and_settings#motordisable-or-md)** command.
  > The use of the value 255 to mean "always enabled" is for Grbl compatibility.  Grbl used an 8-bit number for this parameter so only values of 0-266 were possible.  FluidNC uses a 32-bit number to permit larger values.
  {.si-note}

- <a id="pulse_us"></a>**pulse_us:** 
  - Type: [Integer](/config/overview#integer)
  - Range: 0-10
  - Default: 4
  - Details: The duration of the step pulses (microseconds). This is the "on" duration of the pulse. It typically needs an equal "off" duration. This means the max number of steps per second will be 1,000,000/(pulse_us*2). Stepper drivers will have a minimum required time length for pulses to register them. If the manufacturer provides a datasheet for the stepper driver, this value can be found there. 

- <a id="dir_delay_mus"></a>**dir_delay_us:** 
  - Type: [Integer](/config/overview#integer)
  - Range: 0 -10
  - Default: 0
  - Details: The delay(microseconds) needed between a direction change and a step pulse. Many drivers do not need a delay here.

- <a id="disable_delay_ms"></a>**disable_delay_us:** 
  - Type: [Integer](/config/overview#integer)
  - Range: 0-10
  - Default: 0
  - Details: Some motors need a delay from when they are enabled to when they can take the first step. This value is the number of microsecond delayed. 

- <a id="segments"></a>**segments:** 
  - Type: [Integer](/config/overview#integer)
  - Range: 6-20
  - Default: 12
  - Details: This sets the number of segment buffers. You should leave this at the default unless you are trying to fine tune a special application.


Example

```yaml
stepping:
  engine: I2S_STATIC
  idle_ms: 250
  pulse_us: 4
  dir_delay_us: 4
  disable_delay_us: 0
  segments: 6
```

## Speed Limitations

Step signals are sent as pulses. Each pulse has a duration as described above. The **pulse_us** is the "on" duration of the pulse. It typically needs an equal "off" duration. Other parameters like **dir_delay_us** also can contribute to the total duration of each pulse. The absolute maximum number of pulses you can send per second (Hz) is 1/(total pulse time). This has nothing to do with the speed of the processor; it is just math. Realistically the fastest you can go is in the 100kHz-125kHz range. This will be slower if you are using long pulse durations.

The config items that set this rate are **steps_per_mm** and maximum pulse rate. Here is the equation to find this rate. 
```
(steps_per_mm * (max_rate_mm_per_min) / 60)
```

Therefore, you can see that **steps_per_mm** has a big impact. Do not use a larger number than you need, or max speed will suffer. Consider lowering your microstepping to get a lower **steps_per_mm**.

Some of this math is checked with this formula when the config file is loaded. You may get errors if rates are exceeded, you may also get crashes. 


```
1000000 / ((2 * pulse_us) + dir_delay_us)
```

The speed of the processor can also come into play if a lot of processor time is required per step. High density laser engraving is one example.

> if you exceed the max rate, you will get an error like this: "[MSG:ERR: Initialization error at /axes/y: Stepping rate 157750 steps/sec exceeds the maximum rate 125000]"
{.is-warning}

<a id="axis"></a>
## Axes

- <a id="shared_stepper_disable_pin"></a>**shared_stepper_disable_pin**

  - Type: [Pin](/config/overview#pin)
  - Range: gpio or I2SO 
  - Default: NO_PIN
  - Details: This is a pin that is wired to multiple motor drivers (typically all). This toggles with the motor enable/disable feature. You can also assign pins at the individual motor level. 

- <a id="shared_stepper_reset_pin"></a>**shared_stepper_reset_pin:** 

  - Type: [Pin](/config/overview#pin)
  - Range: gpio or I2SO
  - Default: NO_PIN
  - Details: This is a pin that is wired to multiple motor drivers. This is a feature commonly found on stepstick driver sockets. Currently this only sets the voltage at turn on and it stays that way. You can also assign pins at the individual motor level.
- <a id="homing_runs"></a>**homing_runs:**
  - Type: Integer
  - Default: 2
  - Range: 1 to 5
  - Details: This sets the number of touches during the homing sequence. The default is 2 to match the Grbl style.



  Example

```yaml
axes:
  shared_stepper_disable_pin: NO_PIN
  shared_stepper_reset_pin: NO_PIN
  homing_runs: 2
```
<a id="axis-letter"></a>
## Axis letter

```yaml
axes:
  [x:|y:|z:|a:|b:|c:]
```

#### Axis letters & Linear vs. rotary axes.

The axes *must* be used in order. If using an XZ machine, a Y axis must still be declared. If the Y axis is not defined, FluidNC will define a virtual one without any outputs. This requirement is due to a reporting issue. The reporting sends values like 000.000, 000.000, 000.000. The axes are not labeled, so you assume they are in XYZABC order. The minimum axis count is 3. If you only define X and Y a virtual Z will be created.

ABC axis will not report position in inches: 
XYZ are traditionally linear axes and ABC are considered rotary axes. ABC axis can be used as linear axes with a catch; they do not report units in inches. FluidNC uses millimeters internally and scales to inches for reporting XYZ axis. However, it will not scale ABC because it assumes they are a universal scale like degrees or radians that do not change for inches.


  - <a id="steps_per_mm"></a>**steps_per_mm:** 
    - Type: [Float](/config/overview#float)
    - Range: 0.001 to 100000.000
    - Default: 80.000
    - Details: This is a float value for the resolution of the axis. These are steps from the perspective of the controller. If using a microstepping driver, multiply the motor steps by that value. The name 'steps_per_mm' is not entirely accurate.  It is really 'steps_per_gcode_unit'.  If a GCode command asks for a motion of one unit in G21 mode - as when going from 98 to 99 for example - FluidNC will issue 'steps_per_mm' step pulses.  In G20 (inches) mode for a linear (XYZ) axis, the number of steps is multiplied by 25.4 (mm/inch). Rotary axis motion does not depend on G20 vs G21 mode; a distance of one unit for a rotary axis always issues 'steps_per_mm' pulses.
  - <a id="max_rate_mm_per_min"></a>**max_rate_mm_per_min:**
    - Type: [Float](/config/overview#float)
    - Range: 0.001 to 100000.000
    - Default: 1000.000
    - Details:
  - <a id="acceleration_mm_per_sec2"></a>**acceleration_mm_per_sec2:**
    - Type: [Float](/config/overview#float)
    - Range: 0.001 to 100000.000
    - Default: 25.000
    - Details:
  - <a id="max_travel_mm"></a>**max_travel_mm:** 
    - Type: [Float](/config/overview#float)
    - Range: 0.1000 to 10000000.0
    - Default: 1000.000
    - Details: Working length of the axis. Measured from axis location after pulling off limit switch. If using a limit switch at the other end of travel for a hard limit, make sure max_travel_mm will not reach the second switch.  If the second switch is pressed before the soft limit takes effect, an alarm will be triggered.
  - <a id="soft_limits"></a>**soft_limits:** 
    - Type: [Boolean](/config/overview#boolean)
    - Default: false
    - Details: If set to true, commands that would cause the machine to exceed *max_travel_mm* will be aborted. Jog commands will be constrained in this mode, so it is not possible to get a soft limit alarm while jogging. The jog will simply stop before the end of travel.  Soft limits rely on an accurate machine position. This typically requires homing first. **If you use soft limits alway home the axis before moving the axis via jogs or gcode.**
    - <a id="idle_disable"></a>**idle_disable:**
      - Default: true
      - Details: You can use this to ignore the idle disable (idle_ms:). If you want an axis to always stay on, you can set this to false. This could be used on Z axes to prevent them from falling or on an RC servo axis to keep it enabled.

**Example:**


```yaml
axes:
  x:
    steps_per_mm: 800.000
    max_rate_mm_per_min: 4500.000    
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 180.000
    soft_limits: true
```


<a id="homing"></a>
## Homing

Homing is an optional feature that can move to a specified machine location that is determined by switches or sensors at the end of one or more axes.  The end of the homing process establishes the origin of the "machine coordinate system".  Homing is optional because most CNC workflows depend only on the "work coordinate system" whose origin is relative to the stock, not the overall machine.  Homing typically involves multiple "cycles", in which one or more axes are moved to their ends.  For example, it is common to home the Z axis in the first cycle, moving it all the way to the top, so that the tool does not hit stock or clamping fixtures during a subsequent cycle where X and Y are moved to their ends.

These keys are for the homing at the axis letter level. Even if an axis has more than one motor, it still homes towards one end and at a specific speed.

- <a id="cycle"></a>**cycle:**  

  - Type: [Integer](/config/overview#integer)  
  - Range: -1 to 6  
  - Default: -1
  - Interactions: multi-axis homing cannot be used with CoreXY, because 2 motors are used for each axis move.  
  - Details: 
    - Homing cycles determine each axis home. Cycles allow you to home axes one at a time or group a few axes into a single cycle for multi-axis homing. Assign the same number to multiple axes to home them in the same cycle. Many people would home the Z first (cycle: 1) and then might home X and Y at the same time (cycle: 2)
    - A setting of 1 or greater enables the axis for homing with `$H`. Anything lower than 1 will be an inactive cycle and no physical homing will occur for that axis.
    - A setting of 0 means it will not home with `$H`, but you can still home it with `$H<axis>`
    - A value of -1 means the machine will not move, but the current machine position (mpos) position of the axis will be set to the **mpos_mm** value for the axis. This can be used for axes that don't have any switches.
  
    - Typically, you would put the Z axis on `cycle: 1` and the other axes on higher cycles.

- <a id="allow_single_axis"></a>**allow_single_axis:**  

  - Type: [Boolean](/config/overview#boolean)  
  - Default: `true`  
  - Details: Allows single axis homing for the axis (example: `$HX` to home the X axis).  
    	Set to false if you do not have limit switches, or to block the command. You might want to block it because a single axis home unlocks the machine even though other axes may not be homed. Soft limits are only accurate on homed axes and will not protect a machine that has not homed all axes.

- <a id="positive_direction"></a>**positive_direction:**  

  - Type: Boolean  
  - Default: true
  - Details: Controls the direction in which the axis moves when homing. true will home in the positive direction, where positive means moving towards a higher position value.

- <a id="mpos_mm"></a>**mpos_mm:**  

  - Type: [Float](/config/overview#float)  
  - Range: -1000000.000 to 1000000.000
  - Default: 0.000
  - Details: Sets the machine position after homing and limit switch pull-off in millimeters. If you want the machine position to be zero at the limit switch, set this to zero. Keep in mind the homing direction you choose this number.

- <a id="seek_mm_per_min"></a>**seek_mm_per_min**  

  - Type: [Float](/config/overview#float)  
  - Range: 1.000 to 100000.000
  - Default: 200.000
  - Details: Speed at which axis moves to touch the limit switch for the first time to get a rough position.  The axis will pull-off the limit switch and move at the speed indicated by feed_mm_per_min  to touch the limit switch for a second time for a more precise home position.

- <a id="feed_mm_per_min"></a>**feed_mm_per_min**  

  - Type: [Float](/config/overview#float)
  - Range: 1.000 to 100000.000
  - Default: 50.000
  - Details: Movement speed for second contact with limit switch to get precise home position. Usually, a slow speed because the axis will be close to the limit switch and a slower speed will often yield a more precise/consistent home position. 

- <a name="settle_ms"></a>**settle_ms**

  - Type: [Integer](/config/overview#integer)
  - Range: 0 to 1000
  - Default: 250
  - Details: Amount of time (in milliseconds) the machine will pause between each homing cycle to allow the machine to settle from the previous homing cycle.

- <a id="seek_scaler"></a>**seek_scaler:**

  - Type: [Float](/config/overview#float)
  - Range: 1.0 to 100.0
  - Default: 1.1
  - Details: seek_scaler * max_travel equals distance homing axis will move before the operation fails if it has not reached the limit switch. This multiplier allows the axis to move farther than max_travel to account for extra distance the axis pulls-off the limit switch (mpos_mm). 

- <a id="feed_scaler"></a>**feed_scaler:**

  - Type [Float](/config/overview#float)
  - Range: 1.0 to 100.0
  - Default: 1.1
  - Details: Multiplied by the [pulloff_mm](http://wiki.fluidnc.com/en/config/axes#pulloff_mm) to calculate max distance the axis will travel back to the switch after the first pull-off before it fails. If using switches with a lot of variability or sensorless homing a larger value might be required to guarantee the switch triggers the second time. 
<br>

> Some closed loop motors like servos home themselves and will ignore many of settings like the pulloff and speeds
{.is-info}


  **Example:**

  ```yaml
  axes:
    x:
      homing:
        cycle: 2
        allow_single_axis: true
        positive_direction: false
        mpos_mm: 1.000
        seek_mm_per_min: 200
        feed_mm_per_min: 50
        seek_scaler: 1.5
        feed_scaler: 1.5   
  ```

<a id="motors-settings"></a>
## Motor Settings

You can have up to two motors per axis letter. They are defined as `motor0:` and `motor1:`. If you want to learn about or implement auto squaring of the axis, [see this page](http://wiki.fluidnc.com/en/config/homing_and_limit_switches#axis-squaring).

- <a id="limit_neg_pin"></a>**limit_neg_pin:** 
   - Type: [Pin](/config/overview#pin)
   - Range: gpio
   - Default: NO_PIN
   - Details: Pin used to detect limit switch activation on the negative side of axis travel. 

- <a id="limit_pos_pin"></a>**limit_pos_pin:** 
   - Type: [Pin](/config/overview#pin)
   - Range: gpio
   - Default: NO_PIN
   - Details: Pin used to detect limit switch activation on the positive side of axis travel. This switch will often be just beyond the max_travel limit. 

- <a id="limit_all_pin"></a>**limit_all_pin:** 
   - Type: [Pin](/config/overview#pin)
   - Range: gpio
   - Default: NO_PIN
   - Details: Used when you want switches at both ends of travel wired to the same pin. If limit_all_pin is specified, do not specify a limit_neg_pin or a limit_pos_pin. A drawback to using this feature is that FluidNC does not know which end of travel is causing the trigger. It cannot determine which way to move to clear the switch. Because of this, switches must be cleared manually before homing.

- <a id="hard_limits"></a>**hard_limits:** 
   - Type: [Boolean](/config/overview#boolean)
   - Default: false
   - Details: Set this to true when you want to use the switches defined above as hard limits. Hard limits immediately stop all motion when the switch is activated. Position is considered lost, and rehoming is required. 

- <a id="pulloff_mm"></a>**pulloff_mm:** 
   - Type: [Float](/config/overview#float)
   - Range: 0.100 to 100000.000
   - Default: 1.000
   - Details: This is the distance to pull off a touched switch with this motor. This value should be greater than the amount you can travel after the switch is activated. This makes sure you can always clear the switch during homing. 

<br>
**Example:**

```yaml
axes:
  x:
    motor0:
      limit_neg_pin: gpio.33
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: true
      pulloff_mm: 1.000
```

<a id="motors-types"></a>
# Motor Types

## Standard Stepper

<img src="https://github.com/bdring/FluidNC/wiki/images/external_driver.png" width="300">

  - **<a id="step_pin"></a>step_pin:**
    - Type: [Pin](/config/overview#pin) (output)
    - Range: gpio or i2so
    - Default: NO_PIN
    - Note: Some external drivers require an inverted step pulse. You can invert the pulse by changing the [active state attribute](/config/config_IO#input-pin-attributes) (**:high** or **:low**)
  - **<a id="direction_pin"></a>direction_pin:**
    - Type: [Pin](/config/overview#pin)
    - Range: gpio or i2so
    - Default: NO_PIN
    - Details: This is used to control the direction. You can invert the direction by changing the [active state attribute](/config/config_IO#input-pin-attributes) (**:high** or **:low**)
  - **<a id="disable_pin"></a>disable_pin:**
    - Type: [Pin](/config/overview#pin)
    - Range: gpio or i2so
    - Default: NO_PIN
    - Details: This is used if your controller uses individual disable pins for each driver. Most basic controllers use a common disable pin for all drivers and that is set elsewhere in the config file. You can invert the direction by changing the [active state attribute](/config/config_IO#input-pin-attributes) (**:high** or **:low**)

Use this one for external drivers or when only step direction and enable are needed.

example

```yaml
    motor0:
      standard_stepper:
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: gpio.16:low
```

See this page for [important information step pulse timing](https://github.com/bdring/Grbl_Esp32/wiki/External-Stepper-Drivers)

## Stepstick:

- **[step_pin](#step_pin)**:
- **[direction_pin](#direction_pin)**:
- **[disable_pin](#disable_pin)**:
  - <a id="ms1_pin"></a>**ms1_pin**:
  - Type: [Pin](/config/overview#pin)
  - Range: gpio or i2so
  - Default: NO_PIN
  - Details: This is used to set a voltage to the MS1 pin of the stepstick driver socket. You should specify the active state. This is the state that the pin will be set to. This is typically used to set the microstepping level. Most basic controllers do not route this pin to the controller and use a jumper instead. Example **ms3: i2so.3:high**
  - <a id="ms2_pin"></a>**ms2_pin**:
  - Type: Pin
  - Range: gpio or i2so
  - Default: NO_PIN
  - Details: see above
  - <a id="ms3_pin"></a>**ms3_pin**:
  - Type: Pin
  - Range: gpio or i2so
  - Default: NO_PIN
  - Details: See above.
- <a name="reset_pin"></a>**reset_pin**: A pin on many stepstick controllers. This pin is only used to set the state of the pin at turn on. It does not do any active features at this time. 

example

```yaml
axes:
  x:
    motor0:
      stepstick:
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: gpio.16:low
        ms1_pin: NO_PIN
        ms2_pin: NO_PIN
        ms3_pin: I2SO.6
        reset_pin: NO_PIN
```

### DRV8825 (Stepstick)

### A4988 (Stepstick)

### TB67S249FTG (Stepstick)

<img src="https://github.com/bdring/FluidNC/wiki/images/tb67s249ftg_wiring.png" width=500>

Available at [Pololu](https://www.pololu.com/product/3096). 3.3V-5V Compatible.

AGC is Automatic Gain Control (Like Trinamic Coolstep) This is typically the sleep pin on stepsticks. On the 6 Pack controller this can be controlled via the TMC5160 jumper. Use the TMC5160 side to enable it. 



<img src="https://github.com/bdring/FluidNC/wiki/images/tb67s249ftg_jumpers.png" width=500>

DMODE0 through DMODE2 are typically MS1 through MS3 on the stepstick. These pins are more commonly connected to jumpers rather than the controller. 

TB67S249FTG example config

```yaml
      stepstick:
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: I2SO.7:low
        ms1_pin: NO_PIN
        ms2_pin: NO_PIN
        ms3_pin: I2SO.6:high
        reset_pin: NO_PIN
```


<a id="Trinamic Drivers"></a>
## Trinamic Drivers

Trinamic drivers have many features that can be set by FluidNC. These drivers are typically completely powered by the motor voltage. VCC pins are only used for I/O voltage reference. Therefore, the motor voltage **must be on at all times** to use these. The ESP32 on the controller can often be powered by the USB connection, but the motors cannot. If the motor voltage is not present at turn and the ESP32 is powered by the USB, the drivers will not respond. If the drivers are failing the startup tests, try clicking the ESP32 reset button when the main power is on.

There is a command that allows you to run the motor driver initialization at any time. It is **\$Motors/Init** or **\$MI**. If you forget to turn on the main power, you can turn on the power and then send the **$MI** command. A message will be sent regarding the success or failure of that. You can send that command whenever you want to check the motor status (not in run mode)

Examples

```
[MSG:ERR: X Axis driver test failed. Check connection]
[MSG:ERR: Y Axis driver test failed. Check motor power]
[MSG:ERR: Z Axis driver test passed]
```

We are not experts on these drivers. We use a third-party open source library ([TMCStepper](https://github.com/teemuatlut/TMCStepper)) to control them. We do not know the best register settings for them. Many of them will be specific to your machine and motors. You will have to experiment. They are generally great drivers, but temperamental. Please don't expect the FluidNC developers to solve your issues with these motors.

Note: You can buy some Trinamic drivers on modules in "stand alone" or "stepstick" mode. These cannot be setup by FluidNC and you should configure them as [stepstick](/config/axes#stepstick) drivers.

> **Driver Not Detected:** The drivers are detected using the UART or SPI connection. If you get this message, it is most likely a communication problem. Check the configuration and wiring. 
{.is-info}


<a id="SPI Controlled"></a>
### SPI Controlled (TMC2130 and TMC5160)

SPI controlled drivers use [SPI](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface) (Serial Peripheral Interface) to directly control the features and modes of the driver. SPI has 2 modes, independent and daisy chain mode. This depends on how the SPI is wired on the controller.

<img src="https://github.com/bdring/FluidNC/wiki/images/SPI_normal.png" width="300"> daisy chain <img src="https://github.com/bdring/FluidNC/wiki/images/spi_daisy_chain.png" width="300">

For independent mode each driver needs its own **[cs_pin:](#cs_pin)**. They do not use a **[spi_index:](#spi_index)**, so each **[spi_index:](#spi_index)** should be set to -1.

In daisy chain mode they all use the same **[cs_pin:](#cs_pin)**, but each requires its own **[spi_index:](#spi_index)**. The **[spi_index:](#spi_index)** is a number from 1 to how many drivers you have. The **[spi_index:](#spi_index)** indicates the position of the driver on the SPI daisy chain. You must set the index based on the PCB design and axis letter order.

In a daisy chain arrangement, MOSI loops through all the motors, and then returns to the controller as MISO. To write to the second driver, you write to the first with the data for the second driver, then write dummy data to the first to push the first data to the second. Reading data has the same issue when you must push the data through the drivers at the end of the chain. There FluidNC needs to know about all drivers, even ones you are not using. You must define something for all drivers.

<a id="TMC2130"></a>
## TMC2130

Links
 - [Trinamic Datasheet](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC2130_datasheet.pdf)
 - [BigTreeTech V3.0 Github](https://github.com/bigtreetech/BIGTREETECH-TMC2130-V3.0)
   - [Schematic](https://github.com/bigtreetech/BIGTREETECH-TMC2130-V3.0/blob/master/Hardware/BIGTREETECH%20TMC2130%20V3.0%20SCH.pdf)

**Config Item**
- **[step_pin](#step_pin)**
- **[direction_pin](#direction_pin)**
- **[disable_pin](#disable_pin)**
- <a id="cs_pin"></a>**cs_pin:**
  - Type: [Pin](/config/overview#pin) (output)
  - Range: gpio or i2so
  - Default: NO_PIN
  - Details: Chip select pin. For independent mode each chip needs its own. For daisy chain mode, you should only define it on the motor with spi_index: 1
- <a id="spi_index"></a>**spi_index:**
  - Type:  [Pin](/config/overview#pin) (output)
  - Range: -1 to 127
  - Default: -1
  - Details: For independent mode all must be -1 (default). For daisy chain mode they must be unique (see above). Start with index 1 and increment by 1 for the next motor. They need to be defined in the order the chips are daisy chained together.
- <a id="r_sense_ohms"></a>**r_sense_ohms:**
  - Type: [Float](/config/overview#float)
  - Range:  0.01 to 1.00
  - Default: 0.11
  - Details: This is the value of the current sense resistor used with the driver. This is needed to set the current. The values on plugin TMC2130 modules is usually 0.110 Ohm.
- <a id="run_amps"></a>**run_amps:**
  - Type: [Float](/config/overview#float)
  - Range: 0.05 to 10.0
  - Default: 0.5
  - Details: This value sets the driver's output current when the driver is outputting steps.
- <a id="hold_amps"></a>**hold_amps:**
  - Type:  [Float](/config/overview#float)
  - Range: 0.05 to 10.0
  - Default: 0.5
  - Details: This value sets the driver's output current when the driver is not outputting steps.
- <a id="homing_amps"></a>**homing_amps:**
  - Type:  [Float](/config/overview#float)
  - Range: 0.05 to 10.0
  - Default: 0.5
  - Details: This value sets the driver's output current during a homing cycle.
- <a id="microsteps"></a>**microsteps:**
  - Type: [Integer](/config/overview#integer)
  - Range: 1 to 256 (should be 1,2,4,8,16,32,64,128 or 256 )
  - Default: 16
  - Details: This sets the microstepping level.
- <a id="stallguard"></a>**stallguard:**
  - Type: [Integer](/config/overview#integer)
  - Range: -64 to 63
  - Default: 0
  - Details: Stallguard threshold level. A higher value makes stallGuard2 less sensitive and requires more torque to
indicate a stall. See datasheet for more details.
- <a id="stallguard_debug"></a>**stallguard_debug:**
  - Type: Boolean
  - Default: false
  - Details: This turns on debugging information that can help you tune stallguard. It should not be left on during normal use.
- <a id="toff_disable"></a>**toff_disable:**
  - Type: [Integer](/config/overview#integer)
  - Range: 0 to 15
  - Default: 0
  - Details: TOFF off time and driver enable. A value of 0 disables the driver. See the TMC2130 datasheet regarding this.
- <a id="toff_stealthchop"></a>**toff_stealthchop:**
  - Type: [Integer](/config/overview#integer)
  - Range:  2 to 15
  - Default: 5
  - Details: TOFF in stealthchop mode. See the TMC2130 datasheet regarding this.
- <a id="toff_coolstep"></a>**toff_coolstep:**
  - Type: [Integer](/config/overview#integer)
  - Range:  2 to 15
  - Default: 3
  - Details: TOFF in Coolstep mode. See the TMC2130 datasheet regarding this.
- <a id="run_mode"></a>**run_mode:**
  - Type:  [Enumeration](/config/overview#enum)
  - Range: StealthChop, CoolStep or Stallguard
  - Default: StealthChop
  - Details: This is the mode it runs in. Valid values are Coolstep, Stallguard, & StealthChop
- <a id="homing_mode"></a>**homing_mode:**
  - Type: [Enumeration](/config/overview#enum)
  - Range: StealthChop, CoolStep or Stallguard
  - Default: StealthChop
  - Details: This is the mode it runs in. Valid values are Coolstep, Stallguard, & StealthChop
- <a id="use_enable"></a>**use_enable:**
  - Type: Boolean
  - Default: false
  - Details: This uses the soft enable feature of the chip. The enable is sent to the chip via the SPI.
- <a id="diag0_error"></a>**diag0_error:**
  - Type: Boolean
  - Default: false
  - Details: This cause driver error to change the state of the diag0 pin
- <a id="diag0_otpw"></a>**diag0_otpw:**
  - Type: Boolean
  - Default: false
  - Details: Enable DIAG0 active on driver over temperature prewarning (otpw)

- <a id="diag0_int_pushpull"></a>**diag0_int_pushpull:**
  - Type: Boolean
  - Default: false
  - Details: 
    - False: DIAG0 is open collector output (active low)
    - True: Enable DIAG0 push pull output (active high)
  
  

<img src="https://github.com/bdring/FluidNC/wiki/images/tmc2130_current.png" width="300">

standard example

```yaml
  tmc_2130:
    cs_pin: gpio.17
    spi_index: -1
    r_sense_ohms: 0.110
    run_amps: 0.750
    hold_amps: 0.250
    microsteps: 32
    stallguard: 0
    stallguard_debug: false
    toff_disable: 0
    toff_stealthchop: 5
    toff_coolstep: 3
    run_mode: StealthChop
    homing_mode: StealthChop
    use_enable: false
    step_pin: gpio.12
    direction_pin: gpio.26
    disable_pin: NO_PIN
```

Daisy chain example:
```yaml
  x:  
    steps_per_mm: 800.000
    max_rate_mm_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
      tmc_2130:
        cs_pin: gpio.17
        spi_index: 1
        r_sense_ohms: 0.110
        run_amps: 0.750
        hold_amps: 0.750
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: CoolStep
        homing_mode: CoolStep
        use_enable: true
        step_pin: gpio.12
        direction_pin: gpio.14
        disable_pin: NO_PIN

  y:
    steps_per_mm: 800.000
    max_rate_mm_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: gpio.39
      hard_limits: true
      pulloff_mm: 1.000
      tmc_2130:
        spi_index: 2
        r_sense_ohms: 0.110
        run_amps: 0.750
        hold_amps: 0.750
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: CoolStep
        homing_mode: CoolStep
        use_enable: true
        step_pin: gpio.27
        direction_pin: gpio.26
        disable_pin: NO_PIN

```

<a id="TMC2208"></a>
## TMC2208:

TMC2208 drivers can operate in standalone STEP/DIR mode . Values such as microstep, run current and hold current, amongst others, can also be  configured via UART.
A step_pin and a direction_pin must always be defined in the motor config. Enabling the motor can be done either using a disable_pin: or enabled via UART with  use_enable: true in the config file.

The TMC2208 drivers are not  addressable. This means that when daisy chaining these drivers, config values will be passed to  all drivers, and it is not possible to configure parameters for individual drivers. It is important to note that the values that will be applied will be those defined in the last motor / axis listed in the config file. Values that are not defined in this final motor / axis config will fall back to default, overriding any values set in previous motor/ axis configurations. 

 [Datasheet](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC2202_TMC2208_TMC2224_datasheet_rev1.13.pdf)
 
Config Items:
- **[step_pin](#step_pin)**
- **[direction_pin](#direction_pin)**
- **[disable_pin](#disable_pin)**
- **[r_sense_ohms:](#r_sense_ohms)**
- **[run_amps:](#run_amps)**
- **[hold_amps:](#hold_amps)**
- **[microsteps:](#microsteps)**

Daisy chain example: 
```
  axes:
  shared_stepper_disable_pin: gpio.1

  x:
    steps_per_mm: 400
    max_rate_mm_per_min: 1500
    acceleration_mm_per_sec2: 100
    homing:
      cycle: 2
      allow_single_axis: true
      positive_direction: false
      mpos_mm: 0
      feed_mm_per_min: 50
      seek_mm_per_min: 400
    motor0:
      limit_all_pin: gpio.2:low
      hard_limits: true
      pulloff_mm: 1
      tmc_2208:  
        step_pin: gpio.3
        direction_pin: gpio.4:low
        # THESE VALUES ARE OVERIDEN BY Y AS TMC2208 IS NOT ADDRESSABLE.
        # ALL VALUES ARE TAKEN FROM LAST DEFINED MOTOR/AXIS
        # run_amps: 1.5
        # hold_amps: 0.5
        # microsteps: 8
        # disable_pin: 10

  y:
    steps_per_mm: 400
    max_rate_mm_per_min: 1500
    acceleration_mm_per_sec2: 100
    homing:
      cycle: 2
      allow_single_axis: true
      positive_direction: true
      mpos_mm: 290
      feed_mm_per_min: 50
      seek_mm_per_min: 400
    motor0:
      limit_all_pin: gpio.5:low
      hard_limits: true
      pulloff_mm: 1
      tmc_2208:
        step_pin: gpio.6
        direction_pin: gpio.7
        # THESE ARE THE LAST DEFINED VALUES 
        # AND WILL BE THE VALUES APPLIED TO 
        # ALL DRIVERS IN THE DAISY CHAIN
        microsteps: 16
        r_sense_ohms: 0.110
        # IF NOT DEFINED - DEFAULT VALUES WILL BE USED
        # run_amps: 0.5
        # hold_amps: 0.5
        disable_pin: NO_PIN
        uart:
          txd_pin: gpio.8
          rxd_pin: gpio.9
          baud: 115200
          mode: 8N1
```

<a id="TMC5160"></a>
## TMC5160

[Datasheet](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf)

- **[step_pin](#step_pin)**
- **[direction_pin](#direction_pin)**
- **[disable_pin](#disable_pin)**
- **[r_sense_ohms:](#r_sense_ohms)** For TMC5160 it is typically 0.075 Ohm.
- **[run_amps:](#run_amps)**
- **[hold_amps:](#hold_amps)**
- **[microsteps:](#microsteps)**
- **[toff_disable:](#toff_disable)**
- **[toff_stealthchop:](#toff_stealthchop)**
- **[use_enable:](#use_enable)**
- **[cs_pin:](#cs_pin)**
- **[spi_index:](#spi_index)**
- **[run_mode:](#run_mode)**
- **[homing_mode:](#homing_mode)**
- **[stallguard:](#stallguard)**
- **[stallguard_debug:](#stallguard_debug)**
- **[toff_coolstep:](#toff_coolstep)**
- **tpfd:**
  - Type: Integer
  - Range: 0 to 15
  - Default: 4
  - Details: Passive fast decay time for mid band resonance. See datasheet
- **[diag0_error](#diag0_error)**
- **[diag0_otpw](#diag0_otpw)**
- **[diag0_int_pushpull](#diag0_int_pushpull)**


```yaml
tmc_5160:
      step_pin: gpio.12
      direction_pin: gpio.14
      disable_pin: NO_PIN
      cs_pin: gpio.17
      r_sense_ohms: 0.050
      run_amps: 1.800
      hold_amps: 1.250
      microsteps: 8
      toff_disable: 0
      toff_stealthchop: 5
      use_enable: false
      run_mode: CoolStep
      homing_mode: CoolStep
      stallguard: 16
      stallguard_debug: false
      toff_coolstep: 3
      tpfd: 4
```

> A lot of people have had trouble with these drivers. They are very advanced, and the settings have to be finely tuned to your machine. They also can draw a lot of power. Make sure you have a power supply with a lot of extra capacity. We cannot provide too much support because we are not experts on the chip. **Please respect our support time.** For extra fine tuning see the "pro" versions lower on this page.
{.is-warning}


**Potentiometers** Many TMC5160 modules have potentiometers on them. The TMCStepper library we use sets TMC5160 chips in an *i_scale_analog" mode. This means the pot is used to scale that current value that is set digitally. You should turn these pots up to full or where they output 2.5V. This will allow you to use the full current range of the drivers.

Here is a chart for the current. Most modules use a 0.075Ohm resistor, so for those the maximum current is 3.1A

<img src="https://github.com/bdring/FluidNC/wiki/images/tmc5160_current.png" width="300">

### UART Controlled

## TMC2209
[Datasheet](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC2209_Datasheet_V103.pdf)

> This section is for UART controlled chips. Each chip must have a hardware based addressing system. We do not support write only communication (1 way), because it is critical that we know the chips are responding to commands.
{.is-warning}

> It is very difficult to use TMC2209 plug in modules or controllers that do not directly support Trinamic UART controlled chips. **You must** externally wire the UART and **you must** figure out how to wire the UART externally.   
{.is-warning}


TMC2209 drivers need a step_pin and a direction_pin. They can either use an disable_pin: or enable via UART with a `use_enable: true` in the config file. 

You must define pins for the uart in a [uart section](/config/uart_sections) of the config file. Each motor must have a uart_num:. This could allow multiple uarts to be used to get past the 4 address per uart limit.

```yaml

    motor0:
      limit_neg_pin: gpio.36:low
      tmc_2209:
        uart_num: 1
        addr: 0
        cs_pin: NO_PIN
        r_sense_ohms: 0.110
        run_amps: 1.000
        hold_amps: 0.500
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: StealthChop
        homing_mode: StealthChop
        homing_amps: 0.50
        use_enable: false
        direction_pin: gpio.12
        step_pin: gpio.14
        disable_pin: NO_PIN
```

### TMC UART

The UART is typically connected like this, with a single connection to all drivers. The drivers need the address (`addr:` in config) set from 0 to 3 via the MSn_ADn pins via hardware connections.

![tmc2209_uart_addr.png](/motors/tmc2209_uart_addr.png)

### TMC UART with cs_pin

The cs_pin can be used to control a chip to switch the UART. This can allow you to get around the limit of 4 addresses for the chips. The address can be dynamic. You can also connect the cs_pin to an address pin.

![uart_cs_pin.png](/config/uart_cs_pin.png)

### Design Notes

The VCC on the stepstick modules is used as the I/O reference. It should be 3.3V when directly connected to ESP32s. The driver VCC is generated internally from VMOT, so these chips will not communicate unless the VMOT is connected.

<img src="https://github.com/bdring/FluidNC/wiki/images/tmc2209_current.png" width="450">

## tmc_5160Pro & tmc_2160Pro Motors (Expert Mode)
The tmc_5160Pro and tmc_2160Pro motors are for advanced users who want direct control over the most important and commonly used registers of the driver. We can add more registers if they are needed.

Currently the driver uses the same register values for both normal and homing modes.

You will need the datasheet to understand these registers

- [Datasheet](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf)
- [CHOPCONF](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=51)
- [PWMCONF](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=54)
- [COOLCONF](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=53)
- [GCONF](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=32)
- [IHOLD_IRUN](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=38)
- [THIGH](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=39)
- [TCOOLTHRS](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=39)

### Register Calculators

Most registers are a number built up from many smaller values. There is a [Google Sheet](https://docs.google.com/spreadsheets/d/1Ue5yI3-ZFgoVcz6nrzz_FpY7N90UyCm1wIMYn1uvC5k/edit?usp=sharing) that can help you create the register values from these values. Make your own copy of the sheet to get edit rights. You will still need to use the datasheet to determine what values to use.

> TMC5160 and TMC2160 work exactly the same. The only difference is the name in the config file. 
{.is-info}


[Google Sheet](https://docs.google.com/spreadsheets/d/1Ue5yI3-ZFgoVcz6nrzz_FpY7N90UyCm1wIMYn1uvC5k/edit?usp=sharing)

### Examples

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


> If you are struggling to use this type of config, this might not be for you. The registers are very complex and not for newbies. Even the developers of FluidNC do not fully understand how to use them. Please don't expect support on register values. Ask TMC directly.
{.is-warning}


### Tips

- Currents are set in IHOLD_IRUN
- Microstepping CHOPCONF


<a id="rc_servo"></a>
## RC Servo

<img src="https://github.com/bdring/FluidNC/wiki/images/servo-samples.jpg" width="300">

RC Servos have an internal control system that allows them to move to a specific location based on a PWM signal. There are analog and digital versions of these. They both use the same PWM input, but the digital ones use a more advanced control system. They use the width of the pulse to determine where to move. One end of the travel usually uses a 1ms pulse width and the other end uses a 2ms pulse width. There is no standard on the rotation range of motion and many can use a slightly wider pulse width range. If the PWM signal is removed the servo can often be turned by hand.

> A servo can also be configured as a spindle, if you want to control it with `M3`/`M5` instructions - see the [besc section of the spindles page](/en/config/config_spindles#besc).
{.is-info}

The PWM frequency for analog servos is typically 50Hz. If you increase that it changes the control loop and could overheat the servo. Digital servos can use a higher frequency, but typically never higher than 200 Hz. The PWM signal is only sent when the motors are enabled. Set **idle_ms** to 255 if you want the signal to always be on.

FluidNC creates a virtual stepper motor for the axis. You give it parameters for speed, acceleration, etc like normal motors. The servo range will be mapped to the max_travel of the axis. If your servo is not rotating the correct direction with respect to the virtual axis, you can swap the min_pulse_us/max_pulse_us key values. If your servo cannot keep up with the max rate in your config file and you have a short `idle_ms:`, the servo may turn off before it reaches the commanded location.

Like a normal axis, they operate in machine space. You can still place a work zero wherever you like. Soft limits can be used. Homing works a little differently. They do not use switches because they always know where they are. If you put them on a homing cycle, they will immediately move to the end of travel in the direction specified in the homing: section. To give them enough time to get there. A time of **max_travel: / speed:** will be given.

At startup A servo will immediately move to machine position 0.0 or the closest point in the range if the range does not include 0.0. This will only occur when the motors are enabled. If the motors are not enabled at startup (idle_ms: not 255), then the servos will move to the current machine position as soon as any other axis moves.

**Testing the RC Servo** In the startup messages you will see the range like **Axis Z (-5.000,0.000)**. Send **G53G0Z-5** and **G53G0Z0** to test that range.


**Config file keys**
 - <a name="output_pin"></a>**output_pin:** 
   - Type: [Pin](/config/overview#pin) (output)
   - Range: gpio
   - Details: This is the output pin for the PWM signal
 - <a name="pwm_hz"></a>**pwm_hz:**  
   - Type: [Integer](/config/overview#integer)
   - Range: 50 to 200
   - Details: This is the output pin for the PWM signalThis is the frequency for the PWM in Hz (default 50)
 - <a name="min_pulse_us"></a>**min_pulse_us:**  
   - Type: [Integer](/config/overview#integer)
   - Range: 500 to 2500
   - Details: This is the output pin for the PWM signalThis is the pulse length at the lower end of the axis travel in microseconds (default 1000). 
 - <a name="max_pulse_us"></a>**min_pulse_us:**  
   - Type: [Integer](/config/overview#integer)
   - Range: 500 to 2500
   - Details: This is the output pin for the PWM signal, This is the pulse length at the upper end of the axis travel in microseconds (default 2000). 
 - <a name="timer_ms"></a>**timer_ms:**  
   - Type: [Integer](/config/overview#integer)
   - Range: 20 to 250
   - Details: This how often the PWM value is recalculated and changed to match the position of the virtual Z axis. This will affect the smoothness of the motion. You should definitely set it higher than the PWM period (1/freq). Low values can affect overall performance, because the ESP32 is spending too much time with this. The default is 20.


example
```yaml
  z:
    steps_per_mm: 100.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 5.000
    soft_limits: true
    homing:
      cycle: 1
      positive_direction: true
      mpos_mm: 5.000
      
    motor0:
      rc_servo:
        pwm_hz: 50
        output_pin: gpio.27
        min_pulse_us: 1000
        max_pulse_us: 2000
```
example with rotation reversed
```yaml
    rc_servo:
      pwm_hz: 60
      output_pin: gpio.27
      min_pulse_us: 2000
      max_pulse_us: 1000
```

<a name="rc_servo_tuning"></a>
#### RC Servo Tuning:

All servos have their own speed and acceleration. If you use faster motion values for the virtual axis in the config file than the servo can handle, it will not be able to follow accurately. The virtual axis will reach position before the servo does and the next gcode will execute. The servo eventually catches up, but this lack of coordination is undesirable.

FluidNC will not be able to detect this. You must experiment with values until you get the performance you like. The steps_per_mm key is used for the virtual axis. Most servos will only have 200-1000 units of accuracy across the entire range of motion. Double that higher end number and divide by the max_travel for the axis. Example: For a max_travel or 10mm, set you steps_per_mm to (2 * 1000 / 10) = 200 steps_per_mm.



<a name="rc_servo_range"></a>
#### **RC Servo Range**

Unlike stepper motors, RC servos have a fixed rotational range. That range is mapped to the machine coordinates using the max_travel, mpos_mm and homing direction config items ([more details here](/config/axes#homing)). If you try to move outside the range the servo will stop at the end of travel, but the machine position will still increment. You can still jog the machine position outside the range, but the servo will not move until it is in the range. You can apply soft limits to the axis if you want to prevent this. **Soft limits are strongly recommended for RC servos for this reason.**

#### Pulse Lengths

Pulse lengths vary by manufacturer. The default is 1000-2000 microseconds, but many manufacturers use a larger range. If you are trying to get the FluidNC units to match specific locations in the servo travel you can tweak these values a little. Servo motors are not too accurate, so don't expect them to match stepper motors. Be sure to stay within the servo's range. Servo can be damaged by operating outside their range.

Here is a complete axis RC servo axis definition. In this case the travel is 5mm, the machine position after homing is 5mm, so the range is 0mm to 5mm. You can test the motion on this axis with the following gcode commands. I use G53 to make sure the motion is in machine coordinates, overriding any work offsets you may have created.

```
G53 G0 Z5
G53 G0 Z0
```

```yaml
z:
    steps_per_mm: 100
    max_rate_mm_per_min: 5000
    acceleration_mm_per_sec2: 100
    max_travel_mm: 5
    homing:
      cycle: 1
      mpos_mm: 0
      positive_direction: true

    motor0:
      rc_servo:
        pwm_hz: 50
        output_pin: gpio.27
        min_pulse_us: 1000
        max_pulse_us: 2000
```

<a name="solenoid"></a>
## Solenoid

<img src="https://github.com/bdring/FluidNC/wiki/images/solenoid.png" width="200">

This lets a Solenoid act like an axis. It will be active when the machine position of the axis is above 0.0. This can be inverted with the **direction_invert:** value. If inverted, it will be active at below 0.0.

When active the PWM will come on at the pull_percent value. After pull_ms time, it will change to the hold_percent value. This can be used to keep the coil cooler.

The feature runs on a 50ms update timer. The solenoid should react within 50ms of the position. The pull_ms also used that 50ms update resolution. The PWM can be inverted using the :low attribute on the output pin. This inverts the signal in case you need it. It is not used to invert the direction logic. 

The axis position still respects your speed and acceleration and other axis coordination. If you go from Z0 to Z5, it will activate as soon as it goes above 0. If you G0 from Z5 to Z0, it will not deactivate until it gets to Z0.

 - **[output_pin:](#output_pin)**
 - <a name="pwm_hz"></a>**pwm_hz:**  
   - Type: [Integer](/config/overview#integer)
   - Range: 1000 to 100000
   - Details: This is the frequency for the PWM in Hz (default 1000)
 - <a name="off_percent"></a>**off_percent:**
   - Type: [Float](/config/overview#Float)
   - Range: 0 to 100
   - Default: 0.0
   - Details: This is the PWM duty when the solenoid is not active.
 - <a name="pull_percent"></a>**pull_percent:**
   - Type: [Float](/config/overview#Float)
   - Range: 0 to 100
   - Default: 100.0
   - Details: This is the PWM duty during the initial pull.
- <a name="hold_percent"></a>**hold_percent:**
   - Type: [Float](/config/overview#Float)
   - Range: 0 to 100
   - Default: 75.0 
   - Details: This is the PWM duty during the hold phase.
 - <a name="pull_ms"></a>**pull_ms:**
   - Type: [Integer](/config/overview#Integer)
   - Range: 0 to 3000
   - Default: 75.0
   - Details: Is the duration of the initial pull phase.

Example YAML

```yaml
  z:
    steps_per_mm: 100.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 5.000
    soft_limits: false
    homing:
      cycle: 1
      positive_direction: true
      mpos_mm: 5.000
        
    motor0:
      solenoid:
        output_pin: gpio.26
        pwm_hz: 5000
        off_percent: 0.000
        pull_percent: 100.000
        hold_percent: 20.000
        pull_ms: 1000
        direction_invert: false

```

<a name="dynamixel_servo"></a>
## Dynamixel Servo (Protocol 2)

<img src="https://github.com/bdring/FluidNC/wiki/images/XL430-W250.jpg" width="200">

This allows Dynamixel Servo motors to be used as axis motors. This document was written assuming XL430-250T servos were used, but other servo types that use [Robotis Protocol 2](https://emanual.robotis.com/docs/en/dxl/protocol2/) can probably be used (not tested). The servo's count range is mapped to the axis machine position (mpos) range. If your X axis servo has a count range from 0-4095, that would be mapped across the mpos range. If the range is 0-300 and you send G0X150 it will be told to go to count 2047.

**Servo set up** The servos must be set up with Dynamixel software first. The easiest way is to use the [Dynamixel Wizard](http://emanual.robotis.com/docs/en/software/dynamixel/dynamixel_wizard2/) software. Here are the registers you probably want to set.

| Address       | Name              | Value       | Description     |
| ------------- | ----------------- | ----------- | --------------- |
| 7             | ID                | 1-253       | Must be unique  |
| 8             | Baud Rate         | 3 (1000000) |                 |
| 9             | Return Time Delay | 100         | Faster          |
| 24            | Moving Threshold  | 1           | Most Accurate   |
| 48 (optional) | Max Position      | 0-4095      | Limits rotation |
| 52 (optional) | Min Position      | 0-4095      | Limits rotation |

> If you stall a Dynamixel motor it will likely go into a faulted mode. The only way to recover is to power cycle them. 
{.is-warning}


config values

- <a name="count_id"></a>**id:** 
  - Type:  [Integer](/config/overview#integer)
  - Range: 
  - Details: Each must have a unique id
- **uart_num:**
  - Details: You must define pins for the uart in a [uart section](/config/uart_sections) of the config file. This should match the programmed baud of the servos. 1000000 is recommended. mode should be N81.
- <a name="count_min"></a>**count_min:** 
  - Type: [Integer](/config/overview#integer)
  - Range: 
  - Details: This is the location on the servo for the lower end of the mpos range
- <a name="count_max"></a>**count_max:** 
  - Type: [Integer](/config/overview#integer)
  - Range: 
  - Details:  This is the location on the servo for the upper end of the mpos range.

**Direction reversal:** Swap the count_min: and count_max: values.

**Homing:** The servo will immediately go to the homing/mpos_mm location of the axis. 

**Enable:** The servos will disable whenever the motors disable (see the idle_ms config value). When they are disabled, you can move them by hand and the mpos will track the movement.

Example config section 

```yaml
  x:
    steps_per_mm: 100.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 50.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      dynamixel2:
        id: 1
        uart_num: 1
        count_min: 1024
        count_max: 3072
```

 
<a name="unipolar_motors"></a>
## Unipolar Motors

