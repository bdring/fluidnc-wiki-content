---
title: Developer Tips and Trick
description: 
published: true
date: 2026-08-01T19:35:14.562Z
tags: 
editor: markdown
dateCreated: 2024-05-14T15:25:56.408Z
---

# Here are some tips for developers.


## Creating a custom localfs partition

You can create a custom partition with a config file, macros, etc pre-installed. This is helpful if you plan on deploying several controllers with the same setup.

> If you name your config file `config.yaml`, it will automatically be loaded.
{.is-info}


This requires using vscode and installing via the release package. The example shown is for the wifi firmware. You can do the same for BT, using the BT folders instead of the wifi folders. 

1. Download the release package of the revision you want to install and expand the zip file on your computer
2. Download the source files from the main branch.
3. Add the files you want in the localfs to the data folder.
4. Run `BuildFilesystem Image` from the Platformio menu `Project Tasks/wifi/platform`. This will create a `littlefs.bin` file in the `.pio/build/wifi` folder of the repo you downloaded.
5. Copy the `littlefs.bin` file you created over the one in the release package in the `wifi` folder.

![build_littlefs.png](/development/build_littlefs.png)



