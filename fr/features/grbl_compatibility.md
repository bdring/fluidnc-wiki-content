---
title: 2.1 Grbl Compatibilité
description: 
published: true
date: 2025-03-24T09:17:54.568Z
tags: fr
editor: markdown
dateCreated: 2025-03-21T06:44:01.386Z
---

# Compatibilité Grbl

## Vue d'ensemble

Notre objectif était d'avoir suffisamment de compatibilité avec Grbl pour permettre l'utilisation d'expéditeurs de gcode conçus pour Grbl. Il s'agit uniquement de la partie relative à l'envoi du code source (exécution d'un travail). Nous n'avons pas essayé de le rendre compatible avec les assistants de configuration dont disposent certains expéditeurs.

## Protocole de ligne série

FluidNC implémente le protocole de ligne GRBL selon [Classic Grbl Line Protocol](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Interface) et [serial_protocol](/support/serial_protocol). Comme pour le Plain Old Grbl, les commandes sont envoyées ligne par ligne, avec un contrôle de flux via des accusés de réception de type « ok » ou « erreur... ». Il existe quelques « commandes en temps réel » à un seul caractère qui ne sont pas orientées "ligne" ; elles sont utilisées pour des actions immédiates telles que les demandes d'état, la pause/reprise du programme et les dérogations.

En plus des demandes de rapport d'état de Grbl via **?**, `$G`, et `$#`, FluidNC dispose également d'une fonction optionnelle [Automatic Reporting](/support/interface/automatic_reporting)

FluidNC dispose d'un grand nombre de commandes « $... » en plus du jeu de commandes Grbl, comme décrit dans [FluidNC Commands_and_Settings](/features/commandes_et_settings).  FluidNC n'implémente que très peu des paramètres Grbl $nnn (nnn est un nombre). Ces paramètres numérotés sont destinés à la configuration de la machine. FluidNC configure la machine à l'aide d'un système de configuration hiérarchique qui est beaucoup plus étendu que ce qui serait pratique avec des « noms » numériques.

## Compatibilité émetteur / code GC

Tout ce que vous feriez dans le cadre d'un travail normal est compatible avec Grbl

- Gcodes. Nous supportons tous les gcodes de Grbl et plus encore.
- Le repérage
- Mise à zéro des axes
- Jogging
- Priorités sur l'avance et la vitesse
- Rapports
- Commutation du mode laser
- Commandes en temps réel (Hold, Resume, Reset)

## Compatibilité de l'installation

FluidNC possède beaucoup plus de fonctions et d'options que Grbl. Grbl utilise des paramètres numériques en $. Il n'était pas pratique d'essayer d'émuler ou d'étendre ce système. Par exemple : Grbl dispose d'une valeur d'extraction de l'autoguidage, alors que FluidNC en dispose d'une pour chaque moteur. Cela ajoute beaucoup de flexibilité, mais rompt la compatibilité des réglages. 

Nous prévoyons de créer nos propres assistants. Nos paramètres sont basés sur du texte et se décrivent d'eux-mêmes. L'interface WebUI comporte des fonctions permettant de définir un grand nombre d'entre eux.

N'essayez pas d'utiliser les assistants de configuration de Grbl

## Message de démarrage personnalisé

Certains expéditeurs exigent un message de démarrage précis comme **Grbl 1.1f ['$' pour l'aide]** Vous pouvez le définir comme vous le souhaitez avec la commande **\$Start/Message**. [Voir les détails ici](http://wiki.fluidnc.com/fr/features/commands_and_settings#firmware_build)

