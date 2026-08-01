---
title: 1.8 Refroissement
description: configuration des options de refroidissement
published: true
date: 2026-08-01T19:40:21.437Z
tags: 
editor: markdown
dateCreated: 2025-03-16T10:13:49.766Z
---

# Liquide de refroidissement

Il s'agit de broches de sortie contrôlées par [M7](http://wiki.fluidnc.com/fr/features/supported_gcodes#m7-m71-mist-coolant), [M8](http://wiki.fluidnc.com/fr/features/supported_gcodes#m8-m81-flood-coolant) et [M9](http://wiki.fluidnc.com/fr/features/supported_gcodes#m9-coolant-off). Elles sont traditionnellement appelées « mist » et « flood », mais beaucoup de gens les utilisent pour d'autres choses comme l'extraction de poussière, etc. M9 désactive les deux.

- <a id="mist_pin"></a>**mist_pin:**
- Type : [Pin](http://wiki.fluidnc.com/fr/config/config_IO) (sortie)
  - Plage : gpio ou I2SO
  - Défaut : NO_PIN
  - Détails : Cette fonction est utilisée pour contrôler un dispositif de refroidissement par brouillard. M7 active le dispositif de refroidissement du brouillard et M9 le désactive.
- <a id="flood_pin"></a>**flood_pin:**
  - Type : [Pin](http://wiki.fluidnc.com/fr/config/config_IO) (sortie)
  - Plage : gpio ou I2SO
  - Valeur par défaut : NO_PIN
  - Détails : Cette fonction est utilisée pour contrôler un dispositif de refroidissement par inondation. M8 active le refroidissement par inondation et M9 le désactive.
- <a id="delay_ms"></a>**delay_ms:**
  - Type : [Entier](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Plage de valeurs : 0 à 10000
  - Valeur par défaut : 0
  - Détails : Délai en millisecondes après la mise en marche de M7 et M7. Il n'y a pas de délai si le liquide de refroidissement est déjà activé. Ce délai ne s'applique pas à M9.

## Exemple de configuration:

```yaml
coolant:
  flood_pin: gpio.14
  mist_pin: NO_PIN
  delay_ms: 0
```


