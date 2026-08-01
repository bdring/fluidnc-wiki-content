---
title: 1.16 ATC
description: configuration d'un atc
published: true
date: 2026-08-01T19:42:01.259Z
tags: fr
editor: markdown
dateCreated: 2025-03-17T20:15:53.271Z
---

# Utilisation des ATC avec FluidNC

## Exemple

![atc_5.png](/features/atc_5.png =x320)

Voici une [vidéo d'un exemple](https://www.youtube.com/watch?v=3ikLcC5NidU). Cette opération a été réalisée à l'origine en Grbl_ESP32, mais la machine a été mise à jour en FluidNC.

**Avertissement** Il s'agit d'une nouvelle fonctionnalité. Les développeurs ne peuvent faire que des tests limités car nous n'avons pas accès à beaucoup d'équipements ATC. Vous devez évaluer toutes les fonctions ATC que vous souhaitez utiliser avec des « emplois aériens » sûrs pour déterminer si ces fonctions sont fonctionnelles et sûres sur votre machine.   
{.is-warning}

> Les ATC sont une fonction très avancée et ne sont pas recommandés aux débutants. La plupart des développeurs n'ont pas les moyens d'acheter des machines ATC pour tester et développer cette fonctionnalité. Si vous avez besoin d'aide et de soutien, n'hésitez pas à parrainer le projet. **Merci de respecter notre temps.
{.is-warning}

## Sécurité

Les ATC posent de nombreux problèmes de sécurité. Si votre machine ouvre l'ATC pendant qu'elle tourne, il est probable qu'elle projette cet outil à travers la pièce avec une mèche tranchante comme un rasoir. Cela pourrait vous tuer. Cela risque également d'endommager gravement votre broche. Soyez prudent et ne faites jamais confiance à votre machine ou au micrologiciel. **Vous êtes la seule personne responsable de votre sécurité.

> Pour obtenir le numéro d'outil actuel, vous pouvez envoyer $G ou [D#5400](http://wiki.fluidnc.com/fr/features/gcode_parameters_expressions#numbered-parameters).
{.is-info}

# Vue d'ensemble des types d'ATC pris en charge.

Il existe 4 types d'ATC qui peuvent être pris en charge par FluidNC

## Pas d'ATC

Si vous n'utilisez pas de macros ou de classe ATC, vous pouvez toujours utiliser les numéros d'outils pour changer de broche. Les numéros d'outils ne servent qu'à déterminer le numéro de broche. C'est le système original depuis le début de FluidNC. [Voir la page sur les broches](http://wiki.fluidnc.com/fr/config/config_spindles#using-multiple-spindles-and-tool-numbers).

## m6_macro

Chaque fuseau dans le fichier de configuration peut avoir une `m6_macro:`. Cela peut être du gcode ou vous pouvez spécifier un fichier à exécuter avec $SD/Run=myfile.gcode. Vous pouvez utiliser des paramètres et des expressions dans le gcode. Cela vous donne accès au numéro de l'outil, aux valeurs de la sonde et à d'autres informations. 

```yaml
pwm:
  pwm_hz: 5000
  ...
  atc:
  m6_macro: G55 G0X0Y0
```

## Classe ATC (C++)

Vous pouvez créer des classes ATC avancées. Les fuseaux peuvent utiliser ces classes via l'élément de configuration `atc:`. Cela permet à n'importe quel fuseau d'utiliser n'importe laquelle des classes existantes. 

```yaml
atc_manual:
  safe_z_mpos_mm: -1.000000
  probe_seek_rate_mm_per_min: 800.000000
  probe_feed_rate_mm_per_min: 80.000000
  change_mpos_mm: 80.000 0.000 -1.000
  ets_mpos_mm: 5.000 -9.000 -40.000
  ets_rapid_z_mpos_mm: -25.000000
  
pwm:
  pwm_hz: 5000
  ...
  atc: atc_manual
  M6_macro:
```

## Classes de broches spéciales

Si vous avez un ATC qui nécessite une interaction spéciale entre la broche et l'ATC, vous pouvez écrire une classe de broche personnalisée. Toutes les informations concernant le changement d'outil passent par la broche, vous pouvez donc agir à ce niveau si vous le souhaitez.

```yaml
my_spindle:
  pwm: 5000
  ...
  atc:
  M6_macro:
  my_config_item1: 
  my_config_item2:
```

# Détails

## M6 Macro

Une `m6_macro:` peut être utilisée avec n'importe quel type de broche. Elle s'exécutera si elle est définie et que la broche n'a pas d'élément de configuration ATC. [Pour en savoir plus sur les macros, cliquez ici](http://wiki.fluidnc.com/fr/config/macros).

Vous devez définir le numéro d'outil actuel avec `M61Q<numéro>` dans votre macro. Cela vous permet de décider si le changement d'outil a été effectué avec succès. Dans la plupart des cas, vous voudrez déclencher une alarme et quitter la macro en cas de problème. Utilisez `$Send/Alarm=3` (Abandon en cours de cycle)

### Comportement du Gcode

- **M61 Q\<num\>** Utilisé pour définir le numéro de l'outil déjà installé. Généralement effectué au démarrage si le numéro d'outil n'est pas correct.
  - Règle l'outil actuel.
  - La macro n'est pas exécutée
  - Ceci changera la broche si Q<tool_num> est dans la gamme d'une autre broche.
- **T\<quelque chose\>**
  - Présélectionne l'outil. Il ne se passe rien jusqu'à ce qu'un M6 arrive.
  - La macro n'est pas exécutée
- **M6**
  - Exécute la macro
- **M6 T\Noutil actuel\Nà T\Noutil actuel\N****.
  - Ne fait rien
- **M6 T\N<hors de la plage actuelle [outil de broche](http://wiki.fluidnc.com/fr/config/config_spindles#using-multiple-spindles-and-tool-numbers)\>**
  - Change de broche et utilise la nouvelle configuration ATC des broches.

### Flux de travail typique

à venir...

## spindle/atc : atc_manual

Cette méthode fait appel à une personne pour changer l'outil, mais elle utilise un régleur d'outil électronique pour automatiser le réglage du décalage de la longueur de l'outil (TLO), de sorte que l'axe Z n'a besoin d'être mis à zéro sur le travail qu'une seule fois. Dans l'idéal, le dispositif de réglage de l'outil a une certaine surcourse, ce qui permet de palper plus rapidement en toute sécurité.

![ets_01.png](/hardware/ets_01.png =x250)

Lorsqu'un changement d'outil est demandé pour la première fois, la longueur de l'outil actuellement mis à zéro est mesurée. Il se déplace ensuite jusqu'à l'emplacement de changement d'outil spécifié et reste en place. Vous changez manuellement l'outil et envoyez la commande de reprise. Le système mesure le nouvel outil et règle le TLO pour le remettre à zéro. Il revient ensuite à l'emplacement précédant la demande de changement d'outil.

### Comportement du Gcode

- **M61Q\<numérique>**
  - Définit l'outil actuel
  - S'il y avait un numéro d'outil précédent, il réinitialise le TLO à 0.0  
- **T0 ou M6T0** 
  - Se déplace à la position `change_mpos_mm:` et attend.
  - Réinitialise le TLO et les autres informations sauvegardées sur l'outil.
- **M6T\<pas 0\> De T0**
  - Se déplace à l'emplacement du changement et ne fait rien d'autre. Cette fonction est utilisée lorsque vous souhaitez insérer le premier outil.
- **M6T\<pas 0\> à T\<pas 0\>** première fois 
  - Détermine le décalage TS
  - Va à l'emplacement du changement d'outil
  - Définir le TLO
  - Retourne à la position avant la commande
- **M6T\<pas 0\> à T\<pas 0\>** après la première fois
  - Va à l'emplacement du changement d'outil
  - Régler TLO
  - Retourne à la position avant la commande
- **M6T\<outil actuel\> à T\<outil actuel\>**
  - Ne fait rien
  
### Flux de travail typique

La classe atc_manual est conçue pour accélérer un peu votre flux de travail en effectuant les opérations suivantes lors de l'exécution d'un fichier CAM.

- Déplacement vers un endroit pratique pour placer les outils de changement
- L'utilisation d'un dispositif de réglage d'outil élimine la nécessité de régler le zéro Z sur chaque outil.

C'est **ce que vous devez faire manuellement avant d'exécuter** des fichiers CAM.

- Accueil de la machine
- Installer le premier outil.
  - Si l'outil a déjà été installé, vous pouvez envoyer M61Q<num_outil> où <num_outil> est le numéro de l'outil. Comme M61Q2
  - Si vous devez installer un outil, envoyez M6T<numéro_outil>. La machine se déplace vers l'emplacement de changement. Vous pouvez maintenant installer l'outil.
- Remettez à zéro l'outil installé sur la pièce.
- Déplacez-vous vers un emplacement Z sûr.

Vous pouvez maintenant exécuter votre fichier CAM.

**Après que le fichier gcode est complet.**

- Si vous avez d'autres choses à faire avec la pièce en cours
  - Vous devez être en mesure d'exécuter un nouveau fichier gcode
  - Si le nouveau fichier utilise un nouvel outil, il se déplacera vers l'emplacement de modification pour que vous puissiez l'installer.
- Si vous allez utiliser une nouvelle pièce (même avec le même fichier gcode)
  - Les zéros de travail précédents ne sont probablement plus valables. 
  - Vous devez envoyer M6T0 pour réinitialiser toutes les valeurs sauvegardées.
  - Commencez le « flux de travail typique » illustré ci-dessus depuis le début.

### Notes sur le post-traitement

C'est votre post-processeur et le gcode qui en résulte qui en sont responsables.

- Se retirer du matériau avant la commande M6
- Allumer la broche et régler la vitesse après le retour du changement d'outil

### Utilisation d'un palpeur automatique et d'une machine d'usinage.

Vous pouvez utiliser le palpeur comme l'un de vos numéros d'outil. Vous effectuez le zéro avec le palpeur. Tous les outils de coupe doivent utiliser d'autres numéros d'outils. 

- Installer le palpeur.
- Envoyer M61Q1 (ou l'outil que vous avez attribué au palpeur)
- Utiliser le palpeur pour remettre la pièce à zéro
- Envoyez M6T2 (ou le premier outil de votre travail)
- Installer le premier outil.
- Exécutez votre travail gcode.

> Cela ne fonctionne que si le palpeur et la machine à écrire sont compatibles. Si l'un ou les deux sont à ressort. Lorsque le palpeur touche la matrice, celle-ci doit envoyer le signal avant que le palpeur ne bouge. 
{.is-warning}

### TODO

Sauvegarder le TLO et le numéro d'outil dans la NVRAM.

## Section du fichier de configuration

```yaml
atc_manual:
  safe_z_mpos_mm: -1.000000
  probe_seek_rate_mm_per_min: 400.000000
  probe_feed_rate_mm_per_min: 80.000000
  change_mpos_mm: 80.000 0.000 -1.000
  ets_mpos_mm: 5.000 -17.000 -40.000
  ets_rapid_z_mpos_mm: -25.000000
  
PWM:
  pwm_hz: 5000
  ...
  atc: atc_manual
  m6_macro:
```
- **safe_z_mpos_mm:**
  - Il s'agit de la position z à laquelle le mouvement se produira. Elle est généralement aussi élevée que possible afin d'éviter tout travail avec un long trépan installé.
- **probe_seek_rate_mm_per_min::**
  - Si cette valeur est supérieure à la valeur de `probe_feed_rate_mm_per_min:`, le système effectuera un palpage plus rapide, se rétractera et effectuera un second palpage au taux de `probe_feed_rate_mm_per_min`.
- **probe_feed_rate_mm_per_min:**
  - Il s'agit de la vitesse de la sonde utilisée pour déterminer le TLO.
- **change_mpos_mm:**
  - Il s'agit de l'emplacement dans mpos où vous souhaitez changer les outils. Il doit être facilement accessible.
- **ets_mpos_mm:**
  - Il s'agit de l'emplacement du dispositif électronique de réglage des outils. L'emplacement Z est utilisé pour vérifier la présence de pinces de serrage vides. Abaissez la broche jusqu'à ce qu'une pince de serrage vide se trouve juste au-dessus du dispositif de réglage d'outil. Si la broche descend aussi bas sur un palpeur de dispositif de réglage d'outil, le changement d'outil est interrompu et une alarme est déclenchée.
- **ets_rapid_z_mpos_mm:**
  - Cette fonction peut être utilisée pour accélérer le palpage. Le palpeur se déplace rapidement jusqu'à cette position Z avant le début du palpage.

