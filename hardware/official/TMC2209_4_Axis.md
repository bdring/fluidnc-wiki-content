---
title: TMC2209 4 Axis Controller
description: 
published: true
date: 2025-06-15T15:56:13.940Z
tags: 
editor: markdown
dateCreated: 2022-08-05T17:13:09.616Z
---

# Overview
![20220626_163336_clipped_rev_1.png](/hardware/20220626_163336_clipped_rev_1.png =x600)

- (4) TMC2209 Stepper Drivers in UART Mode
- Can use stallguard for sensorless end stops
- (6) inputs
- (2) CNC I/O Module Sockets
- SD Card socket.
- 9-30V operating voltage.

## Motor Power

The motor power must be on before the USB is attached in order for the motor drivers to accept the configuration.

If you accidentally plug in the USB first, just click the reset button on the ESP32 module or send the `$Motors/Init` or `$MI` command.

## Motor Wiring

Connect the motor coils to adjacent terminals.



## Axis labels

The drivers and limit switch inputs are label XYZ and A. This is just for reference. You can use the motors for any axis arrangement like XYYZ, etc. The switch inputs can also be used for any axis or switch input.

## Inputs

All inputs need :pu. There are no external pulling resistors.

## Using StallGuard

There are (4) jumpers under the ESP32 labeled XYZA. When a jumper is installed, they connect the driver chip StallGuard signal to GPIO inputs on the ESP32.

 - X gpio.36
 - Y gpio.39
 - Z gpio.34
 - A gpio.35
 
>  If you install a jumper, you cannot use the corrosponding input on the terminal block.
{.is-warning} 



# Source Files

 - [In EasyEDA format on OSHW Labs](https://oshwlab.com/bdring/tmc2130-2-axis_copy_copy)

# Config Information

![4x_2209_backside.png](/hardware/4x_2209_backside.png =x600)


> The labels near the terminal blocks show the I/O used to control the built in drivers. They are not labeling the terminal block pins. Those are to be connected directly to stepper motor coils.
{.is-info}

Example Config 

```yaml
name: "TMC2209 XYZA  Huany"
board: "FluidNC 4X 2209"


stepping:
  engine: I2S_STREAM
  idle_ms: 250
  dir_delay_us: 1
  pulse_us: 4
  disable_delay_us: 0

axes:
  shared_stepper_disable_pin: NO_PIN
  
  x:
    steps_per_mm: 400.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 150.000
    max_travel_mm: 750
    homing:
      cycle: 1
      mpos_mm: 0
      positive_direction: false
      seek_mm_per_min: 3000
      feed_mm_per_min: 240
    
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      tmc_2209:
        uart:
          txd_pin: gpio.16
          rxd_pin: gpio.4
          rts_pin: NO_PIN
          cts_pin: NO_PIN
          baud: 115200
          mode: 8N1

        addr: 0
        r_sense_ohms: 0.110
        run_amps: 1.000
        hold_amps: 0.500
        microsteps: 32
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: CoolStep
        homing_mode: CoolStep
        use_enable: false
        direction_pin: i2so.1
        step_pin: i2so.2
        disable_pin: i2so.0

  y:
    steps_per_mm: 53.33
    max_rate_mm_per_min: 18000
    acceleration_mm_per_sec2: 950
    max_travel_mm: 410
    homing:
      cycle: 1
      mpos_mm: 0
      positive_direction: false
      seek_mm_per_min: 3000
      feed_mm_per_min: 240

    motor0:
      limit_neg_pin: gpio.39:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      tmc_2209:
        addr: 1
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
        use_enable: false
        direction_pin: i2so.4
        step_pin: i2so.5
        disable_pin: i2so.7

  z:
    steps_per_mm: 400
    max_rate_mm_per_min: 200
    acceleration_mm_per_sec2: 25
    max_travel_mm: 200
    homing:
      cycle: 2
      mpos_mm: 0
      positive_direction: false
      seek_mm_per_min: 200
      feed_mm_per_min: 100
    
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: gpio.34:low
      limit_all_pin: NO_PIN
      tmc_2209:
        addr: 2
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
        use_enable: false
        direction_pin: i2so.9
        step_pin: i2so.10
        disable_pin: i2so.8
        
  a:
    steps_per_mm: 400
    max_rate_mm_per_min: 200
    acceleration_mm_per_sec2: 25
    max_travel_mm: 200
    homing:
      cycle: 2
      mpos_mm: 0
      positive_direction: false
      seek_mm_per_min: 200
      feed_mm_per_min: 100
    
    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: gpio.35:low
      limit_all_pin: NO_PIN
      tmc_2209:
        addr: 3
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
        use_enable: false
        direction_pin: i2so.12
        step_pin: i2so.13
        disable_pin: i2so.15

spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18
  
i2so:
  bck_pin: gpio.22
  data_pin: gpio.21
  ws_pin: gpio.17

sdcard:
  cs_pin: gpio.5
  card_detect_pin: NO_PIN
  
10V:
  forward_pin: gpio.25
  reverse_pin: gpio.26
  pwm_hz: 5000
  output_pin: gpio.27
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



RS485 Example (just a portion of the config)

```yaml
# Socket 1
Huanyang:
  uart:
    txd_pin: gpio.25
    rxd_pin: gpio.27
    rts_pin: gpio.26
    baud: 9600
    mode: 8N1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 0=25% 6000=25% 24000=100%
```

