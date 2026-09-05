---
title: GCode Clustering
description: GCode Clustering for optimized sending of raster data
published: true
date: 2026-09-05T21:39:18.131Z
tags: 
editor: markdown
dateCreated: 2026-09-05T21:39:18.131Z
---

# GCode Clustering

This page describes FluidNC support for clustered `S` values in linear GCode moves.

Clustered GCode allows a sender to place multiple colon-delimited spindle or laser power samples on one motion line instead of emitting one short move per sample.

## Overview

Clustered GCode is mainly used for raster-style laser engraving, where power changes much more often than motion direction. Instead of sending one `G1` command per pixel or per tiny segment, the sender can encode several evenly spaced power samples on a single linear move.

Example:

```gcode
G1 X0.961 S256:260:268:262:262:262:266:260:264:256:256:264:268:268:264:266
```

In that format, the move endpoint is still defined normally. The clustered `S` list supplies evenly spaced power samples across the distance of the move.

## Why it exists

The main purpose of clustered GCode is to reduce streaming overhead during high-resolution engraving.

Without clustering, a sender may need to transmit many very short moves with frequent `S` updates. That increases serial traffic, parser load, and planner pressure. With clustering, the sender can transmit fewer motion lines while still varying power across the move.

This is most useful for:

- High-DPI raster engraving
- Diode laser jobs with frequent power changes
- Controllers that become limited by GCode traffic before they become limited by mechanics

## FluidNC behavior

FluidNC keeps the feature narrow and compatible with normal motion semantics.

- Clustered `S` syntax is accepted on linear moves.
- The clustered values are treated as evenly spaced samples across the programmed move.
- FluidNC expands the move into internal linear sub-segments, one per sample.
- Each sub-segment uses the corresponding spindle or laser power value.
- Normal `S` scaling is preserved through the existing spindle pipeline.
- `$I` reports `[CLUSTER:16]` so compatible senders can discover support automatically.

This approach avoids introducing a separate raster mode or a new transport protocol.

## Sender-facing behavior

For senders, the important points are:

- The capability is advertised in `$I` as `[CLUSTER:16]`.
- The advertised size is the maximum number of clustered `S` samples FluidNC reports to senders.
- Current LightBurn behavior clamps the advertised cluster size to the range `1..16`.

## Prior art and compatibility

Clustered GCode appears to have evolved as a practical interoperability feature rather than as part of a formal GCode specification.

Public discussion around grblHAL and LightBurn describes the format as colon-delimited `S` values on a single linear move, added to improve raster throughput on slower controllers. Jason Dorie of LightBurn later described the feature as a practical workaround that originally targeted Smoothieware limitations.

Confirmed public references indicate support in the following ecosystems:

- LightBurn
- Smoothieware
- grblHAL
- Ortur firmware
- Tim Rothman firmware or board support
- ioSender, at least in partial or edge-build form
- µCNC, as reported by its maintainer in public discussion

LightBurn initially looked for `[CLUSTER:8]` during early rollout, but later support expanded to up to 16 clustered samples per move. For current interoperability, `[CLUSTER:16]` is the correct capability value to advertise.

## Notes

- This feature is intended for clustered power samples, not for arbitrary parameter packing on a line.
- FluidNC currently implements clustering by subdividing a linear move internally rather than by extending planner blocks to carry multiple power values.
- The syntax is intended for compatibility with existing senders that already emit clustered laser power data.