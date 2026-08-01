---
title: TMC2209 Pen Laser V2
description: A 2 Axis controller with integrated TMC2209 drivers and ESP32 microcontroller 
published: true
date: 2025-11-19T19:27:40.672Z
tags: 
editor: markdown
dateCreated: 2024-03-20T16:26:02.659Z
---

![tmc2209_penlaser_2p1_top.jpg](/hardware/tmc2209_penlaser_2p1_top.jpg =x450)

# Overview
This is a CNC controller targeting machines that use stepper motors on 2 axes. These include pen drawing machines, laser cutter/engravers, sand plotter, etc.

# Where to Buy

- [Tindie](https://www.tindie.com/products/33366583/tmc2209-penlaser-cnc-controller/)
- [Elecrow](https://www.elecrow.com/tmc2209-pen-laser-fluidnc-cnc-controller.html)

# Features

- Built in ESP32 Module (4 Meg, PCB Antenna)
- USB-C Connector
- (2) TMC2209 stepper drivers.
- Optional stallguard for sensorless end stops
- (6) inputs (limit and control switches)
- (3) 5V outputs to control lasers, and accessories.
- (1) RC servo connection
- I/O Expansion port for displays and pendants.
- SD Card socket.

# Asking For Help

Before asking for help, please search all areas of this wiki. Your questions have probably been asked before and long detailed answers with photos, drawings and schematics are on this wiki.

See this [help page](http://wiki.fluidnc.com/en/support/requesting_help) if you still have problems.

Please ask all other questions via our [discord server](http://wiki.fluidnc.com/en/support/discord).

# Built in ESP32

This uses a USB-C connector. The main power must be supplied via the terminal block to power the USB chip. You will not get a USB connection to your computer if the main power is not on.

# Power Supply

The controller must be powered via a 12-30VDC power supply. It should be able to supply a minimum of 3A.  If you are attaching external devices to any of the VMot connections, you should add those currents. 

> Be very careful getting the voltage polarity correct. There is no reverse polariy protection, so you will destroy the controller and probably some connected items. 
{.is-warning}


# Programming

The controller is programmed with the current FluidNC revision at the time it was produced. It also has a very basic config file that is used for testing. There is a testing gcode file that blinks the LEDs and moves the motors. You should check for updates before using the controller. The version is shown in the startup messages. Send `$ss` to see them after again startup. The current FluidNC release is always [listed here](https://installer.fluidnc.com/).

Apply power to the controller via the power terminal block. Check that the 3.3v LED at the upper left of the PCB is lit. Connect a high quality USB C cable to the controller. Connect the other end to a PC (Windows, Mac or Linux).

Use the Chrome browser to connect to the [FluidNC Web Installer](https://installer.fluidnc.com/) page. Click the connect button. Select the COM port associated with controller. The USB device is a Silicon Labs CP2102. If you see several COM ports available, look for one with a description similar to that. Select it, so the web page connects to it.

Install the version with the highest number. Do not use any test releases unless instructed to do so to help with a support issue.

See the [general installation page](/installation) for more information and alternative methods.

# Motors

The motor drivers are [TMC2209](/config/trinamic_drivers#tmc2209). They are configured through the config file. The maximum current setting is about 2.0Amps. If the drivers get hot you must add a heatsink. If they get too hot they will shutdown.

# RC Servo

There is a standard [RC servo](/config/rc_servo) connector that can be used for pen lift mechanism or other uses. See the example config below and the [wiki](/config/rc_servo).

> If you don't use an RC Servo, you can use the signal pin as a 5V output signal.
{.is-info}

# Inputs

The inputs work by completing a circuit to ground. You can use electronic types if they close to ground (NPN). 

Inputs gpio.32,gpio.33, gpio.34 and gpio.35 are used with the 8 pin terminal block. 

Inputs gpio.36 and gpio.39 ship setup for use with stallguard. They have resistors soldered on SJ1 and SJ2. If you want to use the terminal blocks, unsolder the resistors on SJ1 and SJ2.

# Using StallGuard as an endstop

You must not connect anything to the terminal blocks for the X and Y inputs. Configure and tune the settings per this [wiki page](http://wiki.fluidnc.com/en/support/stallguard_tuning).

# Outputs

The outputs are all 5V. You can use them for digital (on/off) functions as well as PWM.

# Expansion Port Connector

This is typically used to connect a display or pendant via a UART connection. 

It uses the standard pinout for CNC I/O module, but there are only 2 I/O pins instead on the normal 4. Many modules will work fine though, like the relay, display isolator or isolated RS485. Other multiple channel module like the MOSFET, 5V output or input modules will work on the first 2 channels.  You may need to clip some unused pins to avoid touching components on the controller.  Use a 11mm M3 spacer to secure it to the controller.

The 2 I/O pins are directly connected to the ESP32, so they can be used for just about any I/O function.

**Example installed module**

![20240611_120011.jpg](/hardware/20240611_120011.jpg =x320)


# Default Config File

```yaml
name: "TMC2209 XY Servo Laser"
board: "FluidNC Pen/Laser 2209 V2"

stepping:
  engine: RMT
  idle_ms: 255
  dir_delay_us: 1
  pulse_us: 2
  disable_delay_us: 0
  
start:
  must_home: true
  deactivate_parking: false
  check_limits: true

#Stepper Driver UART
uart1:
  txd_pin: gpio.17
  rxd_pin: gpio.16
  rts_pin: NO_PIN
  cts_pin: NO_PIN
  baud: 115200
  mode: 8N1

# Pendant UART
uart2:
  txd_pin: gpio.4
  rxd_pin: gpio.15
  rts_pin: NO_PIN
  cts_pin: NO_PIN
  baud: 5000000
  mode: 8N1
# Pendant  
uart_channel2:
  uart_num: 2
  report_interval_ms: 75

axes:
  shared_stepper_disable_pin: gpio.13:high
  
  x:
    steps_per_mm: 100
    max_rate_mm_per_min: 2000
    acceleration_mm_per_sec2: 25
    max_travel_mm: 1000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 0
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100
    
    motor0:
      limit_neg_pin: gpio.36:low
      tmc_2209:
        uart_num: 1
        addr: 0
        r_sense_ohms: 0.110
        run_amps: 1.000
        hold_amps: 0.500
        homing_amps: 1.000
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: StealthChop
        homing_mode: StealthChop
        homing_amps: 0.80
        use_enable: false
        direction_pin: gpio.12
        step_pin: gpio.14
    
    
    motor1:
      null_motor:

  y:
    steps_per_mm: 100
    max_rate_mm_per_min: 2000
    acceleration_mm_per_sec2: 25
    max_travel_mm: 1000
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
      limit_neg_pin: gpio.39:low
      tmc_2209:
        uart_num: 1
        addr: 1
        r_sense_ohms: 0.110
        run_amps: 0.800
        hold_amps: 0.500
        homing_amps: 1.000
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: StealthChop
        homing_mode: StealthChop
        homing_amps: 0.80
        use_enable: false
        direction_pin: gpio.26
        step_pin: gpio.25
    motor1:
      null_motor:

  z:
    steps_per_mm: 100
    max_rate_mm_per_min: 1000
    acceleration_mm_per_sec2: 50
    max_travel_mm: 5.00
    soft_limits: false
    homing:
      cycle: 1
      positive_direction: true
      mpos_mm: 5
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100
    
    motor0:
      rc_servo:
        pwm_hz: 50
        output_pin: gpio.21
        min_pulse_us: 1000
        max_pulse_us: 2100
        
spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18

sdcard:
  cs_pin: gpio.5
  card_detect_pin: NO_PIN

coolant:
  flood_pin: NO_PIN
  mist_pin:  gpio.22

probe:
  pin: gpio.32:low
  
control:
  feed_hold_pin: gpio.35:low
  cycle_start_pin: gpio.34:low
  safety_door_pin: gpio.33:low

  
Laser:
  pwm_hz: 5000
  output_pin: gpio.27
  enable_pin: gpio.2
  disable_with_s0: false
  s0_with_disable: true
  tool_num: 0
  speed_map: 0=0.000% 255=100.000%


```

# Pinout

![2x_2209_v2_pinout.png](/hardware/2x_2209_v2_pinout.png)


# Source Files

- [via EasyEDA](https://oshwlab.com/bdring/tmc2130-2-axis_copy_copy_copy_copy) Please consider donating to the FluidNC if you clone the project or build your own from the source files.
- [3D File (via Fusion 360)](https://a360.co/3KcGArv) 