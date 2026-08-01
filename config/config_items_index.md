---
title: Config Items Index
description: Every FluidNC config item, grouped by config file section, linking to its full documentation
published: true
date: 2026-08-01T23:00:00.000Z
tags: en
editor: markdown
dateCreated: 2026-08-01T23:00:00.000Z
---

# Config Items Index

Every FluidNC config item, grouped by config-file section -- the same grouping you'd see in `config_items.yaml` or in your own `config.yaml`, e.g. everything under `PWM:` or `axes/<letter>/motorN/tmc_2130:`. Each entry links to where that item is fully documented (Type, Range, Default, description). This page only lists names and links -- it's a directory, not a duplicate of the real docs, so it won't drift out of sync the way a second copy of the facts would.

Some sections inherit most or all of their items from another type (e.g. TMC2208 shares nearly everything with TMC2130; PWM shares everything with 0-10V). Where that happens, the section notes what it shares before listing anything it adds of its own -- so a short item list under a section doesn't mean that's the whole story.

The section paths shown (e.g. `axes/<letter>/motorN/tmc_2130:`) use the same `/`-separated hierarchy FluidNC itself uses for runtime `$` commands (e.g. `$/axes/x/steps_per_mm`, described in the [Live Changes](/config/overview#live_changes) section). They correspond directly (just with `/` instead of `.`) to the keys in [`FluidNC/docs/config_items.yaml`](https://github.com/bdring/FluidNC/blob/main/FluidNC/docs/config_items.yaml), the generated reference built directly from the FluidNC source annotations -- the ground truth this whole wiki should match. Use it if you want to double check a fact directly against source rather than against this wiki.

### `(top-level machine items):`

- [`board`](/config/top_level_config_items#board)
- [`name`](/config/top_level_config_items#name)
- [`meta`](/config/top_level_config_items#meta)
- [`arc_tolerance_mm`](/config/top_level_config_items#arc_tolerance_mm)
- [`junction_deviation_mm`](/config/top_level_config_items#junction_deviation_mm)
- [`verbose_errors`](/config/top_level_config_items#verbose_errors)
- [`report_inches`](/config/top_level_config_items#report_inches)
- [`enable_parking_override_control`](/config/top_level_config_items#enable_parking_override_control)
- [`use_line_numbers`](/config/top_level_config_items#use_line_numbers)
- [`planner_blocks`](/config/top_level_config_items#planner_blocks)

### `start:`

- [`must_home`](/config/start_group#must_home)
- [`deactivate_parking`](/config/start_group#deactivate_parking)
- [`check_limits`](/config/start_group#check_limits)

### `stepping:`

- [`engine`](/config/axes#engine)
- [`idle_ms`](/config/axes#idle_ms)
- [`pulse_us`](/config/axes#pulse_us)
- [`dir_delay_us`](/config/axes#dir_delay_us)
- [`disable_delay_us`](/config/axes#disable_delay_us)
- [`segments`](/config/axes#segments)

### `axes:`

- [`shared_stepper_disable_pin`](/config/axes#shared_stepper_disable_pin)
- [`shared_stepper_reset_pin`](/config/axes#shared_stepper_reset_pin)
- [`homing_runs`](/config/axes#homing_runs)

### `axes/<letter>:`

- [`steps_per_mm`](/config/axes#steps_per_mm)
- [`max_rate_mm_per_min`](/config/axes#max_rate_mm_per_min)
- [`acceleration_mm_per_sec2`](/config/axes#acceleration_mm_per_sec2)
- [`max_travel_mm`](/config/axes#max_travel_mm)
- [`soft_limits`](/config/axes#soft_limits)
- [`idle_disable`](/config/axes#idle_disable)

### `axes/<letter>/homing:`

- [`cycle`](/config/axes#cycle)
- [`allow_single_axis`](/config/axes#allow_single_axis)
- [`positive_direction`](/config/axes#positive_direction)
- [`mpos_mm`](/config/axes#mpos_mm)
- [`seek_mm_per_min`](/config/axes#seek_mm_per_min)
- [`feed_mm_per_min`](/config/axes#feed_mm_per_min)
- [`settle_ms`](/config/axes#settle_ms)
- [`seek_scaler`](/config/axes#seek_scaler)
- [`feed_scaler`](/config/axes#feed_scaler)

### `axes/<letter>/motorN:`

- [`limit_neg_pin`](/config/axes#limit_neg_pin)
- [`limit_pos_pin`](/config/axes#limit_pos_pin)
- [`limit_all_pin`](/config/axes#limit_all_pin)
- [`hard_limits`](/config/axes#hard_limits)
- [`pulloff_mm`](/config/axes#pulloff_mm)

### `axes/<letter>/motorN/standard_stepper:`

- [`step_pin`](/config/axes#step_pin)
- [`direction_pin`](/config/axes#direction_pin)
- [`disable_pin`](/config/axes#disable_pin)

### `axes/<letter>/motorN/stepstick:`

Shares [Standard Stepper](/config/axes#standard-stepper) items, plus:

- [`ms1_pin`](/config/axes#ms1_pin)
- [`ms2_pin`](/config/axes#ms2_pin)
- [`ms3_pin`](/config/axes#ms3_pin)
- [`reset_pin`](/config/axes#reset_pin)

### `axes/<letter>/motorN/tmc_2130:`

Shares [Standard Stepper](/config/axes#standard-stepper) items, plus:

- [`cs_pin`](/config/trinamic_drivers#cs_pin)
- [`spi_index`](/config/trinamic_drivers#spi_index)
- [`r_sense_ohms`](/config/trinamic_drivers#r_sense_ohms)
- [`run_amps`](/config/trinamic_drivers#run_amps)
- [`hold_amps`](/config/trinamic_drivers#hold_amps)
- [`microsteps`](/config/trinamic_drivers#microsteps)
- [`stallguard`](/config/trinamic_drivers#stallguard)
- [`stallguard_debug`](/config/trinamic_drivers#stallguard_debug)
- [`toff_disable`](/config/trinamic_drivers#toff_disable)
- [`toff_stealthchop`](/config/trinamic_drivers#toff_stealthchop)
- [`toff_coolstep`](/config/trinamic_drivers#toff_coolstep)
- [`run_mode`](/config/trinamic_drivers#run_mode)
- [`homing_mode`](/config/trinamic_drivers#homing_mode)
- [`use_enable`](/config/trinamic_drivers#use_enable)
- [`diag0_error`](/config/trinamic_drivers#diag0_error)
- [`diag0_otpw`](/config/trinamic_drivers#diag0_otpw)
- [`diag0_int_pushpull`](/config/trinamic_drivers#diag0_int_pushpull)

### `axes/<letter>/motorN/tmc_2208:`

Shares [TMC2130](/config/trinamic_drivers#tmc2130) items, plus:

- [`addr`](/config/trinamic_drivers#addr)
- [`cs_pin`](/config/trinamic_drivers#tmc2208)
- [`uart_num`](/config/trinamic_drivers#uart_num)

### `axes/<letter>/motorN/tmc_5160:`

Shares [TMC2130](/config/trinamic_drivers#tmc2130) items, plus:

- [`tpfd`](/config/trinamic_drivers#tpfd)

### `axes/<letter>/motorN/tmc_2209:`

Shares [TMC2208](/config/trinamic_drivers#tmc2208) items, plus:

- [`stallguard`](/config/trinamic_drivers#tmc2209)
- [`homing_amps`](/config/trinamic_drivers#homing_amps)
- [`shared_address_write_only`](/config/trinamic_drivers#shared_address_write_only)

### `axes/<letter>/motorN/tmc_5160Pro:`

Shares [Standard Stepper](/config/axes#standard-stepper) items, plus:

- [`cs_pin`](/config/trinamic_drivers)
- [`spi_index`](/config/trinamic_drivers)
- [`use_enable`](/config/trinamic_drivers)
- [`CHOPCONF`](/config/trinamic_drivers#chopconf)
- [`COOLCONF`](/config/trinamic_drivers#coolconf)
- [`THIGH`](/config/trinamic_drivers#thigh)
- [`TCOOLTHRS`](/config/trinamic_drivers#tcoolthrs)
- [`GCONF`](/config/trinamic_drivers#gconf)
- [`PWMCONF`](/config/trinamic_drivers#pwmconf)
- [`IHOLD_IRUN`](/config/trinamic_drivers#ihold_irun)

### `axes/<letter>/motorN/rc_servo:`

- [`output_pin`](/config/rc_servo#output_pin)
- [`pwm_hz`](/config/rc_servo#pwm_hz)
- [`min_pulse_us`](/config/rc_servo#min_pulse_us)
- [`max_pulse_us`](/config/rc_servo#max_pulse_us)
- [`timer_ms`](/config/rc_servo#timer_ms)

### `axes/<letter>/motorN/solenoid:`

- [`pwm_hz`](/config/solenoid#pwm_hz)
- [`off_percent`](/config/solenoid#off_percent)
- [`pull_percent`](/config/solenoid#pull_percent)
- [`hold_percent`](/config/solenoid#hold_percent)
- [`pull_ms`](/config/solenoid#pull_ms)
- [`direction_invert`](/config/solenoid#direction_invert)
- [`timer_ms`](/config/solenoid#timer_ms)

### `axes/<letter>/motorN/dynamixel2:`

- [`uart_num`](/config/dynamixel2#uart_num)
- [`id`](/config/dynamixel2#id)
- [`count_min`](/config/dynamixel2#count_min)
- [`count_max`](/config/dynamixel2#count_max)
- [`timer_ms`](/config/dynamixel2#timer_ms)

### `i2so:`

- [`bck_pin`](/config/config_IO#bck_pin)
- [`data_pin`](/config/config_IO#data_pin)
- [`ws_pin`](/config/config_IO#ws_pin)
- [`min_pulse_us`](/config/config_IO#min_pulse_us)
- [`oe_pin`](/config/config_IO#oe_pin)

### `spi:`

- [`miso_pin`](/config/sd_card#miso_pin)
- [`mosi_pin`](/config/sd_card#mosi_pin)
- [`sck_pin`](/config/sd_card#sck_pin)

### `sdcard:`

- [`cs_pin`](/config/sd_card#cs_pin)
- [`card_detect_pin`](/config/sd_card#card_detect_pin)
- [`frequency_hz`](/config/sd_card#frequency_hz)

### `control:`

- [`safety_door_pin`](/config/control#safety_door_pin)
- [`reset_pin`](/config/control#reset_pin)
- [`feed_hold_pin`](/config/control#feed_hold_pin)
- [`cycle_start_pin`](/config/control#cycle_start_pin)
- [`macro0_pin`](/config/control#macro0_pin)
- [`macro1_pin`](/config/control#macro1_pin)
- [`macro2_pin`](/config/control#macro2_pin)
- [`macro3_pin`](/config/control#macro3_pin)
- [`fault_pin`](/config/control#fault_pin)
- [`estop_pin`](/config/control#estop_pin)
- [`homing_button_pin`](/config/control#homing_button_pin)

### `coolant:`

- [`mist_pin`](/config/coolant#mist_pin)
- [`flood_pin`](/config/coolant#flood_pin)
- [`delay_ms`](/config/coolant#delay_ms)

### `probe:`

- [`pin`](/config/probe#pin)
- [`toolsetter_pin`](/config/probe#toolsetter_pin)
- [`check_mode_start`](/config/probe#check_mode_start)
- [`hard_stop`](/config/probe#hard_stop)
- [`probe_hard_limit`](/config/probe#probe_hard_limit)

### `macros:`

- [`startup_line0`](/config/macros#startup_line0)
- [`startup_line1`](/config/macros#startup_line1)
- [`macro0`](/config/macros#macro0)
- [`macro1`](/config/macros#macro1)
- [`macro2`](/config/macros#macro2)
- [`macro3`](/config/macros#macro3)
- [`after_homing`](/config/macros#after_homing)
- [`after_reset`](/config/macros#after_reset)
- [`after_unlock`](/config/macros#after_unlock)

### `user_inputs:`

- [`digital0_pin`](/config/user_inputs#digital0_pin)
- [`analog0_pin`](/config/user_inputs#analog0_pin)

### `user_outputs:`

- [`analog0_pin`](/config/user_outputs#analog0_pin)
- [`analog0_hz`](/config/user_outputs#analog0_hz)
- [`digital0_pin`](/config/user_outputs#digital0_pin)

### `uartN:`

- [`txd_pin`](/config/uart_sections#txd_pin)
- [`rxd_pin`](/config/uart_sections#rxd_pin)
- [`rts_pin`](/config/uart_sections#rts_pin)
- [`cts_pin`](/config/uart_sections#cts_pin)
- [`baud`](/config/uart_sections#baud)
- [`mode`](/config/uart_sections#mode)
- [`passthrough_baud`](/config/uart_sections#passthrough_baud)
- [`passthrough_mode`](/config/uart_sections#passthrough_mode)

### `uart_channelN:`

- [`uart_num`](/config/uart_sections#uart_num)
- [`report_interval_ms`](/config/uart_sections#report_interval_ms)
- [`message_level`](/config/uart_sections#message_level)

### `status_outputs:`

- [`report_interval_ms`](/config/status_outputs#report_interval_ms)
- [`idle_pin`](/config/status_outputs#idle_pin)
- [`run_pin`](/config/status_outputs#run_pin)
- [`hold_pin`](/config/status_outputs#hold_pin)
- [`alarm_pin`](/config/status_outputs#alarm_pin)
- [`door_pin`](/config/status_outputs#door_pin)

### `10V:`

- [`forward_pin`](/config/config_spindles#forward_pin)
- [`reverse_pin`](/config/config_spindles#reverse_pin)
- [`pwm_hz`](/config/config_spindles#pwm_hz)
- [`output_pin`](/config/config_spindles#output_pin)
- [`enable_pin`](/config/config_spindles#enable_pin)
- [`direction_pin`](/config/config_spindles#direction_pin)
- [`disable_with_s0`](/config/config_spindles#disable_with_s0)
- [`s0_with_disable`](/config/config_spindles#s0_with_disable)
- [`spinup_ms`](/config/config_spindles#spinup_ms)
- [`spindown_ms`](/config/config_spindles#spindown_ms)
- [`tool_num`](/config/config_spindles#tool_num)
- [`atc`](/config/config_spindles#atc)
- [`m6_macro`](/config/config_spindles#m6_macro)
- [`speed_map`](/config/config_spindles#speed_map)
- [`off_on_alarm`](/config/config_spindles#off_on_alarm)

### `BESC:`

Shares [0-10V/PWM](/config/config_spindles#0-10v) items, plus:

- [`min_pulse_us`](/config/config_spindles#min_pulse_us)
- [`max_pulse_us`](/config/config_spindles#max_pulse_us)

### `HBridge:`

Shares most [0-10V/PWM](/config/config_spindles#0-10v) items (no direction_pin), plus:

- [`output_cw_pin`](/config/config_spindles#output_cw_pin)
- [`output_ccw_pin`](/config/config_spindles#output_ccw_pin)

### `Laser:`

Shares most [0-10V/PWM](/config/config_spindles#0-10v) items (no direction_pin, spinup_ms, or spindown_ms), plus:

- [`pwm_hz`](/config/config_spindles#laser)

### `PlasmaSpindle:`

Shares the administrative items (tool_num, atc, m6_macro, speed_map, off_on_alarm, s0_with_disable, disable_with_s0) with [0-10V/PWM](/config/config_spindles#0-10v) -- no output_pin/direction_pin/pwm_hz, plus:

- [`enable_pin`](/config/config_spindles#plasma)
- [`arc_ok_pin`](/config/config_spindles#arc_ok_pin)
- [`arc_wait_ms`](/config/config_spindles#arc_wait_ms)

### `ModbusVFD:`

- [`uart_num`](/config/modbus_vfd#uart_num)
- [`modbus_id`](/config/modbus_vfd#modbus_id)
- [`debug`](/config/modbus_vfd#debug)
- [`poll_ms`](/config/modbus_vfd#poll_ms)
- [`retries`](/config/modbus_vfd#retries)
- [`spinup_ms`](/config/modbus_vfd#spinup_ms)
- [`spindown_ms`](/config/modbus_vfd#spindown_ms)
- [`speed_map`](/config/modbus_vfd#speed_map)
- [`model`](/config/modbus_vfd#model)
- [`min_RPM`](/config/modbus_vfd#min_rpm)
- [`max_RPM`](/config/modbus_vfd#max_rpm)
- [`off_on_alarm`](/config/modbus_vfd#off_on_alarm)
- [`cw_cmd`](/config/modbus_vfd#cw_cmd)
- [`ccw_cmd`](/config/modbus_vfd#ccw_cmd)
- [`off_cmd`](/config/modbus_vfd#off_cmd)
- [`set_rpm_cmd`](/config/modbus_vfd#set_rpm_cmd)
- [`get_min_rpm_cmd`](/config/modbus_vfd#get_min_rpm_cmd)
- [`get_max_rpm_cmd`](/config/modbus_vfd#get_max_rpm_cmd)
- [`get_rpm_cmd`](/config/modbus_vfd#get_rpm_cmd)

### `PWM:`

All items shared with [0-10V](/config/config_spindles#0-10v) (no forward_pin/reverse_pin) -- see [PWM](/config/config_spindles#pwm).

### `Relay:`

All items shared with [0-10V/PWM](/config/config_spindles#0-10v) (no pwm_hz) -- see [Relay](/config/config_spindles#relay).

### `DAC:`

All items shared with [Relay](/config/config_spindles#relay) (no pwm_hz) -- see [DAC](/config/config_spindles#dac).

### `NoSpindle:`

No config items -- a no-op default spindle used when no spindle is configured. See [NoSpindle](/config/config_spindles#nospindle).

### `kinematics/CoreXY:`

- [`x_scaler`](/config/kinematics#x_scaler)

### `kinematics/ParallelDelta:`

- [`crank_mm`](/features/kinematics/parallel_delta#crank_mm)
- [`base_triangle_mm`](/features/kinematics/parallel_delta#base_triangle_mm)
- [`linkage_mm`](/features/kinematics/parallel_delta#linkage_mm)
- [`end_effector_triangle_mm`](/features/kinematics/parallel_delta#end_effector_triangle_mm)
- [`kinematic_segment_len_mm`](/features/kinematics/parallel_delta#kinematic_segment_len_mm)
- [`use_servos`](/features/kinematics/parallel_delta#use_servos)
- [`up_degrees`](/features/kinematics/parallel_delta#up_degrees)
