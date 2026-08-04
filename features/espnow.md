# ESPNOW Feature

ESPNOW is a connectionless, low‑latency, peer‑to‑peer wireless protocol created by Espressif for ESP8266/ESP32‑class chips. It uses the same radio as WIFI and can be used at the same time as the standard WIFI features.  

FluidNC uses it like a UART channel. It is intended to used to talk wirelessly to displays and pendants, but it could potentially be used for I/O expanders.

Currently the only device supported is the FluidDial.

## ESPNow commands 

### $espnow/pair

This command will attempt to pair FluidNC with a device that is waiting in pairing mode. It will try for 60 seconds.

###  $espnow/cancel

This will cancel a pairing attempt that is not succeeding.

### $espnow/list

This will list any devices that have been paired. Each the MAC address of each will be shown with an index number (index 1 in example below) 

```
[MSG:INFO: ESP-NOW: 1: 34:b7:da:54:d8:b0]
```

### $espnow/unpair=\<index\>

This command will unpair a device specified by the index number

## Usage

Put the device in pairing mode then send the`$espnow/pair` command to FluidNC. You can also start the pairing on FluidNC first and then enter pairing mode on the device within 60 seconds.

Here is a console session showing all of the commands being used. 

```
$espnow/pair (attempting to pair with no devices in pairing mode)
[MSG:DBG: ESP-NOW: pairing window opened on AP channel 1 MAC d4:8a:fc:d1:b5:19]
[MSG:INFO: ESP-NOW: pairing enabled for 60 seconds]
ok
$espnow/cancel (canceling the pairing attempt)
[MSG:INFO: ESP-NOW: pairing cancelled]
$espnow/pair (pairing with a device in pairing mode)
[MSG:INFO: ESP-NOW: pairing enabled for 60 seconds]
ok
[MSG:INFO: ESP-NOW: paired peripheral 34:b7:da:54:d8:b0]
[MSG:INFO: ESP-NOW: peripheral connected 34:b7:da:54:d8:b0]
[MSG:INFO: espnow auto report interval set to 200 ms]
$espnow/list
[MSG:INFO: ESP-NOW: 1: 34:b7:da:54:d8:b0]
ok
$espnow/unpair=1
[MSG:INFO: ESP-NOW: removed peripheral 34:b7:da:54:d8:b0]
ok
```