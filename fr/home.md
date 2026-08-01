---
title: FluidNC Wiki Page d'Acceuil
description: Page d'accueil de FluidNC CNC Firmware Wiki
published: true
date: 2026-08-01T19:37:11.395Z
tags: fr
editor: markdown
dateCreated: 2025-03-18T19:08:26.482Z
---

# Vue d'ensemble

![fluidnc.svg](/fluidnc.svg)

## Introduction

**FluidNC** est un firmware CNC optimisé pour le contrôleur ESP32. C'est la nouvelle génération de firmware des créateurs de Grbl_ESP32. Il comprend une interface utilisateur basée sur le web et la flexibilité de fonctionner avec une grande variété de types de machines. Cela inclut la possibilité de contrôler des machines avec plusieurs types d'outils tels que laser+broche ou un changeur d'outils.

Voir [Installation](/fr/installation) pour un guide de démarrage rapide de l'installation de FluidNC sur votre machine.

## Recherche Wiki

**Recherche Wifi:** Tout le contenu du wiki n'est pas accessible via le panneau de navigation. Veuillez utiliser la fonction de recherche si vous ne trouvez pas ce que vous cherchez. Vous pouvez également changer le panneau de navigation en une interface de type navigateur de fichiers pour voir toutes les pages. 
{.is-info}

## Architecture du micrologiciel

- Conception hiérarchique orientée objet
- Abstraction matérielle pour les caractéristiques des machines telles que les broches, les moteurs et les pilotes pas à pas
- Extensible - L'ajout de nouvelles fonctionnalités est beaucoup plus facile pour le micrologiciel et les expéditeurs de code source.

## Définition de la machine Méthode

Il n'est pas nécessaire de compiler le microprogramme. Vous utilisez un script d'installation pour télécharger la dernière version du firmware et créer un fichier texte [config file](/config/overview) qui décrit votre machine.  Ce fichier est téléchargé dans le FLASH de l'ESP32 en utilisant le port USB/Série ou le Wifi.  Il existe de nombreux exemples de fichiers de configuration pour différentes configurations que vous pouvez utiliser comme points de départ.  [FluidNC Web Installer](http://wiki.fluidnc.com/fr/installation#fluidnc-web-installer) dispose d'une fonction de configuration graphique qui vous guide tout au long du processus.

## Compatibilité Grbl

FluidNC est compatible avec Grbl pour les opérations quotidiennes telles que l'exécution de programmes GCode à partir d'un expéditeur.  La saveur GCode de FluidNC est compatible avec celle de Grbl, de sorte que les programmes CAM post pour Grbl génèrent un code que FluidNC exécutera correctement.

La configuration de FluidNC est cependant très différente de celle de Grbl.  Grbl est configuré de deux manières - avec les commandes **$number** et en éditant les fichiers source/en-tête C, puis en recompilant.  Les commandes **\$number** de Grbl (par exemple **\$100**) vous permettent de définir les paramètres de mouvement comme les vitesses maximales et quelques aspects des limites et du homing.  Pour des réglages plus profonds tels que l'affectation des broches du contrôleur et les types de broches, vous devez recompiler Grbl après avoir modifié les fichiers d'en-tête en langage C.  FluidNC est configuré avec un fichier texte comme décrit dans la section précédente.

Certains expéditeurs Grbl disposent d'assistants de configuration qui offrent une interface conviviale avec les commandes **\$number** de Grbl.  Ces assistants ne fonctionneront pas avec FluidNC car FluidNC n'implémente pas toutes les commandes **\$number** et même si c'était le cas, ces vieux assistants ne connaîtraient pas les très nombreuses nouvelles possibilités de configuration de FluidNC qui vont bien au-delà des capacités conventionnelles de Grbl.  Mais les anciens expéditeurs seront toujours en mesure de contrôler FluidNC et d'exécuter des programmes GCode une fois que l'installation et la configuration auront été effectuées par d'autres moyens.

FluidNC implémente un très petit nombre de commandes **\$number**  qui imitent celles de Grbl.  Vous pouvez en voir la liste en envoyant **$$**.  Elles ne sont pas utilisées pour configurer FluidNC, mais pour transmettre une quantité très limitée d'informations aux anciens expéditeurs qui ne supportent pas FluidNC.  Il existe quelques émetteurs qui émettent de telles commandes au démarrage afin de découvrir si, par exemple, le homing est activé.  FluidNC les implémente en lecture seule, afin que les anciens émetteurs puissent démarrer correctement, mais ne vous permet pas de les utiliser pour effectuer des modifications (le fichier de configuration est destiné aux modifications).

