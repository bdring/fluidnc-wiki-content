---
title: I2S Performance
description: Measurements of I2S stepping in various mode
published: true
date: 2026-08-01T19:34:25.031Z
tags: 
editor: markdown
dateCreated: 2024-10-05T21:18:14.480Z
---

# I2S Performance
As of October 5, 2024, there are two different I2S operation modes - I2S_STREAM and I2S_STATIC.  This page records an exploration of their performance and some attempts to simply the code while possibly improving the performance.

## Theory 

The ESP32 I2S hardware engine has a data register plus a FIFO and a DMA engine.  Whatever data happens to be in the data register is repeatedly shifted out to the I2S serial data line on the I2S bit clock, and every 16 bit clocks the frame clock toggles.  The data is clocked into a chain of shift registers by the bit clock.  On the rising edge of the frame clock the data that is currently in the shift registers is transferred to output registers.

The frame clock is 4 microseconds (250 kHz), and every step pulse needs a high and a low period, so the minimum pulse time is 8 microseconds for a maximum pulse frequency of 125 kHz.

In I2S_STATIC mode, the FluidNC stepping code directly rewrites the value in a special "constant data" register whenever it wants to change the value of a step or direction line.  This is done inside an interrupt service routine.  For each step pulse, the constant data register must be written twice - once for the leading edge and once for the trailing edge.  The time between the leading and trailing edges is fixed at a configurable value between 4 and 20 microseconds.  Many modern stepper motor drivers can handle short pulses of 4 microseconds or even less, but there are some older drivers that need longer pulses, hence the configurable pulse time.

For I2S_STATIC, the interrupt service routine writes the constant data register for the leading edge of the pulse, busy-waits for the step pulse length time, then writes the data register for the trailing edge of the pulse.  It then sets a timer so that the interrupt will fire again the next time that a pulse should occur.

In I2S_STREAM mode, instead of writing to the constant data register directly, the stepping code writes successive values to a ring of memory buffers.  A DMA engine associated with the I2S engine feeds memory data into the I2S FIFO which then feeds the data register on every frame clock.  In this mode, the pulse timing is done by injecting multiple copies of the data value into the memory buffer.  For example, if the pulse length is configured for 20 microseconds (remembering that the frame clock is 4 microseconds), there must be 5 samples of the data value with the step pin set to active, followed by some number of samples with step pin set to inactive.  The number of inactive samples is the time to the next step pulse divided by 4 microseconds.

In I2S_STREAM mode, the interrupt service routine runs less frequently, but does more work, writing several (or quite a lot if the time to the next pulse is long) of samples to memory.  A separate interrupt service routine takes care of feeding sample buffers to the DMA engine in a timely fashion.

## Status Quo Performance

I2S_STATIC can run at almost the maximum 125 kHz step rate because, on average, the interrupt service routine is fast enough to "keep up" with the step data that is coming in from the FluidNC planner.  However, there are times when the interrupt routine is "locked out" briefly due to something else that the CPU is doing, so it might be delayed by a few microseconds.  This does not result in missed steps, but there can be longer-than-ideal intervals between steps.  So, when running at the maximum speed, instead of a constant stream of steps every 8 microseconds, you might see a burst of 8-microsecond steps, then a 16 or 24 microsecond gap, followed by another burst of full-speed steps.

For most systems where the actual maximum pulse rate is quite a bit lower, say 20 kHz instead of 125 kHz, this "jitter" is not a big problem.  It won't matter at all if the actual pulse period is mostly 50 mcroseconds with occasional longer ones at say 58 microseconds.  But at very high pulse rates, the jitter could result in noisier, slightly less smooth motion.

Since the interrupt routine works in a "just in time" fashion, there is essentially no delay from the time that code presents step segments to the stepping engine and the time that the first step in a segment appears on the output pin.  In other words, there is very low "latency" between step segments and actual step output.  Why this matters will be explained shortly.

I2S_STREAM has slightly higher speed than I2S_STATIC and essentially no jitter, at the expense of higher latency.  I2S_STREAM is always "working ahead" by preparing memory buffers with sample streams, leaving it to the DMA engine and FIFO to feed those samples to the I2S data register in real time, synchronized to the I2S frame clock.  The maximum speed of 125 kHz step rate can thus be achived with essentially no jitter.  However, there is latency between the time that a step segment is presented to the stepping engine and the appearance of the pulses on the step pin, according to the size of the memory buffers that feed the DMA engine.

A step segment is a group of N steps with a fixed inter-step interval, associated with the spindle speed that should be in effect during that group of steps.  When the stepper code receives a new step segment, it tells the spindle which speed to use, then feeds those steps to the step engine.  The reason why latency can matter is that it causes the spindle speed change to happen too soon, before the corresponding motion.  The spindle speed is applied to the spindle, but the steps are delayed by the DMA buffering that happens in I2S_STREAM mode.

