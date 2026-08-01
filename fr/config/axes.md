---
title: 1.4 Axes
description: configuration des axes
published: true
date: 2026-08-01T19:39:58.826Z
tags: fr
editor: markdown
dateCreated: 2025-03-15T10:06:11.958Z
---

# FluidNC Axes Setup

FluidNC supports 12 motors on 6 axes. Cette page détaille les différentes façons dont les pas sont générés, les réglages et l'intégration avec différents matériels. 

<a id="stepping"></a>
## Stepping:

Il s'agit d'une section importante pour les moteurs. 

- <a id="stepping_engine"></a>**engine:** 
  - Type : [Énumération](http://wiki.fluidnc.com/fr/config/overview#enum) 
  - Plage de valeurs : **RMT**| **TIMED**| **I2S_STATIC** | **I2S_STREAM**
  - Valeur par défaut : RMT
  - Détails : Ce paramètre détermine la méthode utilisée pour générer les pas dans le micrologiciel. Le matériel de la carte contrôleur est conçu pour des pas RMT ou I2S, vous devez donc choisir une méthode que votre matériel utilise.  Il n'est pas possible de mélanger les types de pas sur différents moteurs. Les types pris en charge sont les suivants : 
  
  - <a id="RMT"></a>**RMT** permet de simplifier le matériel pour les projets qui ne sont pas limités par le nombre de broches GPIO. Il est typiquement utilisé sur les cartes de contrôleurs qui n'ont pas plus de 4 ports moteurs indépendants. Il utilise la fonction [RMT](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/peripherals/rmt.html) de la puce ESP32 pour gérer la génération d'impulsions pas à pas sans perdre de temps dans des boucles de retard. Il planifie une séquence de transitions de tension à l'avance et se déclenche ensuite pour chaque impulsion de pas. Les broches de pas et de direction sont des broches GPIO natives. Ainsi, s'il y a beaucoup de moteurs, il restera peu de GPIO pour d'autres utilisations.
  - <a id="TIMED"></a>**TIMED** a les mêmes limitations de broches que RMT mais est moins efficace, il n'y a donc aucune raison de l'utiliser. Il utilise l'unité centrale pour piloter directement les pas à pas, ce qui nécessite des délais qui gaspillent des cycles de l'unité centrale.
  - <a id="I2SO"></a>**I2SO** (I2S Output Only) est un moyen de piloter des moteurs avec moins de broches GPIO en utilisant l'interface de bus I2S de l'ESP32. Elle nécessite un matériel externe spécifique sur la carte contrôleur ([lire la suite](/hardware/controller_design_guidelines#IS2O_Chips)). Si vous utilisez du matériel I2SO, il doit y avoir une définition I2SO valide dans votre fichier de configuration. Le [contrôleur 6-pack](https://www.tindie.com/products/33366583/6-pack-universal-cnc-controller) était la carte originale pour utiliser ce moteur. D'autres ont depuis utilisé le design de base pour des cartes différentes telles que MKS DLC32 et Tinybee.<a id="I2S_STATIC"></a>**I2S_STATIC** et <a id="I2S_STREAM"></a>**I2S_STREAM** sont identiques.  Les deux noms distincts existent pour des raisons historiques, lorsqu'il y avait deux variantes avec des compromis différents pour la vitesse par rapport à la latence.  Aujourd'hui, en choisissant l'une ou l'autre, on invoque le même code, ce qui permet d'obtenir une vitesse élevée, une faible latence et une absence de gigue.
  
> Les gens demandent souvent si la méthode I2S peut être utilisée pour l'expansion des entrées.  Bien que cela soit théoriquement possible, il existe des complications qui la rendent moins intéressante que d'autres méthodes d'expansion d'entrée.  Nous ne prévoyons pas d'implémenter l'entrée I2S.  Pour l'extension des entrées, nous recommandons et soutenons l'utilisation d'un MCU auxiliaire qui communique avec le FluidNC ESP32 via une connexion UART.
{.is-note}

- <a id="idle_ms"></a>**idle_ms:**  
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Plage de valeurs : 0-255
  - Valeur par défaut : 250
  - Détails : Une valeur de 255 maintient les moteurs activés en permanence (préférable pour la plupart des projets). Toute valeur comprise entre 0 et 254 fera en sorte que la broche désactivée soit activée autant de millisecondes après la dernière étape. **Note:** Les moteurs peuvent être désactivés manuellement à tout moment avec la commande **[$MD](http://wiki.fluidnc.com/fr/features/commands_and_settings#motordisable-or-md)**.

- <a id="pulse_us"></a>**pulse_us:** 
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Plage de valeurs : 0-10
  - Valeur par défaut : 4
  - Détails : Durée des impulsions de pas (microsecondes). Il s'agit de la durée d'activation de l'impulsion. Il faut généralement une durée « off » égale. Cela signifie que le nombre maximum de pas par seconde sera de 1 000 000/(pulse_us*2). Les pilotes pas à pas ont une durée minimale requise pour les impulsions afin de les enregistrer. Si le fabricant fournit une fiche technique pour le pilote pas à pas, cette valeur peut y être trouvée. 
  
- <a id="dir_delay_mus"></a>**dir_delay_us:**
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Plage : 0 -10
  - Valeur par défaut : 0
  - Détails : Délai (microsecondes) nécessaire entre un changement de direction et une impulsion de pas. De nombreux pilotes n'ont pas besoin d'un délai ici.
  
- <a id="segments"></a>**segments:** 
  - Type : [Integer](/config/overview#integer)
  - Plage : 6-20
  - Valeur par défaut : 12
  - Détails : Ce paramètre définit le nombre de tampons de segment. Il est conseillé de laisser cette valeur par défaut, à moins que vous n'essayiez d'affiner une application particulière.
  
Exemple

```yaml
stepping:
  engine: I2S_static
  idle_ms: 250
  pulse_us: 4
  dir_delay_us: 4
  disable_delay_us: 0
  segments: 6
```

## Limitations de vitesse

Les signaux de pas sont envoyés sous forme d'impulsions. Chaque impulsion a une durée décrite ci-dessus. Le **pulse_us** est la durée « on » de l'impulsion. Elle nécessite généralement une durée « off » égale. D'autres paramètres comme **dir_delay_us** peuvent également contribuer à la durée totale de chaque impulsion. Le nombre maximal absolu d'impulsions que vous pouvez envoyer par seconde (Hz) est de 1/(durée totale de l'impulsion). Cela n'a rien à voir avec la vitesse du processeur, il s'agit simplement de mathématiques. En réalité, la vitesse maximale est comprise entre 100 et 125 kHz. Ce sera plus lent si vous utilisez de longues durées d'impulsion.

Les éléments de configuration qui définissent ce taux sont **pas_par_mm** et le taux d'impulsion maximum. Voici l'équation qui permet de déterminer ce taux. 

```
(steps_per_mm * (max_rate_mm_per_min) / 60)
```

Vous pouvez donc constater que **pas_par_mm** a un impact important. N'utilisez pas un nombre plus élevé que nécessaire, ou la vitesse maximale en souffrira. Envisagez de réduire votre micropas pour obtenir un **pas_par_mm** plus faible.

Certains de ces calculs sont vérifiés avec cette formule lorsque le fichier de configuration est chargé. Vous pouvez obtenir des erreurs si les taux sont dépassés, vous pouvez également obtenir des plantages. 

```
1000000 / ((2 * pulse_us) + dir_delay_us)
```

La vitesse du processeur peut également entrer en ligne de compte si chaque étape nécessite un temps de traitement important. La gravure laser à haute densité en est un exemple.

> Si vous dépassez la vitesse maximale, vous obtiendrez une erreur de ce type : « [MSG:ERR : Erreur d'initialisation à /axes/y : Stepping rate 157750 steps/sec exceeds the maximum rate 125000] »
{.is-warning}

<a id="axis"></a>
## Axes

- <a id="shared_stepper_disable_pin"></a>**shared_stepper_disable_pin**
  - Type : [Broche](http://wiki.fluidnc.com/fr/config/overview#pin)
  - Plage : gpio ou I2SO 
  - Défaut : NO_PIN
  - Détails : il s'agit d'une broche reliée à plusieurs pilotes de moteur (généralement tous) : Il s'agit d'une broche reliée à plusieurs pilotes de moteur (généralement tous). Elle bascule avec la fonction d'activation/désactivation du moteur. Vous pouvez également attribuer des broches au niveau de chaque moteur. 

- <a id="shared_stepper_reset_pin"></a>**shared_stepper_reset_pin:**
  - Type : [Broche](http://wiki.fluidnc.com/fr/config/overview#pin)
  - Plage : gpio ou I2SO
  - Défaut : NO_PIN
  - Détails : Il s'agit d'une broche reliée à plusieurs pilotes de moteur. C'est une caractéristique que l'on trouve souvent sur les prises de commande de steptick. Actuellement, cette broche ne règle que la tension au moment de la mise sous tension et reste inchangée. Il est également possible d'affecter des broches au niveau de chaque moteur.

- <a id="homing_runs"></a>**homing_runs:**
  - Type : Integer
  - Valeur par défaut : 2
  - Plage de valeurs : 1 à 5
  - Détails : Ce paramètre définit le nombre de touches pendant la séquence de retour à la maison. La valeur par défaut est 2 pour correspondre au style Grbl.
  
  Exemple

```yaml
axes:
  shared_stepper_disable_pin: NO_PIN
  shared_stepper_reset_pin: NO_PIN
  homing_runs: 2
```

<a id="axis-letter"></a>
## Lettre de l'axe

```yaml
axes:
  [x:|y:|z:|a:|b:|c:]
```

#### Lettres d'axe & Axes linéaires ou rotatifs.

Les axes doivent être utilisés dans l'ordre. En cas d'utilisation d'une machine XZ, un axe Y doit être déclaré. Si l'axe Y n'est pas défini, FluidNC définira un axe virtuel sans sortie. Cette exigence est due à un problème de rapport. Le rapport envoie des valeurs telles que 000.000, 000.000, 000.000. Les axes ne sont pas étiquetés, vous supposez donc qu'ils sont dans l'ordre XYZABC. Le nombre minimum d'axes est de 3. Si vous ne définissez que X et Y, un Z virtuel sera créé.

L'axe ABC n'indique pas la position en pouces : 

Les axes XYZ sont traditionnellement des axes linéaires et les axes ABC sont considérés comme des axes rotatifs. Les axes ABC peuvent être utilisés comme des axes linéaires avec un inconvénient : ils n'indiquent pas les unités en pouces. FluidNC utilise les millimètres en interne et met à l'échelle les pouces pour les axes XYZ. Cependant, il ne met pas à l'échelle ABC car il suppose qu'il s'agit d'une échelle universelle comme les degrés ou les radians qui ne changent pas pour les pouces.

- <a id="steps_per_mm"></a>**steps_per_mm:** 
   - Type : [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)
   - Plage : 0.001 à 100000.000
   - Valeur par défaut : 80.000
   - Détails : Il s'agit d'une valeur flottante pour la résolution de l'axe. Il s'agit de pas du point de vue du contrôleur. Si vous utilisez un pilote à micropas, multipliez les pas du moteur par cette valeur. 
   
- <a id="max_rate_mm_per_min"></a>**max_rate_mm_per_min:**
    - Type: [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)
    - Plage: 0.001 to 100000.000
    - Default: 1000.000
    - Details:
    
- <a id="max_travel_mm"></a>**max_travel_mm:**
    - Type : [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)
    - Plage de valeurs : 0.1000 à 10000000.0
    - Valeur par défaut : 1000.000
    - Détails : Plage de travail de l'axe. Mesurée à partir de l'emplacement de l'axe après avoir retiré l'interrupteur de fin de course. Si vous utilisez un interrupteur de fin de course à l'autre extrémité de la course pour une limite dure, assurez-vous que max_travel_mm n'atteindra pas le second interrupteur.  Si le second interrupteur est actionné avant que la limite souple ne prenne effet, une alarme sera déclenchée.
    
- <a id="soft_limits"></a>**soft_limits:**  
    - Type : [Booléen](http://wiki.fluidnc.com/fr/config/overview#boolean)
    - Valeur par défaut : false
    - Détails : Si cette option est réglée sur true (vrai), les commandes qui amèneraient la machine à dépasser *max_travel_mm* seront interrompues. Les commandes de jogging sont limitées dans ce mode, de sorte qu'il n'est pas possible d'obtenir une alarme de limite souple pendant le jogging. Le jogging s'arrêtera simplement avant la fin de la course.  Les limites souples dépendent de la précision de la position de la machine. En général, il faut d'abord effectuer un homing. **Si vous utilisez les limites souples, il faut toujours faire le centrage de l'axe avant de déplacer l'axe par jogging ou par gcode.
    
**Exemple:**

```yaml
axes:
  x:
    steps_per_mm: 800.000
    max_rate_mm_per_min: 4500.000    
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 180.000
    soft_limits: true
```

<a id="homing"></a>
## Homing

Le repérage est une fonction optionnelle qui permet de se déplacer vers un emplacement spécifié de la machine, déterminé par des commutateurs ou des capteurs situés à l'extrémité d'un ou de plusieurs axes.  La fin du processus de positionnement établit l'origine du « système de coordonnées de la machine ».  Le centrage est facultatif car la plupart des flux de travail CNC ne dépendent que du « système de coordonnées de travail » dont l'origine est relative au stock, et non à l'ensemble de la machine.  Le centrage implique généralement plusieurs « cycles », au cours desquels un ou plusieurs axes sont déplacés jusqu'à leur extrémité.  Par exemple, il est courant de positionner l'axe Z dans le premier cycle, en le déplaçant jusqu'en haut, afin que l'outil ne heurte pas le stock ou les dispositifs de serrage au cours d'un cycle ultérieur au cours duquel les axes X et Y sont déplacés jusqu'à leurs extrémités.

Ces touches permettent d'effectuer le centrage au niveau de la lettre de l'axe. Même si un axe a plus d'un moteur, il se déplace toujours vers une extrémité et à une vitesse spécifique.

- <a id="cycle"></a>**cycle:** 
  - Type : [Integer](/config/overview#integer)  
  - Plage : -1 à 6  
  - Valeur par défaut : -1
  - Interactions : l'autoguidage multi-axes ne peut pas être utilisé avec CoreXY, car 2 moteurs sont utilisés pour le déplacement de chaque axe.  
  - Détails : 
    - Les cycles de positionnement déterminent le positionnement de chaque axe. Les cycles vous permettent de positionner les axes un par un ou de regrouper quelques axes dans un seul cycle pour un positionnement multi-axes. Attribuez le même numéro à plusieurs axes pour les placer dans le même cycle. De nombreuses personnes commencent par le Z (cycle : 1) et peuvent ensuite effectuer le retour de X et Y en même temps (cycle : 2).
    - Un réglage de 1 ou plus permet à l'axe de s'orienter avec `$H`. Tout réglage inférieur à 1 sera un cycle inactif et aucun déplacement physique ne se produira pour cet axe.
    - Un réglage de 0 signifie que l'axe ne sera pas déplacé avec `$H`, mais vous pouvez toujours le déplacer avec `$H<axis>`.
    - Une valeur de -1 signifie que la machine ne se déplacera pas, mais que la position courante de la machine (mpos) de l'axe sera fixée à la valeur **mpos_mm** de l'axe. Ceci peut être utilisé pour les axes qui n'ont pas de commutateurs.
    - Généralement, vous mettez l'axe Z sur le cycle 1 et les autres axes sur des cycles plus élevés.

- <a id="allow_single_axis"></a>**allow_single_axis:**
  - Type : [Booléen](http://wiki.fluidnc.com/fr/config/overview#boolean)  
  - Valeur par défaut : `true`  
  - Détails : Permet le centrage d'un seul axe (exemple : `$HX` pour centrer l'axe X).  
Mettez false si vous n'avez pas d'interrupteurs de fin de course, ou pour bloquer la commande. Vous pouvez vouloir la bloquer parce que le centrage d'un seul axe débloque la machine même si les autres axes ne sont pas centrés. Les limites souples ne sont précises que sur les axes homologues et ne protègent pas une machine dont tous les axes n'ont pas été homologues.

- <a id="positive_direction"></a>**positive_direction:** 
  - Type : Booléen  
  - Valeur par défaut : true
  - Détails : contrôle la direction dans laquelle l'axe se déplace lors du centrage : Contrôle la direction dans laquelle l'axe se déplace lors du centrage. true permet de centrer l'axe dans la direction positive, ce qui signifie qu'il se déplace vers une valeur de position plus élevée.

- <a id="mpos_mm"></a>**mpos_mm:**
  - Type : [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)  
  - Portée : -1000000.000 à 1000000.000
  - Valeur par défaut : 0.000
  - Détails : Définit la position de la machine après l'autoguidage et le déclenchement de l'interrupteur de fin de course en millimètres. Si vous souhaitez que la position de la machine soit nulle au niveau de l'interrupteur de fin de course, réglez ce paramètre sur zéro. N'oubliez pas de tenir compte de la direction du déplacement lorsque vous choisissez cette valeur.

- <a id="seek_mm_per_min"></a>**seek_mm_per_min**
  - Type : [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)  
  - Plage de valeurs : 1.000 à 100000.000
  - Valeur par défaut : 200.000
  - Détails : Vitesse à laquelle l'axe se déplace pour toucher l'interrupteur de fin de course une première fois afin d'obtenir une position approximative.  L'axe va retirer l'interrupteur de fin de course et se déplacer à la vitesse indiquée par feed_mm_per_min pour toucher l'interrupteur de fin de course une seconde fois afin d'obtenir une position d'origine plus précise.

- <a id="feed_mm_per_min"></a>**feed_mm_per_min**
  - Type : [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)
  - Plage de valeurs : 1.000 à 100000.000
  - Valeur par défaut : 50.000
  - Détails : Vitesse de mouvement pour le deuxième contact avec l'interrupteur de fin de course afin d'obtenir une position d'origine précise. Il s'agit généralement d'une vitesse lente car l'axe est proche de l'interrupteur de fin de course et une vitesse plus lente permet souvent d'obtenir une position d'origine plus précise/consistante. 
  
- <a name="settle_ms"></a>**settle_ms**
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Portée : 0 à 1000
  - Valeur par défaut : 250
  - Détails : Temps (en millisecondes) pendant lequel la machine s'arrête entre chaque cycle de retour à la maison pour permettre à la machine de se stabiliser après le cycle de retour à la maison précédent.

- <a id="seek_scaler"></a>**seek_scaler:**
  - Type : [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)
  - Portée : 1,0 à 100,0
  - Valeur par défaut : 1.1
  - Détails : seek_scaler * max_travel équivaut à la distance que l'axe homing doit parcourir avant que l'opération n'échoue s'il n'a pas atteint le commutateur de fin de course. Ce multiplicateur permet à l'axe de se déplacer plus loin que max_travel pour tenir compte de la distance supplémentaire que l'axe retire de l'interrupteur de fin de course (mpos_mm). 
  
- <a id="feed_scaler"></a>**feed_scaler:**
  - Type [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)
  - Plage de valeurs : 1,0 à 100,0
  - Valeur par défaut : 1.1
  - Détails : Multiplié par [pulloff_mm] (http://wiki.fluidnc.com/en/config/axes#pulloff_mm) pour calculer la distance maximale que l'axe doit parcourir pour revenir à l'interrupteur après le premier déclenchement avant qu'il n'échoue. En cas d'utilisation d'interrupteurs à forte variabilité ou d'autoguidage sans capteur, une valeur plus élevée peut être nécessaire pour s'assurer que l'interrupteur se déclenche la deuxième fois. 

> Certains moteurs à boucle fermée, comme les servos, s'autoalimentent et ignorent de nombreux paramètres tels que le pulloff et les vitesses.
{.is-info}

**Exemple:**

```yaml
  axes:
    x:
      homing:
        cycle: 2
        allow_single_axis: true
        positive_direction: false
        mpos_mm: 1.000
        seek_mm_per_min: 200
        feed_mm_per_min: 50
        seek_scaler: 1.5
        feed_scaler: 1.5   
  ```

<a id="motors-settings"></a>
## Paramètres des moteurs

- <a id="limit_neg_pin"></a>**limit_neg_pin:** 
  - Type : [Broche](http://wiki.fluidnc.com/fr/config/overview#pin)
   - Plage : gpio
   - Défaut : NO_PIN
   - Description : Broche utilisée pour détecter l'activation de l'interrupteur de fin de course du côté négatif de la course de l'axe. 

- <a id="limit_pos_pin"></a>**limit_pos_pin:**
   - Type : [Broche](http://wiki.fluidnc.com/fr/config/overview#pin)  
   - Portée : gpio
   - Défaut : NO_PIN
   - Détails : Broche utilisée pour détecter l'activation d'un interrupteur de fin de course du côté positif de la course de l'axe. Cet interrupteur se trouve souvent juste au-delà de la limite max_travel. 

- <a id="limit_all_pin"></a>**limit_all_pin:** 
  - Type : [Broche](http://wiki.fluidnc.com/fr/config/overview#pin)
   - Portée : gpio
   - Défaut : NO_PIN
   - Détails : Utilisé lorsque vous souhaitez que les interrupteurs situés aux deux extrémités de la course soient connectés à la même broche. Si limit_all_pin est spécifié, ne spécifiez pas de limit_neg_pin ou de limit_pos_pin. L'inconvénient de cette fonction est que FluidNC ne sait pas quelle extrémité de la course est à l'origine du déclenchement. Il ne peut pas déterminer dans quel sens il doit se déplacer pour libérer le commutateur. Pour cette raison, les interrupteurs doivent être effacés manuellement avant de procéder à l'autoguidage.
   
- <a id="hard_limits"></a>**hard_limits:** 
   - Type : [Booléen](http://wiki.fluidnc.com/fr/config/overview#boolean)
   - Valeur par défaut : false
   - Détails : Réglez ce paramètre sur true (vrai) si vous souhaitez utiliser les interrupteurs définis ci-dessus comme des limites strictes. Les limites strictes arrêtent immédiatement tout mouvement lorsque l'interrupteur est activé. La position est considérée comme perdue et un rehoming est nécessaire. 

- <a id="pulloff_mm"></a>**pulloff_mm:**
   - Type : [Flottant](/config/overview#float)
   - Plage de valeurs : 0.100 à 100000.000
   - Valeur par défaut : 1.000
   - Détails : Il s'agit de la distance à parcourir pour déclencher un interrupteur avec ce moteur. Cette valeur doit être supérieure à la distance que vous pouvez parcourir après l'activation de l'interrupteur. Cela permet de s'assurer qu'il est toujours possible de dégager l'interrupteur pendant le déplacement. 

**Exemple:**

```yaml
axes:
  x:
    motor0:
      limit_neg_pin: gpio.33
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: true
      pulloff_mm: 1.000
```

<a id="motors-types"></a>

# Types de moteurs

## Standard Stepper

<img src="https://github.com/bdring/FluidNC/wiki/images/external_driver.png" width="300">

- **<a id="step_pin"></a>step_pin:**
    - Type : [Pin](/config/overview#pin) (sortie)
    - Portée : gpio ou i2so
    - Défaut : NO_PIN
    - Remarque : certains pilotes externes nécessitent une impulsion de pas inversée. Vous pouvez inverser l'impulsion en modifiant l'[attribut d'état actif](http://wiki.fluidnc.com/fr/config/config_IO#input-pin-attributes) (**:high** ou **:low**).

- **<a id="direction_pin"></a>direction_pin:**
    - Type : [Broche](/config/overview#pin)
    - Portée : gpio ou i2so
    - Défaut : NO_PIN
    - Détails : Ce paramètre est utilisé pour contrôler la direction. Vous pouvez inverser le sens en modifiant l'[attribut d'état actif](http://wiki.fluidnc.com/fr/config/config_IO#input-pin-attributes) (**:high** ou **:low**).

- **<a id="disable_pin"></a>disable_pin:**
    - Type : [Broche](http://wiki.fluidnc.com/fr/config/overview#pin)
    - Portée : gpio ou i2so
    - Défaut : NO_PIN
    - Détails : ce paramètre est utilisé si votre contrôleur utilise des broches de désactivation individuelles pour chaque pilote : Ce paramètre est utilisé si votre contrôleur utilise des broches de désactivation individuelles pour chaque pilote. La plupart des contrôleurs de base utilisent une broche de désactivation commune pour tous les pilotes, qui est définie ailleurs dans le fichier de configuration. Vous pouvez inverser le sens en modifiant l'attribut [active state attribute](http://wiki.fluidnc.com/fr/config/config_IO) (**:high** ou **:low**).

Utilisez celui-ci pour les pilotes externes ou lorsque seuls la direction et l'activation des étapes sont nécessaires.

exemple:

```yaml
    motor0:
      standard_stepper:
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: gpio.16:low
```

Voir cette page pour [informations importantes sur la synchronisation des impulsions](https://github.com/bdring/Grbl_Esp32/wiki/External-Stepper-Drivers)

## Stepstick:

- **[step_pin](#step_pin)**:
- **[direction_pin](#direction_pin)**:
- **[disable_pin](#disable_pin)**:
 - <a id="ms1_pin"></a>**ms1_pin**:
   - Type : [Broche](/config/overview#pin)
   - Portée : gpio ou i2so
   - Défaut : NO_PIN
   - Détails : Ce paramètre est utilisé pour définir une tension sur la broche MS1 de l'embase du pilote de steptick. Vous devez spécifier l'état actif. Il s'agit de l'état dans lequel la broche sera placée. Cette fonction est généralement utilisée pour définir le niveau de micropas. La plupart des contrôleurs de base n'acheminent pas cette broche vers le contrôleur et utilisent un cavalier à la place. Exemple **ms3 : i2so.3:high**
   
   - <a id="ms2_pin"></a>**ms2_pin**:
   - Type: Pin
   - Portée: gpio or i2so
   - Default: NO_PIN
   - Details: Voir ci-dessus
   
- <a name="reset_pin"></a>**reset_pin** : Broche présente sur de nombreux contrôleurs de type « steptick ». Cette broche est uniquement utilisée pour définir l'état de la broche à la mise sous tension. Elle n'a aucune fonction active pour le moment. 

exemple:

```yaml
axes:
  x:
    motor0:
      stepstick:
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: gpio.16:low
        ms1_pin: NO_PIN
        ms2_pin: NO_PIN
        ms3_pin: I2SO.6
        reset_pin: NO_PIN
```

### DRV8825 (Stepstick)

### A4988 (Stepstick)

### TB67S249FTG (Stepstick)

<img src="https://github.com/bdring/FluidNC/wiki/images/tb67s249ftg_wiring.png" width=500>

Disponible sur [Pololu](https://www.pololu.com/product/3096). Compatible 3.3V-5V.

AGC est le contrôle automatique de gain (comme Trinamic Coolstep) C'est typiquement la broche de veille sur les stepticks. Sur le contrôleur 6 Pack, il peut être contrôlé par le cavalier TMC5160. Utiliser le côté TMC5160 pour l'activer. 

<img src="https://github.com/bdring/FluidNC/wiki/images/tb67s249ftg_jumpers.png" width=500>

DMODE0 à DMODE2 sont typiquement MS1 à MS3 sur le steptick. Ces broches sont plus souvent connectées à des cavaliers qu'au contrôleur. 

TB67S249FTG exemple de configuration

```yaml
      stepstick:
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: I2SO.7:low
        ms1_pin: NO_PIN
        ms2_pin: NO_PIN
        ms3_pin: I2SO.6:high
        reset_pin: NO_PIN
```

<a id="Trinamic Drivers"></a>

## Conducteurs Trinamic

Les pilotes Trinamic possèdent de nombreuses caractéristiques qui peuvent être réglées par FluidNC. Ces pilotes sont généralement entièrement alimentés par la tension du moteur. Les broches Vcc ne sont utilisées que pour la référence de tension E/S. Par conséquent, la tension du moteur **doit être sous tension en permanence** pour les utiliser. Par conséquent, la tension du moteur **doit être activée à tout moment** pour les utiliser. L'ESP32 sur le contrôleur peut souvent être alimenté par la connexion USB, mais pas les moteurs. Si la tension du moteur n'est pas présente au démarrage et que l'ESP32 est alimenté par la connexion USB, les pilotes ne répondront pas. Si les pilotes échouent aux tests de démarrage, essayez de cliquer sur le bouton de réinitialisation de l'ESP32 lorsque l'appareil est sous tension.

Il existe une commande qui vous permet de lancer l'initialisation du pilote de moteur à tout moment. Il s'agit de **\$Motors/Init** ou **\$MI**. Si vous oubliez de mettre l'appareil sous tension, vous pouvez le mettre sous tension puis envoyer la commande **$MI**. Un message sera envoyé pour indiquer si la commande a réussi ou échoué. Vous pouvez envoyer cette commande chaque fois que vous souhaitez vérifier l'état du moteur (en dehors du mode de fonctionnement).

Exemples de commande

```
[MSG:ERR: X Axis driver test failed. Check connection]
[MSG:ERR: Y Axis driver test failed. Check motor power]
[MSG:ERR: Z Axis driver test passed]
```

Nous ne sommes pas des experts de ces pilotes. Nous utilisons une bibliothèque open source tierce ([TMCStepper](https://github.com/teemuatlut/TMCStepper)) pour les contrôler. Nous ne connaissons pas les meilleurs paramètres de registre pour eux. Beaucoup d'entre eux sont spécifiques à votre machine et à vos moteurs. Vous devrez expérimenter. En général, ce sont d'excellents pilotes, mais ils sont capricieux. N'attendez pas des développeurs de FluidNC qu'ils résolvent vos problèmes avec ces moteurs.

Remarque : Vous pouvez acheter certains pilotes Trinamic sur des modules en mode « stand alone “ ou ” steptick ». Ils ne peuvent pas être configurés par FluidNC et vous devez les configurer en tant que pilotes [stepstick](http://wiki.fluidnc.com/fr/config/axes#stepstick).

> Les pilotes sont détectés à l'aide de la connexion UART ou SPI. Si vous obtenez ce message, il s'agit probablement d'un problème de communication. Vérifiez la configuration et le câblage. 
{.is-info}

<a id="SPI Controlled"></a>
### SPI Controlled (TMC2130 and TMC5160)

Les pilotes contrôlés par SPI utilisent [SPI] (https://en.wikipedia.org/wiki/Serial_Peripheral_Interface) (Serial Peripheral Interface) pour contrôler directement les caractéristiques et les modes du pilote. SPI a deux modes, le mode indépendant et le mode en guirlande. Cela dépend de la manière dont le SPI est câblé sur le contrôleur.

<img src="https://github.com/bdring/FluidNC/wiki/images/SPI_normal.png" width="300"> daisy chain <img src="https://github.com/bdring/FluidNC/wiki/images/spi_daisy_chain.png" width="300">

Pour le mode indépendant, chaque pilote a besoin de sa propre **[cs_pin :](#cs_pin)**. Ils n'utilisent pas de **[spi_index :](#spi_index)**, donc chaque **[spi_index :](#spi_index)** doit être réglé sur -1.

En mode guirlande, ils utilisent tous la même **[cs_pin :](#cs_pin)**, mais chacun nécessite son propre **[spi_index :](#spi_index)**. Le **[spi_index :](#spi_index)** est un nombre compris entre 1 et le nombre de pilotes dont vous disposez. Le **[spi_index :](#spi_index)** indique la position du pilote sur la guirlande SPI. Vous devez définir l'index en fonction de la conception du circuit imprimé et de l'ordre des lettres des axes.

Dans un montage en guirlande, MOSI passe en boucle par tous les moteurs, puis revient au contrôleur en tant que MISO. Pour écrire dans le second pilote, vous écrivez dans le premier avec les données du second pilote, puis vous écrivez des données fictives dans le premier pour pousser les premières données dans le second. La lecture de données pose le même problème lorsqu'il faut pousser les données à travers les pilotes à la fin de la chaîne. FluidNC a besoin de connaître tous les pilotes, même ceux que vous n'utilisez pas. Vous devez définir quelque chose pour tous les pilotes.

<a id="TMC2130"></a>
## TMC2130

Liens

 - [Trinamic Datasheet](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC2130_datasheet.pdf)
 - [BigTreeTech V3.0 Github](https://github.com/bigtreetech/BIGTREETECH-TMC2130-V3.0)
   - [Schematic](https://github.com/bigtreetech/BIGTREETECH-TMC2130-V3.0/blob/master/Hardware/BIGTREETECH%20TMC2130%20V3.0%20SCH.pdf)

**Config Item**

- **[step_pin](#step_pin)**
- **[direction_pin](#direction_pin)**
- **[disable_pin](#disable_pin)**

- <a id="cs_pin"></a>**cs_pin:**
  - Type : [Pin](http://wiki.fluidnc.com/fr/config/overview#pin) (sortie)
  - Portée : gpio ou i2so
  - Défaut : NO_PIN
  - Détails : broche de sélection de puce : Broche de sélection de puce. En mode indépendant, chaque puce a besoin de sa propre broche. Pour le mode daisy chain, vous ne devez la définir que sur le moteur avec spi_index : 1

- <a id="spi_index"></a>**spi_index:**
  - Type :  [Pin](http://wiki.fluidnc.com/fr/config/overview#pin) (sortie)
  - Plage : -1 à 127
  - Valeur par défaut : -1
  - Détails : En mode indépendant, toutes les valeurs doivent être -1 (valeur par défaut). En mode guirlande, ils doivent être uniques (voir ci-dessus). Commencez par l'index 1 et incrémentez-le de 1 pour le moteur suivant. Ils doivent être définis dans l'ordre dans lequel les puces sont connectées en guirlande.
  
- <a id="r_sense_ohms"></a>**r_sense_ohms:**
  - Type : [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)
  - Portée :  0,01 à 1,00
  - Valeur par défaut : 0.11
  - Détails : Il s'agit de la valeur de la résistance de détection de courant utilisée avec le pilote. Elle est nécessaire pour définir le courant. Sur les modules TMC2130 enfichables, la valeur est généralement de 0,110 Ohm.

- <a id="run_amps"></a>**run_amps:**
  - Type : [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)
  - Portée : 0,05 à 10,0
  - Valeur par défaut : 0.5
  - Détails : Cette valeur définit le courant de sortie du circuit d'attaque lorsque celui-ci émet des pas.
  
- <a id="hold_amps"></a>**hold_amps:**
  - Type :  [Flottant](http://wiki.fluidnc.com/fr/config/overview#float)
  - Plage de valeurs : 0,05 à 10,0
  - Valeur par défaut : 0.5
  - Détails : Cette valeur définit le courant de sortie du circuit d'attaque lorsqu'il n'émet pas de pas.
  
- <a id="microsteps"></a>**microsteps:**
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Plage de valeurs : 1 à 256 (devrait être 1,2,4,8,16,32,64,128 ou 256 )
  - Valeur par défaut : 16
  - Détails : Ce paramètre définit le niveau de micropas.

- <a id="stallguard"></a>**stallguard:**
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Portée : -64 à 63
  - Valeur par défaut : 0
  - Détails : Niveau de seuil du Stallguard. Une valeur plus élevée rend le StallGuard2 moins sensible et nécessite un couple plus important pour

- <a id="stallguard_debug"></a>**stallguard_debug:**
  - Type : Booléen
  - Valeur par défaut : false
  - Détails : Cette option active les informations de débogage qui peuvent vous aider à régler stallguard. Elle ne doit pas être activée dans le cadre d'une utilisation normale.

- <a id="toff_disable"></a>**toff_disable:**
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Portée : 0 à 15
  - Valeur par défaut : 0
  - Détails : Temps de désactivation du TOFF et activation du pilote. Une valeur de 0 désactive le pilote. Voir la fiche technique du TMC2130 à ce sujet.

- <a id="toff_stealthchop"></a>**toff_stealthchop:**
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Portée : 2 à 15
  - Valeur par défaut : 5
  - Détails : TOFF en mode stealthchop. Voir la fiche technique du TMC2130 à ce sujet.

- <a id="toff_coolstep"></a>**toff_coolstep:**
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Portée : 2 à 15
  - Valeur par défaut : 3
  - Détails : TOFF en mode Coolstep. Voir la fiche technique du TMC2130 à ce sujet.

- <a id="run_mode"></a>**run_mode:**
  - Type :  [Énumération](http://wiki.fluidnc.com/fr/config/overview#enum)
  - Portée : StealthChop, CoolStep ou Stallguard
  - Valeur par défaut : StealthChop
  - Détails : Il s'agit du mode de fonctionnement. Les valeurs valides sont Coolstep, Stallguard et StealthChop.
 
- <a id="homing_mode"></a>**homing_mode:**
  - Type : [Énumération](http://wiki.fluidnc.com/fr/config/overview#enum)
  - Portée : StealthChop, CoolStep ou Stallguard
  - Valeur par défaut : StealthChop
  - Détails : Il s'agit du mode de fonctionnement. Les valeurs valides sont Coolstep, Stallguard et StealthChop.

- <a id="use_enable"></a>**use_enable:**
  - Type : Booléen
  - Valeur par défaut : false
  - Détails : Cette fonction utilise la fonction d'activation douce de la puce. L'activation est envoyée à la puce par l'intermédiaire de l'interface SPI.

<img src="https://github.com/bdring/FluidNC/wiki/images/tmc2130_current.png" width="300">

exemple strandard:

```yaml
  tmc_2130:
    cs_pin: gpio.17
    spi_index: -1
    r_sense_ohms: 0.110
    run_amps: 0.750
    hold_amps: 0.250
    microsteps: 32
    stallguard: 0
    stallguard_debug: false
    toff_disable: 0
    toff_stealthchop: 5
    toff_coolstep: 3
    run_mode: StealthChop
    homing_mode: StealthChop
    use_enable: false
    step_pin: gpio.12
    direction_pin: gpio.26
    disable_pin: NO_PIN
```

Daisy chain example:

```yaml
  x:  
    steps_per_mm: 800.000
    max_rate_mm_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
      tmc_2130:
        cs_pin: gpio.17
        spi_index: 1
        r_sense_ohms: 0.110
        run_amps: 0.750
        hold_amps: 0.750
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: CoolStep
        homing_mode: CoolStep
        use_enable: true
        step_pin: gpio.12
        direction_pin: gpio.14
        disable_pin: NO_PIN

  y:
    steps_per_mm: 800.000
    max_rate_mm_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: gpio.39
      hard_limits: true
      pulloff_mm: 1.000
      tmc_2130:
        spi_index: 2
        r_sense_ohms: 0.110
        run_amps: 0.750
        hold_amps: 0.750
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: CoolStep
        homing_mode: CoolStep
        use_enable: true
        step_pin: gpio.27
        direction_pin: gpio.26
        disable_pin: NO_PIN
```

<a id="TMC2208"></a>
## TMC2208:

Les pilotes TMC2208 peuvent fonctionner en mode autonome STEP/DIR. Des valeurs telles que le micropas, le courant de marche et le courant de maintien, entre autres, peuvent également être configurées via UART.

Une broche de pas et une broche de direction doivent toujours être définies dans la configuration du moteur. L'activation du moteur peut se faire soit à l'aide d'une broche disable_pin :, soit via UART avec use_enable : true dans le fichier de configuration.

Les pilotes TMC2208 ne sont pas adressables. Cela signifie que lors de la mise en chaîne de ces pilotes, les valeurs de configuration seront transmises à tous les pilotes et qu'il n'est pas possible de configurer des paramètres pour des pilotes individuels. Il est important de noter que les valeurs qui seront appliquées seront celles définies dans le dernier moteur / axe listé dans le fichier de configuration. Les valeurs qui ne sont pas définies dans cette configuration finale du moteur / de l'axe reviendront à la valeur par défaut, remplaçant toutes les valeurs définies dans les configurations précédentes du moteur / de l'axe. 

 [Fiche technique](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC2202_TMC2208_TMC2224_datasheet_rev1.13.pdf)

Config Items:
- **[step_pin](#step_pin)**
- **[direction_pin](#direction_pin)**
- **[disable_pin](#disable_pin)**
- **[r_sense_ohms:](#r_sense_ohms)**
- **[run_amps:](#run_amps)**
- **[hold_amps:](#hold_amps)**
- **[microsteps:](#microsteps)**

Daisy chain example: 

```
  axes:
  shared_stepper_disable_pin: gpio.1

  x:
    steps_per_mm: 400
    max_rate_mm_per_min: 1500
    acceleration_mm_per_sec2: 100
    homing:
      cycle: 2
      allow_single_axis: true
      positive_direction: false
      mpos_mm: 0
      feed_mm_per_min: 50
      seek_mm_per_min: 400
    motor0:
      limit_all_pin: gpio.2:low
      hard_limits: true
      pulloff_mm: 1
      tmc_2208:  
        step_pin: gpio.3
        direction_pin: gpio.4:low
        # THESE VALUES ARE OVERIDEN BY Y AS TMC2208 IS NOT ADDRESSABLE.
        # ALL VALUES ARE TAKEN FROM LAST DEFINED MOTOR/AXIS
        # run_amps: 1.5
        # hold_amps: 0.5
        # microsteps: 8
        # disable_pin: 10

  y:
    steps_per_mm: 400
    max_rate_mm_per_min: 1500
    acceleration_mm_per_sec2: 100
    homing:
      cycle: 2
      allow_single_axis: true
      positive_direction: true
      mpos_mm: 290
      feed_mm_per_min: 50
      seek_mm_per_min: 400
    motor0:
      limit_all_pin: gpio.5:low
      hard_limits: true
      pulloff_mm: 1
      tmc_2208:
        step_pin: gpio.6
        direction_pin: gpio.7
        # THESE ARE THE LAST DEFINED VALUES 
        # AND WILL BE THE VALUES APPLIED TO 
        # ALL DRIVERS IN THE DAISY CHAIN
        microsteps: 16
        r_sense_ohms: 0.110
        # IF NOT DEFINED - DEFAULT VALUES WILL BE USED
        # run_amps: 0.5
        # hold_amps: 0.5
        disable_pin: NO_PIN
        uart:
          txd_pin: gpio.8
          rxd_pin: gpio.9
          baud: 115200
          mode: 8N1
```

<a id="TMC5160"></a>
## TMC5160

[Datasheet](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf)

- **[step_pin](#step_pin)**
- **[direction_pin](#direction_pin)**
- **[disable_pin](#disable_pin)**
- **[r_sense_ohms:](#r_sense_ohms)** For TMC5160 it is typically 0.075 Ohm.
- **[run_amps:](#run_amps)**
- **[hold_amps:](#hold_amps)**
- **[microsteps:](#microsteps)**
- **[toff_disable:](#toff_disable)**
- **[toff_stealthchop:](#toff_stealthchop)**
- **[use_enable:](#use_enable)**
- **[cs_pin:](#cs_pin)**
- **[spi_index:](#spi_index)**
- **[run_mode:](#run_mode)**
- **[homing_mode:](#homing_mode)**
- **[stallguard:](#stallguard)**
- **[stallguard_debug:](#stallguard_debug)**
- **[toff_coolstep:](#toff_coolstep)**
- **tpfd:**
  - Type : Entier
  - Plage de valeurs : 0 à 15
  - Valeur par défaut : 4
  - Détails : Temps de décroissance rapide passif pour la résonance de la bande moyenne. Voir la fiche technique

```yaml
tmc_5160:
      step_pin: gpio.12
      direction_pin: gpio.14
      disable_pin: NO_PIN
      cs_pin: gpio.17
      r_sense_ohms: 0.050
      run_amps: 1.800
      hold_amps: 1.250
      microsteps: 8
      toff_disable: 0
      toff_stealthchop: 5
      use_enable: false
      run_mode: CoolStep
      homing_mode: CoolStep
      stallguard: 16
      stallguard_debug: false
      toff_coolstep: 3
      tpfd: 4
```

> Beaucoup de personnes ont eu des problèmes avec ces pilotes. Ils sont très avancés et les paramètres doivent être finement ajustés à votre machine. Ils peuvent également consommer beaucoup d'énergie. Assurez-vous d'avoir un bloc d'alimentation avec une grande capacité supplémentaire. Nous ne pouvons pas fournir trop d'assistance car nous ne sommes pas des experts de la puce. **Pour des réglages plus fins, voir les versions « pro » plus bas sur cette page.
{.is-warning}

**Potentiomètres** De nombreux modules TMC5160 sont équipés de potentiomètres. La bibliothèque TMCStepper que nous utilisons met les puces TMC5160 en mode *i_scale_analog ». Cela signifie que le potentiomètre est utilisé pour mettre à l'échelle la valeur du courant qui est réglée numériquement. Vous devez tourner ces potentiomètres à fond ou jusqu'à ce qu'ils produisent 2,5 V. Cela vous permettra d'utiliser la totalité du courant. Cela vous permettra d'utiliser toute la gamme de courant des pilotes.

Voici un tableau pour le courant. La plupart des modules utilisent une résistance de 0,075Ohm, le courant maximum est donc de 3,1A.

<img src="https://github.com/bdring/FluidNC/wiki/images/tmc5160_current.png" width="300">

### UART Controlled

## TMC2209

[Datasheet](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC2209_Datasheet_V103.pdf)
786

> Cette section concerne les puces contrôlées par UART. Chaque puce doit avoir un système d'adressage matériel. Nous ne prenons pas en charge les communications en écriture seule (à sens unique), car il est essentiel que nous sachions que les puces répondent aux commandes.
{.is-warning}

> Il est très difficile d'utiliser les modules enfichables TMC2209 ou les contrôleurs qui ne prennent pas directement en charge les puces contrôlées par Trinamic UART. **Vous devez** câbler l'UART en externe et **vous devez** trouver comment câbler l'UART en externe.   
{.is-warning}

Les pilotes TMC2209 ont besoin d'une step_pin et d'une direction_pin. Ils peuvent utiliser une broche disable_pin : ou l'activer via UART avec un `use_enable : true` dans le fichier de configuration. 

Vous devez définir les broches pour l'uart dans une section [uart](http://wiki.fluidnc.com/fr/config/uart_sections) du fichier de configuration. Chaque moteur doit avoir un uart_num :. Cela pourrait permettre d'utiliser plusieurs uarts pour dépasser la limite de 4 adresses par uart.

```yaml
    motor0:
      limit_neg_pin: gpio.36:low
      tmc_2209:
        uart_num: 1
        addr: 0
        cs_pin: NO_PIN
        r_sense_ohms: 0.110
        run_amps: 1.000
        hold_amps: 0.500
        microsteps: 16
        stallguard: 0
        stallguard_debug: false
        toff_disable: 0
        toff_stealthchop: 5
        toff_coolstep: 3
        run_mode: StealthChop
        homing_mode: StealthChop
        homing_amps: 0.50
        use_enable: false
        direction_pin: gpio.12
        step_pin: gpio.14
        disable_pin: NO_PIN
```

### TMC UART

L'UART est typiquement connecté comme ceci, avec une seule connexion pour tous les pilotes. Les pilotes ont besoin de l'adresse (`addr:` dans la configuration) réglée de 0 à 3 via les broches MSn_ADn via les connexions matérielles.

![tmc2209_uart_addr.png](/motors/tmc2209_uart_addr.png)

### TMC UART avec cs_pin

La broche cs_pin peut être utilisée pour contrôler une puce qui commute l'UART. Cela peut vous permettre de contourner la limite de 4 adresses pour les puces. L'adresse peut être dynamique. Vous pouvez également connecter la broche cs_ à une broche d'adresse.

![uart_cs_pin.png](/config/uart_cs_pin.png)

### Notes de conception

Le Vcc sur les modules steptick est utilisé comme référence E/S. Il doit être de 3,3V lorsqu'il est directement connecté aux ESP32s. Elle doit être de 3,3 V lorsqu'elle est directement connectée à l'ESP32. Le Vcc du pilote est généré en interne à partir du VMot, de sorte que ces puces ne communiqueront pas si le VMot n'est pas connecté.

<img src="https://github.com/bdring/FluidNC/wiki/images/tmc2209_current.png" width="450">

## tmc_5160Pro & tmc_2160Pro Motors (Expert Mode)

Les moteurs tmc_5160Pro et tmc_2160Pro sont destinés aux utilisateurs avancés qui souhaitent contrôler directement les registres les plus importants et les plus couramment utilisés du pilote. Il est possible d'ajouter d'autres registres si nécessaire.

Actuellement, le pilote utilise les mêmes valeurs de registre pour les modes normal et homing.


Vous aurez besoin de la fiche technique pour comprendre ces registres.

- [Datasheet](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf)
- [CHOPCONF](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=51)
- [PWMCONF](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=54)
- [COOLCONF](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=53)
- [GCONF](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=32)
- [IHOLD_IRUN](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=38)
- [THIGH](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=39)
- [TCOOLTHRS](https://www.trinamic.com/fileadmin/assets/Products/ICs_Documents/TMC5160A_Datasheet_Rev1.14.pdf#page=39)

### Calculatrices de registre

La plupart des registres sont constitués d'un nombre construit à partir de plusieurs valeurs plus petites. Il existe une [feuille Google](https://docs.google.com/spreadsheets/d/1Ue5yI3-ZFgoVcz6nrzz_FpY7N90UyCm1wIMYn1uvC5k/edit?usp=sharing) qui peut vous aider à créer les valeurs de registre à partir de ces valeurs. Faites votre propre copie de la feuille pour obtenir les droits d'édition. Vous devrez toujours utiliser la feuille de données pour déterminer les valeurs à utiliser.

> TMC5160 et TMC2160 fonctionnent exactement de la même manière. La seule différence est le nom dans le fichier de configuration. 
{.is-info}

[Google Sheet](https://docs.google.com/spreadsheets/d/1Ue5yI3-ZFgoVcz6nrzz_FpY7N90UyCm1wIMYn1uvC5k/edit?usp=sharing)

### Examples

```yaml
      tmc_5160Pro:
        step_pin: I2SO.2
        direction_pin: I2SO.1
        disable_pin: I2SO.0
        cs_pin: I2SO.3
        spi_index: -1
        use_enable: false
        CHOPCONF: 373326168
        COOLCONF: 0
        THIGH: 0
        TCOOLTHRS: 0
        GCONF: 4
        PWMCONF: 3289120798
        IHOLD_IRUN: 3852
```

```yaml
      tmc_2160Pro:
        step_pin: I2SO.2
        direction_pin: I2SO.1
        disable_pin: I2SO.0
        cs_pin: I2SO.3
        spi_index: -1
        use_enable: false
        CHOPCONF: 373326168
        COOLCONF: 0
        THIGH: 0
        TCOOLTHRS: 0
        GCONF: 4
        PWMCONF: 3289120798
        IHOLD_IRUN: 3852
```

> Si vous avez une configuration qui fonctionne à partir de l'élément de configuration normal de tmc_5160, vous pouvez l'utiliser comme point de départ. Si vous mettez **$message/level=debug**, cela vous montrera les valeurs actuelles des registres. 
{.is-info}

> Si vous avez du mal à utiliser ce type de configuration, ce n'est peut-être pas pour vous. Les registres sont très complexes et ne sont pas destinés aux débutants. Même les développeurs de FluidNC ne comprennent pas complètement comment les utiliser. Ne vous attendez pas à recevoir de l'aide sur les valeurs des registres. Adressez-vous directement à TMC.
{.is-warning}

### Conseils

- Les courants sont définis dans IHOLD_IRUN
- Micropasage CHOPCONF

<a id="rc_servo"></a>
## RC Servo

<img src="https://github.com/bdring/FluidNC/wiki/images/servo-samples.jpg" width="300">

Les servos RC ont un système de contrôle interne qui leur permet de se déplacer à un endroit spécifique en fonction d'un signal PWM. Il existe des versions analogiques et numériques de ces servos. Les deux utilisent la même entrée PWM, mais les versions numériques utilisent un système de contrôle plus avancé. Ils utilisent la largeur de l'impulsion pour déterminer où se déplacer. Une extrémité de la course utilise généralement une largeur d'impulsion de 1 ms et l'autre extrémité une largeur d'impulsion de 2 ms. Il n'y a pas de norme sur la plage de rotation du mouvement et beaucoup peuvent utiliser une plage de largeur d'impulsion légèrement plus large. Si le signal PWM est supprimé, le servo peut souvent être tourné à la main.

> Un servo peut aussi être configuré comme une broche, si vous voulez le contrôler avec des instructions `M3`/`M5` - voir la [section besc de la page des broches](/fr/config/config_spindles#besc).
{.is-info}

La fréquence PWM pour les servos analogiques est typiquement de 50Hz. Si vous l'augmentez, vous modifiez la boucle de contrôle et vous risquez de faire surchauffer le servo. Les servos numériques peuvent utiliser une fréquence plus élevée, mais généralement jamais supérieure à 200 Hz. Le signal PWM n'est envoyé que lorsque les moteurs sont activés. Mettez **idle_ms** à 255 si vous voulez que le signal soit toujours actif.

FluidNC crée un moteur pas à pas virtuel pour l'axe. Vous lui donnez des paramètres de vitesse, d'accélération, etc. comme à un moteur normal. La plage du servo sera mappée sur la course maximale de l'axe. Si votre servo ne tourne pas dans le bon sens par rapport à l'axe virtuel, vous pouvez intervertir les valeurs des touches min_pulse_us/max_pulse_us.

Comme un axe normal, ils fonctionnent dans l'espace machine. Vous pouvez toujours placer un zéro de travail où vous le souhaitez. Des limites souples peuvent être utilisées. Le repérage fonctionne un peu différemment. Ils n'utilisent pas d'interrupteurs car ils savent toujours où ils se trouvent. Si vous les placez dans un cycle de positionnement, ils se déplaceront immédiatement jusqu'à la fin de la course dans la direction spécifiée dans la section positionnement :. Pour leur donner suffisamment de temps pour y arriver. Un temps de **max_travel : / vitesse:** sera donné.

Au démarrage, un servo se déplace immédiatement à la position 0,0 de la machine ou au point le plus proche de la plage si la plage n'inclut pas 0,0. Cela ne se produit que si les moteurs sont activés. Si les moteurs ne sont pas activés au démarrage (idle_ms : not 255), les servos se déplacent vers la position actuelle de la machine dès qu'un autre axe se déplace.

**Dans les messages de démarrage, vous verrez la plage comme **Axe Z (-5.000,0.000)**. Envoyez **G53G0Z-5** et **G53G0Z0** pour tester cette plage.

**Config file keys**
 - <a name="output_pin"></a>**output_pin:** 
   - Type : [Pin](http://wiki.fluidnc.com/fr/config/overview#pin) (sortie)
   - Plage : gpio
   - Détails : Il s'agit de la broche de sortie du signal PWM.

- <a name="pwm_hz"></a>**pwm_hz:**  
   - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
   - Plage de valeurs : 50 à 200
   - Détails : Broche de sortie du signal PWM Fréquence du PWM en Hz (par défaut 50)
    
- <a name="min_pulse_us"></a>**min_pulse_us:** 
   - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
   - Plage de valeurs : 500 à 2500
   - Détails : Il s'agit de la broche de sortie pour le signal PWM. Il s'agit de la longueur d'impulsion à l'extrémité inférieure de la course de l'axe en microsecondes (par défaut 1000). 
   
- <a name="max_pulse_us"></a>**min_pulse_us:**
   - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
   - Plage de valeurs : 500 à 2500
   - Détails : Il s'agit de la broche de sortie pour le signal PWM. Il s'agit de la longueur d'impulsion à l'extrémité supérieure de la course de l'axe en microsecondes (par défaut 2000). 

exemple:

```yaml
  z:
    steps_per_mm: 100.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 5.000
    soft_limits: true
    homing:
      cycle: 1
      positive_direction: true
      mpos_mm: 5.000     

    motor0:
      rc_servo:
        pwm_hz: 50
        output_pin: gpio.27
        min_pulse_us: 1000
        max_pulse_us: 2000
```

example avec rotation inversée:

```yaml
    rc_servo:
      pwm_hz: 60
      output_pin: gpio.27
      min_pulse_us: 2000
      max_pulse_us: 1000
```

<a name="rc_servo_tuning"></a>
#### RC Servo Tuning:

Tous les servos ont leur propre vitesse et leur propre accélération. Si vous utilisez des valeurs de mouvement plus rapides pour l'axe virtuel que ce que le servo peut supporter, il ne pourra pas suivre avec précision. FluidNC ne pourra pas le détecter. Vous devez expérimenter avec les valeurs jusqu'à ce que vous obteniez les performances souhaitées. La touche steps_per_mm est utilisée pour l'axe virtuel. La plupart des servos n'ont qu'une précision de 200 à 1000 unités sur l'ensemble de la plage de mouvement. Doublez cette valeur supérieure et divisez-la par la course maximale de l'axe. Exemple : Pour une course maximale de 10 mm, réglez votre nombre de pas par mm sur (2 * 1000 / 10) = 200 pas par mm.

<a name="rc_servo_range"></a>
#### **RC Servo Range**

Contrairement aux moteurs pas à pas, les servos RC ont une plage de rotation fixe. Cette plage est mise en correspondance avec les coordonnées de la machine en utilisant les éléments de configuration max_travel, mpos_mm et homing direction ([plus de détails ici](/config/axes#homing)). Si vous essayez de vous déplacer en dehors de la plage, le servo s'arrêtera à la fin de la course, mais la position de la machine continuera à s'incrémenter. Vous pouvez toujours déplacer la position de la machine en dehors de la plage, mais le servo ne se déplacera pas tant qu'il ne sera pas dans la plage. Vous pouvez appliquer des limites souples à l'axe pour éviter cela. **Pour cette raison, les limites souples sont fortement recommandées pour les servos RC.

#### Longueur des impulsions

La longueur des impulsions varie selon les fabricants. La valeur par défaut est de 1000 à 2000 microsecondes, mais de nombreux fabricants utilisent une plage plus large. Si vous essayez de faire correspondre les unités FluidNC à des endroits spécifiques de la course du servo, vous pouvez modifier légèrement ces valeurs. Les servomoteurs ne sont pas très précis, il ne faut donc pas s'attendre à ce qu'ils correspondent aux moteurs pas à pas. Veillez à rester dans la plage de réglage du servo. Les servos peuvent être endommagés s'ils fonctionnent en dehors de leur plage.

Voici une définition complète d'un axe de servo RC. Dans ce cas, la course est de 5 mm, la position de la machine après le positionnement est de 5 mm, la plage est donc de 0 mm à 5 mm. Vous pouvez tester le mouvement sur cet axe avec les commandes gcode suivantes. J'utilise G53 pour m'assurer que le mouvement est en coordonnées machine, ce qui annule les décalages de travail que vous avez pu créer.

```
G53 G0 Z5
G53 G0 Z0
```

```yaml

z:
    steps_per_mm: 100
    max_rate_mm_per_min: 5000
    acceleration_mm_per_sec2: 100
    max_travel_mm: 5
    homing:
      cycle: 1
      mpos_mm: 0
      positive_direction: true

    motor0:
      rc_servo:
        pwm_hz: 50
        output_pin: gpio.27
        min_pulse_us: 1000
        max_pulse_us: 2000
```

<a name="solenoid"></a>
## Solenoid

<img src="https://github.com/bdring/FluidNC/wiki/images/solenoid.png" width="200">

Cette fonction permet à un solénoïde d'agir comme un axe. Il sera actif lorsque la position machine de l'axe est supérieure à 0,0. Ceci peut être inversé avec la valeur **direction_invert:**. S'il est inversé, il sera actif lorsque la position de la machine est inférieure à 0,0.

Lorsqu'il est actif, le PWM est activé à la valeur pull_percent. Après le temps pull_ms, il passera à la valeur hold_percent. Ceci peut être utilisé pour garder la bobine plus froide.

Cette fonction fonctionne avec un délai de mise à jour de 50 ms. Le solénoïde doit réagir dans les 50 ms suivant la position. La fonction pull_ms utilise également cette résolution de mise à jour de 50 ms. Le PWM peut être inversé en utilisant l'attribut :low sur la broche de sortie. Cela permet d'inverser le signal en cas de besoin. Il n'est pas utilisé pour inverser la logique de direction. 

La position de l'axe respecte toujours votre vitesse, votre accélération et la coordination des autres axes. Si vous passez de Z0 à Z5, elle s'activera dès qu'elle dépassera 0. Si vous G0 de Z5 à Z0, elle ne se désactivera pas avant d'être arrivée à Z0.

 - **[output_pin:](#output_pin)**
 - <a name="pwm_hz"></a>**pwm_hz:**  
   - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
   - Plage de valeurs : 1000 à 100000
   - Détails : Il s'agit de la fréquence du PWM en Hz (par défaut 1000).

 - <a name="off_percent"></a>**off_percent:**
   - Type : [Float](http://wiki.fluidnc.com/fr/config/overview#Float)
   - Portée : 0 à 100
   - Valeur par défaut : 0.0
   - Détails : Il s'agit de la fonction PWM lorsque le solénoïde n'est pas actif.
      
 - <a name="pull_percent"></a>**pull_percent:**
   - Type : [Float](http://wiki.fluidnc.com/fr/config/overview#Float)
   - Portée : 0 à 100
   - Valeur par défaut : 100.0
   - Détails : Il s'agit de l'obligation PWM pendant la traction initiale.

- <a name="hold_percent"></a>**hold_percent:**
   - Type : [Float](http://wiki.fluidnc.com/fr/config/overview#Float)
   - Portée : 0 à 100
   - Valeur par défaut : 75.0 
   - Détails : Il s'agit de l'obligation PWM pendant la phase de maintien.

 - <a name="pull_ms"></a>**pull_ms:**
   - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#Float)
   - Plage de valeurs : 0 à 3000
   - Valeur par défaut : 75.0
   - Détails : Durée de la phase de traction initiale.

Exemple YAML

```yaml

  z:
    steps_per_mm: 100.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 5.000
    soft_limits: false
    homing:
      cycle: 1
      positive_direction: true
      mpos_mm: 5.000
     
    motor0:
      solenoid:
        output_pin: gpio.26
        pwm_hz: 5000
        off_percent: 0.000
        pull_percent: 100.000
        hold_percent: 20.000
        pull_ms: 1000
        direction_invert: false
```

<a name="dynamixel_servo"></a>
## Dynamixel Servo (Protocol 2)

<img src="https://github.com/bdring/FluidNC/wiki/images/XL430-W250.jpg" width="200">

Cela permet d'utiliser des servomoteurs Dynamixel comme moteurs d'axe. Ce document a été écrit en supposant que des servos XL430-250T étaient utilisés, mais d'autres types de servos utilisant le [Robotis Protocol 2](https://emanual.robotis.com/docs/en/dxl/protocol2/) peuvent probablement être utilisés (non testé). La plage de comptage du servo est mise en correspondance avec la plage de position machine de l'axe (mpos). Si votre servo d'axe X a une plage de comptage comprise entre 0 et 4095, elle sera mappée sur la plage mpos. Si la plage est de 0-300 et que vous envoyez G0X150, il lui sera demandé d'aller au comptage 2047.

**Configuration des servos** Les servos doivent d'abord être configurés avec le logiciel Dynamixel. Le plus simple est d'utiliser le logiciel [Dynamixel Wizard](http://emanual.robotis.com/docs/en/software/dynamixel/dynamixel_wizard2/). Voici les registres que vous voudrez probablement configurer.

| Address       | Name              | Value       | Description     |
| ------------- | ----------------- | ----------- | --------------- |
| 7             | ID                | 1-253       | Must be unique  |
| 8             | Baud Rate         | 3 (1000000) |                 |
| 9             | Return Time Delay | 100         | Faster          |
| 24            | Moving Threshold  | 1           | Most Accurate   |
| 48 (optional) | Max Position      | 0-4095      | Limits rotation |
| 52 (optional) | Min Position      | 0-4095      | Limits rotation |

> Si vous décrochez un moteur Dynamixel, il est probable qu'il se mette en mode défaut. La seule façon d'y remédier est d'effectuer un cycle de mise sous tension. 
{.is-warning}

valeurs de configuration

- <a name="count_id"></a>**id:** 
  - Type :  [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Plage : 
  - Détails : Chacun doit avoir un identifiant unique
- **uart_num:**
  - Détails : Vous devez définir les broches pour le uart dans une [section uart](/config/uart_sections) du fichier de configuration. Cela doit correspondre à la vitesse de transmission programmée des servos. 1000000 est recommandé. Le mode doit être N81.

- <a name="count_min"></a>**count_min:** 
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Plage :  
  - Détails : Il s'agit de l'emplacement sur le servo de l'extrémité inférieure de la plage mpos.

- <a name="count_max"></a>**count_max:** 
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer) 
  - Plage : 
  - Détails :  Il s'agit de l'emplacement sur le servo de l'extrémité supérieure de la plage mpos.
  
**Inversion de sens:** Intervertit les valeurs count_min : et count_max :.

**Homing:** Le servo se rend immédiatement à l'emplacement homing/mpos_mm de l'axe. 

**Enable:** Les servos sont désactivés lorsque les moteurs sont désactivés (voir la valeur de configuration idle_ms). Lorsqu'ils sont désactivés, vous pouvez les déplacer à la main et les mpos suivront le mouvement.

Exemple de section de configuration:

```yaml

  x:
    steps_per_mm: 100.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 50.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: false
      mpos_mm: 0.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: NO_PIN
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      dynamixel2:
        id: 1
        uart_num: 1
        count_min: 1024
        count_max: 3072
```

<a name="unipolar_motors"></a>

## Unipolar Motors

