---
title: 2.5 Système de fichiers locaux
description: Utilisation du système de fichiers sur l'ESP32
published: true
date: 2025-03-25T19:19:33.445Z
tags: fr
editor: markdown
dateCreated: 2025-03-22T17:25:49.737Z
---

# Vue d'ensemble

Le système de fichiers local se trouve sur l'ESP32, dans sa mémoire FLASH. Il est utilisé pour stocker les fichiers de l'interface WebUI, les fichiers de configuration et les petits fichiers gcode pour les macros. L'espace est très limité, donc peu de choses peuvent y être stockées. Son fonctionnement est très similaire à celui de la carte SD, les commandes étant préfixées par **LocalFS**, plutôt que **SD**.

> Note : Le système de fichiers local est implémenté avec **SPIFFS** ou, à l'avenir, **LittleFS**. Ces deux systèmes permettent de stocker des fichiers dans un périphérique FLASH. Si vous voyez une référence à SPIFFS ou LittleFs, il s'agit de la même chose que LocalFS dans ce cas.
{.is-info}

> Par défaut, le serveur web FluidNC refusera d'aller chercher des fichiers dans le système de fichiers Flash (y compris de recharger l'interface WebUI) à moins que votre machine ne soit inactive. Cela évite que l'accès à FS ne monopolise la bande passante de FLASH alors que le CPU pourrait avoir besoin de charger plus de code en mémoire.

> Cette mesure de sécurité est contrôlée par le paramètre `$HTTP/BlockDuringMotion` (depuis **v3.6.8**).
{.is-warning}

# Commandes de la console

## Listing des fichiers

Envoyez **$LocalFS/List**. Les résultats ressembleront au rapport ci-dessous.


```
[FILE:/index.html.gz|SIZE:122477]
[FILE:/3axis_v4.yaml|SIZE:1762]
[FICHIER:/favicon.ico|SIZE:1150]
[Local FS Free:44.86 KB Used:124.52 KB Total:169.38 KB]
```

## Affichage des fichiers texte

Envoyez **$LocalFS/Show=\<filename\>**. C'est un bon moyen de vérifier le contenu de fichiers tels que les fichiers de configuration.

**Exemple**

```
$localfs/show=fluidnc_pen_laser_2209.yaml
name: TMC2209 XY Servo Laser
board: FluidNC Pen/Laser 2209
meta:
stepping:
  engine: RMT
  idle_ms: 255
...

ok
```
## Fichiers en cours d'exécution

Envoyer **$LocalFS/Run=\<filename\>**. Ceci est utilisé pour exécuter les fichiers gcode.

## Formatage

Envoyez **$LocalFS/Format**. Cela reformatera le LocalFS. Si vous avez des difficultés à charger des fichiers alors qu'il devrait y avoir suffisamment d'espace, essayez de reformater.

## Suppression de fichiers

Envoyer **$Localfs/Delete=\<filename\>**

## Renommer des fichiers.

Envoyer `$Localfs/Rename=oldname>newname` pour renommer un fichier existant sur le disque local. 

## Obtenir la taille

Envoyez **$LocalFS/Size**. Les résultats ressembleront au rapport ci-dessous.

```
SPIFFS Total:169.38 KB Utilisé:124.52 KB
```

# Utilisation de l'interface WebUI

Vous pouvez accéder à LocalFS dans l'onglet FluidNC. Cliquez sur l'icône verte.

<img src="https://github.com/bdring/FluidNC/wiki/images/localfs_dialog.png" width="500">

- Télécharger des fichiers à l'aide du bouton de téléchargement
- Télécharger des fichiers en cliquant sur le nom du fichier dans la liste
- Supprimer avec l'icône de la corbeille.





