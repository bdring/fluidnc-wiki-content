---
title: 1.5 Homing et limite switches
description: configuration du homing et des switchs de limitation
published: true
date: 2026-08-01T19:40:30.940Z
tags: fr
editor: markdown
dateCreated: 2025-03-15T12:36:32.804Z
---

# FluidNC Interrupteur de fin de course et configuration du Homing

## Vue d'ensemble

La configuration des interrupteurs de fin de course dans FluidNC est très souple. Cela lui permet d'être à la fois riche en fonctionnalités et d'offrir un nombre très faible de broches d'entrée. FluidNC prend en charge les axes de base ainsi que les axes groupés avec ou sans équerrage. Certaines touches se trouvent dans le groupe **[homing :](http://wiki.fluidnc.com/fr/config/axes#homing)** de l'axe et d'autres dans le groupe **[motor<0 ou 1> :](http://wiki.fluidnc.com/fr/config/axes#motor-types)**.

Une broche IO ne peut être utilisée qu'une seule fois. Vous pouvez utiliser un câblage en parallèle ou en série pour plusieurs commutateurs, mais vous ne pouvez jamais affecter l'entrée à plus d'un élément dans votre fichier de configuration.

## Placer des interrupteurs de fin de course sur un axe.

Vous pouvez placer des interrupteurs de fin de course à l'extrémité positive ou négative de la course, ou aux deux. L'extrémité positive de la course est celle vers laquelle vous vous déplacez lorsque la position de l'axe augmente. Si vous vous déplacez de X0 à X10, vous vous déplacez dans le sens positif. 

Généralement, l'extrémité négative de l'axe X se trouve sur le côté gauche et l'extrémité positive sur le côté droit. L'extrémité positive de l'axe Z est le sommet.

Vous pouvez attribuer des commutateurs aux extrémités à l'aide de ces mots-clés.

```
limit_neg_pin:
limit_pos_pin:
limit_all_pin:
```
Le paramètre `limit_all_pin:` est utilisé lorsqu'un interrupteur est placé aux deux extrémités, mais câblé sur une seule broche d'entrée. Ces interrupteurs seront câblés en série ou en parallèle selon le type d'interrupteur. Si un `limit_all_pin:` est déclenché, FluidNC ne saura pas quelle extrémité a été touchée. Cela convient à tous les scénarios, sauf si un interrupteur est déclenché avant le retour au point de départ. FluidNC ne sait pas de quel côté se déplacer pour effacer l'interrupteur. Vous devez effacer manuellement l'interrupteur avant le retour au point de départ.

En règle générale, vous pouvez utiliser...

 - un interrupteur négatif
 - un interrupteur pos
 - un interrupteur neg et un interrupteur pos
 - un interrupteur « all » (tout)

En règle générale, vous n'utilisez pas un commutateur « all » avec d'autres commutateurs.

Chaque axe est indépendant et vous pouvez choisir la meilleure disposition pour cet axe.

## Limites souples et dures

Ces fonctions permettent de contrôler si vous pouvez déplacer l'axe au-delà de ses points d'extrémité. Vous ne pouvez utiliser ni l'une ni l'autre de ces fonctions, ni les deux.

Les limites strictes utilisent des interrupteurs pour arrêter le mouvement lorsque vous activez un interrupteur de fin de course. L'idéal est d'avoir des interrupteurs aux deux extrémités. S'il heurte un interrupteur, le mouvement est immédiatement arrêté, une alarme est émise et la position exacte est supposée perdue. Vous devez alors procéder au repositionnement. Comme cette fonction est contrôlée par des interrupteurs, elle est définie au même niveau que les interrupteurs. Les alarmes de limites strictes ne se produisent pas pendant le retour à la position initiale.

Les limites souples sont déterminées par l'amplitude du mouvement. Si vous envoyez une commande qui l'enverrait au-delà de la plage, elle est bloquée. Elle s'arrête en toute sécurité et la position n'est pas perdue. Vous devez faire le point de départ de la machine, afin qu'elle sache exactement où elle se trouve. La plage de limite souple de chaque axe est indiquée dans les messages de démarrage. Ces valeurs sont exprimées en coordonnées machine et non en coordonnées de travail. La plupart des codes graphiques utilisent les coordonnées de travail. Si vous obtenez des erreurs de limite souple inattendues, vérifiez vos décalages de travail.

```
[MSG:INFO : Axe X (0.000,300.000)]
```

## Test

