---
title: Modules
description: Plug-in code
published: true
date: 2026-08-01T19:34:29.476Z
tags: 
editor: markdown
dateCreated: 2024-07-17T22:21:40.101Z
---

# Modules
> This page describes an internal aspect of FluidNC that is primarily of interest to developers who are implementing new features or modifying existing ones.  Most FluidNC users would not need to know this
{.is-info}

A Module is a source file that can be included or excluded from the FluidNC build simply by adding or removing the filename from build_src_filter in platformio.ini.  It is not necessary to guard the file contents with `#ifdef ENABLE_NAME .. #endif`

Module symbols, and the name of the module itself, are generally not visible to or referenced from outside code, except for the few methods of the module abstract interface.  The module's functionality is invoked in various places in FluidNC with
```
    for (auto const& module : Modules()) {
        module->METHOD();
    }
```
which calls METHOD() on all of the registered objects.

Each module is registered with, for example,
```
    ModuleFactory::InstanceBuilder<OLED> oled_module __attribute__((init_priority(104))) ("oled");
```
That creates an instance of the module's derived class and arranges for it to be configured if necessary.  The **init_priority** value permits modules to be initialized in a defined order, for cases where one module depends on another.  For example, the TelnetServer module requires that the WifiConfig module be initialized first.  Lower numbers are initialized before higher numbers. If two modules have the same number, the order among them is undefined.

The Module class derives from Configurable, so a module can define its own configuration items by overriding the group() method.  A module that needs no configuration items need not define a **group()** method, since the Module class includes a default no-op **group()** method.

Each module will create a similarly-named section in the configuration tree which  will show up in the output of **$cd**.  If the module has a non-null **group()** method, that section will include the config items that it defines.  Otherwise the section will be empty.  It is not necessary to include the section name in the config file unless you want to set some of the item values.  For modules without **group()** items, you can either include or omit the module section name in the config file.

## Module methods:
-  **void init()** FluidNC calls all the init methods at startup, to prepare the modules for use
- **void deinit()** The deinit method disables the module.  FluidNC does not call the deinit()        methods.  It is for completeness and possible future use.
- **void poll()** FluidNC calls all the poll() methods when waiting for input.  If the module needs to be called periodically, it can implement this.
- **void status_report(Channel& out)** FluidNC calls all the status_report() methods when preparing a status report (the response to a ? realtime command, or with auto-reporting).  If them odule needs to add information to the report, it can implement this.
- **void build_info(Channel& out)** FluidNC calls all the build_info() methods when responding to $I.  If the module needs to add information to the report, it can implement this.
- **void wifi_stats(JSONencoder& j)** FluidNC calls all the wifi_stats() methods when responding to [ESP420] from WebUI. If the module needs to add information to the report, it can implement this.
- **bool is_radio()** Returns true if the module is for a radio like Bluetooth or WiFi.  This is used to populate the "R" field in the Grbl signon message.


