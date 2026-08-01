---
title: 1.12 Entrée utilisateur
description: 
published: true
date: 2026-08-01T19:41:29.307Z
tags: fr
editor: markdown
dateCreated: 2025-03-29T20:26:58.220Z
---

# Entrées utilisateur

Les entrées utilisateur vous permettent d'avoir des broches qui peuvent être lues par le gcode [commande M66](http://wiki.fluidnc.com/fr/features/supported_gcodes#m66-read-user-input).

> Seules les entrées numériques sont prises en charge à l'heure actuelle.
{.is-warning}

## Numérique

  Les broches `digital0_pin` à `digital7_pin` peuvent être définies.

- <a name="digital0_pin"></a> **digital0_pin:**
   - Type : [Pin](http://wiki.fluidnc.com/fr/config/overview#pin).
   - Portée : gpio ou canal E/S UART
   - Défaut : NO_PIN
   - Détails : la broche peut être lue par la commande [M66]() : La broche peut être lue par la [commande M66](http://wiki.fluidnc.com/fr/features/supported_gcodes#m66-read-user-input).
   
```yaml
  user_inputs:
  analog0_pin: NO_PIN
  analog1_pin: NO_PIN
  analog2_pin: NO_PIN
  analog3_pin: NO_PIN
  digital0_pin: gpio.12:low
  digital1_pin: NO_PIN
  digital2_pin: NO_PIN
  digital3_pin: NO_PIN
  digital4_pin: NO_PIN
  digital5_pin: NO_PIN
  digital6_pin: NO_PIN
```
  