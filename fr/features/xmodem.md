---
title: 2.13 XModem
description: XModem File Upload/Download
published: true
date: 2025-03-25T19:22:44.414Z
tags: fr
editor: markdown
dateCreated: 2025-03-23T16:02:10.193Z
---

# XModem file upload

Vous pouvez utiliser xmodem via le port série pour télécharger des fichiers dans le fichier local. Cela peut être utile pour télécharger des fichiers de configuration ou de gcode et d'autres ressources. Le contrôleur doit être en mode `Idle` ou `Alarm` pour pouvoir utiliser la fonction XModem.

FluidNC supporte le [XModem-1K](https://en.wikipedia.org/wiki/XMODEM#XMODEM-1K) avec CRC16. 

Voici quelques exemples d'implémentation du protocole dans différents langages de programmation. Toutes les bibliothèques existantes pour ce protocole avaient des parties manquantes ou n'implémentaient pas le protocole correctement. Elles peuvent être utilisées comme référence :

* [TypeScript](https://github.com/breiler/fluid-installer/blob/master/src/utils/xmodem/xmodem.ts)
* [Java](https://github.com/winder/Universal-G-Code-Sender/blob/master/ugs-core/src/com/willwinder/universalgcodesender/connection/xmodem/XModem.java)

## Envoi d'un fichier à FluidNC

Avant d'envoyer des fichiers au contrôleur FluidNC, vous devez entrer la commande `$Xmodem/Receive=<filename>` (ou `$XR=<filename>`). Le caractère 'C' s'affiche sur le terminal. Vous devez alors lancer le transfert xmodem sur votre programme de terminal. Si le transfert n'est pas lancé au bout d'un certain temps, il sera interrompu.

> L'emplacement par défaut du LocalFS, mais vous pouvez le spécifier avec **/sd/** ou **/localfs/**, comme `$Xmodem/Receive=/sd/test.gcode`
{.is-info}

```
?<Idle|WPos:0.000,0.000,-3.000|FS:0.000,0>

$XModem/Receive=new.yaml
[MSG:INFO: Receiving new.yaml via XModem]
C[MSG:INFO: Received 5433 bytes]
ok
?<Idle|WPos:0.000,0.000,-3.000|FS:0.000,0>
$localfs/list

[FILE:/foo.12|SIZE:0]
[FILE:/foo.1|SIZE:0]
[FILE:/foo.yam|SIZE:0]
[FILE:/test.yaml|SIZE:5]
[FILE:/favicon.ico|SIZE:1150]
[FILE:/index.html.gz|SIZE:116657]
[FILE:/new.yaml|SIZE:5433]
[Local FS Free:46.08 KB Used:123.29 KB Total:169.38 KB]
ok
```

## Téléchargement d'un fichier depuis FluidNC

Entrez la commande `$XModem/Send=<filename>`. Lancez ensuite la réception xmodem dans votre programme de terminal.

```
?<Idle|WPos:0.000,0.000,-3.000|FS:0.000,0>
$XModem/Send=index.html.gz
[MSG:INFO: Sending index.html.gz via XModem]
[MSG:INFO: Sent 116736 bytes]
ok
?<Idle|WPos:0.000,0.000,-3.000|FS:0.000,0|WCO:0.000,0.000,3.000>

```

## Programmes de terminal qui supportent XModem

La méthode la plus simple consiste à utiliser Fluidterm. Utilisez CTRL+T puis CTRL+X pour commencer le téléchargement. 

- Fenêtres
  - Tera Term
- Mac
  - [écran avec lrzsz](https://www.unixfu.ch/upload-firmware-to-a-switch-with-xmodem-from-a-mac/)
- Linux
  - [Minicom](https://launchpad.net/ubuntu/bionic/+package/minicom) avec [lrzsz](https://launchpad.net/ubuntu/bionic/+package/lrzsz)
  
