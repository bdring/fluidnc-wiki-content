---
title: 2.10 Gcodes pris en charge
description: fonction des Gcodes
published: true
date: 2025-03-25T19:21:50.719Z
tags: fr
editor: markdown
dateCreated: 2025-03-23T08:22:06.326Z
---

# Vue d'ensemble

Notre code GC est fortement basé sur [LinuxCNC](http://linuxcnc.org/docs/stable/html/) ([G](https://linuxcnc.org/docs/2.8/html/gcode/g-code.html) et [M](https://linuxcnc.org/docs/2.8/html/gcode/m-code.html) codes). Si vous envisagez de suggérer une nouvelle commande, regardez ce que fait LinuxCNC. Dire « ...comme Marlin » ne vous mènera nulle part.

Elle est très proche de la définition des codes de [RS274NGC Interpreter](https://tsapps.nist.gov/publication/get_pdf.cfm?pub_id=823374).

Certains [paramètres et expressions gcode](http://wiki.fluidnc.com/fr/features/gcode_parameters_expressions) sont pris en charge.

# Commentaires

Vous pouvez placer des commentaires dans le gcode en utilisant deux méthodes.

## Point-virgule

Tout ce qui se trouve après un point-virgule sera considéré comme un commentaire et ignoré par l'analyseur syntaxique de gcode.

```gcode
G0 G53 Z-1 ;move to top of Z
```

## Parenthèses 

Tout ce qui est entre parenthèses sera considéré comme un commentaire et ignoré par l'analyseur de code. Cela peut être entre les commandes de gcode..,

```gcode
M3 (Broche CCW) S1000 (Vitesse 1000)
``` 
Si le commentaire contient 'MSG', il sera renvoyé à la console dans le format `[MSG:INFO : GCode Comment...My Message]`. Il enlèvera le `MSG` et le caractère suivant (typiquement un espace) de votre commentaire.

```gcode
M3 (MSG Broche CCW) S1000 (MSG Vitesse 1000)
```
Réponse

```
[MSG:INFO : Commentaire du code GC...Broche CCW]
[MSG:INFO : Commentaire GCode...Vitesse 1000]
```
## Commandes synchronisées ou non synchronisées.

Le planificateur tente de maintenir un mouvement précis, rapide et fluide. Pour ce faire, il charge plusieurs commandes de mouvement et les combine. Il n'accélère pas et ne décélère pas entre toutes les commandes de mouvement. L'exemple le plus simple est le mouvement rectiligne. 

Cet extrait contient deux commandes de déplacement distinctes, mais il les combinera en un seul déplacement fluide vers X200.

```gcode
G1 F100 X100
X200
```

Si les commandes de mouvement créent un angle, le planificateur insère la quantité minimale de décélération/accélération dans l'angle dont il a besoin pour maintenir sa précision (junction_deviation_mm).

Les commandes non synchronisées sont des commandes de broche ou des retards. Le même code que ci-dessus avec un petit délai entraînera l'arrêt de la machine entre les mouvements.

```gcode
G1 F100 X100
G4 P0.5 ;délai 0,5 secondes
X200
```

> Cela peut avoir une incidence sur l'affichage des commentaires de ligne par FluidNC. Ils sont affichés lorsqu'ils sont lus dans le planificateur. Cela signifie que vous verrez probablement les commentaires s'afficher tôt lorsque les commandes de mouvement sont combinées.
{.is-info}

# Paramètres

## XYZABC

Les axes de la machine XYZ sont linéaires et affectés par le mode d'unité G20/G21. ABC sont rotatifs et ne sont pas affectés par G20/21. Vous pouvez les utiliser comme linéaires si vous utilisez des millimètres.

## IJK

Paramètres de l'arc

## E

Numéro de la broche de sortie avec M67 

## L

Paramètre pour G10

## N

Numéro de ligne. En option, un numéro de ligne peut être utilisé pour chaque ligne de gcode.

```Gcode
N100 G0 Z23.4
```
## P

  - Temps d'attente avec G4
  - Utilisé pour indiquer le système de coordonnées avec G10

## Q

  - Utilisé pour indiquer le niveau analogique avec M67

## T Numéro d'outil

Cette commande est utilisée avec la commande M6. Elle permet de modifier le numéro d'outil actuel. Avec FluidNC, elle peut également être utilisée pour changer de broche si plusieurs broches sont utilisées.

# Mots du Gcode

## S Vitesse de la broche

Permet de régler la vitesse de la broche ou la puissance du laser. Il peut être utilisé seul sur une ligne ou avec d'autres gcodes. La valeur est modale et reste en vigueur jusqu'à ce qu'elle soit modifiée. L'unité est traditionnellement le RPM, mais elle est également utilisée pour le niveau de puissance du laser dans FluidNC.

```gcode
S12000 ;set speed to 1000
M3 ;run spindle CW. It uses speed 12000
M5 ;turn of spindle
M3 S2000 ;turn on spindle CW with speed 2000
```

> Lorsque la vitesse est fixée à 0, vous pouvez éventuellement désactiver votre broche. Voir la documentation sur la configuration de la broche. 
{.is-info}

## F Vitesse d'alimentation

  - Permet de régler la vitesse d'alimentation en fonction des unités actuelles.

```gcode
F1000 ; set feed rate to 1000
G1 X20 ;move to x20 at 1000
G1 X0 F3000 ;move to 0x0 at 3000
```
> Vous obtiendrez une erreur si vous essayez d'utiliser une commande de mouvement comme G1, G2, G3, etc. si vous n'avez pas une vitesse d'avance supérieure à 0.
{.is-warning}

## T Numéro d'outil

Préparer le passage au numéro d'outil. Lorsque la commande M6 arrive, l'outil actuel est changé. Il peut être utilisé sur sa propre ligne ou avec M6. FluidNC standard utilise des numéros d'outils pour les broches multiples. C'est la façon de passer à une autre broche.

> Les ATC réels doivent être implémentés en ajoutant du code au firmware. Il s'agit d'un sujet très avancé et l'aide que l'on peut apporter est limitée.
{.is-warning}

```gcode
M6 T2 ;change to tool 2 now
T7 ;prepare to change to tool 7
M6 ; change to tool 7
```

## G0 Mouvement rapide

Mouvement rapide. Le mouvement s'effectue à la vitesse d'avance maximale possible. Les mouvements sur plusieurs axes sont coordonnés, de sorte que la vitesse réelle dans la direction résultante peut être supérieure ou inférieure à celle d'un axe spécifique. 

Remarque : Certaines broches, comme les lasers, peuvent être désactivées pendant ce déplacement.

## G1 Mouvement à l'avance

Mouvement à la vitesse d'avance actuelle. Il utilisera la vitesse d'avance actuelle (valeur F). Cette valeur peut provenir d'une valeur précédente spécifiée ou de la même ligne que celle sur laquelle se trouve le G1. Si aucune valeur F n'a été reçue, vous obtiendrez une erreur. 

Exemple:

```
F100 (set the feed rate)
G1 X5.5 (move to X5.5 at 100)
G1 X0 F500 (move to X0 at 500)
X1.5 (Move to X1.5 at 500. It uses the current modal G1 and F values)
```

## G2 (sens des aiguilles d'une montre), G3 (sens inverse des aiguilles d'une montre) Arc ou mouvement hélicoïdal à l'avance

### Arcs de format central

C'est la forme la plus courante. Elle utilise un format `G2 ou G3 <centre...> <offsets...> <turns>`.

Il crée un arc de déplacement de l'emplacement actuel au point déterminé par les décalages en utilisant le centre fourni. Le décalage x est `I` et le décalage y est `J`. Si vous fournissez une valeur Z, cela créera un déplacement en hélice. Ajoutez un paramètre `P` pour le nombre de tours.

```
G0 X0 Y0
F500
G02 X10 Y10 I0 J10
```

Cela créerait un mouvement dans le sens inverse des aiguilles d'une montre de (0,0) à (0,10) avec le centre à X10, Y10.

> S'il est impossible d'ajuster un arc aux points fournis, vous obtiendrez un message d'erreur ` error:33 [MSG:ERR : Gcode invalid target]`.
{.is-warning}

Si vous souhaitez créer un arc dans le plan XZ ou YZ, vous devez effectuer une sélection de plan G18 ou G19.

Le codage manuel des arcs est compliqué. Si vous voulez plus d'informations, faites une recherche sur Internet.

### Radius Format Arcs

## G4 Dwell

  - `Pn.n` Il s'agit du délai en secondes.

```
G4 Px.x
```

> Il s'agit d'une commande synchronisée. Cela signifie que tout le gcode mis en mémoire tampon est terminé avant que le dwell ne commence.
{.is-info}

## G10 Définir le décalage du système de coordonnées

```
G10 Axes Lx Px
```

- `L2` Ceci définit le décalage de la coordonnée de travail à la valeur des axes
- `L20` Définit la coordonnée de travail dans le numéro de système spécifié à la valeur des axes
- `Pn` Indique le système de coordonnées à modifier. P0 est utilisé pour changer le système G54-G59 actuel. P1 à P6 sélectionnent les systèmes G54 à G59.

```gcode
G10 L2 P0 X0 ; modifie le décalage X dans le système de coordonnées actuel à 0
G10 L20 P1 X0 ; règle la valeur de la coordonnée de travail X dans G54 sur 0
```

La commande `$#` permet d'afficher toutes les valeurs sauvegardées.

## G17, G18, G19 Sélection du plan

Les arcs ne fonctionnent que sur des plans 2D. Le plan XY est sélectionné par défaut. Si vous voulez un arc sur un autre plan 2D, vous devez d'abord sélectionner ce plan.

- `G17` XY (par défaut)
- `G18` ZX
- `G19` YZ

## G20, G21 Unités

Cette option définit les unités. L'unité native de FluidNC est le millimètre. Il commencera en millimètres. S'il voit un G20, il commencera à convertir les valeurs d'axe et de vitesse en millimètres. Il ne le fait que pour les axes X, Y et Z. Les axes A, B et C sont considérés comme rotatifs et sans unité. Aucune conversion n'est effectuée pour ces axes.

Les valeurs de configuration ne sont jamais converties.

- `G20` - Utiliser les pouces pour les valeurs de longueur et de vitesse
- `G21` - Utiliser les millimètres pour les valeurs de longueur et de vitesse

## G28 Position prédéfinie

G28 est une position de coordonnées machine stockée dans une mémoire non volatile. Il se rendra au même endroit quel que soit le système de coordonnées ou les décalages G92. Vous pouvez visualiser le réglage actuel via la commande `$#`.

- `G28` Cette commande effectue un déplacement rapide vers l'emplacement. 
- `G28 axes` Si vous spécifiez des valeurs d'axe, il y aura d'abord un déplacement rapide vers cet emplacement dans votre système de coordonnées de travail actuel. Ensuite, il effectuera un déplacement rapide vers l'emplacement G28 stocké. Il ne se déplacera que sur les axes spécifiés. 
  - `G28 Z10` se déplacera vers le travail Z10 puis se déplacera vers l'emplacement Z stocké dans G28. Pas de mouvement sur X ou Y.
  - `G28 X10 Y20` se déplacera vers le travail X10 Y20 puis vers l'emplacement G28 pour X et Y. Il n'y aura pas de mouvement sur Z ou tout autre axe que vous avez défini.
  - `G28 G91 X0` C'est un moyen de se déplacer uniquement vers le X stocké dans G28. G91 X0 est un déplacement relatif de 0, donc il n'y aura pas de déplacement avant le déplacement de G28.  Encore une fois, seul l'axe X se déplacera. **Note:** Vous resterez en G91 après le déplacement. Si vous étiez en G90 avant le déplacement, vous pouvez envoyer un G90 pour revenir à ce mode.
- `G28.1` Utilisez ceci pour définir le décalage G28 à la position actuelle en coordonnées machine. 

```
<Idle|MPos:0.000,-10.000,-30.000|FS:0,0|Ov:100,100,100>
G28.1
ok
$#
[G54:0.000,-150.000,0.000]
[G55:0.000,0.000,0.000]
[G56:0.000,0.000,-30.000]
[G57:0.000,0.000,0.000]
[G58:0.000,0.000,0.000]
[G59:0.000,0.000,0.000]
[G28:0.000,-10.000,-30.000]
[G30:5.000,-5.000,-1.000]
[G92:0.000,0.000,0.000]
[TLO:0.000]
ok
```

> Vous ne devez utiliser G28 qu'une fois que vous avez entièrement localisé une machine. Il faut que la position de la machine soit précise, sinon elle se déplacera vers des emplacements imprécis. 
{.is-warning}

> De nombreuses personnes règlent G28 sur la position d'origine. Après le retour à la base, envoyez G28.1 pour mettre G28 en position de retour à la base. Vous pouvez ensuite envoyer G28 pour aller à cette position.
{.is-info}

## G30 Position prédéfinie

C'est la même chose que G28, mais on utilise 30 au lieu de 28.

## G38 Sondage

```gcode
G38.n axes Pnn.nnn
```

 - Conformité aux normes
   - `G38.2` Sonde en direction de la pièce. Arrêt au contact. Erreur en cas d'échec.
   - `G38.3` Identique à G38.2, mais pas d'erreur en cas d'échec.
   - `G38.4` Sonde éloignée de la pièce. Arrêt en cas de perte de contact. Erreur en cas d'échec.
   - `G38.5` Identique à G38.4, mais pas d'erreur en cas d'échec.
 - (depuis v3.7.6) FluidNC Only (identique au précédent mais toujours incrémental et en millimètres) cela ne modifie pas l'état actuel de G20/G21 ou G90/G91. 
   - `G38.6` comme G38.2
   - `G38.7` comme G38.3
   - `G38.8` comme G38.4
   - `G38.9` comme G38.5

Le déplacement utilisera la vitesse d'avance et le mode de distance existants (pour G38.2-G38.5) s'il n'y en a pas.

Le paramètre P est facultatif. Il est utilisé pour définir l'emplacement de travail du Z, le paramètre P représentant le décalage par rapport à une plaque, etc. Utilisez-le pour définir l'épaisseur de votre plaque de contact (idéalement mesurée avec un micromètre). Les décalages de longueur d'outil G43 et de coordonnées système G92 sont pris en compte lors de l'utilisation du paramètre P.

> Vous obtiendrez une erreur si le palpeur touche avant la commande de palpage sur G38.2 et G38.3. Vous obtiendrez une erreur si le palpeur n'est pas en contact avant la commande sur G38.4 et G38.5.
{.is-info}

```gcode
G91 G38.2 Z-20.0 F80.0 ;sonde d'une quantité absolue de -20 en Z avec un débit d'alimentation de 80 jusqu'à ce que la sonde soit déclenchée, puis régler l'emplacement de la sonde à 0. (Le voyage maximal est de 20.)
```

```gcode
G53 G38.2 Z-40 F80 ;sonde à une position machine de 40 avec un débit de 80 jusqu'à ce que la sonde soit déclenchée, puis régler l'emplacement de la sonde à 0. (Le voyage maximal est de 40.)
```

```gcode
G38.2 Z-40 F80 P4.985 ;sonde à une position de travail de -40 avec un débit de 80 jusqu'à ce que la sonde soit déclenchée, puis régler l'emplacement de la sonde à 4,985 (l'épaisseur de votre plaque tactile). (Le voyage maximal est de 40.)
```

## G40 Cutter Compensation Off

## G43.1 Décalage dynamique de la longueur d'outil

```gcode
Axes G43.1
```

Cette commande est utilisée pour ajuster les outils de différentes longueurs. Elle crée un décalage par rapport au système de coordonnées actuel. Elle ne crée aucun mouvement. Si votre valeur Z de travail est de 1,00 et que vous envoyez `G43.1 Z0.250`, la valeur Z de travail sera maintenant de 1,25.

Vous pouvez voir la valeur actuelle avec la commande `$#`.

```
[G54:0.000,0.000,0.000]
...

[G92:0.000,0.000,0.000]
[TLO:0.000]
[PRB:0.000,0.000,0.000:0]
```

> Nous ne supportons pas le format `G43 H<numéro d'outil>`. FluidNC ne stocke pas de table de valeurs de décalage d'outil.
{.is-info}

## G49 Annuler le décalage de la longueur de l'outil

Réinitialise le TLO à 0.

```gcode
G49
ok
$#
...
[TLO:0.000]
ok
```

## G53 Utiliser les coordonnées de la machine

Format

```gcode
Axes G53
```

Cette commande permet de se déplacer vers un point spécifique en coordonnées machine. Ce sont les coordonnées rapportées comme MPos avec la commande d'état `?` en mode de rapport `$10=1`. Le mode G53 n'est actif que pour la ligne sur laquelle il se trouve (il n'est pas modal). Le système de coordonnées sélectionné (G54, etc.) ne change jamais.

***Exemples:***

```gcode
G0 G53 Z-1 (déplacement vers Z-1 dans MPos)
G53 X20 (déplacement de G0 vers Mpos X20)
```

## G54 à G59 Sélectionner le système de coordonnées

Cette fonction permet de définir le système de coordonnées actuel. Les systèmes de coordonnées enregistrent les décalages du système de coordonnées de travail. Ceci vous permet de définir 6 décalages de travail différents. Le système commence toujours en G54. Vous définissez la valeur des décalages à l'aide de la commande G10. Les décalages sont stockés dans une mémoire non volatile et sont automatiquement restaurés au démarrage. Vous pouvez lire les valeurs de décalage avec la commande `$#`. 

***Exemples:***

```
G54
G10 L2 P1 Y5
$#
(response)
[G54:0.000,5.000,0.000]
[G55:0.000,0.000,0.000]
[G56:0.000,0.000,0.000]
[G57:0.000,0.000,0.000]
[G58:0.000,0.000,0.000]
[G59:0.000,0.000,0.000]
[G28:0.000,0.000,0.000]
[G30:0.000,0.000,0.000]
[G92:0.000,0.000,0.000]
[TLO:0.000]
```
## G90, G91 Mode Distance

- G90 - Mode distance absolue. Les valeurs des axes sont utilisées comme emplacements. Le déplacement se fera à l'emplacement spécifié dans le système de coordonnées actuel G54-G59 ou G53 si spécifié.
- G91 - Mode distance incrémentale. Les valeurs des axes sont utilisées comme des distances de déplacement.

***G90 Exemple:***

```gcode
G90 ;(set absolute mode)
G0 X10.5 ;(move to X10.5 including any G54-G59 and G92 offsets)
```

```gcode
G91 ;(set incremental mode)
G0 X-10.5 ;(move -10.5 in on the X axis)
```

## G92 Décalage du système de coordonnées

```gcode
Axes G92
```

G92 fait en sorte que la position de travail actuelle ait l'emplacement souhaité. Pour ce faire, il crée un décalage supplémentaire par rapport à la position actuelle [G54-G59](http://wiki.fluidnc.com/fr/features/supported_gcodes#g54-through-g59-select-coordinate-system). La valeur du décalage peut être lue avec la commande `$#`. Le décalage est volatile et sera perdu au redémarrage.

Cette commande ne doit être utilisée que par des utilisateurs expérimentés. L'effet désiré est perdu si le système redémarre, si vous changez de système [G54-G59](http://wiki.fluidnc.com/fr/features/supported_gcodes#g54-through-g59-select-coordinate-system) ou si le décalage G54-G59 actuel est modifié.  La plupart des gens devraient utiliser [G10](http://wiki.fluidnc.com/fr/features/supported_gcodes#g10-set-coordinate-system-offset). La plupart des expéditeurs de gcode utiliseront [G10](http://wiki.fluidnc.com/en/features/supported_gcodes#g10-set-coordinate-system-offset).

Par exemple, si vous utilisez `G92 X0 Y0 Z0` : Si vous utilisez `G92 X0 Y0 Z0`, l'équivalent serait `G10 L20 P0 X0 Y0 Z0` 

Il s'agit d'un vestige de l'époque du codage manuel. Si vous codez à la main un tas de gcode pour une pièce et que vous voulez couper une deuxième pièce sur le côté, vous pouvez utiliser le gcode pour faire la première pièce, puis utiliser G92 pour se décaler sur le côté et commencer une deuxième pièce avec exactement le même gcode. Vous devez toujours utiliser un décalage G54 (etc.) sur la première partie. Sinon, tout est perdu après la mise hors tension. Si vous utilisez G92 sans utiliser G10 avant, vous souffrez d'une intoxication au RepRap.


## G93, G94 Modes d'alimentation

G93 est le mode temps inverse. En mode d'avance à temps inverse, un mot F signifie que le déplacement doit être terminé en une minute divisée par le nombre F. Par exemple, si le nombre F est 2,0, le déplacement doit être terminé en une demi-minute. Par exemple, si le nombre F est de 2,0, le déplacement doit être effectué en une demi-minute.

Lorsque le mode d'avance en temps inverse est actif, un mot F doit apparaître sur chaque ligne qui a un mouvement G1, G2 ou G3, et un mot F sur une ligne qui n'a pas de G1, G2 ou G3 est ignoré. Le fait d'être en mode d'avance à temps inverse n'affecte pas les mouvements G0 (déplacement rapide).

```gcode
G93
ok
G1 X50 F10 ;move will take 1/10=0.6 minutes
ok
G1 X0 ;missing feedrate
error:22
$e=22  ;get the error text
22: Gcode undefined feed rate
ok
```

G94 (par défaut) est le mode Unités par minute. En mode d'avance par unités par minute, un mot F est interprété comme signifiant que le point contrôlé doit se déplacer à un certain nombre de pouces par minute, de millimètres par minute ou de degrés par minute, en fonction des unités de longueur utilisées et de l'axe ou des axes qui se déplacent.

# Mcodes

## M0 Pause

Cette commande met la machine en mode pause. Vous devez envoyer la commande de reprise (démarrage du cycle) `~` ou via une [entrée de commande](http://wiki.fluidnc.com/fr/config/control#control) `cycle_start_pin:`

## M2, M30 Fin du programme

Ces touches mettent fin au travail en cours. Ils ne doivent être utilisés qu'à la fin d'un fichier gcode. Leur utilisation n'est pas obligatoire.

**Note:** Parce qu'ils font les choses énumérées ci-dessous, c'est probablement une mauvaise idée de les utiliser dans une macro ou un fichier qui est exécuté à partir d'un autre fichier.

Ces deux commandes ont les effets suivants :

- Les décalages d'origine sont définis par défaut (comme G54).
- Le plan sélectionné est défini sur le plan XY (comme G17).
- Le mode de distance est réglé sur le mode absolu (comme G90).
- Le mode de vitesse d'avance est réglé sur les unités par minute (comme G94).
- Les dérogations d'avance et de vitesse sont réglées sur ON (comme M48).
- La compensation de coupe est désactivée (comme G40).
- La broche est arrêtée (comme M5).
- Le mode de mouvement actuel est réglé sur l'avance (comme G1).
- Le liquide de refroidissement est désactivé (comme M9).


## M3 Broche CW

Allumer la broche dans le sens des aiguilles d'une montre. Avec un laser, il s'agit d'un mode à puissance constante

## M4 Spindle CCW

Mettre la broche en marche dans le sens inverse des aiguilles d'une montre. Avec un laser, il s'agit du mode de puissance dynamique

## M5 Arrêt de la broche

Ceci désactive la broche. Vous pouvez définir ce qui se passe pendant la désactivation via la section « spindle » du fichier de configuration.

## M6 Changement d'outil 

```gcode
M6 T1
```

```gcode
T2 ; Tool #2 will be next
G0 X0 Y0
M6 ; now change to tool #2
```

Vous pouvez spécifier le numéro T n'importe où avant la ligne avec M6 ou sur la même ligne que M6.

> Avec FluidNC : Si vous avez plusieurs broches, cette commande peut être utilisée pour changer de broche. Voir la section sur les broches. 
{.is-info}

## M7, M7.1 Liquide de refroidissement par brouillard

Activation du liquide de refroidissement par brumisation. Il s'agit simplement d'un signal numérique qui peut être utilisé pour n'importe quelle fonction (vide, etc.).

M7.1 désactive le liquide de refroidissement.

> Le gcode standard utilise M9 pour désactiver le liquide de refroidissement. M7.1 fonctionnera dans FluidNC pour arrêter le refroidissement par brouillard. Aucune commande M de la norme ne comporte de .\<numéro\>. Cela peut prêter à confusion pour les personnes qui lisent votre code ou pour les expéditeurs de code qui diffusent votre code. 
{.is-warning}

## M8. M8.1 Liquide de refroidissement

Activer le liquide de refroidissement. Il s'agit simplement d'un signal numérique qui peut être utilisé pour n'importe quelle fonction (vide, etc.).

M8.1 désactive l'inondation par brouillard. (Voir la note M7.1 ci-dessus) 

## M9 Coolant Off

Ceci désactive à la fois M7 et M8. Voir M7.1 et M8.1 pour savoir comment les désactiver individuellement.

## M61 Régler l'outil actuel

- `M61 Qn` Modifie l'outil dans `Qn` sans changer d'outil. Cette fonction est utilisée lorsqu'un outil est installé sans que FluidNC ne le sache. Cela n'affecte pas le TLO ([G43](http://wiki.fluidnc.com/en/features/supported_gcodes#g43-tool-length-offset)). Il faut le régler séparément.

## M62, M63, M64, M65 Sortie numérique

  - `M62 Pn` Active la sortie numérique synchronisée avec le mouvement. Le mot P indique le numéro de la sortie numérique.
  - `M63 Pn` Désactiver la sortie numérique synchronisée avec le mouvement. Le mot P indique le numéro de la sortie numérique.
  - `M64 Pn` Activation immédiate de la sortie numérique. Le mot P indique le numéro de la sortie numérique.
  - `M65 Pn` Désactiver immédiatement la sortie numérique. Le mot P indique le numéro de la sortie numérique.

```gcode
M62 P0 ;turn on digital0_pin in your config file
M63 P0 ;turn it off.
```
> Nous vous recommandons d'éviter les commandes M64 et M65. Ces commandes non synchronisées sont imprévisibles.
{.is-info}

## M66 Lire les données de l'utilisateur

Il s'agit d'une implémentation partielle du gcode LinuxCNC de la M66. Seul le mode immédiat 0 est supporté. Le mode immédiat est utile pour les tests conditionnels dans la programmation du gcode.

- **P** spécifie le numéro de l'entrée numérique de 0 à 7.
- **E** spécifie le numéro de l'entrée analogique de 0 à 3.
- **L** spécifie le type de mode d'attente.
- **Q** spécifie le délai d'attente en secondes. Si le délai est dépassé, l'attente est interrompue et la variable #5399 contient la valeur -1. La valeur Q est ignorée si le mot L est zéro (IMMEDIATE). Une valeur Q de zéro est une erreur si le mot L est différent de zéro.

Mode 0 : IMMEDIATE - pas d'attente, retour immédiat. La valeur actuelle de l'entrée est stockée dans le paramètre #5399.

``` gcode
M66 P0 L0
ok
o100 if [#5399]
  G53G0Z-1 ; move to top of Z
o100 endif
```
## M67 Sortie analogique

Cette fonction est utilisée pour définir le niveau PWM d'une sortie. Elle utilise les paramètres suivants. Ceux-ci sont définis dans la section des sorties utilisateur du fichier de configuration.

  - `E` Le numéro de la sortie
  - `Q` Le pourcentage du cycle de travail 0% - 100%

  ```GCode
  M67 E0 Q23.76
  ```
  
# Groupes modaux

Vous pouvez placer plusieurs commandes sur une seule ligne de gcode, à condition que deux commandes ou plus ne fassent pas partie du même groupe modal. Par exemple, G20 (mode pouces) et G21 (mode millimètres) appartiennent tous deux au groupe des unités. Vous ne pouvez pas placer G20 et G21 sur la même ligne.

  - Modes du mot G
    - Mouvement (groupe 1) G0, G1, G2, G3, G38.2
    - Sélection du plan (groupe 2) G17, G18, G19
    - Mode distance (groupe 3) G90, G91
    - Mode de distance Arc IJK (Groupe 4)
    - Mode vitesse d'avance (groupe 5) 
    - Mode Unité (Groupe 6) G20, G21
    - Système de coordonnées (Groupe 12) G54, G55, G56, G57, G58, G59
  - Modes du mot M 
    - Mode arrêt (Groupe 4) M0, M2, M30
    - Broche (Groupe 7) M3, M4, M5
    - Arrosage (groupe 8) M7, M8, M9 (M7 et M8 peuvent être actifs en même temps)

# État modal actuel

Une fois que vous avez défini une valeur dans un groupe modal, elle reste en vigueur.

```gcode
G1 F100 X100
X200 ; we are still in G1 and F100
G0 ; switch to G0 mode
X100 ; move to X100 in G0 mode
G1 X200 ; switch to G1 mode and use existing speed of F100

```
Vous pouvez voir quels sont les modes en vigueur avec la commande `$G`.


```
$G
OK
[GC:G0 G54 G17 G21 G90 G94 M0 M5 M9 T0 S0.0 F500.0]
```

# Meilleures pratiques

## Réinitialiser les valeurs modales

La première ligne de vos fichiers gcode devrait réinitialiser toutes les valeurs modales. Vous devez vous assurer que des éléments tels que G90/G91 sont dans l'état attendu, sinon votre gcode pourrait se comporter de manière inattendue. Voici un exemple de ligne qui ramène plusieurs valeurs modales aux valeurs par défaut de FluidNC.

```gcode
G0 G54 G17 G21 G90 G94
```

> Si vous créez des macros, vous devez également garder cela à l'esprit. Vous pourriez vouloir ramener les valeurs modales aux valeurs par défaut.
{.is-info}




 





















