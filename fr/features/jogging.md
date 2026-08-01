---
title: 2.11 Jogging
description: 
published: true
date: 2025-03-25T19:22:00.947Z
tags: fr
editor: markdown
dateCreated: 2025-03-23T15:42:12.794Z
---

# Jogging FluidNC

FluidNC utilise la méthode de jogging Grbl v1.1. Voir le [Grbl wiki](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Jogging) pour plus de détails.


Chaque commande de jogging est indépendante des valeurs modales et des vitesses d'avance existantes. Elle ne modifie pas les valeurs modales existantes.

  - Mots requis
    - `XYZABC` Vous avez besoin d'au moins d'un lette d'axe.
    - `F` Vous avez besoin d'une [vitesse d'avance](http://wiki.fluidnc.com/fr/features/supported_gcodes#f-feed-rate) pour chaque commande de jogging.
    - `G90/G91` Vous pouvez spécifier le [mode de distance](http://wiki.fluidnc.com/fr/features/supported_gcodes#g90-g91-distance-mode), sinon la valeur actuelle sera utilisée.
    - `G20/G21` Vous pouvez spécifier les [unités, pouces ou mm](http://wiki.fluidnc.com/fr/features/supported_gcodes#g20-g21-units), sinon la valeur actuelle sera utilisée.
    - `G53` Vous pouvez spécifier un [déplacement dans l'espace machine ](http://wiki.fluidnc.com/fr/features/supported_gcodes#g53-use-machine-coordinates)absolu. 
    
Exemples

```gcode
$J=X10.0 Y-1.5 F100 ;se déplacer vers les coordonnées de travail X10 Y-1,5 à une vitesse de 100
$J=G91 F200 Z5 ; se déplacer de +5 unités sur Z à une vitesse de 200
$J=G53 Y5.0 F100 ; se déplacer vers la coordonnée machine Y5.0 à une vitesse de 100  
```

## FluidNC Différences

La seule modification que nous avons apportée concerne les limites souples. Avec Grbl, si vous avez activé les limites souples et que vous essayez de vous déplacer en dehors de la distance configurée, vous obtiendrez une alarme de limite souple. Avec FluidNC, le jogging sera limité à la plage de limites souples. Par exemple : Si 300 est la fin de course maximale et que vous essayez d'avancer jusqu'à 350. La machine se déplacera jusqu'à 300 et s'arrêtera.

 Ceci a été fait pour permettre une méthode plus simple de jogging continu. Le jogging continu est généralement utilisé avec un bouton sur un émetteur de code source. L'événement « bouton vers le bas » lance le jogging et l'événement « bouton vers le haut » l'arrête. Vous pouvez envoyer une commande comme **$J =G91 X1000 F1000** où la distance X est plus longue que la durée du jogging. FluidNC ajustera la valeur pour éviter d'atteindre les limites, de sorte qu'il fonctionnera quel que soit l'endroit. Si la valeur utilisée pour la distance est inférieure à la plage, le jogging s'arrêtera après avoir parcouru la totalité de la distance. Vous pouvez alors cliquer à nouveau sur le bouton. Dès que vous relâchez le bouton, la machine décélère jusqu'à l'arrêt.

