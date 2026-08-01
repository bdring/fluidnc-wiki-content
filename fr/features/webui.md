---
title: 2.4 WebUi
description: explication de l'utilisation de webui
published: true
date: 2025-03-25T19:19:18.062Z
tags: fr
editor: markdown
dateCreated: 2025-03-22T09:35:44.579Z
---

# WebUI

![webui.png](/webui/webui.png)

L'interface WebUI est un contrôleur basé sur un navigateur Web pour FluidNC. Il s'agit d'un projet distinct de FluidNC. Il ne peut être utilisé que via WiFi.

## Développement

L'équipe FluidNC n'a pas actuellement de développeur pour l'interface Web. Pour l'instant, nous ne faisons que de petites mises au point et des corrections. Nous serions heureux de recevoir de l'aide pour ce projet.  

## Code source

Il s'agit d'une branche de [ESP3D](https://github.com/luc-github/ESP3D-WEBUI). La branche fluidnc est [située ici](https://github.com/MitchBradley/ESP3D-WEBUI). La branche active actuelle est [revamp](https://github.com/MitchBradley/ESP3D-WEBUI/tree/revamp).

FluidNC fonctionne également avec la version 3 de WebUI, via [ce fork](https://github.com/michmela44/ESP3D-WEBUI/tree/3.0-FluidNCDev).

# Utilisation

> Cette page est un travail en cours et très incomplet pour l'instant. Aidez-nous ou faites un don au projet.
{.is-info}

## Installation

L'interface WebUI sera automatiquement installée avec le micrologiciel si vous utilisez le programme **install-fs** d'une version. Il s'agit d'un fichier appelé **index.html.gz** qui est installé dans le [système de fichiers local] (http://wiki.fluidnc.com/en/features/local_file_system). Vous pouvez à tout moment télécharger manuellement une version différente. L'installateur Web vous permet de choisir la version 2 ou 3 de l'interface WebUI lors du flashage de fluidnc.

## Reporting

Le flux d'informations peut être contrôlé de deux manières.

- Dans ce mode, FluidNC envoie l'état à l'interface Web. Il envoie des mises à jour à chaque changement d'état et à intervalles réguliers pendant les déplacements. Ce mode peut donner l'impression que l'affichage de l'état est plus réactif.
- Dans ce mode, l'interface WebUI envoie des requêtes à FluidNC.

Ces valeurs peuvent être sauvegardées dans les préférences.

> Un réglage trop bas de la fréquence de mise à jour peut entraîner une charge excessive sur l'ESP, ce qui peut nuire à son fonctionnement. Procédez avec précaution.
{.is-info}

![webui_reporting.png](/webui/webui_reporting.png)

## Panneau de contrôle

![webui_ctrl.png](/webui/webui_ctrl.png)

Ceci vous montre les positions actuelles des axes en [ coordonnées « travail » et « machine »](http://wiki.fluidnc.com/fr/support/machine_space_and_homing). Le nombre d'axes affichés est basé sur le nombre d'axes que vous avez dans votre fichier de configuration.

Les vitesses de jogging sont contrôlées en bas du panneau. Il n'y a que trois axes affichés dans la section jog à la fois, mais le Z peut être changé en A, B ou C.

## Macros

La section située à droite du panneau Jog est utilisée pour créer des macros.

![webui_macros.png](/webui/webui_macros.png =x400)

Il stocke votre configuration de macro dans un fichier appelé macrocfg.json. Voici le format de ce fichier.
```json
[
  {
  "name": "M1",
  "glyph": "star",
  "filename": "/macro1.g",
  "target": "ESP",
  "class": "btn-default",
  "index": 0
 },
 {
  "name": "M2",
  "glyph": "star",
  "filename": "/macro2.g",
  "target": "ESP",
  "class": "btn-default",
  "index": 1
 },
 {
  "name": "M3",
  "glyph": "star",
  "filename": "/macro3.g",
  "target": "ESP",
  "class": "btn-default",
  "index": 2
 },
 {
  "name": "M4",
  "glyph": "star",
  "filename": "/macro4.g",
  "target": "ESP",
  "class": "btn-default",
  "index": 3
 },
 {
  "name": "M5",
  "glyph": "star",
  "filename": "/macro4.g",
  "target": "ESP",
  "class": "btn-default",
  "index": 4
 },
 {
  "name": "",
  "glyph": "",
  "filename": "",
  "target": "",
  "class": "",
  "index": 5
 },
 {
  "name": "",
  "glyph": "",
  "filename": "",
  "target": "",
  "class": "",
  "index": 6
 },
 {
  "name": "",
  "glyph": "",
  "filename": "",
  "target": "",
  "class": "",
  "index": 7
 },
 {
  "name": "",
  "glyph": "",
  "filename": "",
  "target": "",
  "class": "",
  "index": 8
 }
]
```

## Onglet FluidNC

Cet onglet vous permet de visualiser la configuration. Vous pouvez modifier certains paramètres, mais beaucoup d'entre eux ne peuvent pas être modifiés lors de l'exécution. Cette fonctionnalité sera probablement complètement modifiée ou supprimée à l'avenir.

Les cinq boutons situés en haut sont...

- **Afficher l'état du système** Affiche l'état du système (sans rapport avec la CNC).
- **Gestion des fichiers locaux** Permet de gérer le [système de fichiers locaux](http://wiki.fluidnc.com/fr/features/local_file_system). L'utilisation la plus courante est la mise à jour de la [WebUI](http://wiki.fluidnc.com/fr/features/webui).
- Mise à jour du micrologiciel** Cette fonction vous permet d'effectuer une mise à jour du micrologiciel OTA (over the air). Vous pouvez trouver le fichier firmware.bin dans les fichiers zip de la version github dans les dossiers wifi et bt.
- Redémarrer FluidNC** Cette opération redémarre le contrôleur. Vous perdrez la connexion WiFi.
- **Réactualiser les paramètres** 

![webui_fnc_tab.png](/webui/webui_fnc_tab.png)

## Onglet Tablette

Ce tableau est optimisé pour l'utilisation de tablettes tactiles. Il comporte de grands boutons et s'adapte à la taille de l'écran.

![webui_tablet_tab.png](/webui/webui_tablet_tab.png)

## Préférences

Vous pouvez contrôler certaines fonctions, comme l'affichage du panneau de sondage de la WebUI, et enregistrer de nombreux paramètres dans le panneau des préférences. Vous y accédez à partir du menu hamburger situé dans le coin supérieur droit de la WebUI.

![webui_prefs.png](/webui/webui_prefs.png)









