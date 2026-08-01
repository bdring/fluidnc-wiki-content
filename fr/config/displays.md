---
title: 1.18 Ecran
description: configuration d'ecran annexe
published: true
date: 2026-08-01T19:40:26.114Z
tags: fr
editor: markdown
dateCreated: 2025-03-18T18:15:42.336Z
---

# Afficheurs

Tous les développements futurs des écrans doivent être effectués en utilisant [UART Channels](http://wiki.fluidnc.com/fr/config/uart_sections#uart-channels). 

Tout le monde utilise le même fichier compilé de FluidNC. Cela signifie que toutes les options pour tout le monde doivent être compilées dans le même fichier. Cela nous obligerait à limiter considérablement le nombre d'affichages et de langues que nous pourrions prendre en charge.

L'utilisation de canaux UART permet d'utiliser n'importe quel écran intelligent. Nous n'avons pas non plus besoin de limiter les langues en raison d'une mémoire limitée. 

Ce concept est similaire à celui de la prise en charge des expéditeurs de gcode. Nous n'utilisons pas un protocole différent pour chaque expéditeur. Tout le monde utilise le protocole commun Grbl.

## Legacy Small OLEDs

![oled_display.jpg](/config/oled_display.jpg =x200)

> La prise en charge de cet affichage a été ajoutée avant la fonction Canaux UART. C'est le seul affichage que nous supportons directement dans le firmware et nous le supprimerons probablement à un moment donné.
{.is-info}

Il s'agit de petits écrans OLED 1 ou 2 couleurs utilisant les communications I2C. Ils utilisent le circuit intégré de commande d'affichage SSD1306. Il s'agit généralement d'écrans d'une résolution de 128x64 ou 64x48. Ils sont utilisés pour l'état de base et pour afficher les paramètres WiFi ou Bluetooth lorsqu'une connexion USB n'est pas utilisée.

### Fichier de configuration

Vous devez d'abord définir une section d'interface I2C

 Voir cette page wiki (TBD)

Définir ensuite une section **oled:**.

 - **i2c_num:**
   - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
   - Range : 0 ou supérieur
   - Valeur par défaut : 0
   - Détails : Indique l'interface I2C que vous avez définie (voir ci-dessus).
 - **i2C_address:**
   - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer) 
   - Valeur par défaut : 60
   - Détails : Adresse du circuit intégré I2C. Il s'agit généralement de l'adresse 60.
  - **largeur:**
    - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
    - Valeur par défaut : 64
    - Détails : Largeur de l'écran. Elle est généralement de 128 ou 64. Elle est utilisée pour le formatage de l'écran.
  - **hauteur:**
    - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
    - Valeur par défaut : 48
    - Détails : Hauteur de l'affichage. Elle est généralement de 64 ou 48. Elle est utilisée pour le formatage de l'écran.
  - **radio_delay_ms:**
    - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
    - Range : 0-65535
    - Valeur par défaut : 0
    - Détails :  Retarde d'un certain nombre de millisecondes l'affichage des informations relatives au WiFi et à la BT, afin que vous ayez le temps de consulter, par exemple, l'adresse IP.

```yaml
i2c0:
   sda_pin: gpio.14
   scl_pin: gpio.13

oled:
   i2c_num: 0
   i2c_address: 60
   width: 128
   height: 64
   radio_delay_ms: 1000
```
