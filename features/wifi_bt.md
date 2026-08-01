---
title: Wifi and Bluetooth
description: 
published: true
date: 2026-08-01T19:36:52.468Z
tags: 
editor: markdown
dateCreated: 2022-07-22T14:15:58.208Z
---

# FluidNC Wifi and Bluetooth Setup

## Quick Start for WiFi Setup

First time users can setup WiFi with this [WiFi Quick Start Guide](/en/features/wifi-quick-start).  More details about advanced topics are given below

## Wifi or Bluetooth

The ESP32 cannot do wifi and Bluetooth at the same time because there is only one radio. Both use a lot of code space, so we have 2 versions of the pre-compiled firmware (wifi & bt). Install the one you plan to use. You can still choose the noradio and (wifi & bt) options if you compile yourself. [See this page](https://github.com/bdring/Grbl_Esp32/wiki/FluidNC-Compiling) for more details.

## WiFi Settings

All of the radio options are set with `$` commands and not via the config file. This was done to help make sure you have a stable radio setup while developing and fine tuning your config file. The list of settings available depends on whether you are using WiFi or Bluetooth. You will not see the Bluetooth options while using the WiFi firmware.

To change one of these settings, you can use [FluidTerm](en/fluidterm/fluidterm_usage) to connect to the USB serial interface, then type a command like:

```
$Sta/SSID=MyWifiSSID
```

Below are all the settings.

**STA** refers to "Station" which would be your local wifi. Send `$STA` to see all the current values.

- **$Sta/SSID** This is the SSID (service set identifier) of your local WiFi router. See [International characters in SSIDs](/support/faq#international-characters-in-wifi-ssids) if your SSID contains a space or non-US-ASCII characters.
- **$Sta/Password** This is the password for your local WiFi router.
- **$Sta/IPMode** (DHCP or Static) Typically your router will give you an address to use at the time of connection. Use **DHCP** for that mode. If you have set up your router to use a specific address, use the **Static** mode.
- **$Sta/IP** Set this to an IP address if you are using **Static** mode, otherwise the value is ignored.
- **$Sta/Gateway**
- **$Sta/Netmask**
- **$STA/SSDP/Enable** (Since 3.7.7) Set this to true (default) to enable SSDP and mDNS. You will see something like this in the start messages `[MSG:INFO: Start mDNS with hostname:http://fluidnc.local/]`. If false you gain some memory, but must use the IP address for the browser URL. This can help if you are low on memory.
- **$Sta/MinSecurity**  Values: OPEN, WEP, WPA-PSK, WPA2-PSK (default), WPA-WPA2-PSK, WPA2-ENTERPRISE, WPA3-PSK, WPA2-WPA3-PSK, WAPI-PSK, or WPA3-ENT-192.

**AP** refers to "Access Point". This is a WiFi access point on the ESP32. Send `$AP` to see all the current values.

- **$AP/SSID** This is the SSID name for the access point. The default is "FluidNC"
- **$AP/Password** The password will not be shown when you request the current value. The default password is `12345678`
- **$AP/IP** The static IP used by the AP for itself.
- **$AP/Channel**
- **$AP/Country** \[since v3.6.7\] The regulatory domain configured for the AP. Affects available channels and maximum transmit power. See this [list of 2 letter codes](https://github.com/bdring/FluidNC/blob/main/FluidNC/src/WebUI/WifiConfig.cpp#L47)

Other settings

- **$Hostname**
- **$HTTP/Enable**
- **$HTTP/Port**
- **$HTTP/BlockDuringMotion** [since v3.6.8] Prevents serving files from LocalFS when the machine is running
- **$Telnet/Enable**
- **$Telnet/Port**
- **$WiFi/Mode** (AP, Off, STA or STA>AP) This is the mode the wifi will use. STA>AP means it will attempt to use STA, then fall back to AP mode

- $Notification/Type
- $Notification/T1
- $Notification/T2
- $Notification/TS

## Passwords

There are no commands to tell you the current password. This offers a little bit of security. Someone with direct access to the ESP32 can dump the flash memory and find the password. For better security you should use a network firewall.

**Note:** Your console does not know you are sending a password, so it will be displayed as you type it.

## Wifi AP Mode

In this mode FluidNC becomes its own wifi access point. The [startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages) show that it has created an access point with SSID "FluidNC". You can connect to this with your computer, tablet or phone. The default password is "12345678". The IP address is 192.168.0.1.

> AP mode is not recommended for production, only for initial setup. It will affect the performance of your machine, possibly causing crashes after some time. Change to STA or STA>AP mode after FluidNC is set up. If you do not have an external WiFi access point to connect to in STA mode, you can set up a private network using a WiFi router that need not be connected to any outside networks.  The router can be an old slow one - perhaps one that has been removed from service - because the ESP32 WiFi speed is limited to about 30 mBits/sec, which is more than enough for WebUI. 
{.is-warning}


```
[MSG:INFO: AP SSID FluidNC IP 192.168.0.1 mask 255.255.255.0 channel 1]
[MSG:INFO: AP started]
[MSG:INFO: WiFi on]
[MSG:INFO: Captive Portal Started]
[MSG:INFO: HTTP started on port 80]
[MSG:INFO: Telnet started on port 23]
```

## WiFi STA DHCP Address

In this mode your router will assign an address. You will be able to see it in the [startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages). In the case below it is `192.168.1.19`. You would use this as the address in your web browser.

```
[MSG:INFO: STA SSID Barts-WLAN DHCP]
[MSG:INFO: Connecting.]
[MSG:INFO: Connecting..]
[MSG:INFO: Connecting...]
[MSG:INFO: Connected - IP is 192.168.1.19]
[MSG:INFO: WiFi on]
[MSG:INFO: Start mDNS with hostname:http://fluidnc.local/]
[MSG:INFO: SSDP Started]
[MSG:INFO: HTTP Started]
[MSG:INFO: Telnet Started on port 23]


```
## WebUI

The [WebUI](http://wiki.fluidnc.com/en/features/webui) is the web browser based user interface.

# Bluetooth

You can use Bluetooth if you selected the bluetooth option when you installed FluidNC. You will see this in your start messages if you are using the Bluetooth version.

```
[MSG:INFO: BT Started with FluidNC]
```

When you connect to the FluidNC Bluetooth device, a bluetooth com port will be created. You can use this com port with gcode senders, FluidTerm etc.

# Troubleshooting

## Failing to Connect

This is an example of failing to connect in STA mode and switching to AP mode.

```
[MSG:INFO: STA SSID Barts-WLAN DHCP]
[MSG:INFO: Connecting.]
[MSG:INFO: Connecting..]
[MSG:INFO: Connecting...]
[MSG:INFO: Connecting....]
[MSG:INFO: Connecting.]
[MSG:INFO: Connecting..]
[MSG:INFO: Connecting...]
[MSG:INFO: Connecting....]
[MSG:INFO: Connecting.]
[MSG:INFO: Connecting..]
[MSG:INFO: AP SSID FluidNC IP 10.0.0.1 mask 255.255.255.0 channel 1]
[MSG:INFO: AP started]
[MSG:INFO: WiFi on]
[MSG:INFO: Captive Portal Started]
[MSG:INFO: HTTP Started]
[MSG:INFO: Telnet Started on port 23]
```

<!-- 220322_1728: The following are my version of the excellent remarcks by Mitch, here: https://discord.com/channels/780079161460916227/955882703520145488 -->
## Connect to an External Network

Using AP mode for production is not recommended, use it only for the initial setup.  The AP core code from Espressif seems to have problems that we have been unable to isolate, and that might be too deep in the SDK for us to fix.  As a workaround, consider a dedicated external AP.  It does not need to be a modern high performance one, an old one from the junk box will probably be just fine.

Users routinely use WiFi connected tablets running WebUI.  Both the tablet and the FluidNC controller can connect to an external network which can be a collection of routers from a couple of generations back.  Even better performance would be expected from a dedicated AP.

## Use of a USB/Serial Cable

USB is always available as a fallback - and FluidNC will also fallback to AP mode if it fails to connect to an external AP in STA mode. 

You cannot use WebUI via a USB connection. Instead you must use some other sender like [UGS](https://winder.github.io/ugs_website/) on a connected computer.  There are also senders that run on computers connected either via Bluetooth, or serial (with some amount of extra effort to get a USB serial port into the tablet hardware/software setup).

## Use of Bluetooth

If you are having WiFi connection problems, perhaps Bluetooth would be more reliable in your specific environment, it is unknowable.  You will just have to try it.

## Electrical Noise

Spindles or other high power motors can generate a lot of electrical noise that can cause interference with WiFi and Bluetooth radios.  One way to determine if they are part of the problem is to run "air cut" test jobs with the spindle turned off, to see if the disconnects stop.

<!-- 220322_1757: what terms would be a good start for searching? -->
If the spindle turns out to be part of the problem, search the web for advice on how to filter and shield its power connections.

## Signal Strength

Check the signal strength of the target WiFi with `$Wifi/ListAPs`. It is in JSON format because it is primarily used by the WebUI and senders.

```
{"AP_LIST":[{"SSID":"Barts-WLAN","SIGNAL":"82","IS_PROTECTED":"1"},{"SSID":"4ag2hc1lj2ek7","SIGNAL":"32","IS_PROTECTED":"1"},{"SSID":"TheWIFI-2","SIGNAL":"30","IS_PROTECTED":"1"}]}
```

## Special Characters

SSIDs and passwords often use special characters. [See this FAQ note on character limitations](http://wiki.fluidnc.com/en/support/faq#special-character-issue).

# Wifi Communication Methods

## Telnet

If you have `$Telnet/Enable=True`, you can communicate via telnet with the same protocol as serial. The default port is 23 and set by **$Telnet/Port**. If enabled, you should see it in your [startup messages](http://wiki.fluidnc.com/en/support/requesting_help#fluidnc-startup-messages).

```
[MSG:INFO: Telnet Started on port 23]
```

## WebSockets and Web API

The [Web API](/en/features/WebAPI) allows to access FluidNC via HTTP or WebSockets

## WebDAV

You can [map a drive](http://wiki.fluidnc.com/en/support/interface/http-rest-api#webdav) on your computer to the filesystem on the FluidNC controller.
