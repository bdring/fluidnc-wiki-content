---
title: 3.7 Expéditeurs GCode
description: Logiciel Gcode
published: true
date: 2025-03-27T19:06:22.478Z
tags: fr
editor: markdown
dateCreated: 2025-03-27T19:06:14.146Z
---

# Grbl GCode Senders

FluidNC est conçu pour avoir une compatibilité de base avec les émetteurs Grbl utilisant la connexion USB/Série. La compatibilité se concentre sur l'exécution de votre machine et l'envoi de gcode.

FluidNC n'est pas compatible avec Grbl en ce qui concerne la configuration des paramètres et des options. FluidNC dispose d'un système beaucoup plus souple et complet. Les paramètres Grbl $$ et les options de compilation étaient beaucoup trop restrictifs, c'est pourquoi nous avons créé le système de fichiers de configuration.

Vous trouverez ci-dessous des liens vers des expéditeurs de code g. Ils n'ont pas tous été testés avec FluidNC. Ils n'ont pas tous été testés avec FluidNC. Si vous souhaitez en ajouter un à cette liste, faites-le nous savoir.

## Universal GCode Sender (aka UGS)

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/ugs.png" width="500">

[Site web](https://winder.github.io/ugs_website/)

## LaserGRBL

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/lasergrbl.jpg" width="500">

* [Site web](https://lasergrbl.com/)

## LaserWeb4

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/LaserWebDec2016.png" width="600">

* [Github](https://github.com/LaserWeb/LaserWeb4)

* [Site web](https://cncpro.yurl.ch/)

## Candle

<img src="https://github.com/Denvi/Candle/raw/master/screenshots/screenshot_heightmap_original.png" width="600">

* [Site web](https://github.com/Denvi/Candle)

## CNCJS

Après la connexion, cliquez sur le bouton de réinitialisation pour synchroniser Grbl_ESP32 et CNCJS.

<img src="https://cloud.githubusercontent.com/assets/447801/24392019/aa2d725e-13c4-11e7-9538-fd5f746a2130.png" width="600">

* [Site web](https://cnc.js.org/) 

## Grbl-Plotter

<img src="https://github.com/svenhb/GRBL-Plotter/raw/master/doc/GRBLPlotter_GUI.png" width="400">

* [Site web](https://github.com/svenhb/GRBL-Plotter)

## Focus - Système de commande CNC 6 axes sur PC

<img src="https://cdn.sourcerabbit.com/Data/FluidNCWiki/Focus.png" width="600">

* [Site web](https://www.sourcerabbit.com/Shop/pr-i-91-t-focus-cnc-control-software.htm)

## LightBurn (Lasers)

<img src="http://www.buildlog.net/blog/wp-content/uploads/2021/01/lightburn.png" width="600">

* [Site web](https://lightburnsoftware.com/)
* [Page wiki FluidNC](http://wiki.fluidnc.com/en/support/senders/lightburn)

## EstlCAM

* [Website](https://www.estlcam.de/)


## bCNC

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/bCNC.png" width="600">

- [Site web](https://github.com/vlachoudis/bCNC)

## Chilipeppr

<img src="https://github.com/bdring/Grbl_Esp32/wiki/images/chilipeppr.jpg" width="600">

- [Site web](http://chilipeppr.com/jpadie)

## OpenCNCPilot

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/opencncpilot.png" width="600">

* [Github](https://github.com/martin2250/OpenCNCPilot)

## Grbl Panel

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/Grbl-Panel-Example.jpg" width="600">

- [Site web](https://github.com/gerritv/Grbl-Panel/wiki)

## Ultimate CNC

<img src="https://github.com/bdring/FluidNC/wiki/images/senders/ultimate_cnc.png" width="600">

- [Site web](https://ultimatecnc.softgon.net/en/home)

## OpenBuilds CONTROL

<img src="/openbuilds_control.png" width="600" alt="OpenBuilds CONTROL screenshot" />

CONTROL se connecte au websocket du build wifi dès sa sortie de la boîte.

* [Website](https://software.openbuilds.com)
* [Problème d'intégration FluidNC](https://github.com/OpenBuilds/OpenBuilds-CONTROL/issues/283)

## Contrôle des fluides

<img src="https://mitov84.github.io/images_fluid/Wiki_feature.png" width="600" alt="Fluid Control feature image" />

Contrôle des fluides : 

- [Application Android](https://artisans3d.com/projects/fluid-control-android-app/), se connecte à Telnet par Wi-Fi. Freemium.
- [iOS, iPadOS app](https://artisans3d.com/projects/fluid-control-pro-ios-application/), se connecte à Telnet par Wi-Fi. Sur abonnement.

# Info développeur

## Démarrage

Grbl original était basé sur des Arduinos qui redémarrent généralement lorsque vous vous y connectez. Lorsqu'un expéditeur ouvre une connexion, il peut immédiatement reconnaître Grbl par les premiers messages qu'il envoie.

FluidNC préfère ne pas être redémarré lorsqu'il est connecté. FluidNC prend en charge plusieurs types de connexion, notamment Wifi et Bluetooth. Un redémarrage romprait ces connexions et risquerait d'interrompre un travail en cours. Le rétablissement de ces connexions peut prendre beaucoup de temps.

Voici un bon organigramme pour déterminer la version (FluidNC, Grbl, etc.) dans tous les cas.

![sender_flowchart.png](/support/sender_flowchart.png)

```
Grbl 3.4 [FluidNC v3.4.2 (wifi) '$' pour l'aide]
```

Si votre expéditeur est très pointilleux sur le texte exact et la révision du message, vous pouvez le modifier avec la [commande] **$Start/Message** (/features/commandes_et_settings#start_message).

Nous ne voulons pas qu'une connexion redémarre arbitrairement le micrologiciel. Cela signifie que certains expéditeurs ne verront pas le message. La plupart des contrôleurs ou des modules ESP32 disposent d'un bouton de réinitialisation manuelle.


Si vous avez des problèmes ou des questions à ce sujet, veuillez contacter les développeurs avant de nous contacter.



