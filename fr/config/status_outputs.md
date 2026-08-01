---
title: 1.19 Sorties d'état
description: configuration des sortie d état
published: true
date: 2026-08-01T19:41:11.079Z
tags: fr
editor: markdown
dateCreated: 2025-03-18T18:22:31.555Z
---

# Sorties d'état

Cette fonction vous permet de lier une sortie à un état. Cela vous permet d'avoir quelque chose comme un voyant de pile sur votre machine.

![stack_light.png](/config/stack_light.png)

## Éléments de configuration

- **report_interval_ms** 
  - Type : Entier
  - Range : (100 à 5000) millisecondes
  - Valeur par défaut : 500
  - Détails : Il s'agit du taux de mise à jour de l'état. Vous recevez également une mise à jour automatique après les changements d'état, il n'est donc pas nécessaire qu'elle soit rapide.
 - **run_pin:**
   - Type : Broche (entrée)
   - Range : gpio ou i2so
   - Défaut : NO_PIN
   - Détails : Actif lorsque l'état est exécuté. 
- **hold_pin:**
   - Type : Broche (entrée)
   - Range : gpio ou i2so
   - Défaut : NO_PIN
   - Détails : Actif lorsque l'état est « hold ». 
- **alarm_pin:**
   - Type : Broche (entrée)
   - Range : gpio ou i2so
   - Défaut : NO_PIN
   - Détails : Actif lorsque l'état est une alarme.
- **pin_porte:**
   - Type : Broche (entrée)
   - Range : gpio ou i2so
   - Défaut : NO_PIN
   - Détails : Actif lorsque [l'entrée de la porte de sécurité](http://wiki.fluidnc.com/fr/config/control#safety_door_pin) est active. 

## Config Example

```yaml
status_outputs:
  report_interval_ms: 500
  idle_pin: gpio.26
  run_pin: gpio.4
  hold_pin: gpio.16
  alarm_pin: gpio.27
  door_pin: NO_PIN
```

# FAQ

## Peut-on inverser l'état ?

  Il suffit d'ajouter `:low` après la broche.

## Pouvez-vous ajouter d'autres états ?

Oui, il suffit de les ajouter au code et de soumettre un PR ou de faire un don pour nous demander de le faire. 


