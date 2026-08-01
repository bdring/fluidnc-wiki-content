---
title: 2.8 Caractéristique du stationnement
description: Configuration des paramètres de stationnement
published: true
date: 2025-03-25T19:20:26.971Z
tags: fr
editor: markdown
dateCreated: 2025-03-22T17:47:25.745Z
---

# Dispositif de stationnement

La fonction de stationnement est associée à la broche [safety door](http://wiki.fluidnc.com/fr/config/control#safety_door_pin) ou à la commande en temps réel SafetyDoor (0x84). Si vous utilisez la fonction de stationnement, la machine se déplace vers un emplacement sûr sur un axe donné. Il est généralement utilisé avec l'axe Z. La séquence est décrite ci-dessous.

- Le mouvement décélère jusqu'à l'arrêt
- Il effectue un retrait initial de **PARKING_PULLOUT_INCREMENT** mm de la pièce à une vitesse de **PARKING_PULLOUT_RATE** mm/sec
- La broche est arrêtée.
- Il attend l'arrêt de la broche
- Il se déplace ensuite vers **PARKING_TARGET**, dans l'espace machine, à une vitesse de **PARKING_RATE**.

Utiliser la commande de démarrage ou de reprise du cycle, `~`, pour revenir au mouvement.

- Il se déplace à **PARKING_PULLOUT_INCREMENT** mm au-dessus de l'ouvrage.
- La broche est mise en marche.
- Il attend l'essorage
- Elle se déplace à l'endroit où le mouvement de stationnement initial a commencé. Il reprend le travail.

## Configuration

 - <a id=« enable »>**enable:**</a>
   - Type: [Boolean](/config/overview#boolean)
   - Default: true
   - Details: Permet la fonction de stationnement.
 - <a id=« axis »>**axis:**</a>
   - Type: [String](/config/overview#string) 
   - Default: Z
   - Details: Quel axe se déplacera pendant la séquence de stationnement.
 - <a id=« pullout_distance_mm »>**pullout_distance_mm:**</a>
   - Type: [Float](/config/overview#float)
   - Default: 5.0
   - Details: La distance de l'arrachement se déplace. Ceci est un relatif à l'emplacement avant le début de la séquence de stationnement.
 - <a id=« pullout_rate_mm_per_min »>**pullout_rate_mm_per_min:**</a>
   - Type: [Float](/config/overview#float)
   - Default: 250.0
   - Details: Le taux de déplacement initial de la sortie.   
 - <a id=« target_mpos_mm »>**target_mpos_mm:**</a>
   - Type: [Float](/config/overview#float)
   - Default: -5.0
   - Details: Cible du déménagement final. Il s'agit d'un espace machine qui n'est affecté par aucun décalage de courant..
 - <a id=« rate_mm_per_min »>**rate_mm_per_min:**</a>
   - Type: [Float](/config/overview#float)
   - Default: 800.0
   - Details: Le rythme du passage à la position finale du parc.
   
Exemple:

```yaml
parking:
  enable: true
  axis: Z
  pullout_distance_mm: 5.000
  pullout_rate_mm_per_min: 250.000
  target_mpos_mm: -5.000
  rate_mm_per_min: 800.000
```

## Statut

Le [rapport d'état](http://wiki.fluidnc.com/fr/support/serial_protocol) standard indique l'état de la séquence de porte.

  - `Door:0` Porte fermée. Prêt à reprendre. Utilisez la commande de démarrage du cycle ou le bouton pour reprendre.
  - `Door:1` Machine arrêtée. La porte est encore entrouverte. Ne peut pas reprendre tant qu'elle n'est pas fermée.
  - `Porte:2` Porte ouverte. Maintien (ou rétraction du parking) en cours. La réinitialisation déclenche une alarme.
  - `Porte:3` Porte fermée et reprise. Remise en place à partir de la position de stationnement, le cas échéant. La réinitialisation déclenche une alarme

```
<Door:1|MPos:151.000,149.000,-1.000|Pn:D|FS:0,0|WCO:12.000,28.000,78.000>
```

## Désactivation de la fonction parking

Vous pouvez utiliser l'élément de configuration [deactivate_parking](https://wiki.fluidnc.com/fr/config/start_group#deactivate_parking) pour désactiver cette fonction.

## Remplacer la fonction de stationnement

La commande **M56** peut être utilisée pour faire basculer la fonction. Utilisez **M56 P0** pour désactiver la fonction et **M56 P1** pour l'activer.

## Cas particuliers

### Homing

Si vous interrompez le repérage en ouvrant la porte, le repérage s'arrêtera et une alarme se déclenchera. La séquence de stationnement ne s'exécutera pas, car nous supposons que la position de la machine n'est pas connue si vous êtes en train d'effectuer un repérage. Vous devez fermer la porte, lancer une réinitialisation ctrl+x (0x18), puis effectuer un nouveau déplacement.




```


