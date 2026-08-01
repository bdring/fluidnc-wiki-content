---
title: 1.9 Macros
description: configuration des macros
published: true
date: 2026-08-01T19:40:40.589Z
tags: fr
editor: markdown
dateCreated: 2025-03-15T18:39:40.070Z
---

# Macros

Les macros sont une courte série de gcodes et de commandes. Vous pouvez définir des macros dans votre fichier de configuration. Elles sont généralement associées à des boutons de commande et à des événements. Les macros peuvent également être définies séparément dans [WebUI](http://wiki.fluidnc.com/fr/features/webui#macros), [pendants](http://wiki.fluidnc.com/fr/hardware/pendants_displays) et [gcode senders](http://wiki.fluidnc.com/fr/support/gcode_senders). Consultez la documentation relative à ces éléments pour obtenir de l'aide à ce sujet.    

Les macros peuvent être utilisées pour exécuter certaines commandes en cliquant sur un bouton. Ces commandes peuvent être la plupart des commandes gcode et FluidNC, y compris l'exécution d'un fichier à partir de la carte SD. Si vous avez plus d'une commande, séparez-les par une esperluette « & ». **L'utilisation de « & » pour diviser une ligne en plusieurs commandes GCode ne fonctionne que pour les lignes de démarrage ; ce n'est pas une fonctionnalité générale de GCode.

## Exemple de macro

- **G90&G53G0Z-1&G0X0Y0** Ceci déplace le Z vers l'espace machine -1 (généralement vers le haut) et ensuite vers l'espace de travail X0 Y0.

## Utiliser des commandes et des paramètres dans les macros

Les macros sont généralement destinées à être utilisées avec le gcode. Certaines commandes $ peuvent être utilisées dans les macros mais vous devez être prudent lorsque vous les mélangez avec le gcode. Les commandes $ nécessitent généralement un état d'inactivité. Sinon, elles seront rejetées.

Si vous souhaitez exécuter une commande $ après une commande gcode, il est préférable d'ajouter un court délai (G4) pour attendre que la force termine le mouvement en premier.

De nombreuses commandes ne peuvent pas être utilisées dans les macros. Il s'agit en général de commandes qui modifient la configuration de FluidNC

## Utilisation de commandes en temps réel dans les macros

Les caractères temps réel sont des commandes d'un seul octet que FluidNC traite généralement immédiatement. Il s'agit généralement de caractères imprimables non ASCII, c'est pourquoi il existe une méthode spéciale pour les inclure dans les macros.

Envoyez le caractère ***#***, puis l'abréviation à deux lettres de la commande. En voici la liste.

```
    "fr" Feedrate Override Reset
    "f>" Feedrate override Coarse Increase
    "f<" Feedrate override Coarse Decrease
    "f+" Feedrate override Fine Increase
    "f-" Feedrate override Fine Decrease
    "rr" Rapid Override Reset
    "rm" Rapid Override Medium
    "rl" Rapid Override Low
    "rx" Rapid Override Extra Low
    "sr" Spindle Override Reset
    "s>" Spindle Override Coarse Plus
    "s<" Spindle Override Coarse Minus
    "s+" Spindle Override Fine Plus
    "s-" Spindle Override Fine Minus
    "ss" Spindle Override Stop
    "ft" Flood coolant Toggle
    "mt" Mist coolant Toggle
```

## Utilisation de paramètres et d'expressions dans le Gcode

Gcode peut également être utilisé comme un simple langage de programmation lorsque vous ajoutez [paramètres et expressions](http://wiki.fluidnc.com/fr/features/gcode_parameters_expressions)

## Eléments de configuration

- **startup_line0 : & startup_line1:** Il s'agit de fonctions héritées de Grbl, qui les appelait $N0 et $N1. Elles s'exécutent lorsque le firmware entre en veille pour la première fois.

- **macro0 à macro3** Il s'agit du texte de la macro qui s'exécutera lorsque le [commutateur de commande associé](https://github.com/bdring/FluidNC/wiki/Control) sera activé. Ces interrupteurs ne doivent pas être actifs au démarrage. Vous devez désactiver le commutateur avant d'effacer l'alarme.

- **after_homing** (à partir de la v3.7.6) Cette macro s'exécute une fois que le homing est terminé, c'est-à-dire une fois que tous les axes pour lesquels le homing est activé ont été homés.

- **after_reset** (à partir de la version 3.7.6) Cette macro s'exécute après la réinitialisation du système, soit à partir d'une mise sous tension/démarrage initial, soit après une réinitialisation CTRL-X en temps réel, mais uniquement si le système est en état de repos immédiatement après la réinitialisation.

- **after_unlock** (à partir de la version 3.7.6) Cette macro s'exécute après une commande de déverrouillage $X.

## Exemple de configuration

```yaml
macros:
  startup_line0:
  startup_line1:
  macro0: G90&G53G0Z-1&G0X0Y0
  macro1: $SD/Run=drill.nc
  macro2: 
  macro3: 
  after_homing: g0 x1 y1
  after_reset: g20
  after_unlock: g91
```

## Exécuter par commande

Envoyez `$Macros/Run=<numéro de macro>` ou `$RM=<numéro de macro>` comme `$Macros/Run=0` ou `$RM=0`. [Voir la page des commandes](http://wiki.fluidnc.com/fr/features/commands_and_settings#macros_run).  Les macros non numérotées ne peuvent pas être exécutées à partir d'une commande, sauf en déclenchant l'événement associé (par exemple, vous pourriez envoyer `$x` pour exécuter `after_unlock`).

## Exécuter via le commutateur

Configurez une broche `macro<switch>:` dans la [section de contrôle](http://wiki.fluidnc.com/fr/config/control).

