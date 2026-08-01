---
title: 3.8 Réglage de StallGuard
description: 
published: true
date: 2025-03-27T19:14:06.408Z
tags: fr
editor: markdown
dateCreated: 2025-03-27T19:13:59.370Z
---

# StallGuard Tuning

## Vue d'ensemble

Les pilotes Trinamic ont 2 modes de base. Le **SteathChop** est le mode super silencieux et le **CoolStep** est un mode dans lequel le pilote peut dynamiquement augmenter le courant lorsque le moteur est sous charge. Comme **CoolStep** peut déterminer la charge, dans de nombreux cas, il peut détecter si le moteur est sur le point de caler ou s'il a déjà calé. Pour plus d'informations, Trinamic propose une [note d'application sur StallGuard](https://www.trinamic.com/fileadmin/assets/Support/Appnotes/AN002-stallGuard2.pdf).

Pour ce faire, il mesure le rapport entre l'énergie envoyée au moteur et l'énergie renvoyée. Au fur et à mesure que la charge du moteur augmente, l'énergie renvoyée diminue. Lorsque l'énergie renvoyée tombe à un certain niveau, le circuit d'attaque indique un décrochage. Comme il existe de nombreuses sources de perte de puissance, telles que le câblage et la conception du moteur, le pilote vous permet de définir le niveau auquel le décrochage est indiqué.

Chaque machine doit être réglée en fonction de la taille/courant du moteur, de la vitesse, de la masse, etc. C'est un processus lent et fastidieux. C'est un processus lent et fastidieux. Le micrologiciel ne peut aider que dans une faible mesure, car il s'agit d'une fonction purement liée au pilote.

La méthode ne fonctionne pas à des vitesses très basses ou très élevées. Vous devez tester votre système pour déterminer une bonne vitesse de détection des décrochages afin d'éviter les décrochages manqués ou les fausses indications.

Les puces pilotes émettent un signal sur la broche associée à l'état StallGuard. Cette broche doit être connectée à l'ESP32. Certains contrôleurs le font directement sur le circuit imprimé. D'autres peuvent nécessiter l'utilisation d'un cavalier ou d'un câble physique. FluidNC traite cette broche comme un interrupteur mécanique. Veuillez lire la configuration des interrupteurs de limite dans d'autres sections de ce wiki pour [obtenir de l'aide à ce sujet](http://wiki.fluidnc.com/fr/support/help_with_switch_problems).

## StallGuard est-il fait pour vous ?

Dans le meilleur des cas, il est précis à environ 1 ou 2 pas entiers. La plupart des commutateurs de base sont beaucoup plus précis. La précision peut convenir pour X et Y sur une imprimante 3D ou un traceur de stylo, mais probablement pas pour une défonceuse ou un graveur laser. 

- Étant donné qu'il ne fonctionne pas bien à des vitesses faibles et élevées, il n'est pas recommandé de l'utiliser avec des limites strictes (détection de limites en temps réel). 
- Il devrait fonctionner avec des axes à deux moteurs, mais il sera probablement plus difficile à configurer. 
- Il n'est pas du tout recommandé pour CoreXY, car deux moteurs sont utilisés pour le déplacement de chaque axe. Il est peu probable qu'un arrêt brutal ne soit détecté que par le bon moteur.
- Il n'est pas recommandé pour les machines telles que les défonceuses qui peuvent avoir des charges élevées et variables sur les axes.
- J'ai constaté qu'avec le temps, sous des charges variables ou à des températures différentes, le réglage du stallguard peut changer. Il peut en résulter des arrêts plus brutaux, des arrêts prématurés ou l'impossibilité de s'arrêter. 

> L'installation peut être un processus long et frustrant. Ne vous attendez pas à recevoir beaucoup d'aide et de soutien. Il n'est pas facile d'apporter une aide à distance.
{.is-warning}

## Fichier de configuration

Voici les paramètres du fichier de configuration qui s'appliquent au mode de déplacement de Stallguard. Vous avez toujours besoin de tous les autres paramètres, mais ceux-ci s'appliquent spécifiquement à ce mode.

- **interrupteur de limite** Les entrées de l'interrupteur de limite que vous utiliserez avec StallGuard doivent être correctement configurées. Les attributs high/lo doivent être réglés de manière à ce que l'état actif soit correctement signalé. Les contrôleurs peuvent inverser ce signal, nous ne pouvons donc pas recommander l'état actif en nous basant uniquement sur la puce du pilote. 
- Réglez **homing/feed_mm_per_min** et **seek_mm_per_min** à la même valeur et à une vitesse moyenne. StallGuard est moins sensible aux vitesses élevées et basses.
- La broche diag1 du pilote pas à pas doit être directement connectée à l'entrée de l'interrupteur de fin de course.
- Sélectionnez une valeur moyenne pour **stallguard**, comme 15. Cette valeur sera réglée ultérieurement.
- Mettre **stallguard_debug** à false. Il sera mis à vrai lors de l'ajustement.
- **homing_mode** doit être StallGuard

```yaml
homing:     
      feed_mm_per_min: 200.000
      seek_mm_per_min: 200.000
motor0:
      limit_neg_pin: gpio.4:high
      tmc_2209:      
        stallguard: 15
        stallguard_debug: false
        homing_mode: StallGuard
```

## Configuration du matériel

Dans la plupart des cas, le circuit du pilote du pas à pas est un drain ouvert qui se ferme à la terre. Cela signifie que vous définissez la broche de l'interrupteur comme active basse (`:low`). Vous avez également besoin d'une résistance d'excursion quelque part. Si votre contrôleur possède des résistances pull up, c'est parfait. Vous pouvez aussi ajouter le pullup interne de l'ESP32 avec `:pu` sur les [broches qui le supportent](http://wiki.fluidnc.com/fr/hardware/esp32_pin_reference#input-only-no-pulluppulldown).


```yaml
      limit_neg_pin : gpio.33:low:pu
```

## Test et mise au point

Vérifiez l'état des interrupteurs de fin de course sans mouvement à l'aide de la commande de demande d'état `?`. Aucun interrupteur de fin de course ne doit être signalé. Si c'est le cas, modifiez l'état actif à l'aide de la commande [pin attributes](http://wiki.fluidnc.com/fr/config/overview#pin_declaration).

Activez l'affichage des données StallGuard avec **$/axes/x/motor0/tmc_2209/stallguard_debug=true**. Les données StallGuard seront alors transmises au port [USB/Serial](https://github.com/bdring/Grbl_Esp32/wiki/Serial-Port-Setup-and-Usage). Il faut utiliser le port série pour obtenir la meilleure vitesse et la meilleure synchronisation des données. Les données ressembleront à ceci. Il s'agit de 4 relevés effectués juste avant la détection d'un décrochage. Note : N'utilisez ce rapport que lors de la mise au point. Désactivez le rapport lorsque vous exécutez le gcode normal.

> Parfois, le texte et le style exacts du rapport changent en fonction de la version, mais les informations de base sont généralement les mêmes.
{.is-info}

```
[MSG:INFO: X Axis Stallguard 0   SG_Val:784 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 0   SG_Val:784 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 0   SG_Val:553 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 0   SG_Val:403 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 0   SG_Val:403 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 0   SG_Val:403 Rate:200.000 mm/min SG_Setting:6]
[MSG:INFO: X Axis Stallguard 1   SG_Val:0 Rate:200.000 mm/min SG_Setting:6]
```

Voici ce que signifient les valeurs...

- Axe X** Il s'agit de l'axe affiché.
- **Stallguard 0** Un décrochage n'est pas détecté.
- **SG_Val : 0168** Il s'agit de la valeur actuelle du capteur StallGuard. Le rapport est ralenti pour éviter d'interférer avec le mouvement, il est donc possible que vous ne le voyiez pas atteindre la valeur 0 lorsqu'il se déclenche.
- **Rate : 200 mm/min** Il s'agit du taux de pas actuel que Grbl_ESP32 produit. Elle devrait être proche de votre valeur **$/axes/x/homing/seek_mm_per_min** (ou feed), mais augmentera et diminuera en raison de l'accélération et de la décélération.
- **SG_Setting:30** Il s'agit du réglage **$/axes/x/motor0/tmc_2209/stallguard** actuel.

Accueil utilisant **$HX**. Ajoutez une charge au moteur, proche du calage. Observez les valeurs.

Vous voulez que SG_Val : tombe à 0.

Essayez différentes vitesses et **$/axes/x/motor0/tmc_2209/stallguard**.

Des valeurs plus faibles = **$/axes/x/motor0/tmc_2209/stallguard** plus faibles le rendent plus sensible.

Essayez d'ajuster **$/axes/x/motor0/tmc_2209/stallguard** vers le haut et vers le bas jusqu'à ce que vous obteniez la meilleure sensibilité sans faux déclenchements. Enregistrez votre résultat.

Essayez différentes valeurs de vitesse d'orientation avec le même processus.

Si la deuxième touche, après l'arrachage, ne se déclenche pas, essayez d'utiliser une valeur plus élevée de [feed_scaler :](https://github.com/bdring/FluidNC/wiki/FluidNC-Motor-Setup#feed_scaler).

Utilisez la meilleure combinaison de valeurs que vous trouverez.

# Dépannage

## Retirer le mouvement

Si la première phase d'une séquence de retour à la maison est un mouvement de retrait, FluidNC pense que l'interrupteur est déjà actif au moment où vous avez commandé la séquence de retour à la maison. Pour StallGuard, cela ne devrait jamais se produire. Il doit toujours signaler l'état non actif jusqu'à ce qu'il soit empêché de bouger. Votre attribut d'état actif peut être erroné.

## Le deuxième cycle échoue

Si le premier cycle (recherche) fonctionne, mais que le second cycle (alimentation) échoue, essayez d'augmenter le **homing/feed_scaler:**. Cela permettra d'avancer un peu plus dans cette phase. Parfois, il suffit de quelques étapes sautées pour enregistrer un décrochage.


