---
title: JSON Format for WebUI
description: 
published: true
date: 2022-08-23T13:45:36.297Z
tags: 
editor: markdown
dateCreated: 2022-08-23T00:50:23.931Z
---


Send the `$WebUI/List` command to get a JSON array of all settings and config items stored in the FNC EEPROM.

The json is a top-level object containing a single property named "EEPROM", whose value is an array of items.  At the top level it looks like 

```json
{"EEPROM": [ <item>, <item>, ... <item>] }
```
  - Each item is an object `{ <property>, <property>, ... <property> }`
  - A `<property>` is a `"name": <value>`
`<value>` is either a quoted string like "tree" or an array that contains a single object 
```json
[{ `<property>, <property>, ... <property>}]
```
  - Every `<item>` object contains at least these properties:
  
  


```
"F": (either "nvs" for a setting or "tree" for an entry in the config tree)
"P": the name of the setting, e.g. "Telnet/Port", or the tree item, e.g. "/stepping/idle_ms"
"H": the samve value as for "P" ("H" used to be a help description but since the names are now self-describing, we could not think of anything better to say that was not essentially just a rearrangement of the words that are already in the name)
"T": the data type - "B" for boolean or enumeration, "I" for integer, "R" for real, "S" for string, "A" for IP Address
"V": the current value.  It is always represented as a string enclosed in quotes, but the way that string is interpreted depends on "T"
```

Example

```json
{"F":"tree","P":"/axes/x/steps_per_mm","H":"/axes/x/steps_per_mm","T":"R","V":"800.000"}
```

## Additional properties:


```
"O": [ { <name>:<value>, <name>:value, ... <name>:<value> }] - this provides the name-to-value mapping for enumerations.  For example, for a boolean it is "O": [{ "False":"0", "True":"1"}]
"S":<maximum_value> - the maximum value for an integer type item
"M":<minimum_value> - the minimum value for an integer type item
```

Examples

```json
{"F":"tree","P":"/stepping/engine","H":"/stepping/engine","T":"B","V":"2","O":[{"Timed":"0"},{"RMT":"1"},{"I2S_static":"2"},{"I2S_stream":"3"}]}
```

```json
{"F":"tree","P":"/user_outputs/analog1_hz","H":"/user_outputs/analog1_hz","T":"I","V":"5000","S":"20000000","M":"1"}
```

The webui/list output reflects the set of always-present config items plus the set of optional items that currently exist in the config.yaml file.  It does not list possible things that are not configured in.  For example, there are many spindle types, like laser, pwm, besc, and many different vfds, each with their own set of options.  At present there is no way to ask the firmware what all of those possibilities are.