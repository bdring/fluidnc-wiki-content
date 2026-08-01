---
title: 2.7 E Boutons d'arrêt
description: E-Stops et substituts
published: true
date: 2025-03-25T19:20:12.447Z
tags: fr
editor: markdown
dateCreated: 2025-03-22T17:39:29.774Z
---

# E Boutons d'arrêt

![](https://github.com/bdring/FluidNC/wiki/images/e_stop.jpg)

FluidNC ne prend pas directement en charge les boutons d'arrêt d'urgence. C'est intentionnel. Un bouton d'arrêt d'urgence doit couper l'alimentation principale. Le fait de s'appuyer sur un micrologiciel va à l'encontre de l'un des principaux objectifs d'un bouton d'arrêt d'urgence.

## Arrêts moins urgents

Si vous souhaitez vous arrêter rapidement, mais qu'il ne s'agit pas d'une véritable urgence et que le firmware fonctionne toujours, vous pouvez utiliser ces alternatives [control inout](http://wiki.fluidnc.com/fr/config/control). Toutes ces commandes peuvent être envoyées via un expéditeur gcode, l'interface WebUI ou un bouton matériel.

- **Maintien de l'alimentation**. Cette fonction permet d'arrêter très rapidement la machine sans perte de position. Il peut être repris avec le démarrage du cycle. La commande de maintien de l'alimentation est le caractère «  ! ». La broche matérielle est configurée avec **feed_hold_pin**.
- **Reset**. Cette commande arrête immédiatement la machine et la broche, mais la position est perdue et vous devrez revenir à la position initiale. Les moteurs resteront enclenchés si la valeur de **idle_ms** est de 255. La commande est CTRL-X (0x18).  La broche matérielle est configurée avec **reset_pin**. Cette commande peut être utilisée parallèlement à un véritable arrêt d'urgence. L'alimentation sera coupée et FluidNC se réinitialisera.
- **Porte/Parking**. Cette fonction est utilisée pour une porte d'enceinte. Si la porte est ouverte pendant un travail, le mouvement s'arrête rapidement, la broche s'arrête et se rétracte plus loin du travail. La commande est le caractère 0x84. La broche matérielle est configurée avec **safety_door_pin**. 

```yaml
control:
  safety_door_pin: NO_PIN
  reset_pin: NO_PIN
  feed_hold_pin: NO_PIN
```


