---
title: 1.13. Sonde
description: configuration des sondes
published: true
date: 2026-08-01T19:40:50.744Z
tags: fr
editor: markdown
dateCreated: 2025-03-16T09:42:38.479Z
---

# Probe

<img src="https://github.com/bdring/FluidNC/wiki/images/3axis_probe.jpg" width="300">

[image credit](https://makerparts.ca/products/makerparts-xyz-touch-plate?variant=16094253580382)

## Aperçu

Les palpeurs sont utilisés pour trouver la surface de la pièce. La plupart du temps, cela se fait sur l'axe Z, mais FluidNC permet de le faire avec n'importe quel axe. Le circuit du palpeur est une entrée de FluidNC, similaire à un interrupteur de fin de course. La méthode la plus courante consiste à utiliser la conductivité électrique de la mèche et une plaque métallique ou un palet d'épaisseur connue sur le matériau pour compléter un circuit. Vous pouvez également utiliser n'importe quel type de circuit qui s'ouvre ou se ferme par contact.

FluidNC déplace la sonde vers la surface. Lorsqu'un contact est détecté, FluidNC affiche la position sur le port série et sur les autres canaux connectés. Il décélère ensuite jusqu'à l'arrêt afin d'éviter toute perte de pas due à un arrêt immédiat. Si vous indiquez le paramètre P, FluidNC mettra l'axe à zéro en utilisant le décalage fourni.

La mise à niveau de surface multipoint n'est **pas prise en charge** par le microprogramme. Une simple version GCode aurait trop de paramètres pour être pratique. Une bien meilleure solution est d'avoir une interface graphique qui vous demande tous les paramètres de la grille. Beaucoup d'expéditeurs de gcode supportent cela. Ils modifient ensuite le code g en continu pour l'adapter au profil du matériau.  FluidNC supporte cette méthode.

##  Fichier de configuration

- **pin:**
  - Type: Pin (input)
  - Range: gpio
  - Default: NO_PIN
  - Details: C'est le signal de la sonde

- **toolsetter_pin:**
  - Type: Pin (input)
  - Range: gpio
  - Default: NO_PIN
  - Details: Il s'agit d'une deuxième sonde optionnelle..

- **check_mode_start:** 
  - Type: Boolen
  - Default: true
  - Details: Ceci forcera une vérification de la sonde avant qu'elle ne démarre..

- **hard_stop:**
  - Type: Boolean
  - Default: false
  - Details: Si c'est le cas, l'axe s'arrêtera brutalement au lieu de décélérer. Cette option peut être utilisée avec des pièces fragiles qui pourraient se briser en raison de la surcourse nécessaire à la décélération. Elle risque d'être moins précise à des vitesses plus élevées où le moteur peut sauter quelques étapes sans décélération.

Config Exemple:

```yaml
probe:
  pin: gpio.34
  toolsetter_pin: NO_PIN
  check_mode_start: true
  hard_stop: false
```

## Setup

Assurez-vous que la broche a le bon [attribut pour actif haut ou bas](http://wiki.fluidnc.com/fr/config/config_IO#input-pin-attributes). Vous pouvez le vérifier en envoyant la commande d'état ['?'](http://wiki.fluidnc.com/fr/support/serial_protocol#pin-section). Vous ne devez pas voir le « P » dans la réponse d'état de la section Pn :. Si vous voyez le P [inverser l'état actif](http://wiki.fluidnc.com/fr/support/faq#how-do-i-invert-a-pin-state).

Ensuite, activez manuellement la sonde en déclenchant l'interrupteur, en bouclant le circuit ou en faisant ce qu'il faut pour l'activer. Dans l'état actif, vous devriez voir le P dans la section Pn : lorsque vous envoyez la commande ?

Tant que vous n'avez pas réussi un test manuel, vous ne devez pas tenter une action réelle de la sonde.

## Utilisation de la sonde

Le palpage de base utilise une commande G38.2 pour palper un interrupteur ou un contact électrique. Vous pouvez ajuster l'[état actif](http://wiki.fluidnc.com/fr/config/config_IO#input-pin-attributes) du signal avec l'attribut high/low.

Si vous définissez **check_mode_start : true**, vous vérifierez que la sonde n'est pas touchée avant le déplacement. Si c'est le cas, vous recevrez une alarme 4

Si le déplacement de la sonde se termine sans activation d'une entrée de sonde, l'alarme 5 s'affiche.

Si le palpage est réussi, il émet un message du type `[PRB:151.000,149.000,-137.505:1]` avec la position de la machine au moment du contact. Le `1` à la fin indique que le palpage a réussi. Après le toucher, la machine décélère jusqu'à l'arrêt. Cela signifie que la position de la machine diffère de celle indiquée dans le message après le palpage. Il s'agit généralement d'un écart minime, mais vous devez en tenir compte. La surcourse est proportionnelle à la vitesse. Si la surcourse est élevée ou si le bit est très fragile, il risque de se briser.

Si la sonde échoue, elle émettra un message du type `[PRB:0.000,0.000,0.000:0]`. Le 0 à la fin indique que la sonde a échoué.

Vous devez spécifier les paramètres de l'axe de déplacement et une vitesse d'avance.

- **[G38.2 Z-5 F200](https://linuxcnc.org/docs/2.6/html/gcode/gcode.html#sec:G38-probe)** Cette opération permet de palper vers la position de travail Z-5 avec une avance de 200.
- **[G38.2 G91 Z-5 F200](https://linuxcnc.org/docs/2.6/html/gcode/gcode.html#sec:G38-probe)** Le paramètre G91 permet de descendre de 5 en Z avec une vitesse d'avance de 200. Remarque : sachez que le paramètre G91 persiste et affecte les codes g suivants. Vous devez le réinitialiser à G90 si c'était le mode précédent.
- **G53 G38.2 Z-125 F200 P16** Cette opération permet de palper Z-125 dans l'espace machine (G53).

Vous pouvez effectuer un palpage vers n'importe quel point d'un ou de plusieurs axes à la fois. Les limites souples seront respectées. Si la commande demande une course maximale qui dépasse la plage et que les limites souples sont vraies pour l'axe, vous recevrez une alarme.

## Réglage du travail zéro

La valeur du message PRB est le point exact où la sonde s'active. La machine décélère ensuite jusqu'à l'arrêt. La machine ne sera plus au point de palpage même si le palpeur avance lentement. La meilleure façon de définir un zéro de travail est d'utiliser la commande [**G10 L2 Px**](https://linuxcnc.org/docs/2.6/html/gcode/gcode.html#sec:G10-L2_), x étant le système de coordonnées. P0 correspond au système actuel. P1 à P6 sont utilisés pour spécifier [G54-G59](https://linuxcnc.org/docs/2.6/html/gcode/gcode.html#sec:G54-G59_3). Pour définir le Z de travail actuel à 0 après avoir reçu **[PRB:151.000,149.000,-137.505:1]**, envoyez **G10 L2 P0 Z-137.505**, en utilisant la valeur z du message PRB. Si vous avez une plaque ou un autre décalage, il suffit de l'ajouter à la valeur PRB.

## Paramètre P optionnel

Vous pouvez utiliser un paramètre « P » facultatif qui spécifie l'épaisseur (ou le décalage par rapport à 0) de l'appareil de mesure, comme une plaque ou un palet.

Lorsque le palpage est réussi, le décalage du système actuel est mis à zéro et la valeur P est appliquée. Cela facilitera grandement la tâche des afficheurs et des expéditeurs en cas de sondage.

Exemple : G38.2 G91 F80 Z-20 P8.00

Cette opération permet de palper une valeur incrémentale (G91) de -20 en Z. Elle règle la position du palpeur à 8,00 sur l'axe Z dans le système de coordonnées de travail actuel. 

**Notes:** 
 - Après le contact avec le palpeur, l'état indique que la position de l'axe est légèrement décalée par rapport à la position du palpeur.  Ceci est dû à la décélération après le palpage. La position du palpeur est précise par rapport au point de contact réel. Si vous souhaitez minimiser la surcourse, utilisez une vitesse plus faible (la meilleure) ou une accélération plus rapide (dans votre fichier de configuration). 
 - Vous ne pouvez spécifier un mouvement que sur un seul axe lorsque vous utilisez le paramètre P.

# Dépannage

## ALARM:4 Échec de la sonde. 

La sonde n'est pas dans l'état initial attendu avant de démarrer le cycle de palpage lors d'une tentative de palpage. Vous ne pouvez pas démarrer un cycle de palpage si la sonde est déjà active. Voir la [section de configuration](http://wiki.fluidnc.com/fr/config/probe#setup) ci-dessus.

# Macros

Les macros peuvent être utilisées pour sonder et définir les coordonnées de travail actuelles.

## Exemple utilisant le gcode standard

Cet exemple suppose que vous effectuez un palpage en Z à l'aide d'une plaque de palpage placée au-dessus de la pièce et d'une épaisseur de 10 mm. Il suppose également que vous vous trouvez au-dessus de l'emplacement du palpeur, au-dessus de la plaque.

```gcode
G21 ; utiliser les millimètres
G91 ; se déplacer en mode mouvement relatif
G38 Z-30 F80 P10 ; palpage d'un maximum de 30 mm vers le bas à une vitesse de 80
G90 ; utiliser le mode de déplacement absolu
G0 Z50 ; se rétracte à 30 mm au-dessus du travail
```

Utilisation d'expressions gcode

```gcode
; dual speed probe macro

; set parameters
#<fast_rate>=160
#<slow_rate>=80
#<probe_dist>=100
#<probe_offset>=10
#<retract_height>=5

G38.2 G91 Z[-#<probe_dist>] F#<fast_rate> ; probe fast
G0 Z3  ; retract a little
G38.2 G91 Z[-#<probe_dist>] F#<slow_rate>; probe slowly
#<wco_z_touch>=#5063 ; save the z touch WCO location
G0 Z[#<retract_height>+#<probe_offset>] ; retract
G10 L2 P0 Z[#<wco_z_touch>+#<probe_offset>]
G91 G0 Z[#<retract_height>+#<probe_offset>]
```

# Exemples

## Sonde bon marché

![cheap_toolsetter.jpg](/hardware/probes/cheap_toolsetter.jpg)

Il s'agit d'une sonde très répandue. Elle est bon marché, mais fonctionne assez bien. Il existe plusieurs couleurs et finitions. Il y a deux points d'activation. 

- **Signal de l'outil de travail**. C'est le premier point d'activation et probablement le plus précis. Il doit être relié à l'entrée de votre sonde.
- **Signal de sécurtié**. Il s'active après le parlpage "normal"(plus bas,) que l'autre signal. Généralement le 1er signal de parlpage d'outils va jusqu'à 5 mm au dela de 5 mm on active le signal de sécurtié pour arreter le palpage en urgence. Il est conçu comme un avertissement que vous êtes sur le point d'écraser votre outils. Il sauvera votre outils et peut-être d'autres choses si votre axe Z est très fort. Vous pouvez le connecter à n'importe quelle entrée d'alarme, comme la réinitialisation ou l'arrêt d'urgence. Vous pouvez également l'utiliser comme interrupteur de limite Z si vous utilisez des limites strictes. Si vous êtes à court d'entrées, mettez-le en parallèle ou en série avec un interrupteur de fin de course existant.

Les couleurs des fils sont assez aléatoires, mais les interrupteurs sont des interrupteurs mécaniques simples, de sorte que vous pouvez facilement déterminer le câblage avec un multimètre. Les interrupteurs sont vendus en version N.C. et N.O.