Vous pouvez visualiser l'état des commutateurs en temps réel en mode test en envoyant la commande `$limits`. L'état des commutateurs sera affiché sur la console série. Activez les interrupteurs et vous devriez le voir dans le rapport.  Il utilise des minuscules pour le moteur 0 et des majuscules pour le moteur 1. Si vous activez un interrupteur **[limit_all_pin :](http://wiki.fluidnc.com/fr/config/axes#limit_all_pin)**, il indiquera une extrémité positive et une extrémité négative. Envoyez `!` pour quitter ce mode et revenir au mode de contrôle normal.

La meilleure façon de tester les interrupteurs est d'appuyer et de relâcher lentement chaque interrupteur individuellement. Observez l'état affiché. Veillez à laisser du temps pour chaque mise à jour de l'affichage. Vous devez voir un changement d'état lorsque vous poussez et relâchez chaque interrupteur.

L'affichage se présente alors comme suit :

```
$limits
Homing Axes: xyz
Limit  Axes: xyz
  PosLimitPins NegLimitPins Probe
: x            x
: x     X
```


```
$limits                            (La commande pour démarrer le rapport)
Homing Axes: xyz                   (Votre fichier de configuration a une section de homing pour les moteurs x, y et z)
Limit Axes: xyz                    (Les axes x, y et z ont des broches de fin de course définies dans le fichier de configuration)
PosLimitPins NegLimitPins Probe    (Un en-tête pour le rapport ci-dessous)
:                                  (Aucun interrupteur n'est actuellement actif)
: x            x                   (motor0 a un interrupteur positif x et négatif x actif. Cela pourrait être un interrupteur tout)
: x     X                          (motor0 et motor1 [majuscule] ont des interrupteurs positifs actifs)
:                                  (Aucun interrupteur n'est actif)
:                           P      (L'interrupteur de sonde est actif)
!                                  (La commande pour arrêter l'enregistrement)
```

## Équerrage des axes

L'équerrage de l'axe utilise 2 commutateurs de positionnement pour s'assurer que l'axe est équerré pendant le positionnement.. Il nécessite 2 moteurs et une entrée d'interrupteur séparée pour chaque côté. S'il voit cela dans le fichier de configuration, l'équerrage sera utilisé. Cela permet une méthode sans stress. Cela signifie qu'aucun côté ne se déplacera sans l'autre s'il n'y est pas obligé. Si votre axe démarre à l'équerre, il ne sera jamais sorti de l'équerre (stressé) pendant l'équerrage.

La méthode ci-dessus suppose que vos interrupteurs sont montés à l'équerre. C'est certainement la configuration idéale. Si ce n'est pas le cas, vous pouvez utiliser les paramètres [pulloff_mm :](http://wiki.fluidnc.com/fr/config/axes#pulloff_mm) dans le fichier de configuration pour compenser cela. Il s'agit de l'ampleur de l'inversion du moteur après avoir touché l'interrupteur. En utilisant des valeurs différentes pour chaque moteur, vous pouvez compenser les interrupteurs mal alignés.

> Il est très important de ne pas mélanger les interrupteurs et les moteurs. Le moteur 0 doit activer ses interrupteurs et le moteur 1 doit activer les siens, sinon vous obtiendrez des plantages.
{.is-warning}

Il est recommandé de définir **[stepping/idle_ms : 255](http://wiki.fluidnc.com/fr/config/axes#stepping)**. Cela empêchera les moteurs de se désactiver dans l'état d'inactivité. Les machines qui ont besoin d'être équerres ont tendance à se déséquilibrer lorsque les moteurs sont désactivés. 

## Plusieurs interrupteurs sur une même entrée

Vous pouvez placer un interrupteur à chaque extrémité de l'axe et les relier à la même entrée. Vous les câblerez en série pour une configuration N.C. ou en parallèle pour une configuration N.O.. Vous devez définir l'entrée en tant que `limit_all_pin:`.

> Cela présente un inconvénient avec le homing. Si un interrupteur de fin de course est touché avant le retour au point de départ, FluidNC s'éloignera légèrement de l'interrupteur pour le désactiver, puis essaiera de revenir au point de départ. Avec un `limit_all_pin:`, FluidNC ne sait pas quelle extrémité est en contact, et ne sait donc pas dans quelle direction se déplacer pour libérer l'interrupteur. S'il se déplace dans le mauvais sens, il risque d'endommager quelque chose. Vous devez déplacer manuellement l'axe pour libérer l'interrupteur avant de procéder à l'autoguidage.
{.is-warning}

## Exemples

### Axes à un seul moteur

- Un interrupteur du côté de la direction intérieure

```yaml
x :
  motor0 :
    limit_neg_pin : gpio:2
```

- Entrées séparées pour les extrémités positive et négative

```yaml
x :
  motor0 :
    limit_neg_pin : gpio:2
    limit_pos_pin : gpio:2
```
### Axes moteurs groupés

 - 2 interrupteurs indépendants sur l'extrémité homologue de chaque côté

```yaml
x:
  motor0:
    limit_neg: gpio:2
  motor1:
      limit_neg: gpio:3
```

- 4 commutateurs indépendants
```yaml
x:
  motor0:
      limit_neg_pin: gpio:2
      limit_pos_pin: gpio:3
  motor1:
      limit_neg_pin: gpio:4
      limit_pos_pin: gpio:5
```

- Un côté avec un interrupteur et l'autre avec pos, nig, ou les deux

```yaml
x:
  motor0:
      limit_all_pin: gpio:2
  motor1:
      limit_neg_pin: gpio:4
      limit_pos_pin: gpio:5
```

## Moteurs groupés avec une entrée de commutation

Cette option est prise en charge, mais l'axe ne s'équarrissera pas automatiquement pendant le homing. L'interrupteur peut être placé du côté du moteur 0 ou du moteur 1.

## Normalement ouvert (N.O.) vs. Normalement fermé (N.C.)

Vous pouvez utiliser des interrupteurs N.O. ou N.C.. Les deux nécessitent une résistance de tirage pour l'état ouvert. L'état fermé a une impédance plus faible car l'état ouvert utilise une résistance pour régler la tension et l'état fermé est une connexion directe. Cela signifie que l'état N.C. est moins susceptible de se déclencher faussement à cause du bruit en fonctionnement normal.

# Dépannage

## Obtenir des informations de débogage

Vous pouvez obtenir des informations supplémentaires en affichant les messages de débogage. Ces messages donnent des informations sur chaque phase du cycle de retour à la maison. Si vous demandez de l'aide pour des problèmes de retour à la maison, veuillez fournir ces informations.

```
$Message/Level=Debug
ok
$HX
[MSG:DBG: Homing Cycle X]
[MSG:DBG: Homing nextPhase FastApproach]
[MSG:DBG: Starting from 50.000,80.000,50.000]
[MSG:DBG: Planned move to -115.002,80.000,50.000 @ 800.000]
[MSG:DBG:  X Neg Limit 1]
[MSG:DBG: Homing limited X]
[MSG:DBG: Homing nextPhase Pulloff0]
[MSG:DBG: Starting from 36.042,80.000,50.000]
[MSG:DBG: Planned move to 39.042,80.000,50.000 @ 600.000]
[MSG:DBG: CycleStop Pulloff0]
[MSG:INFO: ALARM: Homing Fail Pulloff]
```

Vous pouvez également voir les informations de débogage si vous activez manuellement les commutateurs.

```
[MSG:DBG:  X Neg Limit 1]
[MSG:DBG: Limit switch tripped for X motor 0]
[MSG:DBG:  X Neg Limit 0]
```

## <a id="floating_pins"></a>Pinces flottantes

Si vous obtenez un comportement étrange, il se peut que vous ayez besoin d'une résistance pull up ou pull down. Les résistances externes de l'ordre de 3k-10k fonctionnent bien. You can also apply ESP32 ones to many pins in firmware with the **:pu** or **:pd** [pin attribute](http://wiki.fluidnc.com/fr/config/config_IO#input-pin-attributes). C'est une bonne pratique de mettre ces attributs dans votre fichier de configuration même si vous avez des résistances externes, de sorte que les personnes qui lisent votre fichier le sachent.

## <a id="inverted_reporting"></a>Rapports inversés

Si les commutateurs [reporting](http://wiki.fluidnc.com/fr/config/homing_and_limit_switches#testing) sont inversés par rapport à ce que vous souhaitez, vous devez modifier l'attribut d'état actif du commutateur (**:low** vs **:high**). Si vous n'avez pas d'attribut d'état actif, il suppose **:high**.

  - comme **limit_neg_pin : gpio.32:low** vs. **limit_neg_pin : gpio.32:high**
  
## Direction du Homing et commutateurs configurés

> Avant de déboguer tout problème de direction d'orientation, assurez-vous que les directions fonctionnent avec des mouvements normaux et des jogs. 
{.is-info}

La direction du homing est déterminée par des valeurs de configuration comme `axes/<axis>/homing/positive_direction:` Si cette valeur est vraie, vous devez avoir une `limit_pos_pin:` définie pour au moins le moteur0.

## Problème d'axe à deux moteurs

- Si vous observez un comportement étrange après le contact initial de l'interrupteur lorsque vous essayez d'initialiser un axe à deux moteurs, assurez-vous que chaque interrupteur est associé au bon moteur. L'équerrage échouera s'il déplace un moteur, mais que le mauvais interrupteur s'active.   

## Homing Fail Pulloff

Si vous obtenez une erreur de ce type, cela signifie que le commutateur d'autoguidage est actif et qu'il ne s'est pas désactivé lorsque la machine a essayé de reculer. Cela peut signifier que l'interrupteur est bloqué dans l'état actif, que la machine ne s'est pas retirée suffisamment loin ou que la machine ne se déplace pas réellement lorsqu'elle se retire.

Dans ce cas, la machine essaiera de s'éloigner de la machine, qu'elle touche ou non l'interrupteur. Si vous utilisez une broche `limit_all_pin`, vous obtiendrez une alarme ambiguë d'interrupteur de fin de course.  

```
[MSG:INFO : ALARM : Homing Fail Pulloff]
ALARME:8
```

## Un axe s'arrête brièvement pendant le homing

Si vous avez plus d'un axe sur un cycle de homing, comme X et Y, les deux axes s'arrêteront lorsque le premier axe touchera, puis l'axe non touché continuera jusqu'à ce qu'il touche l'interrupteur.




