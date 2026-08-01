---
title: 3.10 Lignes directrices pour les demandes d'extraction
description: 
published: true
date: 2026-08-01T19:42:00.890Z
tags: fr
editor: markdown
dateCreated: 2025-03-27T19:25:55.330Z
---

# Lignes directrices pour la création de pull requests.

## Question

Veuillez créer un problème pour une discussion générale concernant les changements dans la demande d'extension. L'idéal est de le faire avant que la demande ne soit soumise. Les pull requests sont toujours les bienvenues et encouragées, mais coordonner les efforts permet de gagner du temps pour tout le monde. Les discussions via Discord sont également acceptables. Mettez un lien vers la discussion dans la description du PR.

## Branches

Veuillez cibler la *dernière version de* la branche principale avec vos demandes de modifications.

**Avant de soumettre votre PR, assurez-vous de récupérer tous les derniers changements dans votre arbre de travail, sinon il en résultera un désordre qui pourrait annuler le travail déjà effectué.** La commande git `git pull --rebase upstream main` - ou l'opération équivalente depuis l'une des interfaces utilisateur de Git, est la meilleure façon de le faire.  Le mot clé est « rebase ».  Si le rebasement pose des problèmes, un autre workflow git consiste à créer une nouvelle branche basée sur la dernière main, puis à « récupérer » vos commits de votre branche de travail sur la nouvelle branche.

Pour les dispositifs expérimentaux, il est également acceptable de cibler d'autres branches que la branche principale.

## Versioning

Le versionnage est appliqué lors de la publication d'une version

## Style de code

[Voir ce document pour notre style de codage](https://github.com/bdring/FluidNC/blob/main/CodingStyle.md)

Ajoutez votre nom au début des fichiers. Incluez vos noms d'utilisateur @github et @discord pour que les questions du support puissent vous être adressées.

## Directives importantes pour le code.

- **ISRs:** Les ISRs doivent être très rapides. Ils bloquent tous les traitements, y compris les tâches du RTOS. L'ESP32 a un [bogue de virgule flottante](https://esp32.com/viewtopic.php?t=1292) lié aux BVR et au FPU. N'utilisez pas de flottants dans les BVR ou dans tout ce qui pourrait être appelé par un BVR. Les doubles peuvent être utilisés. Ils contournent la FPU, mais nécessitent beaucoup de temps de traitement.  

## Procédure d'examen et d'approbation.

Nous travaillons généralement sur plusieurs choses en même temps. Celles-ci sont typiquement sur des branches ou des PRs. Nous déterminons ce que nous voulons inclure dans la prochaine version. Seuls les éléments que nous prévoyons de publier ensuite seront fusionnés avec la version principale. N'hésitez pas à essayer de nous convaincre de l'ajouter à la prochaine version via Discord, mais respectez notre décision.

Si votre PR n'est pas destiné à notre prochaine version, il devra attendre.

## Discord

Les devs discutent sur Discord. Nous avons quelques canaux réservés aux développeurs où seuls les développeurs peuvent poster. Nous les restreignons pour limiter les bavardages. Si vous avez besoin d'un accès pour poster, veuillez le demander sur un canal public de Discord.

## Le Wiki

Si vous créez un nouvel élément configurable, vous devez également fournir des informations pour le wiki.


