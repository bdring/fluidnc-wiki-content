---
title: 1.3 Démarrage (options de démarrage)
description: configuration des options de démarrage
published: true
date: 2026-08-01T19:41:06.049Z
tags: fr
editor: markdown
dateCreated: 2025-03-15T09:35:24.342Z
---

# Fichier de configuration Groupe de départ

Ce groupe contrôle les éléments optionnels qui se produisent au démarrage.

 - <a id="must_home">**must_home:**</a>
   - Type: [Boolean](http://wiki.fluidnc.com/fr/config/overview#boolean)
   - Valeur par défaut: true
   - Détails : Cette valeur détermine si vous êtes tenu d'effectuer un retour à la maison au démarrage ou non. Si cette valeur est vraie, vous obtiendrez une alarme de retour au domicile au démarrage. Cette alarme empêche tout mouvement jusqu'à ce que la machine soit réinitialisée ou que l'alarme soit supprimée..

 - <a id=« deactivate_parking »>**deactivate_parking:**</a>
   - Type : [Booléen](http://wiki.fluidnc.com/fr/config/overview#boolean)
   - Valeur par défaut : true
   - Détails : Désactive la fonction de stationnement.

 - <a id=« check_limits »>**check_limits**</a>
   - Type : [Booléen](http://wiki.fluidnc.com/fr/config/overview#boolean) 
   - Valeur par défaut : false
   - Détails : Si true, ceci indique si des interrupteurs de limite sont actifs au démarrage si `hard_limits` est vrai pour l'axe.

```yaml
start:
  must_home: true
  deactivate_parking: false
  check_limits: false
```