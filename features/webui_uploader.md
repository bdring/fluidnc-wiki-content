---
title: WebUI Uploader
description: FluidNC's built-in web page for managing files and WebUIs
published: true
date: 2026-10-10T00:00:00.000Z
tags: 
editor: markdown
dateCreated: 2026-10-10T00:00:00.000Z
---

# WebUI Uploader

FluidNC has a small web page built into the firmware. Its main job is getting a [WebUI](/en/features/webui) onto the controller. You can also use it to look at, upload and delete files, and to update the firmware. It works even when the local file system is empty, so you can always get back to it.

## Opening the WebUI Uploader

Browse to the controller, for example `http://fluidnc.local/`, using your controller's hostname or IP address. You get the WebUI Uploader when no WebUI is installed. FluidNC chooses what to show at `/` like this:

1. If [HTTP/DefaultUI](#choosing-the-webui-you-get-at) names an installed WebUI, it redirects to that WebUI.
2. Otherwise, if the local file system has an `index.html.gz` or `index.html`, it shows that WebUI.
3. Otherwise, it shows the WebUI Uploader.

To get the WebUI Uploader even when a WebUI is installed, browse to:

```
http://fluidnc.local/?forcefallback=yes
```

This is the way out when an installed WebUI is broken or fails to load. The list of WebUIs at `http://fluidnc.local/ui/` also links to the WebUI Uploader.

## The Page

- **Help button:** opens this page. It needs an internet connection, so it does not work when your computer is connected to the controller's own WiFi access point. The firmware version is shown at the right.
- **Go to WebUI:** a button for each installed WebUI, which opens it. If none are installed, it says that no WebUI `index.html.gz` files are present.
- **File panel:** the file browser. Its **Manage Files on** buttons choose what it shows: **LocalFS**, **SD** or **WebUIs**.
- **Firmware Update panel:** installs a new firmware over WiFi, called an OTA update.

## The LocalFS View

This view shows the [local file system](/en/features/local_file_system) in the ESP32's flash memory. That is where `config.yaml`, macro files and WebUI preference files live, and usually the main WebUI's `index.html.gz` too.

- **Upload:** click **Upload** and choose a file. It uploads right away into the directory you are viewing, replacing any file of the same name.
- **Download:** click a file's name.
- **Delete:** click the red trash can next to a file or directory, then confirm.
- **New directory:** click the folder with the **+**. Subdirectories work only on LittleFS. See [File System Migration](/en/support/filesystem_migration).
- **Navigate:** click a directory to open it, and **Up..** or the path bar to go back.
- **Refresh:** lists the directory again, for example after changing files with `$` commands.

The status line at the bottom shows how much of the file system is used.

When the local file system has an `index.html.gz` or `index.html`, a **Default** button opens `/`. That is the WebUI chosen by [HTTP/DefaultUI](#choosing-the-webui-you-get-at) if it is set, and otherwise this one. To install the standard WebUI, upload the `index.html.gz` from the release's `wifi` folder.

## The SD View

Select **SD** to browse the SD card, starting at its top directory. It works the same way as the LocalFS view. Clicking a file opens it at its `/sd/...` address.

## The WebUIs View

FluidNC can hold several WebUIs at once and you can switch between them. Each WebUI lives in its own subdirectory of the directory named by the `$HTTP/UIDir` setting, which is `/sd/ui` by default. A WebUI named `webui3` is in `/sd/ui/webui3/`, and you open it at `http://fluidnc.local/ui/webui3/`.

Select **WebUIs** to browse that directory. It works like the LocalFS view, except that the top level is the WebUI directory:

- Each directory at the top level is one WebUI, and a button appears for each. Its name is the directory's name.
- Clicking a file opens it in a new tab, at its `/ui/<name>/...` address, the way the WebUI itself sees it.

### Installing a WebUI

1. Select **WebUIs**.
2. Click the folder with the **+** and type a name for the WebUI, such as `webui3`. Use only letters, digits, `-`, `_` and `.`.
3. Open the new directory.
4. Upload the WebUI's `index.html.gz` (or `index.html`) into it.
5. Reload the page. A **webui3** button appears.

Each WebUI keeps its own preference files in its own directory, so several WebUIs, or several copies of one WebUI, don't overwrite each other's settings. Some older WebUIs instead use absolute paths for their files, and keep their preferences on the local file system as before.

To remove a WebUI, delete its directory.

### Choosing the WebUI you get at /

Set `$HTTP/DefaultUI` to a WebUI's name to make `http://fluidnc.local/` open that WebUI:

```
$HTTP/DefaultUI=webui3
```

Set it to nothing (`$HTTP/DefaultUI=`) to go back to the local file system's `index.html.gz`, or the WebUI Uploader if there is none.

### Keeping WebUIs somewhere else

`$HTTP/UIDir` can name any directory on the SD card or the local file system:

```
$HTTP/UIDir=/sd/ui
$HTTP/UIDir=/localfs/ui
```

The local file system is small, and putting WebUIs there requires LittleFS. The SD card is usually the better place. If the SD card is missing, WebUIs that are stored on it are not available, but the local file system's WebUI and the WebUI Uploader still work.

## Updating the Firmware

The **Firmware Update** panel installs a `firmware.bin` from a release's `wifi` folder:

1. Click **Choose File** and select `firmware.bin`.
2. Click **Update** and confirm.
3. Wait while the file uploads. FluidNC then restarts, and the page reloads after a countdown.

See [Installation](/en/installation) for more about updating.

## While a Job is Running

FluidNC does not read files during motion by default, so that it cannot disturb a job (see `$HTTP/BlockDuringMotion`). File operations and loading a WebUI that is not already cached may be refused until the machine stops.
