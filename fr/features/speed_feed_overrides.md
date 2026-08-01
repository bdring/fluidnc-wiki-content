---
title: 2.6 Vitesse de déplacement et de la broche
description: configuration de la broche
published: true
date: 2025-03-25T19:19:51.907Z
tags: fr
editor: markdown
dateCreated: 2025-03-22T17:34:48.757Z
---

# Dérogations

Les dérogations sont des commandes en temps réel qui affectent les paramètres pendant l'exécution d'une tâche. Elles sont généralement envoyées par l'intermédiaire d'un émetteur de gcode ou d'un pendant. Voici, à titre d'exemple, le panneau d'annulation de l'interface WebUI. 

<img src="https://github.com/bdring/FluidNC/wiki/images/overrides.png" width="600">

## Aperçu

Les dérogations de vitesse (broche), de vitesse rapide (mouvement G0) et d'avance (mouvement G1, G2, G3) vous permettent de remplacer les valeurs actuelles. Elles peuvent être utilisées pendant l'exécution d'un travail de gcode. Par exemple : si vous pensez que la modification de la vitesse de la broche peut améliorer la qualité de la coupe, vous pouvez augmenter ou diminuer la vitesse par incréments de 1 % ou 10 %. Vous ne pouvez jamais aller plus vite que la vitesse maximale indiquée dans vos fichiers de configuration.

Les incréments sont basés sur la valeur S (vitesse) ou F (avance) actuelle. Si vous avez une vitesse de 1000, des incréments de 10% l'amèneront à 1100, 1200, etc.

Vous pouvez voir les valeurs actuelles dans les réponses d'état.

```
<Idle|MPos:60.000,0.000,0.000,0.000,0.000,0.000|FS:500,8000|Ov:100,100,110>
```

- `FS:500,8000` contient des données sur la vitesse d'avance en temps réel, suivie de la vitesse de la broche, en tant que valeurs.
- `Ov:100,100,110` indique les valeurs prioritaires actuelles en pourcentage des valeurs programmées pour l'avance, les rapides et la vitesse de la broche, respectivement.

Envoyez **$G** pour voir toutes les valeurs du gcode.

```
[GC:G0 G54 G17 G21 G90 G94 M5 M9 T0 F200 S1000]
```

- `F200` Ceci donne la vitesse d'avance programmée (avant les dérogations).
- `S1000` Vitesse programmée (avant dérogations).

## Arrêt de la broche

Cette fonction **ne fonctionne qu'en mode de maintien**. Elle vous permet d'arrêter la broche. Si votre mèche est emmêlée dans des copeaux, vous pouvez effectuer un maintien de l'avance, puis un arrêt prioritaire de la broche, ce qui vous permet de dégager les copeaux. Vous pouvez soit cliquer à nouveau sur le bouton pour démarrer la broche, soit la broche redémarrera automatiquement à la fin de l'arrêt.

**Remarque:** Ce bouton ne peut pas être utilisé pour faire basculer la broche au repos. Utilisez M3, M4 et M5 pour cela.

## Toggles pour le liquide de refroidissement

Vous pouvez modifier l'état du liquide de refroidissement d'un travail en cours. Cette fonction n'est pas destinée au contrôle normal du liquide de refroidissement. Utilisez M7, M8 et M9 pour cela.

### Caractères de commande

Ces commandes sont toutes des commandes « immédiates » à un seul caractère. Elles prennent effet en une fraction de seconde. Les caractères ne sont pas imprimables et ne peuvent donc pas être placés accidentellement dans le gcode. Vous avez besoin d'une application d'envoi ou de l'interface WebUI pour les envoyer.

Voici les valeurs:

```
    FeedOvrReset          = 0x90,  // Rétablit de l'alimentation à 100 %.
    FeedOvrCoarsePlus     = 0x91,
    FeedOvrCoarseMinus    = 0x92,
    FeedOvrFinePlus       = 0x93,
    FeedOvrFineMinus      = 0x94,
    RapidOvrReset         = 0x95,  // Rétablit la valeur de l'annulation rapide à 100 %.
    RapidOvrMedium        = 0x96,
    RapidOvrLow           = 0x97,
    RapidOvrExtraLow      = 0x98,  // *NON SOUS SUPPORTÉE*
    SpindleOvrReset       = 0x99,  // Rétablitt la valeur de la rotation de la broche à 100 %..
    SpindleOvrCoarsePlus  = 0x9A,  //
    SpindleOvrCoarseMinus = 0x9B,
    SpindleOvrFinePlus    = 0x9C,
    SpindleOvrFineMinus   = 0x9D,
    SpindleOvrStop        = 0x9E,
    CoolantFloodOvrToggle = 0xA0,
    CoolantMistOvrToggle  = 0xA1
```

# Utilisateurs avancés

Ce sont les valeurs définies dans `config.h` pour les surcharges.

```cpp
// Configure les paramètres de vitesse, d'avance et d'annulation de la broche. Ces valeurs définissent les valeurs max et min
// Ces valeurs définissent les valeurs maximales et minimales admissibles et les incréments grossiers et fins par commande reçue. S'il vous plaît
// noter les valeurs autorisées dans les descriptions qui suivent chaque définition.

namespace FeedOverride {
    const int Default = 100 ; // 100%. Ne pas modifier cette valeur.
    const int Max = 200 ; // Pourcentage de l'avance programmée (100-255). Habituellement 120% ou 200%
    const int Min = 10 ; // Pourcentage de l'avance programmée (1-100). Généralement 50% ou 1%
    const int CoarseIncrement = 10 ; // (1-99). Habituellement 10%.
    const int FineIncrement = 1 ; // (1-99). Généralement 1%.
} ;

namespace RapidOverride {
    const int Default = 100 ; // 100%. Ne pas modifier cette valeur.
    const int Medium = 50 ; // Pourcentage de rapidité (1-99). Habituellement 50 %.
    const int Low = 25 ; // Pourcentage de rapidité (1-99). Généralement 25 %.
    const int ExtraLow = 5 ; // Pourcentage de rapide (1-99). Généralement 5%.  Non pris en charge
} ;

namespace SpindleSpeedOverride {
    const int Default = 100 ; // 100%. Ne pas modifier cette valeur.
    const int Max = 200 ; // Pourcentage de la vitesse de rotation programmée (100-255). Habituellement 200%.
    const int Min = 10 ; // Pourcentage de la vitesse de rotation programmée (1-100). Habituellement 10%.
    const int CoarseIncrement = 10 ; // (1-99). Habituellement 10%.
    const int FineIncrement = 1 ; // (1-
};
```









