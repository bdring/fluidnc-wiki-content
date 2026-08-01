---
title: 1.2 Objets de configuration de haut niveau
description: configuration des paramètres de haut niveau (base)
published: true
date: 2026-08-01T19:41:16.007Z
tags: fr
editor: markdown
dateCreated: 2025-03-15T09:20:59.791Z
---

# Touches du haut de la page de FluidNC

Il s'agit de touches (et non de noms de sections) au niveau supérieur (non indenté). L'endroit où vous les placez n'a pas d'importance. Lors de la sortie du microprogramme, il se peut qu'elles ne soient pas regroupées.

- <a id="board">**board:**</a>
  - Type : [Chaîne](http://wiki.fluidnc.com/fr/config/overview#string)  
  - Portée : 80 caractères
  - Défaut : Chaîne vide  
  - Interactions : Aucune  
  - Détails : Texte descriptif tel que « ESP32 Dev Controller V4 ».

- <a id="name">**name:**</a>
  - Type : [Chaîne](http://wiki.fluidnc.com/fr/config/overview#string)
  - Portée : 80 caractères  
  - Défaut : Chaîne vide  
  - Interactions : Aucune
  - Détails : Une description de base de la machine telle que « Router XYYZ 10V Spindle ».

- <a id="meta">**meta:**</a>
  - Type : [Chaîne](http://wiki.fluidnc.com/fr/config/overview#string)  
  - Portée : 80 caractères  
  - Défaut : Chaîne vide  
  - Interactions : Aucune
  - Détails : Ce champ est utilisé pour stocker des informations sur le fichier de configuration, telles que "B. Dring 2022-03-15 Rev 2".  

- <a id="arc_tolerance_mm">**arc_tolerance_mm:** </a>
  - Type : [Float](http://wiki.fluidnc.com/fr/config/overview#float)
  - Plage de valeurs : 0,001 à 1,0 
  - Valeur par défaut : 0.002
  - Interactions : Aucune
  - Détails : FluidNC convertit les arcs en petits segments de ligne représentant l'arc. Cette valeur détermine à quel point les segments représentent l'arc. Cette valeur est rarement modifiée par l'utilisateur.

- <a id="junction_deviation_mm">**junction_deviation_mm:** </a>
  - Type : [Float](http://wiki.fluidnc.com/fr/config/overview#float) 
  - Plage de valeurs : 0,01 à 1,0
  - Valeur par défaut : 0.01
  - Interactions : Aucune
  - Détails : La déviation de la jonction est utilisée par le planificateur pour calculer les vitesses dans les virages. Il n'est généralement pas ajusté par l'utilisateur. Lire le code source du micrologiciel pour une description complète.

- <a id="verbose_errors">**verbose_errors:** </a>
  - Type : [Booléen](http://wiki.fluidnc.com/fr/config/overview#boolean)
  - Valeur par défaut : False
  - Détails : Imprime une chaîne d'erreur pour chaque code d'erreur. Cela peut ne pas être compatible avec certains expéditeurs de gcode.

- <a id="report_inches">**report_inches:**</a>
  - Type : [Booléen](http://wiki.fluidnc.com/fr/config/overview#boolean)
  - Valeur par défaut : False
  - Détails : La valeur est fixée à true (vrai) pour les pouces et à false (faux) pour les millimètres. Ceci ne concerne que les rapports et non les valeurs d'entrée.

- <a id="enable_parking_override_control">**enable_parking_override_control:**</a>
  - Type : [Booléen](http://wiki.fluidnc.com/fr/config/overview#boolean)
  - Valeur par défaut : False
  - Détails : Cette option permet de neutraliser la fonction de stationnement par le biais du code source. Lorsqu'il est vrai, M56 P0 désactive le stationnement et M56 P1 l'active.

- <a id="use_line_numbers">**use_line_numbers:** </a>
  - Type : [Booléen](http://wiki.fluidnc.com/fr/config/overview#boolean)
  - Valeur par défaut : False
  - Détails : Permet à FluidNC d'utiliser les numéros de ligne dans le gcode. Pour utiliser les numéros de ligne, définissez cette option à true. Les numéros de ligne sont indiqués dans le code avec N\<numéro de ligne\>, comme N100. Le numéro de ligne en cours d'exécution par le planificateur de mouvement sera affiché dans les rapports d'état avec Ln:100. S'il n'y a pas d'informations sur le numéro de ligne dans le code source, le rapport indiquera Ln:0.

- <a id=« planner_blocks »>**planner_blocks:** </a>
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Plage : [Integer](http://wiki.fluidnc.com/fr/config/overviewinteger) 59 10 - 120
  - Valeur par défaut : 16
  - Détails : Ce paramètre définit le nombre de blocs utilisés dans le planificateur. Il est conseillé de laisser la valeur par défaut, à moins que vous ne souhaitiez effectuer des réglages pour une application spéciale.

## Exemple

```yaml
board: ESP32 Dev Controller V4
name: ESP32 Dev Controller V4
meta: B. Dring 2022-03-15 Rev 2

arc_tolerance_mm: 0.002
junction_deviation_mm: 0.010
verbose_errors: false
report_inches: false
enable_parking_override_control: false
use_line_numbers: false
planner_blocks: 16
```

 
