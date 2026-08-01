---
title: 3.4 Codes d'alarme et d'erreur
description: 
published: true
date: 2025-03-25T18:10:31.381Z
tags: fr
editor: markdown
dateCreated: 2025-03-25T18:09:59.297Z
---

# Codes d'erreur

> Vous pouvez obtenir des descriptions des codes d'erreur en utilisant `$E` pour voir tous les codes et `$E=<numéro de code>` pour obtenir le texte d'un numéro d'erreur spécifique. 
{.is-info}


  - 0 : Pas d'erreur**

  - 1 : Lettre attendue de la commande GCodecommand**

  - **2 : Mauvais format de numéro de GCode**

  - **3 : Déclaration $ invalide**

  - **4 : Valeur négative**

  - **5 : Réglage désactivé**

  - **6 : Impulsion de pas trop courte**

  - **7 : Échec de la lecture des paramètres**

  - **8 : La commande nécessite un état d'inactivité**

  - 9 : Le code GC ne peut pas être exécuté dans un état de verrouillage ou d'alarme.

  - **10 : Erreur de limite souple**

  - **11 : Ligne trop longue**
  
- 12 : Max step rate exceeded** Votre valeur de configuration dépasse le taux de pas maximum. Cela peut être dû à de nombreux facteurs, notamment la vitesse, les pas/mm et les longueurs d'impulsion. Voir la [page des axes](http://wiki.fluidnc.com/fr/config/axes). 

  - **13 : Vérifier la porte**

  - **14 : Ligne de démarrage trop longue**

  - **15 : Course maximale dépassée pendant la marche par à-coups**
  
  - **16 : Commande de jogging non valide**

  - **17 : Le mode laser nécessite une sortie PWM**.

  - **18 : Aucun Homing/Cycle défini dans les paramètres**

  - **19 : Homing sur un seul axe non autorisé**

  - **20 : Commande GCode non prise en charge**

  - **21 : Gcode modal group violation** Voir ceci sur [modal groups](https://linuxcnc.org/docs/html/gcode/overview.html#_modal_groups)

  - **22 : Gcode undefined feed rate** Le gcode utilisé nécessite un feed rate. Vous devez avoir un F\<value\> sur ou avant la ligne avec le gcode.
  
  - **23 : La valeur de la commande Gcode n'est pas un entier**

  - **24 : Conflit de commande de l'axe du code gris**

  - **25 : Mot de code répété**

  - **26 : Gcode pas de mots d'axe**

  - **27 : Gcode invalid line number** (numéro de ligne non valide)

  - **28 : Gcode value word missing** Le gcode envoyé nécessite une valeur de paramètre spécifique. Voir la [page des gcodes pris en charge] (http://wiki.fluidnc.com/en/features/supported_gcodes).

  - **29 : Gcode unsupported coordinate system** (système de coordonnées non pris en charge)

  - **30 : Code G53 mode de mouvement non valide**

  - **31 : Gcode mots d'axe supplémentaires**

  - **32 : Gcode pas de mots d'axe dans le plan**

  - **33 : Gcode invalid target**

  - **34 : Erreur de rayon d'arc du code général**

  - **35 : Gcode no offsets in plane** (pas de décalage dans le plan)
  
  - **36 : Gcode mots inutilisés**

  - **37 : Code G43 erreur d'axe dynamique**

  - **38 : Valeur maximale du code G dépassée**

  - **39 : P param max dépassé**

  - **40 : Vérifier les broches de contrôle** (les broches de contrôle ne peuvent pas être actives au démarrage)

  - 60 : Échec du montage de l'appareil

  - 61 : Échec de la lecture

  - 62 : Échec de l'ouverture du répertoire

  - 63 : Répertoire non trouvé

  - 64 : Fichier vide

  - 65 : Fichier non trouvé

  - 66 : Échec de l'ouverture du fichier

  - 67 : L'appareil est occupé

  - 68 : Échec de la suppression du répertoire

  - 69 : Échec de la suppression du fichier

  - 70 : Le démarrage de Bluetooth a échoué

  - 71 : Le démarrage du WiFi a échoué

  - 80 : Numéro hors de la plage de réglage

  - 81 : Valeur invalide pour le réglage

  - 82 : Échec de la création du fichier

  - 90 : Échec de l'envoi du message

  - 100 : Échec de l'enregistrement du réglage

  - 101 : Échec de l'obtention de l'état du réglage

  - 110 : Échec de l'authentification !

  - 111 : Fin de ligne

  - 112 : Fin du fichier

  - 120 : Une autre interface est occupée

  - 130 : Jog annulé

  - 150 : Mauvaise spécification de broche

  - 152 : La configuration n'est pas valide. Vérifier les messages de démarrage pour les ERR.

  - 160 : Échec du téléchargement de fichier

  - 161 : Échec du téléchargement de fichier
  
# Codes d'alarme

> Vous pouvez obtenir des descriptions pour les codes d'erreur en utilisant `$A` pour voir tous les codes et `$A=<numéro de code>` pour obtenir le texte d'un numéro d'erreur spécifique. 
{.is-info}

Ce texte provient de `alarm_codes_en_US.csv` dans le repo Github

  - **1 : Limite dure** La limite dure a été déclenchée. Vous devez envoyer la commande de réinitialisation **0X18** ou **ctrl+X** à partir du clavier de FluidTerm. Il peut s'agir d'un bouton spécial sur votre émetteur de code source. La position de la machine est probablement perdue en raison d'un arrêt soudain. Il est fortement recommandé de procéder à un réacheminement.

  - **2 : Limite souple** Alarme de limite souple. La cible de mouvement du code G dépasse la course de la machine. La position de la machine est conservée. L'alarme peut être déverrouillée en toute sécurité.

  - 3 : Abandon en cours de cycle** Réinitialisation en cours de mouvement. La position de la machine est probablement perdue en raison d'un arrêt soudain. Il est fortement recommandé de procéder à un réacheminement.

  - **4 : Échec de la sonde** Échec de la sonde. La sonde n'est pas dans l'état initial attendu avant le début du cycle de sonde lorsque G38.2 et G38.3 ne sont pas déclenchés et que G38.4 et G38.5 sont déclenchés.
  
  - **5: Probe fail** Probe fail. Probe did not contact the workpiece within the programmed travel for G38.2 and G38.4

  - **6: Homing fail** Homing fail. The active homing cycle was reset.

  - **7 : Échec du centrage** Échec du centrage. La porte de sécurité a été ouverte pendant le cycle de radioralliement.

  - **8 : Échec du centrage** Échec du centrage. La course de retrait n'a pas réussi à dégager l'interrupteur de fin de course. Essayez d'augmenter le réglage de la course de retrait ou vérifiez le câblage.

  - **9: Homing fail** Homing fail. Could not find limit switch within search distances. Try increasing max travel, decreasing pull-off distance, or check wiring.

  - **10: Spindle Control**

  - **11: Control Pin**

  - **12: Ambiguous Switch** There is a limit switch active, but FluidNC does not have enough info to clear the switch. [See this](http://wiki.fluidnc.com/en/support/help_with_switch_problems#ambiguous-limit-switch-messages).

  - **13: Hard Stop**

  - **<a id=« Alarm14 »></a>14: Unhomed** Your machine needs to be homed. See the [must_home item](http://wiki.fluidnc.com/en/config/start_group) in the config file. You home with [\$H](http://wiki.fluidnc.com/en/config/homing_and_limit_switches). You can clear the error with [\$Alarm/Disable or \$X](http://wiki.fluidnc.com/en/features/commands_and_settings#alarmdisable-or-x).

  - **15 Init**