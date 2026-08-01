---
title: Web API
description: HTTP and WebSocket API
published: true
date: 2026-08-01T19:35:28.035Z
tags: 
editor: markdown
dateCreated: 2025-06-08T23:41:36.253Z
---

# Web API

The API can be used to interact with FluidNC via HTTP and WebSocket protocol.

In the curl examples below, `${FLUIDNC_FQDN}` should be replace with your FluidNC address (for example: `fluidnc.home` or `192.168.1.162`

## Endpoints

### WebSocket

If you connect via a websocket (on $http/port +1, e.g. 81), you have a streaming connection to FluidNC that behaves just like serial. You send newline-delimited lines just like you would over serial, and get back the same ok or error responses. Flow control is the same as for serial, as documented on the plain old Grbl wiki.

#### curl example

A web socket can be opened to listen to messages emitted by FluidNC

```
curl ws://$(FLUIDNC_FQDN):81
```

### Upload file to flash filesystem

* URL: /files
* Method: POST
* Content-Type: multipart/form-data

#### curl example

This will upload file `file.yaml` to the ESP32 localfs (flash) with the name `/config.yaml`

```
curl -F "file=@/path/to/local/file.yaml;filename=/config.yaml" http://${FLUIDNC_FQDN}/files
```

### Upload file to the SD Card

* URL: /upload
* Method: POST
* Content-Type: multipart/form-data

#### curl example

This will upload file `file.gcode` to the SD card with the name `/test.yaml`


```
curl -F "file=@/path/to/local/file.gcode;filename=/test.gcode" http://${FLUIDNC_FQDN}/upload
```