## WebUI

FluidNC comprend une interface Web intégrée basée sur un navigateur ([ESP3D-WebUI](https://github.com/luc-github/ESP3D-WEBUI)) qui vous permet de contrôler la machine à partir d'un PC, d'un téléphone ou d'une tablette sur le même réseau Wifi.  WebUI est un projet séparé, mais l'équipe FluidNC maintient un fork séparé avec quelques améliorations - notamment un mode tablette alternatif qui est optimisé pour une utilisation sur un ordinateur tablette, y compris un visualiseur GCode - et avec le support de certaines fonctionnalités spécifiques à FluidNC.  Le code source de notre version est disponible à l'adresse suivante : https://github.com/MitchBradley/ESP3D-WEBUI/tree/revamp

Pour utiliser WebUI, installez la version wifi de FluidNC, configurez FluidNC pour qu'il se connecte à votre réseau WiFi local et naviguez jusqu'à `fluidnc.local`

WebUI a maintenant deux versions principales, 2 et 3.  L'installation standard de FluidNC vous donne la version 2, mais vous pouvez la remplacer par la version 3 en allant sur https://github.com/michmela44/ESP3D-WEBUI/tree/3.0-FluidNCDev .

## Crédits

Le [Grbl original](https://github.com/gnea/grbl) est un projet génial de Sungeon (Sonny) Jeon. Je le connais depuis de nombreuses années et il est toujours très serviable. J'ai utilisé Grbl sur de nombreux projets.

Le Wifi et la WebUI sont basés sur [ce projet](https://github.com/luc-github/ESP3D-WEBUI).

L'équipe FluidNC remercie les personnes suivantes pour leurs contributions à la base de code :

https://github.com/odaki - a écrit le pilote I2S qui permet l'extension des sorties.  Cette fonctionnalité a été cruciale pour créer des cartes de contrôleur flexibles qui prennent en charge plusieurs axes et différents scénarios d'utilisation, au lieu d'avoir à créer différentes cartes pour allouer le nombre limité de GPIO de l'ESP32 à différentes fonctions.

https://github.com/atlaste - a écrit le code pour configurer FluidNC à partir d'un fichier texte yaml et nous a appris à utiliser efficacement le langage C++.  La configurabilité à partir d'un fichier yaml élimine la nécessité pour chaque utilisateur de compiler sa propre version de FluidNC.

## Discussion

![discord-logo_trans.png](/discord-logo_trans.png =x80) 

Nous avons un [serveur Discord](https://discord.gg/j29vtknJnU) pour le soutien et le développement de ce projet.

## Dons

Ce projet nécessite beaucoup de travail et souvent des articles coûteux pour les tests. Merci d'envisager un don sûr, sécurisé et très apprécié via les liens PayPal ou Github Sponsor ci-dessous. 

Lorsque nous fournissons un support pour des contrôleurs chinois ou bricolés bon marché, nous perdons du temps pour le développement de FluidNC. Ces contrôleurs sont bon marché parce que les vendeurs ne les supportent pas. Vous devriez vraiment faire un don si nous vous avons aidé.

N'hésitez pas à choisir n'importe quelle personne ci-dessous. Nous travaillons ensemble et sommes heureux pour la personne qui reçoit le don.

---

A Mitch Bradley pour le firmware FluidNC et l'assistance

![paypal-logo.png](/paypal-logo.png =x80)[ ![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/donate/?hosted_button_id=8DYLB6ZYYDG7Y)

---

A Bart Dring pour le firmware FluidNC et l'assistance

![github-logo.png](/github-logo.png =x78)[ ![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://github.com/sponsors/bdring)

---

A Joacim Breiler (Web Installer, UGS et beaucoup d'aide pour FluidNC)

![github-logo.png](/github-logo.png =x78)[ ![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://github.com/sponsors/breiler)

---

Vers Luc pour le micrologiciel de l'interface Web

![paypal-logo.png](/paypal-logo.png =x80)[ ![](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FQL59C749A78L)

> Si vous faites un don et que vous êtes sur notre serveur Discord, veuillez nous indiquer votre nom d'utilisateur Discord. Nous pourrons vous identifier comme sponsor. Cela vous donnera un badge de parrainage à côté de votre nom et encouragera d'autres personnes à parrainer FluidNC. 
{.is-info}

## Suivez-nous

[ ![instagram_icon.png.webp](/logos/instagram_icon.png.webp =x50)](https://www.instagram.com/fluidnc_cnc_firmware/#)




 