This is not a problem with rotational spindles (cutting spindles), because they can only change speed slowly and must be synchronized at a higher level, before motion is even planned.  But it is a problem with lasers which can change their power very rapidly and must be synchronized precisely to the motion to produce good engravings.  That is why we recommend using I2S_STATIC mode for lasers.

The other problem with latency is when you are homing or probing.  Motion must stop quickly when limit switches are touched.  When homing and probing, FluidNC always uses I2S_STATIC mode, even if otherwise configured for I2S_STREAM.

## Development Goals

If I can find a way to improve the performance of I2S_STATIC mode, it would like to eliminate I2S_STREAM mode.  It would be easier for users if there were only one mode.  The I2S_STREAM code is complicated and difficult to maintain, especially in light of the need to switch back and forth to I2S_STATIC during homing and probing.  Furthermore, the I2S hardware on ESP32-S3 is different from ESP32, especially with respect to the DMA portion, so we currently do not have an I2S solution for ESP32-S3.  If we only had to support I2S_STATIC mode, it would likely be much easier to get I2S working on S3.

## Compatibility
 For ease of migration, the stepping engine names I2S_STREAM and I2S_STATIC would still be supported, but there would be no difference in behavior between the two.  They would both behave the same, as the new, improved I2S_STATIC mode (low latency, hopefully lower jitter than the current I2S_STATIC).
 
 ## Things to try
 
 To accomplish this new improved I2S_STATIC mode, I have a couple of ideas.  The key idea is to use the I2S FIFO instead of writing directly to the I2S data register.  Instead of busy-waiting to time the pulse length, it should be possible to feed one to five "step active" pulses into the FIFO, followed by one "step inactive" pulse.  This would make it possible to exit quickly from the ISR, leaving more time for other CPU activity.  Hopefully this would reduce the probability of delaying the next ISR.
 
If that isn't good enough, there is a secondary possibility.  The full length of the FIFO could be used, along with data that keeps track of how many samples remain until the next change in data value.  The interrupt could fire on FIFO-almost-full, and keep filling the FIFO with the next value.  That would provide 32\*4 = 128 microseconds of working time against the interrupt latency.

That would create a latency of 128 microseconds if the FIFO is kept full, but it might be possible to set the almost-full threshold to a lower value like 8 and fill to level of say 12, for a spindle/step latency of 48 microseconds.  That is similar to the inherent latency of PWM speed changes assuming a 20 kHz PWM frequency.  48 microseconds is probably plenty to accomodate interrupt latency and variation.

## Results

I tried the first version, just using the FIFO directly without the almost-full interrupt trick.  It worked great.  Stepping at 125 kHz was rock solid, without any longer-than-usual inter-pulse times.

## ESP32-S3 Porting Failure

I tried porting to ESP32-S3 and ran into a problem that I haven't been able to solve.  ESP32-S3 does not have a "write to FIFO from CPU" register.  On ESP32, the register at offset 0 in the I2S hardware block is "fifo_wr", but on ESP32-S3, that register is "reserved_0" according to i2s_struct.h.  Similarly, i2s_reg.h does not define a register at offset 0, nor does the ESP32-S3 Technical Reference Manual mention a register there.  It is possible that there is such a register but it is undocumented.  It is also possible that the register is tied up with the DMA link in such a way that accessing it from the CPU is problematic.

The other registers in the ESP32-S3 I2S block are quite different from the ESP32 I2S block, so the ESP32 code would need a complete rewrite for ESP32-S3.  We may have to give up on using I2S on S3.  The fact that S3 has more GPIOs makes it plausible to support a reasonable number of motors with GPIOs, and maybe we can use UART I/O expansion to get enough non-stepping I/Os.

## Final Results

The winning strategy for ESP32 turned out as follows.  Interrupt when the I2S FIFO is below a threshold (16 out of a total of 64 entries).  Maintain two counters, one for the remaining number of pulse samples and another for the remaining number of delay (inter-pulse) samples, along with data values for pulse and delay.  In the ISR, add N (currently 8) samples to the FIFO, first pulses while remaining_pulses is nonzero, then delay while remaining_delay is nonzero.  When remaining_delay is zero, call Stepper::pulse_func to compute new values for the counters and data values.

This approach works very well, with no jitter, low latency (16+8 sample clocks), and acceptably low CPU usage.  It can pulse at 250 kHz.  It is deployed in version 3.9.0.  With this scheme, there is no need for a distinction between I2S_STATIC and I2S_STREAM, working well in all situations.