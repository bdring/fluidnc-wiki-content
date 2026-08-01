---
title: 1.17 Connecteur IO
description: configuration des connecteurs io
published: true
date: 2026-08-01T19:40:05.016Z
tags: fr
editor: markdown
dateCreated: 2025-03-17T20:29:50.905Z
---

# Configuration des broches

Vous devez attribuer un numéro de broche et des attributs à chaque broche utilisée dans votre configuration. FluidNC sait si la broche est une entrée, une sortie, etc. en fonction de la fonction à laquelle elle est affectée. Par exemple, il sait que le GPIO assigné à un interrupteur de fin de course sera toujours une entrée. Il existe quelques attributs pour chaque type de broche. Chaque attribut a un état par défaut, ils sont donc tous optionnels. Chaque attribut est précédé de deux points. Ils peuvent être utilisés dans n'importe quel ordre.

## Numéros de broches

Il existe actuellement deux types de broches qui peuvent être utilisées, **gpio** et **i2so**. Vous spécifiez une broche avec le type, suivi d'un point, suivi du numéro de la broche. Par exemple, **gpio.14** ou **i2so.24**.

- **gpio** Il s'agit des broches natives de l'ESP32. Elles sont assez flexibles et peuvent être utilisées pour la plupart des fonctions.
- **i2so** Ces broches sont sur des puces I2S externes. Elles sont uniquement des sorties et ne peuvent pas être utilisées pour des fonctions avancées telles que PWM. Ils ne sont disponibles que sur les contrôleurs qui les implémentent, comme le 6 Pack. **Note:** Lors de la mise sous tension initiale, ils s'allument souvent brièvement. Gardez cela à l'esprit si vous les utilisez pour allumer des appareils. Pensez à les allumer après le démarrage.

## Section i2So

Si vous utilisez des broches de sortie i2so, vous devez avoir une section **i2so** dans votre fichier de configuration. Il s'agit des broches de contrôle pour les puces i2so.

Exemple :

```yaml
i2so :
  bck_pin : gpio.22
  broche_données : gpio.21
  ws_pin : gpio.17
  min_pulse_us : 2
```

- **min_pulse_us:**
    - **Type:** Entier
    - **Range:** Vous ne pouvez utiliser que 1, 2 ou 4
 - **Par défaut:** 2
    - **Détails:** Ce paramètre définit la longueur minimale de l'impulsion. La plupart des gens devraient utiliser 2. Vous devrez peut-être utiliser 4 pour les puces I2S plus lentes comme celles des contrôleurs Roots ou MKS. Utilisez 1 pour des taux de pas extrêmement rapides. 

> Avertissement : Les broches I2SO sont allumées dans un état indéterminé à la mise sous tension. Le micrologiciel les met rapidement dans l'état souhaité. Cela signifie que la broche peut être dans le mauvais état pendant une fraction de seconde à la mise sous tension. Elles conserveront leur état actuel si le microprogramme est réinitialisé. Si elles contrôlent une broche, un laser ou d'autres éléments dangereux, vous devez les mettre sous tension après l'exécution du microprogramme.
{.is-warning}

## Attributs des broches d'entrée

- **État actif** Chaque caractéristique d'entrée a un état actif. Par exemple, l'état actif d'un interrupteur est lorsque l'interrupteur est actionné. En fonction du type d'interrupteur et de son câblage, l'interrupteur peut être connecté à une tension basse (masse) ou à une tension haute logique vers l'unité centrale de traitement lorsque l'interrupteur est actionné. Vous le spécifiez dans votre configuration avec l'attribut **high** ou **low**. Exemples : **gpio:14:high** ou **gpio.14:low** La valeur par défaut **high** sera utilisée si elle n'est pas spécifiée. Si votre commutateur fournit des informations inverses à celles que vous souhaitez, remplacez **:high** par **:low** ou inversement. 
- **Résistance de tirage** Vous pouvez ajouter une résistance interne de tirage vers le haut ou vers le bas aux broches d'entrée qui les supportent. Cette opération s'effectue à l'aide de l'attribut **pu** (pull-up) ou **pd** (pull-down). Exemples : **gpio.14:high:pd** ou **gpio.14:low:pu**. Par défaut, il n'y a pas de résistance de traction. La broche sera flottante à moins que vous n'ayez un circuit externe qui la tire dans un sens ou dans l'autre. Cela provoque généralement des lectures incorrectes de la broche lorsque le circuit est à l'état ouvert. ***Note:*** [Certaines broches ne supportent pas](http://wiki.fluidnc.com/fr/hardware/esp32_pin_reference) les résistances de tirage internes et vous devez en fournir une externe.

Exemple :

```yaml
  limit_all_pin : gpio.16:low:pu
```

## Attributs des broches de sortie

- État actif** Chaque caractéristique de sortie a un état actif. Cela signifie généralement que la fonction est activée. En fonction de votre circuit, un signal de sortie faible ou élevé activera la fonction. Vous le spécifiez dans votre configuration avec l'attribut **high** ou **low**. Exemples : **gpio:14:high** ou **gpio.14:low** La valeur par défaut est **high** si elle n'est pas spécifiée.

Si votre fonctionnalité fonctionne à l'envers (inversée, dans le mauvais sens, retournée) par rapport à ce que vous voulez, comme la broche de direction d'un moteur, retournez le hi vers le low, ou l'inverse.

Exemple :

```yaml
  coolant:
    flood_pin : gpio.25:low
```

## Les types d'épingles et leur utilisation

Il existe trois types de broches de base

* GPIO - une broche qui est directement pilotée ou détectée par la puce ESP32.  En ce qui concerne l'ESP32, une broche GPIO peut être utilisée pour l'entrée ou la sortie, mais les cartes de contrôleur ont généralement des circuits entre la broche de l'ESP32 et le connecteur sur le bord de la carte.  Ces circuits limitent souvent l'utilisation de la broche en question.  Par exemple, s'il y a une puce tampon/pilote pour fournir une sortie de 5V, son GPIO ne peut pas être utilisé en tant qu'entrée.  De même, s'il y a un circuit de conditionnement d'entrée, son GPIO ne peut pas être utilisé comme sortie.  La seule façon de le savoir est de consulter la documentation ou les schémas de la carte concernée.
* I2SO - une broche de sortie seulement qui est pilotée par la sortie d'un registre à décalage.  La chaîne de registres à décalage est à son tour pilotée par les broches de l'ESP32 qui sont configurées pour utiliser le bus « I2S ».  Cette fonction n'est disponible que sur des cartes spécifiques qui incluent les registres à décalage.  Les broches I2SO sont particulièrement utiles pour piloter les broches step, dir et enable des pilotes pas à pas.  Elles peuvent être utilisées à d'autres fins, telles que les broches de sélection de puce pour les pilotes TMC configurés en SPI et les activations de sortie de broche.  Les broches I2SO ne peuvent pas être utilisées pour les sorties PWM.  Si une carte supporte I2SO, les signaux pas à pas seront toujours câblés comme des broches i2so.  Il n'est pas possible de piloter certains pas à partir de i2so et d'autres à partir de gpio.
* uart_channel - une broche qui est pilotée ou détectée par un périphérique externe « IO Expander » qui communique avec l'ESP32 via un UART série. 




