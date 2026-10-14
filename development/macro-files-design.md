---
title: Macro Files Design
description: Proposal for a single, UI-independent way to store, list and run user macros as files
published: true
date: 2026-10-14T00:00:00.000Z
tags: 
editor: markdown
dateCreated: 2026-10-14T00:00:00.000Z
---

# Macro Files Design

**Status:** proposal, October 2026.

This page proposes a storage convention that every FluidNC user interface - WebUI v2, WebUI v3, FigUI, the tablet UI, FluidDial and other pendants - can use to store, find and run user macros.  It establishes where macros are kept and how they are run; how a client presents them is up to the client.  It is about the macros that UIs show as buttons or menu items.  [Config file macros](/en/config/macros) are a different thing and are unchanged; see [Config file macros](#config-file-macros) below.

## The problem

At a fundamental level a macro is just a file of commands.  The only real difference from a GCode program is that UIs give a quick way to run one.  But each UI keeps its own list of macros, in its own format, in its own place:

| | Where the list is | How a macro is run |
|---|---|---|
| WebUI v2 | `macrocfg.json`: exactly 9 slots, with button classes and icon names specific to WebUI v2 | `$LocalFS/Run=` or `$SD/Run=` |
| WebUI v3 | `settings.macros` inside the whole `preferences.json`, which may be on LocalFS or SD | `[ESP700]` or `$SD/Run=` over HTTP; "CMD" macros are inline text, split on `;` |
| FigUI | WebUI v2's `macrocfg.json` with an extra `pinned` field and more than 9 slots; files it creates go in `/.macros/` | Downloads the file and sends it line by line over the WebSocket |
| FluidDial | Reads `macrocfg.json`, or `preferences.json` only if that is missing, and only from the LocalFS root | `$Localfs/Run=` |

So the same macro is started in four different ways, one-line macros are split on `;`, `&`, newlines or not at all depending on who runs them, and a macro created in one UI is invisible in another unless that UI happens to parse the first one's preferences.  Pendants have to know every UI's format.

## Principles

- **A macro is a file.**  Its content is ordinary GCode and `$` commands, one per line, run by FluidNC like any other file.
- **The machine owns the set of macros.**  Every UI and pendant sees the same macros, because they are found by listing a directory on the controller, not by reading some UI's preferences.
- **Each UI owns its presentation.**  Colors, icons, pinning, keyboard shortcuts and the like are each UI's own business, stored in its own preferences.

## Specification

### Where macros live

The NVS setting **`$Files/MacroDir`** names the macro directory.  Its default is **`/localfs/macros`**.  The value is a fully qualified path, so it can also name a directory on the SD card, e.g. `/sd/macros`.

There is one macro directory.  LocalFS and SD are not merged.  This keeps one answer to "which macros exist" and "where does a new macro go", and the list does not change when an SD card is removed.

Clients find the directory by sending `$Files/MacroDir` and reading the `$Files/MacroDir=<path>` reply.  If the command fails, as it will on firmware without the setting, they use the default.

Changing the setting does not move existing macros.

### What is a macro

A macro is a file in the macro directory whose extension is `.nc`, `.gc` or `.gcode`, compared without regard to case.  Other files, such as notes or backups, are ignored.  New macros are saved as `.nc`.

Macros may be grouped in subdirectories of the macro directory.  Whether and how a client presents those groups - as submenus, as a flattened list, or not at all - is up to the client.

`$Files/ListGCode` also lists other extensions, such as `.g`, `.txt` and `.tap`, so clients filter the listing to these three themselves.

### Label and order

A macro's label is its file name without the extension.  Macros are sorted by file name, without regard to case, and that is all: a numeric prefix such as `10_Probe Z.nc` is part of the label, and is a simple way for a user to control the order.

### Listing

Clients list the macro directory the same way they list any directory:

- `$Files/ListGCode=<dir>` over a serial, Telnet or WebSocket channel, as pendants do;
- or HTTP `GET /files?path=<dir>` for LocalFS or `GET /upload?path=<dir>` for SD, as WebUIs do.

A missing macro directory means there are no macros.  It is not an error.

### Running

A macro is run with **`$LocalFS/Run=<file>`** using the fully qualified path, e.g. `$LocalFS/Run=/localfs/macros/Park.nc`.  FluidNC resolves the volume from the path, so the same command works when the directory is on SD.  The file runs as a nested job, so it can itself use `$SD/Run=` or `$LocalFS/Run=`.

Clients should not download a macro and send its lines themselves.  Running the file in the controller gives proper flow control and the same behavior in every client.

**Alarm state:**  FluidNC refuses to run files in Alarm state, and macros are no exception.  The user must clear the alarm with the Unlock or Home controls, which every UI already has.  UIs and pendants should disable their macro controls in Alarm state, or say "Unlock first", rather than sending a command that fails with a bare error number.  For an automatic action after homing, such as parking, use the `after_homing` config file macro.

Macros are also refused while a job is running, as files are today.

### Creating and editing

A UI's macro editor writes the file into the macro directory.  If the directory does not exist, the first save creates it:

- over HTTP, with the `createdir` action of `/files` or `/upload`;
- over a command channel, with `$LocalFS/Mkdir=<dir>` or `$SD/Mkdir=<dir>` (bdring/FluidNC#1919), which create missing parents and do not complain if the directory already exists.

Renaming and deleting a macro are ordinary file operations.

### Presentation

Each UI may keep its own presentation settings for macros, keyed by file name.  It must:

- show a macro it has no settings for, with its own defaults;
- ignore settings for a macro whose file no longer exists.

## Out of scope

### Config file macros

The `macros:` section of the config file - `startup_line0/1`, `macro0`..`macro3`, `after_homing`, `after_reset`, `after_unlock` - is unchanged.  Those are hooks run by events, control pins and realtime commands, not a menu.  They can run a macro file, e.g. `macro0: $LocalFS/Run=/localfs/macros/Park.nc`.

### URI macros

WebUI v2 and v3 "URI" macros open a web page.  They are not machine macros and do not fit in files; a UI that wants them keeps them in its own preferences.

### Migration

Migration is manual.  Existing macro files are not moved, and there is no automatic conversion from `macrocfg.json` or `preferences.json`.  A user moves or recreates their macros in the macro directory.

## Work

### Firmware

- Add the `$Files/MacroDir` NVS setting, default `/localfs/macros`.
- Create missing parent directories on HTTP upload to `/files` and `/upload`, as the `/ui/<name>/` PUT already does and as bdring/FluidNC#1919 does for Xmodem receive.  WebDAV PUT should keep failing with 409 Conflict when the parent is missing, as RFC 4918 requires; WebDAV clients create folders themselves.
- Separately: `$Macros/Run=` does not check its index, so a digit above 3 reads past the end of the config file macro table.

### Clients

Each of these lists, runs and (where it has an editor) saves macros as specified above.  Whether a client also keeps handling its old scheme, such as `macrocfg.json` or `settings.macros`, is up to that client.

- the tablet UI (ESP3D-WEBUI `tablet/`)
- WebUI v2 (ESP3D-WEBUI)
- WebUI v3 (WebUI-mm)
- FigUI
- FluidDial

The `/macros` pseudo-filesystem in the ESP32-P4 work, which presents `macrocfg.json` and `preferences.json` entries as files, is not needed with this scheme and should not be merged.
