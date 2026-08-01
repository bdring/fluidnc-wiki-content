---
title: 2.12 Terminaux de série
description: 
published: true
date: 2025-03-25T19:22:25.689Z
tags: fr
editor: markdown
dateCreated: 2025-03-23T15:56:20.431Z
---

## Envoi de données

FluidNC traite les données serial caractère par caractère. Avec certains caractères spéciaux comme ? (état) et CTRL+X (réinitialisation), le traitement est extrêmement rapide. Il s'agit de caractères immédiats. Pour les autres caractères, il les stocke dans un tampon jusqu'à ce qu'il voie un caractère de fin de ligne. La fin de ligne peut être un retour chariot (CR) ou un saut de ligne (LF). Lorsqu'il voit le caractère de fin de ligne, il traite toute la ligne. Ceci est utilisé pour des choses comme le gcode, les commandes ou les paramètres. 

## Caractères immédiats.

Les caractères immédiats sont traités dès qu'ils sont vus, même s'ils se trouvent au milieu d'une commande. Exemple : si vous essayez de régler le SSID de l'AP sur « Hello?world », vous aurez des problèmes. Le système supprimera le ? (commande d'état), enverra l'état, puis définira la valeur à « Helloworld ». Voir ci-dessous. Dès que FluidNC a vu le ?, il a renvoyé le statut.

```
$AP/SSID=Hello<Idle|WPos:-26.000,-51.000,0.000|FS:0.000,0>
world
ok
$AP/SSID
$AP/SSID=Helloworld
```

Il n'y a que trois caractères immédiats qui sont des caractères imprimables standard. Cela limite le nombre de caractères qui causent le problème mentionné ci-dessus. Ce sont des caractères que vous ne pouvez pas envoyer à partir du port série à d'autres fins. Si vous devez les utiliser dans un mot de passe WiFi, etc., vous devez le faire via l'interface WebUI. Celle-ci gère l'envoi de chaînes de caractères un peu différemment.

- ? - Statut
- ! - Maintien de l'alimentation
- ~ Démarrage du cycle (reprise à partir du maintien de l'avance)

Les autres caractères ne sont pas des caractères d'impression. Ils sont généralement envoyés par des expéditeurs utilisant le code clé pour ce caractère. Une liste de ces codes se trouve dans [Serial.h](https://github.com/bdring/FluidNC/blob/main/FluidNC/src/Serial.h). Le caractère pour Reset peut être envoyé avec de nombreux terminaux série avec la touche CTRL-X du clavier.

> Les caractères immédiats ne répondent pas par un ok. Vous pouvez les envoyer à tout moment. Nous recommandons une fréquence maximale de 10Hz pour l'envoi de ? pour l'état.
{.is-info}

## Commandes, paramètres et code GC

Ces commandes sont envoyées ligne par ligne avec une fin de ligne. FluidNC les traite dès qu'il le peut. FluidNC répondra par un « ok » lorsqu'il sera prêt à recevoir une autre commande. Il y a un tampon pour les lignes de gcode. Si vous envoyez une commande pour un déplacement lent et long, FluidNC répondra immédiatement par un « ok », même si le déplacement n'est pas terminé. Il peut mémoriser plusieurs commandes. À terme, il faudra que les commandes précédentes soient terminées avant qu'il n'envoie un « ok ». Vous devez attendre le « OK » pour envoyer une autre commande. Les expéditeurs de gcode avancés peuvent compter les caractères en interne et suivre les tampons, mais cela dépasse le cadre de cette page wiki.

**Note:** Si vous envoyez à la fois un retour chariot et une fin de ligne (CR+LF) avec la commande, vous obtiendrez 2 'ok'. Le premier concerne la commande proprement dite. Le second 'ok' est pour la commande vide entre les caractères de fin de ligne. C'est un peu négligé, mais c'est bien de procéder ainsi. 

## Types de terminaux sériels

Il existe de nombreux types de terminaux série. Certains sont des programmes autonomes et d'autres sont intégrés dans des programmes, comme les IDE de programmation et les expéditeurs de code source. La plupart des terminaux série autonomes envoient des caractères dès que vous les tapez. Ceux qui sont intégrés à d'autres programmes vous demandent souvent de taper les caractères dans une zone de texte, puis de cliquer sur le bouton d'envoi. La touche « Entrée » envoie aussi généralement cette ligne. Elle envoie la ligne entière et ajoute une fin de ligne. 

## Terminaux d'envoi de ligne entière

Le moniteur du port série de l'IDE Arduino fonctionne de cette manière, ainsi que la plupart des émetteurs de gcode. Si vous envoyez le caractère immédiat ? avec ces terminaux, vous obtiendrez un 'ok'. Cela est dû au fait que FluidNC considère qu'il s'agit d'un caractère immédiat et d'une commande vide avec une fin de ligne. Le 'ok' est pour la commande vide. Dans la plupart des cas, vous ne pouvez pas envoyer de caractères spéciaux, comme CTRL-X, avec ce type de terminal. Les émetteurs GCode disposent souvent d'un bouton dédié à la réinitialisation. 

Sur certains terminaux comme celui-ci, la fin de ligne est configurable. Nous recommandons d'utiliser CR comme fin de ligne.

## Caractère à la fois Terminaux

Ces terminaux envoient chaque caractère à la fois et peuvent également envoyer des touches composées comme CTRL-X. La fin de ligne qui est envoyée avec la touche Entrée est généralement configurable. Il s'agit de CR.

**FluidNC ne renvoie normalement pas les caractères à l'expéditeur. Vous devez définir l'écho local sur votre terminal. C'est ainsi que fonctionnent Grbl et Grbl_ESP32. Nous avons voulu assurer la compatibilité avec ces logiciels, c'est donc le mode de fonctionnement par défaut. Voir le mode avancé ci-dessous pour une autre méthode. 

 **Note:** Certaines de ces méthodes n'envoient pas toutes les touches. Il peut utiliser la touche de tabulation, les touches fléchées ou CTRL-X pour les fonctions du programme hôte et ne pas envoyer le caractère. Le terminal série intégré dans platform.IO avec VSCode bloque quelques caractères.

## Mode terminal avancé

Un bon terminal série ressemble au terminal shell d'un système d'exploitation. Les terminaux shell possèdent des caractéristiques intéressantes que nous avons essayé d'émuler avec FluidNC. Les flèches haut/bas pour faire défiler l'historique des commandes que vous avez envoyées en sont un exemple basique. Pour ce faire, FluidNC doit faire l'écho des caractères. Vous devrez désactiver l'écho local si vous utilisez ce mode. Le mode avancé n'est pas activé par défaut. Ceci afin de préserver la compatibilité avec Grbl. Vous pouvez déclencher le mode en envoyant l'une des touches d'édition spéciales.

> CTRL+L désactive l'écho local.
{.is-info}


Vous trouverez ci-dessous les touches spéciales pour le mode d'édition avancé. Appuyez sur l'une de ces touches pour accéder au mode. La touche d'effacement arrière est probablement la meilleure touche pour démarrer ce mode. Si vous redémarrez, vous devez redémarrer le mode.    FluidTerm essaie d'activer automatiquement le mode dans certaines conditions, mais n'y parvient pas toujours.

> Les terminaux comme celui de VSCode n'envoient pas toutes les touches de non-impression énumérées ci-dessous. Il ne peut utiliser que partiellement les fonctions du mode avancé. FluidTerm les prend toutes en charge.
{.is-warning}

```
## Touches d'édition de ligne (le symbole de l'aiguille ^ signifie qu'il faut maintenir la touche de contrôle)
Flèche gauche ou ^B - caractère de retour en arrière
Flèche droite ou ^F - caractère vers l'avant
Flèche vers le haut ou ^P - rappeler la ligne précédente de l'historique
Flèche vers le bas ou ^N - rappeler la ligne suivante de l'historique
Accueil ou ^A - début de la ligne
Fin ou ^E - fin de la ligne
Delete ou ^D - supprimer le caractère sous le curseur (vers l'avant)
Effacement arrière ou ^H - suppression d'un caractère vers l'arrière
       ESC puis b - revenir en arrière jusqu'à la limite du mot
       ESC puis f - avancer jusqu'à la fin du mot
               ^W - effacer vers l'arrière jusqu'à la limite du mot
               ^U - efface toute la ligne
               ^K - efface le reste de la ligne après le curseur et sauvegarde
               ^Y - insérer le texte précédemment sauvegardé à partir du dernier ^K
Tab - Complète les mots des commandes et des paramètres
Les mots sont délimités par un espace, /, = ou une virgule.
```

# FAQ

## Pourquoi y a-t-il un double écho ?

Si vous voyez 2 caractères identiques à chaque fois que vous appuyez sur une touche, cela signifie que vous avez probablement un écho local activé dans votre terminal et que FluidNC se trouve dans le mode d'édition avancé. Désactivez votre écho local. Dans Fluidterm et miniterm (vscode), envoyez Ctrl+T et Ctrl+E pour basculer le mode écho.) 








