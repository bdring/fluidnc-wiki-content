---
title: 1.10 Contrôle (inputs)
description: configuration des inputs
published: true
date: 2026-08-01T19:40:16.967Z
tags: fr
editor: markdown
dateCreated: 2025-03-15T19:13:39.081Z
---

## Contrôle
Cette section est utilisée pour les entrées de contrôle. Ceux-ci sont généralement utilisés avec des interrupteurs.

<a name="safety_door_pin">**safety_door_pin:**</a> 
- Type : [Pin](http://wiki.fluidnc.com/en/config/config_IO#configuring-pins) (entrée)
    - Plage : gpio
    - Défaut : NO_PIN
    - Détails : Cette fonction est typiquement utilisée avec une porte d'enceinte. Si la machine est en marche, elle s'arrête rapidement et passe en mode « porte » ([voir les modes disponibles](http://wiki.fluidnc.com/fr/support/serial_protocol#mode-section)). Il est souvent utilisé avec la [fonction de stationnement](http://wiki.fluidnc.com/fr/features/parking). Vous devez désactiver l'interrupteur pour utiliser la machine. Si l'ouverture de la porte interrompt une tâche en cours, celle-ci peut être reprise après la fermeture de la porte par un cycle_start. Le cycle_start peut être effectué via un bouton play/resume dans l'interface utilisateur de l'expéditeur (qui envoie le caractère en temps réel `~`), ou en appuyant sur un interrupteur connecté à une broche de cycle_start.

- <a name="reset_pin">**reset_pin:**</a>
- Type : [Pin](http://wiki.fluidnc.com/fr/config/config_IO#configuring-pins) (entrée)
    - Plage : gpio
    - Défaut : NO_PIN
    - Détails : Effectue une « réinitialisation douce », identique à l'envoi du caractère Ctrl-X en temps réel via l'interface utilisateur.

 - <a name="feed_hold_pin">**feed_hold_pin:**</a>
- Type : [Pin](http://wiki.fluidnc.com/fr/config/config_IO#configuring-pins) (entrée)
    - Plage : gpio
    - Défaut : NO_PIN
    - Détails : Effectue une « réinitialisation douce », identique à l'envoi du caractère Ctrl-X en temps réel via l'interface utilisateur.
    
 - <a name="cycle_start_pin">**cycle_start_pin:**</a>
- Type : [Broche](http://wiki.fluidnc.com/fr/config/config_IO#configuring-pins) (entrée)
    - Plage : gpio
    - Défaut : NO_PIN
    - Détails : Reprend un travail en pause, de la même manière qu'en envoyant le caractère '~' en temps réel via l'interface utilisateur. Associé à « feed_hold_pin », il permet d'interrompre et de reprendre une machine à l'aide de boutons physiques. 

- <a name="macro0_pin">**macro0_pin:**</a>
- Type : [Broche](http://wiki.fluidnc.com/fr/config/config_IO#configuring-pins) (entrée)
    - Plage : gpio
    - Défaut : NO_PIN
    - Détails : Exécute la macro0 [configurée dans cette section](http://wiki.fluidnc.com/fr/config/macros), ce qui revient à envoyer le caractère temps réel 0x87 via l'interface utilisateur.

 - <a name="macro1_pin">**macro1_pin:**</a>
- Type : [Broche](http://wiki.fluidnc.com/fr/config/config_IO#configuring-pins) (entrée)
    - Plage : gpio
    - Défaut : NO_PIN
    - Détails : Exécute la macro 1 [configurée dans cette section](http://wiki.fluidnc.com/fr/config/macros), ce qui revient à envoyer le caractère temps réel 0x88 via l'interface utilisateur.
    
 - <a name="macro2_pin">**macro2_pin:**</a>    
- Type : [Pin](http://wiki.fluidnc.com/fr/config/config_IO#configuring-pins) (entrée)
    - Plage : gpio
    - Défaut : NO_PIN
    - Détails : Exécute la macro 2 [configurée dans cette section](http://wiki.fluidnc.com/fr/config/macros), ce qui revient à envoyer le caractère temps réel 0x89 via l'interface utilisateur.
    
 - <a name="macro3_pin">**macro3_pin:**</a>
- Type : [Pin](http://wiki.fluidnc.com/fr/config/config_IO#configuring-pins) (entrée)
    - Plage : gpio
    - Défaut : NO_PIN
    - Détails : Exécute la macro 2 [configurée dans cette section](http://wiki.fluidnc.com/fr/config/macros), ce qui revient à envoyer le caractère temps réel 0x8a via l'interface utilisateur.

 - <a name="fault_pin">**fault_pin:**</a>
 - Type : [Broche](http://wiki.fluidnc.com/fr/config/config_IO#configuring-pins) (entrée)
    - Plage : gpio
    - Défaut : NO_PIN
    - Détails : Effectue un arrêt brutal, provoquant l'arrêt immédiat de tous les mouvements sans décélération, ce qui peut entraîner une perte de précision de la position.  Arrête la broche si off_on_alarm est vrai dans la configuration de la broche active.  Entre dans l'état d'alarme critique, qui ne peut être quitté que par une réinitialisation douce.
      - (depuis la version 3.7.5) Cette fonction peut être utilisée avec un arrêt d'urgence. Un véritable [arrêt électronique devrait également couper l'alimentation](http://wiki.fluidnc.com/fr/features/e_stop_button).
      - Depuis (v3.9.3) L'état d'alarme critique bloque le retour à la maison et le déverrouillage.
      - Les actions de fault_pin et estop_pin sont identiques. fault_pin est destiné à être utilisé pour les défauts détectés par la machine, tels que les signaux d'alarme du pilote de pas à pas.
      
 - <a name="estop_pin">**estop_pin:**</a>
- Type : [Broche](http://wiki.fluidnc.com/fr/config/config_IO#configuring-pins) (entrée)
    - Plage : gpio
    - Défaut : NO_PIN
    - Détails : Effectue un arrêt brutal, provoquant l'arrêt immédiat de tous les mouvements sans décélération, ce qui peut entraîner une perte de précision de la position.  Arrête la broche si off_on_alarm est vrai dans la configuration de la broche active.  Entre dans l'état d'alarme critique, qui ne peut être quitté que par une réinitialisation douce.
      - (depuis la version 3.7.5) Cette fonction peut être utilisée avec un arrêt d'urgence. Un véritable [arrêt électronique devrait également couper l'alimentation](http://wiki.fluidnc.com/fr/features/e_stop_button).
      - Depuis (v3.9.3) L'état d'alarme critique bloque le retour à la maison et le déverrouillage.
      - Les actions de fault_pin et estop_pin sont identiques. fault_pin est destiné à être utilisé pour les défauts détectés par la machine, tels que les signaux d'alarme du pilote de pas à pas.
      
 - <a name="homing_button_pin">**homing_button_pin:**</a>
   - Type : [Pin](http://wiki.fluidnc.com/FR/config/config_IO#configuring-pins) (entrée)
   - Portée : gpio
   - Valeur par défaut : NO_PIN
   - Détails : Cette fonction permet d'effectuer un retour à la maison ($H) lorsqu'elle est activée. 
            
## État initial

Toutes les entrées de contrôle doivent être dans l'état non actif au moment de la mise sous tension. Cela permet d'éviter d'utiliser une machine dont l'interrupteur est bloqué. L'état actif peut être modifié à l'aide des [attributs haut/bas](http://wiki.fluidnc.com/fr/config/config_IO#Input-Pin-Attributes).

## Rapport

L'état des broches est disponible via la commande d'état ' ?

## Note de compatibilité :

Les 4 premières broches indiquées ci-dessous sont les mêmes que les broches standard de Grbl (v1.1). Elles déclenchent les mêmes actions que les caractères en temps réel [tels que définis ici](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Commands#grbl-v11-realtime-commands). 

Le Grbl standard ne prend en charge que les broches Door, Reset, Feed Hold et Cycle start. Si vous utilisez les autres broches, les expéditeurs de gcode Grbl ne seront probablement pas très utiles pour signaler ou utiliser ces broches.

## Exemple

```yaml
control:
  safety_door_pin: NO_PIN
  reset_pin: NO_PIN
  feed_hold_pin: NO_PIN
  cycle_start_pin: NO_PIN
  macro0_pin: NO_PIN
  macro1_pin: NO_PIN
  macro2_pin: NO_PIN
  macro3_pin: NO_PIN
  fault_pin: gpio.34
  estop_pin: gpio.2
```

