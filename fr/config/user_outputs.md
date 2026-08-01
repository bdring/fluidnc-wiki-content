---
title: 1.11 Utilisation des Outputs
description: configuration des signaux de sortie
published: true
date: 2026-08-01T19:41:44.400Z
tags: fr
editor: markdown
dateCreated: 2025-03-15T19:50:41.956Z
---

# Vue d'ensemble

Les sorties utilisateur vous permettent d'émettre des signaux numériques (on/off) et analogiques (PWM) via le gcode. Le code est synchronisé. Cela signifie que le changement sur la broche de sortie se produit après que tous les codes g précédents dans la mémoire tampon ont été exécutés.

# Configuration

## Analogique

Les broches 0 à 3 peuvent être définies

- <a name="analog0_pin"></a>**analog0_pin:**
 - Type : [Broche](http://wiki.fluidnc.com/fr/config/overview#Pin)
   - Plage : gpio
   - Défaut : NO_PIN
   - Détails : un signal PWM est émis sur cette broche : Un signal PWM est émis sur cette broche. Il est contrôlé par la [commande M67] (http://wiki.fluidnc.com/en/features/supported_gcodes#m67-analog-output). **M67 E0 Q23.87** active l'analogique 0 avec un rapport cyclique de 23,87 %. **M67 E0 Q0** éteint l'analogique 0.
  
- <a name="analog0_hz"></a>**analog0_hz:**
  - Type : [Entier](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Plage de valeurs : 1 à 20000000
  - Valeur par défaut :
  - Détails : Fréquence du signal PWM.
  
> Le signal analogique peut être utilisé pour contrôler des servos RC. Considérons un servo 50Hz (typique) avec une plage d'impulsions de 1ms à 2ms. 50Hz a une période de 20ms, donc 5% est 1ms et 10% est 2ms. 
{.is-info}

## Numérique

  Les broches numériques 0 à 7 peuvent être définies.
  
   - <a name="digital0_pin"></a>**digital0_pin:**
- Type : [Broche](http://wiki.fluidnc.com/config/overview#pin)
   - Gamme : gpio ou i2so
   - Défaut : NO_PIN
   - Détails : la sortie est sur cette broche : La sortie est sur cette broche. Elle est contrôlée par les [commandes M62, M63, M64 et M65](http://wiki.fluidnc.com/fr/features/supported_gcodes#m62-m63-m64-m65-digital-output). **M62 P0** Active la broche digital0. **M63 P0** Désactive la broche digital0. Comme pour toutes les broches de sortie, vous pouvez définir l'[état actif](http://wiki.fluidnc.com/fr/config/config_IO#output-pin-attributes) avec l'attribut `:high` ou `:low`.

Exemples de configuration :  
  
```yaml
user_outputs:
  analog0_pin: gpio.13
  analog1_pin: gpio.14:low
  analog2_pin: NO_PIN
  analog3_pin: NO_PIN
  analog0_hz: 5000
  analog1_hz: 5000
  analog2_hz: 5000
  analog3_hz: 5000
  digital0_pin: gpio.26
  digital1_pin: gpio.4
  digital2_pin: i2so.5
  digital3_pin: i2so.6:low
  digital4_pin: NO_PIN
  digital5_pin: NO_PIN
  digital6_pin: NO_PIN
  digital7_pin: NO_PIN
```