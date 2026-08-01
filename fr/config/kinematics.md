---
title: 1.14 Cinématique
description: configuration cinématique
published: true
date: 2026-08-01T19:40:35.711Z
tags: fr
editor: markdown
dateCreated: 2025-03-16T10:07:15.600Z
---

 # Cinématique
<img width="400" src="https://github.com/bdring/FluidNC/wiki/images/delta-robot-v4-pic-1.jpg">

## Vue d'ensemble

Les programmes GCode de la CNC spécifient le mouvement dans un [système de coordonnées cartésiennes](https://en.wikipedia.org/wiki/Cartesian_coordinate_system), avec les axes X, Y et Z à angle droit l'un par rapport à l'autre. Le code GCode spécifie les coordonnées X, Y et Z du point final d'un déplacement.  La machine se déplace ensuite de la position actuelle à cette nouvelle position, soit en ligne droite pour la plupart des déplacements, soit le long d'un arc de cercle pour les déplacements G2 ou G3.

La plupart des machines CNC sont équipées de moteurs qui se déplacent directement dans le système cartésien.  Il y a un moteur qui déplace la machine le long de l'axe X, un autre pour l'axe Y et un autre pour l'axe Z. Pour un mouvement qui est aligné sur un axe, un seul moteur tourne, tandis que les autres restent immobiles.  Il est également possible d'avoir deux moteurs pour un axe, par exemple sur une machine « à portique » où chaque extrémité du portique a son propre moteur.  Ces deux moteurs se déplacent en même temps pour entraîner l'axe, de sorte qu'il s'agit toujours d'un système cartésien, les deux moteurs étant considérés comme un seul moteur dans la plupart des cas. (Au cours de l'autoguidage, il est possible de déplacer les moteurs jumelés indépendamment sur de courtes distances, afin de « mettre un portique à l'équerre »).

Il existe d'autres façons de faire en sorte que les moteurs contrôlent le mouvement, lorsqu'une coordination complexe de plusieurs rotations de moteurs est nécessaire pour un mouvement « simple » le long d'un seul axe X, Y ou Z. Les mathématiques permettant de calculer cette action multi-moteur sont appelées « cinématique ».  Les mathématiques permettant de calculer l'action de plusieurs moteurs sont appelées « cinématique ».  Pour la cinématique cartésienne, les mathématiques sont triviales - il suffit de tourner le moteur X d'une certaine quantité pour se déplacer d'une distance proportionnelle en X, et de même pour les moteurs Y et Z.  La machine illustrée en haut de cette page est une machine « delta » dans laquelle trois moteurs doivent tourner en même temps pour déplacer la tête de l'outil en ligne droite.  Les mathématiques de la cinématique delta sont beaucoup plus compliquées et nécessitent la résolution d'un problème géométrique délicat en trois dimensions.

FluidNC supporte plusieurs systèmes cinématiques décrits ci-dessous.

# Setup

La section **kinématique:** au niveau supérieur de votre fichier de configuration spécifie le type de cinématique. Certains types peuvent avoir des éléments subordonnés. Voici quelques exemples. 

## Cartésien

<img src="https://openbuilds.com/attachments/c-beam-prefab_final-render-sm-jpg.19423/" width=400>

Le système cartésien est le système par défaut. Tous les axes sont directement associés aux moteurs. Si deux moteurs sont affectés à un axe, ils se déplaceront ensemble.

```yaml
kinematics:
  Cartesian:
x:
  motor0:
    ...
y:
  motor0:
    ...
  motor1:
    ...
```

## CoreXY

<img src="https://corexy.com/reference.png" width=400>

[CoreXY](https://corexy.com/) est une conception de machine dans laquelle deux moteurs travaillent ensemble pour se déplacer dans l'espace XY, en utilisant un arrangement de courroies pour déplacer la tête d'outil.  Pour se déplacer dans la direction X uniquement ou dans la direction Y uniquement, les deux moteurs doivent tourner simultanément.  Si un seul moteur tourne, la tête de l'outil se déplace en diagonale.  L'avantage de cette configuration non évidente est que les deux moteurs peuvent être fixés à des positions fixes sur le cadre, de sorte que le mouvement de la tête de l'outil ne nécessite pas de déplacer la masse de l'un des moteurs, comme c'est le cas avec les systèmes cartésiens.  Les systèmes CoreXY peuvent donc être très rapides pour les mouvements dans le plan XY. Ils sont généralement utilisés pour les machines dont les têtes d'outils sont de faible masse et dont le mouvement dans la direction Z est peu rapide, voire inexistant. 

```yaml
kinematics:
  corexy:
x:
  motor0:
    ...
y:
  motor0:
    ...
```

Dans les systèmes CoreXY, le moteur indiqué sous la section x : est le premier de la paire de moteurs coopérants, et le moteur indiqué sous la section y : est le second.  Dans le système CoreXY, il n'est pas possible d'avoir deux moteurs pas à pas sur un axe, comme c'est le cas dans un système cartésien.  Pour CoreXY, il y a exactement deux moteurs qui travaillent ensemble pour le mouvement XY.

### Obtenir les bonnes directions.

Il n'est pas toujours facile d'obtenir des directions correctes. Si les moteurs sont intervertis ou si les directions des moteurs ne sont pas correctes, vous obtiendrez des mouvements incorrects. Voici une méthode pour résoudre ce problème.

Tournez manuellement un moteur à la fois en tenant l'autre fermement jusqu'à ce que l'effecteur se déplace dans les directions positives X et Y (45 degrés). Souvenez-vous du moteur que vous avez tourné et du sens dans lequel vous l'avez tourné.

Ne pas envoyer de petits jogs comme celui-ci `$J=G91 G21 X5 Y5 F200`

Vous voulez que les moteurs fassent la même chose que ce que vous avez fait manuellement.

Si le mauvais moteur bouge, échangez les moteurs

Si le bon moteur bouge, mais dans le mauvais sens, changez l'attribut de direction (:high vs. :low) de ce moteur.

Redémarrez et testez à nouveau.

Si ce jogging fonctionne, essayez de le faire dans d'autres directions. Si cela ne fonctionne pas, la seule chose qui pourrait être erronée est la direction de l'autre moteur.

## midTbot

<img src="https://github.com/bdring/midTbot_esp32/blob/master/Docs/images/20190721_092227.jpg?raw=true" width=400>

[MidTbot](https://github.com/bdring/midTbot_esp32) est un traceur de plumes qui utilise une variante de la cinématique CoreXY.

```yaml
kinematics:
  midtbot:
```

## Wallplotter

<img src="/hardware/wallplotter.jpg" width="400">

La cinématique du traceur mural utilise une tête d'outil suspendue à deux câbles reliés à des moteurs situés dans les coins supérieurs d'une surface presque verticale.  Elle est similaire à celle de la défonceuse verticale [MaslowCNC](https://www.maslowcnc.com/).

> Le code de wallplotter a été contribué par un utilisateur. Les développeurs principaux ne maintiennent pas activement le code et ne fournissent pas de support. Si vous avez des questions, créez un message sur Github. Vous devriez également rechercher d'autres problèmes pour `Wallplotter` et demander directement à ces utilisateurs.
{.is-warning}

Cette cinématique n'utilise pas le homing. Vous devez déplacer manuellement le stylo jusqu'à la position 0,0 définie par vos paramètres de configuration, puis réinitialiser le microprogramme. Dans l'exemple ci-dessous, vous devez déplacer le stylo au centre de X et à 100 mm sous les ancres.

Il est probablement plus facile de s'assurer que vos moteurs sont correctement définis en effectuant les tests initiaux avec la cinématique cartésienne. Cela vous permettra de déplacer chaque moteur individuellement pour vous assurer qu'il fonctionne correctement. Assurez-vous qu'un déplacement en X déplace le moteur gauche et qu'un déplacement en Y déplace le moteur droit. Assurez-vous que les deux moteurs se déplacent dans le bon sens. Un mouvement dans le sens positif produit plus de cordes.

```yaml
kinematics:
  WallPlotter:
    left_axis: 0
    left_anchor_x: -100.000
    left_anchor_y: 100.000
    right_axis: 1
    right_anchor_x: 100.000
    right_anchor_y: 100.000
    segment_length: 5.000
```

## Couteau tangentiel

<img src="/tangentialknifemachine.webp" width="400">

> Il s'agit d'une fonctionnalité expérimentale, actuellement disponible uniquement sur une branche.
{.is-warning}

Cette cinématique est utilisée pour commander un couteau tangentiel ou un couteau oscillant. Le couteau est tangent à la direction de la coupe, l'orientation du couteau est motorisée sur l'axe C. La position du moteur de l'axe C est calculée pour chaque mouvement XY afin d'être tangente à la trajectoire. Cela signifie que vous pouvez utiliser le code G standard XY ou XYZ.

De nombreuses découpeuses n'ont pas d'axe Z motorisé mais utilisent un étage pneumatique pour déplacer la tête de découpe vers le haut ou vers le bas. L'électrovanne de l'étage pneumatique peut être contrôlée à l'aide d'un [moteur solénoïde](http://wiki.fluidnc.com/fr/config/axes). Dans le cas de l'axe Z pneumatique, votre code G n'a besoin que des informations XY. Pour l'axe Z motorisé, le G-CODE doit fournir les données XYZ.

> Cette cinématique n'est pas compatible avec les couteaux traînants. L'orientation du couteau n'est pas motorisée mais libre de tourner le long de l'axe Z. Le décalage entre la pointe du couteau et l'axe crée un moment de sorte que le couteau suit la coupe.

La trajectoire de la lame traînante doit être générée par le générateur de code g.
{.is-warning}

Un couteau tangentiel est toujours tangent à la direction du mouvement. Lors d'un changement d'orientation, le couteau est tourné à l'extérieur du matériau (levage) ou à l'intérieur du matériau avant ou pendant le déplacement, en fonction des paramètres suivants :

- tan_knife_safe_angle_deg : L'angle entre deux mouvements qui déclenchera un soulèvement de l'axe Z s'il est dépassé, afin de faire tourner le couteau en toute sécurité.
- tan_knife_lift_distance_mm : La distance à laquelle le couteau est soulevé lorsque l'angle entre deux mouvements dépasse le seuil d'angle de sécurité tangentiel du couteau.
- tan_knife_blend_angle_deg : Lorsque l'angle entre les segments de mouvement suivants est inférieur à cette valeur, le couteau n'est pas tourné avant l'angle mais pendant le mouvement. Les segments de mouvement doivent également être plus courts que la distance de mélange du couteau tangentiel.
- tan_knife_blend_distance_mm : Lorsque l'angle entre les segments de mouvement suivants est inférieur à l'angle de mélange tangentiel du couteau et que les segments de mouvement sont plus courts que cette valeur, le couteau n'est pas tourné avant l'angle mais pendant le mouvement.
- tan_knife_z_axis_is_pneumatic : Vrai si l'axe Z est pneumatique. La hauteur de l'axe Z sera réglée sur la hauteur de coupe tangentielle du couteau pendant les mouvements G1, G2 et G3 et sur tan_knife_lift_dup_distance_mm.
- tan_knife_cutting_height_mm : Hauteur du couteau tangentiel lors de la découpe si l'axe Z est pneumatique. La valeur n'a pas d'importance tant qu'elle est négative pour déclencher la sortie d'un moteur solénoïde.

Il s'agit de valeurs par défaut que je recommande comme paramètres initiaux.

```yaml
kinematics:
  TangentialKnife:
    tan_knife_safe_angle_deg: 3
    tan_knife_blend_angle_deg: 1
    tan_knife_blend_distance_mm: 50
    tan_knife_lift_distance_mm : 5
    tan_knife_z_axis_is_pneumatic: true
    tan_knife_cutting_height_mm: -1
```

## Cinématique spéciale

Les types listés ci-dessus sont compilés par défaut et vous pouvez simplement les ajouter à votre fichier de configuration. Dans le futur, des types moins populaires pourront être ajoutés et ne seront pas compilés par défaut. Ceux-ci nécessiteront un #define ajouté au fichier kinematics.h. 

## Utilisation d'un préprocesseur Gcode

Une alternative à l'intégration de la cinématique dans FluidNC est l'utilisation d'un préprocesseur. Il s'agit d'un programme simple qui convertit le gcode cartésien en gocde nécessaire à votre système avant de l'envoyer à FluidNC. Vous pouvez le faire en Python ou même dans un tableur. Par exemple, un mouvement rectiligne en X sur le mur : Un mouvement rectiligne en X sur le traceur mural serait converti en un mouvement à 2 moteurs nécessaire pour le traceur mural.

`G0 X20 se convertit en G0 X25 Y10`

C'est un moyen facile de tester les équations cinématiques et les performances de votre machine.

## Créez votre propre type

Vous pouvez créer un nouveau type en ajoutant une nouvelle classe dérivée de la classe KinematicSystem. Si votre machine est toujours basée sur le système cartésien, comme CoreXY, vous pouvez dériver de Cartesian.

Regardez toutes les fonctions virtuelles dans Kinematic.h. Vous voudrez probablement surcharger la plupart d'entre elles dans votre classe. Vous pouvez chercher dans le code principal pour voir comment elles sont appelées. Vous pouvez également regarder d'autres exemples comme CoreXY pour voir ce qui est fait.

Il existe une fonction [parallel delta kinematics on Grbl_ESP32](https://github.com/bdring/Grbl_Esp32/tree/main/Grbl_Esp32/Custom), qui peut vous donner une longueur d'avance si vous voulez ce type de cinématique.

## Nous en ferons une sur mesure pour vous.

La réponse est probablement non. C'est beaucoup de travail et il faut une machine pour faire les tests. Nous serons heureux d'inclure votre code si vous en écrivez un nouveau.
