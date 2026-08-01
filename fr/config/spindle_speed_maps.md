---
title: 2.9 Cartes de la vitesse de la broche
description: Comprendre les régalge de la vitesse de la broche
published: true
date: 2026-08-01T19:41:01.013Z
tags: fr
editor: markdown
dateCreated: 2025-03-22T20:53:36.613Z
---

# Cartographie de la vitesse de rotation de la broche FluidNC

FluidNC propose un moyen souple de contrôler la relation entre les valeurs S du code GC et les vitesses de broche.  Auparavant, la correspondance entre les valeurs S et la vitesse de rotation de la broche s'effectuait à l'aide de quelques paramètres globaux nommés GCode/MinS, GCode/MaxS, Spindle/PWM/Frequency, Spindle/PWM/Off, Spindle/PWM/Min, et Spindle/PWM/Max.  L'ancien schéma prévoyait une vitesse minimale pour les valeurs S non nulles inférieures à Spindle/PWM/Min, suivie d'une rampe linéaire de MinS à MaxS.  Le code comportait des stubs pour une courbe de cartographie multi-segments « linéaire par morceaux », mais elle n'a pas été mise en œuvre.

Dans le nouveau schéma, chaque broche (plusieurs peuvent être configurées à la fois) a sa propre « carte de vitesse » multi-segments qui peut faire tout ce que l'ancien schéma pouvait faire, et plus encore, y compris la cartographie linéaire par morceaux.  La base du système est une chaîne de texte qui énumère les « points d'inflexion » d'une courbe linéaire par morceaux, comme dans cet exemple :

**carte_de_vitesse : 0=0% 0=20% 4000=20% 8000=30% 16000=100%**

Chaque entrée se présente sous la forme **Svalue**=**spindle%** .  **Valeur** est la valeur du « mot S » du GCode, comme dans « M3 S1000 ».  **spindle%** est un pourcentage de 0 à 100% de la vitesse ou de la puissance maximale de la broche.  Il est tentant de considérer les valeurs S et la vitesse de la broche comme des tours/minute, mais c'est souvent incorrect.  Par exemple, une « broche » de laser ne tourne pas, donc « tours par minute » n'est pas correct.  Au niveau matériel, là où les broches sont effectivement contrôlées, le signal de commande peut prendre de nombreuses formes différentes avec des unités différentes.  Par exemple, une broche commandée par tension peut régler la vitesse à partir d'un signal de 0 à 10 V, et le matériel qui génère ce signal de 0 à 10 V peut à son tour être commandé par un nombre compris entre 0 et 1023.  La bonne façon d'envisager **la broche%** est que 100% correspond à la valeur maximale du signal de contrôle, quel qu'il soit.

Chaque entrée est un point dans un graphique qui convertit les nombres GCode S en vitesse ou en puissance de la broche.  Si S=0, la vitesse de la broche est fixée au premier pourcentage de la liste - typiquement 0%, mais ce n'est pas obligatoire.  Si S est différent de 0, le code recherche le premier point dont la valeur S est supérieure à S et utilise le segment situé juste à gauche de ce point.  La vitesse de la broche est interpolée à l'intérieur de ce segment.

Les vitesses demandées dont la valeur est supérieure à la vitesse maximale spécifiée dans la carte des vitesses utilisent le pourcentage le plus élevé. Ainsi, si la valeur la plus élevée est 18000=75% et que vous demandez une vitesse de 20000, elle sera toujours de 75%.

## Courbe linéaire parcellaire avec plateau de vitesse minimum

**carte_de_vitesse : 0=0% 0=20% 4000=20% 8000=30% 16000=100%**

correspond à ce graphique des valeurs S (axe horizontal) par rapport au % de la broche (axe vertical)

![speeds0_20_20_30_100.png](/speeds0_20_20_30_100.png)

Dans cet exemple, S=0 utilise 0%, S>0 et <4000 utilisent 20%, S>=4000 et <8000 est une rampe linéaire de 20% à 30%, S>=8000 et <16000 est une rampe linéaire de 30% à 100%.  Si S>= 16000, on utilise 100%, ce qui correspond au pourcentage de l'entrée finale.  L'« étagère » de (juste au-dessus) S0 à S4000 est une fonction commune de « vitesse minimale » qui est souvent utilisée pour les broches qui perdent du couple, ou ne peuvent pas fonctionner du tout, ou ont tendance à surchauffer à faible vitesse.  Le passage direct de l'arrêt à une vitesse minimale peut éviter d'endommager les embouts et les moteurs.

## Courbe linéaire avec zone morte

**carte_de_vitesse : 0=0% 1000=0% 10000=100%**

![speeds0_0_100.png](/speeds0_0_100.png)

Dans cet exemple, la vitesse ou la puissance de la broche est de 0% jusqu'à S=1000, puis augmente linéairement jusqu'à la pleine vitesse lorsque S=10000, et reste à la pleine vitesse si S>10000.

## Relais ou Arrêt/Marche de la broche

Vous pouvez spécifier que toute valeur S non nulle active la broche avec

**speed_map : 0=0% 0=100% 1=100%**

La transition entre l'arrêt (0 %) et l'allumage complet (100 %) se produit juste après 0. Le graphique de cette transition est trivial et n'est pas représenté ; il s'agit simplement d'une ligne verticale allant de 0 à 100 % à S=0.

## Broche entièrement linéaire

**speed_map : 0=0% 10000=100%**

![speeds0_100.png](/speeds0_100.png)

Il s'agit d'un cas simple où la vitesse/puissance de la broche augmente linéairement entre S=0 et S=10000, sans comportement particulier pour les basses vitesses.

## Spindle% non nul à S=0

Le **spindle%** de la première entrée ne doit pas nécessairement être 0%.  Vous pouvez avoir une broche pour laquelle S=0 nécessite une valeur non nulle pour un signal de contrôle.

**speed_map : 0=20% 10000=100%**

![speeds20_100.png](/speeds20_100.png)

Une courbe comme celle-ci peut être utilisée avec une boucle de courant 4-20mA, par exemple.

## Broche maximale% < 100%

Supposons que vous ayez une broche dont la vitesse maximale est de 24 000 tr/min lorsque son signal de commande est de 100 %, mais que vous souhaitiez limiter la vitesse à, disons, 18 000 tr/min parce que, disons, les roulements surchauffent à des vitesses plus élevées.

**carte_de_vitesse : 0=0% 0=25% 6000=25% 18000=75%**

![speeds0_25_25_75.png](/speeds0_25_25_75.png)

Remarquez que la vitesse/puissance de la broche s'arrête à 75 %.  Toute valeur S supérieure à 18000 sera limitée à 75%.

# Exemples

## Super-PID

Quelqu'un sur Discord a signalé que cela fonctionnait bien avec le [Super-PID router speed controller](https://www.vhipe.com/product-private/SuperPID-Home.htm). Il respecte la vitesse minimale appropriée. Des questions ? Cherchez Super-PID sur notre [Discord](http://wiki.fluidnc.com/#discussion).

**carte_de_vitesse : 0=0.000% 5000=18% 27000=100.000%**

# Feuille de calcul graphique

Voici un [lien vers un tableur graphique Google](https://docs.google.com/spreadsheets/d/15zuaLm9CnoRoeVbWtjw4LBzyiUzYyxpxcI69XkNcUoA/edit?usp=sharing) que vous pouvez utiliser pour créer les graphiques présentés ci-dessus.







