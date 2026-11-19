---
title: Stepping Engines
description: Comparison of FluidNC stepping engines, how they work, and the hardware they support
published: true
date: 2026-11-18T00:00:00.000Z
tags: en
editor: markdown
dateCreated: 2026-11-18T00:00:00.000Z
---

# Stepping Engines

A stepping engine is the part of FluidNC that turns planned motion into step and direction signals. Only one engine can be active at a time; all motors use the same engine. Select it with `stepping.engine` in `config.yaml`; the shared timing settings are documented under [Stepping](/config/axes#stepping).

This page compares the engines and explains when to use each one. For pin syntax and attributes, see [Configuring Pins](/config/config_IO).

> Engine availability is compiled into the firmware. A particular build can only select engines that are compiled for its platform, so its `stepping.engine` choices may be smaller than the table below.
{.is-info}

## At a glance

| Engine | Config value | Platforms | Step/dir pins | Motor capacity | Default on |
|---|---|---|---|---|---|
| RMT | `RMT` | Classic ESP32 | `gpio.N` | 8 | Classic ESP32 |
| PARLIO (Experimental) | `PARLIO` | ESP32-P4 | `parlio.N` | 8 | ESP32-P4 |
| I2S (I2SO) | `I2S_STATIC` or `I2S_STREAM` | ESP32, ESP32-S2, ESP32-S3, and some RP2040 builds with I2SO hardware | `i2so.N` | Board-dependent | Board-dependent |
| TIMED | `Timed` | Most non-P4 targets | `gpio.N` | GPIO-limited | ESP32-S3 |
| Simulator | `Simulator` | POSIX and WASM simulator builds | none | Virtual | POSIX and WASM |
| PIO | `PIO` | RP2040 | Native GPIOs | GPIO-limited | RP2040 |

## RMT

RMT uses the ESP32 RMT peripheral. Each step pin gets one RMT TX channel. FluidNC programs the channel with the step pulse and direction delay, then starts it for each step. Direction pins are ordinary native GPIOs written by the stepping code.

- **Hardware:** Classic ESP32 has eight RMT TX channels. ESP32-S3/P4 have four RMT TX channels, but this step engine is not selectable in stock S3 or P4 builds.
- **Pins:** `gpio.N` for step and direction. No extra bus section is required.
- **Pros:** no external hardware; simple native-GPIO wiring; low motion-start latency; well suited to small machines.
- **Cons:** one GPIO per signal; four-motor limit on ESP32-S3/P4; channels start in sequence, so there is sub-microsecond cross-axis skew (0.32 µs per channel in ESP32-P4 tests); the stepping ISR starts a channel for each step.
- **Use it when:** you have a classic ESP32

See [Stepping](/config/axes#stepping) for the shared settings.

## PARLIO (Experimental)

> **Experimental:** PARLIO is new and still under validation. Its configuration, timing, and behavior may change. Test it on your machine before relying on it for production work.
{.is-warning}

PARLIO (Experimental) uses the ESP32-P4 parallel I/O peripheral. It is the default engine on ESP32-P4 builds. It streams 16-bit words at 1 MHz; every step and direction bit in a word updates together. A GDMA ring feeds the stream, and a DMA end-of-chunk interrupt advances the step generator. The stream runs continuously between moves; a new move starts at the next 64-word chunk boundary.

- **Hardware:** ESP32-P4 only. It uses one PARLIO clock GPIO and up to 16 data GPIOs. No external shift registers are required.
- **Pins:** `parlio.N`; the `parlio:` section assigns the physical GPIOs. See [parlio section](/config/config_IO#parlio-section).
- **Pros:** up to eight axes with step and direction; all axes update together; no measurable cross-axis skew; low CPU load; no external hardware.
- **Axis limit:** FluidNC can define up to nine axes, but PARLIO's 16 data bits provide eight independent step/dir pairs.
- **Cons:** P4 only; experimental; one clock plus data pins; up to 64 µs motion-start latency; 1 µs word resolution; not a general-purpose I/O expander.
- **Use it when:** Are willing to help refine the PARLIO engine, need absolute step alignment, and have a P4 board.

Use `engine: PARLIO` in the config; the `(Experimental)` notation is documentation only.

## I2S (I2SO)

I2S uses the ESP32 I2S peripheral to shift a serial stream into an external chain of shift registers. The shift-register outputs are exposed as `i2so.N` virtual pins. The `i2so:` section defines the bit clock, data, and word-select pins. On current firmware, `I2S_STATIC` and `I2S_STREAM` select the same implementation; the two names are historical.

- **Hardware:** ESP32, ESP32-S2, and ESP32-S3 boards with the I2S shift-register chain, such as the 6 Pack, MKS DLC32, and TinyBee; some RP2040 builds also support I2SO.
- **Pins:** `i2so.N`; the `i2so:` section uses three bus pins, and the shift registers provide the motor outputs.
- **Pros:** many step, direction, and enable outputs with few MCU pins; high speed and low jitter; can drive other outputs such as TMC chip selects and spindle enables.
- **Cons:** requires board-level shift registers; not portable to boards without them; uses bus pins; not available on P4.
- **Use it when:** your controller board is designed for I2SO and you need many motors or outputs.

See [i2so section](/config/config_IO#i2so-section) for configuration and [I2S Performance](/development/IS2_Performance) for performance details.

## TIMED

TIMED drives step pins directly from the CPU. It sets a pin, busy-waits for the pulse width, then schedules the next step with the step timer. It uses the same native GPIOs as RMT.

- **Hardware:** most non-P4 targets; no external hardware.
- **Pins:** `gpio.N`.
- **Pros:** simple fallback; no special peripheral.
- **Cons:** CPU-intensive; less efficient than other options.
- **Use it when:** you have a special build that needs it. There is normally no reason to prefer it over other options.

The current ESP32-S3 platform uses TIMED as its default because RMT is not exposed there; S3 boards with I2SO hardware normally select I2S instead.

## Simulator

The Simulator engine does not drive physical pins. It tracks motion and sends position updates to the simulator UI over WebSocket.

- **Hardware:** POSIX and WASM simulator builds only; no controller.
- **Pins:** none.
- **Pros:** develop and test without hardware; useful for CI and UI work.
- **Cons:** virtual only; not for real machines.
- **Use it when:** you are running FluidNC in the simulator.

## PIO

The RP2040 PIO engine uses a PIO state machine to drive step pins from a 32-bit shadow register.

- **Hardware:** RP2040 builds with PIO support.
- **Pins:** native GPIOs.
- **Pros:** hardware-timed; no external hardware; can drive many step pins from one state machine.
- **Cons:** RP2040 only; not available on ESP32.
- **Use it when:** you are running FluidNC on an RP2040 board.

## Pin cost

| Engine | MCU pins for 3 axes | Notes |
|---|---|---|
| RMT | 6 | 3 step plus 3 direction; add enable pins separately |
| PARLIO (Experimental) | 7 | 1 clock plus 3 step plus 3 direction; add enable pins separately |
| I2S (I2SO) | 3 bus pins | The shift registers provide the motor outputs |
| TIMED | 6 | Same as RMT |
| Simulator | 0 | Virtual only |
| PIO | 6 | Same as RMT, on RP2040 |

## Choosing an engine

- **Classic ESP32, 1-8 motors, native GPIOs:** RMT.
- **ESP32-S3:** I2SO if the board has shift registers; otherwise TIMED. RMT hardware exists, but current stock S3 builds do not expose it.
- **ESP32-P4, 1-8 motors, synchronized motion:** PARLIO (Experimental).
- **ESP32 board with I2SO hardware:** I2S.
- **No hardware / CI:** Simulator.
- **RP2040:** PIO.