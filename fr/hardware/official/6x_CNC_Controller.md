---
title: 6x CNC Contrôleur 
description: Un contrôleur CNC complet pour 6 moteurs
published: true
date: 2025-03-20T20:21:39.252Z
tags: contoleur 6x
editor: markdown
dateCreated: 2025-03-20T19:59:53.526Z
---

# Vue d'ensemble



Il existe deux versions de ce contrôleur. L'une utilise un ESP32 à brancher et l'autre en a un intégré dans le contrôleur. Elles ont des brochages identiques et à peu près le même emplacement de tous les connecteurs. Sauf indication contraire, cette page couvre les deux versions.



# Où l'acheter.



- Les clients américains peuvent l'acheter sur [Tindie](https://www.tindie.com/products/33366583/6x-cnc-controller-for-fluidnc-integrated-esp32/). 



- Les clients internationaux peuvent acheter via [Elecrow](https://www.elecrow.com/6x-cnc-controller-for-fluidnc.html).



# Caractéristiques



- (6) Connecteurs de moteur pour les pilotes pas à pas externes (signaux de 5 V). Chaque moteur a ses propres signaux de pas, de direction et d'activation. Des diodes électroluminescentes sont présentes sur chaque signal pour faciliter la configuration.

- (8) Entrées pour interrupteurs (limites, sondes, contrôle)

- Broches (plusieurs types pris en charge). Certains arrangements multibroches sont possibles, comme RS485 et laser sur la même machine.

  - RS485 VFD Broches

  - Broches commandées par 0-10V avec des signaux supplémentaires de direction avant et arrière.

  - Contrôleurs de vitesse PWM avec signaux de validation séparés en option

  - Broches commandées par relais (marche/arrêt).

  - Broches basées sur le BESC (moteur sans balais)

  - Lasers avec PWM et activation

- (2) MOSFETs 3A pour piloter des relais, des solénoïdes et des vannes.

- Les sorties 5V de la broche non utilisées peuvent être utilisées pour n'importe quelle fonction de sortie (liquide de refroidissement, etc.).

- Prise pour carte Micro SD pour le stockage local des fichiers gcode

- Prise de module pour les extensions GPIO et les interfaces pendantes.





# Versions



Actuellement, toutes les versions utilisent les mêmes E/S. Les fichiers de configuration sont compatibles entre les versions.



- V1.2** Cette version est passée de l'antenne ESP32 pour PCB à la version avec connecteur pour PCB. Cela **ne change pas** la disposition du PCB car les 2 empreintes sont compatibles.





# Démarrage



Le contrôleur est livré avec une version de FluidNC qui était à jour au moment de la construction du contrôleur. Vous pouvez mettre à jour le micrologiciel à l'aide du [web installer here] (https://installer.fluidnc.com/). Il est préférable d'effectuer une **mise à niveau** et non une **installation récente**.



Il est livré avec un fichier de configuration par défaut qui est principalement utilisé pour les tests en usine et qui ne fera probablement pas fonctionner votre machine. Vous devrez [créer un fichier de configuration] (http://wiki.fluidnc.com/en/config/overview) pour votre machine et le télécharger. 



# Demander de l'aide



Avant de demander de l'aide, veuillez consulter toutes les sections de ce wiki. Vos questions ont probablement déjà été posées et des réponses détaillées avec des photos, des dessins et des schémas sont disponibles sur ce wiki.



Consultez cette [page d'aide] (http://wiki.fluidnc.com/en/support/requesting_help) si vous avez encore des problèmes.



Pour toute autre question, veuillez utiliser notre [serveur discord](http://wiki.fluidnc.com/en/support/discord).



# Construit dans l'ESP32



Ceci utilise un connecteur USB-C. L'alimentation principale doit être activée pour alimenter la puce USB. Vous n'obtiendrez pas de connexion à votre ordinateur si l'alimentation principale n'est pas activée.

# Alimentation électrique

Le contrôleur doit être alimenté par une alimentation 12-30VDC. Cette tension primaire est appelée VMot sur le schéma et dans la documentation. Elle doit pouvoir fournir un minimum de 2A.  Si vous branchez des appareils externes sur l'une des connexions VMot, vous devez ajouter ces courants à la tension minimale de l'alimentation.

Au milieu du contrôleur se trouve un en-tête permettant d'accéder à toutes les tensions du contrôleur. Celles-ci sont réservées aux faibles courants. Vous ne devez pas tirer plus de 1A de l'une de ces connexions.

VMot est également accessible sur les bornes du MOSFET. Vous pouvez tirer jusqu'à 3A sur chacune de ces broches.

Vous ne devez pas alimenter une broche ou un laser à partir de ce contrôleur. Utilisez un câblage séparé de votre alimentation électrique. 

>Il n'est pas possible d'alimenter le contrôleur uniquement par l'intermédiaire de l'USB. L'USB ne se connectera pas
{.is-info}

> Faites très attention à la polarité de la tension. Il n'y a pas de protection contre l'inversion de polarité, vous allez donc détruire le contrôleur et probablement certains objets connectés. 
{.is-warning}

Un en-tête central permet à l'utilisateur d'accéder à ces tensions.

- 3,3V 100mA max total
- 5V 500mA max total
- VMot 1A par broche max.

# Programmation

Le contrôleur est programmé avec la révision FluidNC en vigueur au moment de sa fabrication. Il dispose également d'un fichier de configuration très basique qui est utilisé pour les tests. Il existe un fichier gcode de test qui fait clignoter les DEL et bouger les moteurs. Vous devez vérifier les mises à jour avant d'utiliser le contrôleur. La version est indiquée dans les messages de démarrage. Envoyez `$ss` pour les voir après un nouveau démarrage. La version actuelle de FluidNC est toujours [listée ici] (https://installer.fluidnc.com/).

Mettez le contrôleur sous tension via le bornier d'alimentation. Vérifiez que la LED 5v au milieu du PCB est allumée. Connectez un câble USB C de haute qualité au contrôleur. Connectez l'autre extrémité à un PC (Windows, Mac ou Linux).

Utilisez le navigateur Chrome pour vous connecter à la page [FluidNC Web Installer](https://installer.fluidnc.com/). Cliquez sur le bouton Connecter. Sélectionnez le port COM associé au contrôleur. Le périphérique USB est un Silicon Labs CP2102. Si plusieurs ports COM sont disponibles, recherchez celui dont la description est similaire à celle-ci. Sélectionnez-le pour que la page web s'y connecte.

Installez la version portant le numéro le plus élevé. N'utilisez pas de versions de test, sauf si cela vous est demandé pour résoudre un problème d'assistance.

Voir la [page d'installation générale](/installation) pour plus d'informations et d'autres méthodes.

# Moteurs

![external_stepper.jpg](/hardware/external_stepper.jpg =x200)

Le contrôleur est conçu pour des modules de pilotage pas à pas externes qui acceptent des signaux de pas, de direction et d'activation de 5V. Ils utilisent tous des broches [i2so](http://wiki.fluidnc.com/en/support/controller_design_guidelines#i2so-chips), vous devez donc utiliser I2S_STATIC ou I2S_STREAM dans la [section stepping](http://wiki.fluidnc.com/en/config/axes#stepping) de votre fichier de configuration.

```yaml
stepping:
  engine: I2S_static
  idle_ms: 255
  pulse_us: 4
  dir_delay_us: 4
  disable_delay_us: 0
  segments: 6
```

Chaque sortie moteur peut être utilisée pour n'importe quel axe ou numéro de moteur. Ils sont étiquetés Motor1 à motor6, juste pour référence. Voici les broches de chaque moteur.

```yaml
# motor 1
      standard_stepper:
        step_pin: I2SO.2
        direction_pin: I2SO.1
        disable_pin: I2SO.0
      
# motor2
      standard_stepper:
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: I2SO.7

# motor3
      standard_stepper:
        step_pin: I2SO.10
        direction_pin: I2SO.9
        disable_pin: I2SO.8
       
# motor4
      standard_stepper:
        step_pin: I2SO.13
        direction_pin: I2SO.12
        disable_pin: I2SO.15

# motor 5
      standard_stepper:
        step_pin: I2SO.18
        direction_pin: I2SO.17
        disable_pin: I2SO.16

# motor 6
      standard_stepper:
        step_pin: I2SO.21
        direction_pin: I2SO.20
        disable_pin: I2SO.23

```

## Câblage du moteur

![external_stepper_wiring.jpg](/hardware/external_stepper_wiring.jpg =x300)

La meilleure façon de câbler le moteur est d'utiliser une masse commune. Reliez la borne de terre du contrôleur à l'une des bornes (-) du moteur pas à pas, puis reliez-la en guirlande aux deux autres bornes (-). Voir le fil noir dans l'image ci-dessus. Ensuite, câblez individuellement les bornes step, dir et enable du contrôleur aux bornes (+) équivalentes des pilotes pas à pas. Si une fonction est activée, comme enable ou dir, changez l'[état actif] (http://wiki.fluidnc.com/en/config/config_IO#output-pin-attributes) de la broche.

![motor_wiring.png](/hardware/motor_wiring.png =400x)

Les DEL Ena, Stp et Dir du contrôleur 6x peuvent vous aider à vérifier les signaux. Les DEL indiquent l'état électrique du signal. Si le signal est élevé (5 V), la DEL est allumée. S'il est bas (gnd), la LED est éteinte. Le fait que le signal de désactivation soit actif haut ou actif bas détermine si la LED est allumée ou éteinte lorsque les moteurs se bloquent. Vous devriez simplement regarder si elle change lorsque vous envoyez $MD et $ME. La LED de direction sera allumée dans un sens et éteinte dans l'autre. La LED de pas s'allume généralement plus faiblement que les autres LEDs avec une luminosité proportionnelle à la vitesse. Ceci est dû au fait que les signaux de pas sont des impulsions très courtes. Si vous inversez l'état actif du signal de pas, l'activité de la DEL sera également inversée.

# Entrées

Toutes les entrées sont activées en fermant le circuit à la terre. Vous pouvez utiliser des interrupteurs N.O. et N.C. tant que l'une des positions ferme à la terre. 

Vous pouvez utiliser des interrupteurs électroniques tels que des interrupteurs de proximité ou inductifs tant que le signal de sortie passe à la terre (généralement appelé NPN). Si les interrupteurs nécessitent une alimentation externe, vous devez la connecter ailleurs sur le contrôleur ou sur une alimentation externe qui partage une masse commune. Dans tous les cas, l'interrupteur ne doit jamais mettre plus de 5V sur le bornier. Souvent, les types NPN ont une résistance de tirage interne sur le signal vers la tension +. Cette résistance est généralement de l'ordre de 10k. Tant qu'elle est supérieure ou égale à 5k, la connexion à l'entrée ne présente aucun danger.

Toutes les entrées ont des résistances pullup externes sauf gpio.2 et gpio.26. Vous devez ajouter l'attribut ***:pu*** à ces entrées. 

Pour les interrupteurs normalement ouverts, vous devez ajouter l'attribut ***:low** à toutes les entrées. Les interrupteurs normalement fermés sont actifs. Vous pouvez ajouter l'attribut ***:high***, mais il n'est pas nécessaire car il s'agit de l'attribut par défaut de FluidNC.

Example:

```yaml
gpio.2:low:pu
gpio.36:low
gpio.39

```

**Exemple de câblage d'un détecteur de proximité NPN.**

Connectez le fil marron à une tension compatible avec le capteur (typiquement 6-30v). Vous pouvez utiliser le connecteur de tension situé au milieu du contrôleur. Connectez le fil bleu à une masse quelconque. Connectez le fil noir aux **Entrées** marquées io.xx.

![npn_sw_wiring.png](/hardware/npn_sw_wiring.png =x300)

**Avertissement:** Certains circuits de commutateurs NPN peuvent avoir une résistance d'excursion vers la tension positive. Si cette tension est supérieure d'un ou deux volts aux 5V de l'autre côté de la LED opto sur le circuit d'entrée du contrôleur 6x, elle peut créer un potentiel inverse nuisible sur la LED. Vous pouvez utiliser un appareil de mesure pour voir la tension du signal à l'état actif et à l'état inactif. Vous pouvez utiliser une diode pour empêcher la tension inverse comme indiqué ci-dessous.

![npn_diode.png](/hardware/npn_diode.png =x450)

# Nombre de sorties

Le contrôleur possède beaucoup plus de connexions de sortie que de broches d'entrée/sortie. Pour ce faire, il partage les broches d'E/S. Par exemple, le MOSFET utilise les mêmes E/S que certaines des sorties 5V. Lorsque vous affectez cette broche d'E/S, vous pouvez utiliser soit la sortie 5V, soit le MOSFET. Ils sont liés et actifs en même temps. Vous ne pouvez pas les utiliser pour des fonctions distinctes. Voir la carte des E/S.

## Sorties I2SO

Les broches i2so sont typiquement utilisées pour le contrôle des moteurs, mais vous pouvez les utiliser pour d'autres fonctions de sorties digitales (on/off). Si par exemple vous n'utilisez pas un 6ème moteur, vous pouvez utiliser n'importe laquelle de ces broches, comme `mist_pin : i2so.23`. Voir plus d'informations sur [i2s0 pins here] (http://wiki.fluidnc.com/en/config/config_IO#i2so-section).

# Broches

De nombreuses broches partagent des sorties avec d'autres fonctions. Gardez une trace des E/S que vous utilisez pour éviter les conflits.

## PWM

Le PWM peut être placé sur n'importe laquelle des sorties 5V.

## 0-10V

Il utilise un ampli-op et un filtre passe-bas pour créer une tension analogique. Elle peut être réglée à l'aide d'un potentiomètre pour une tension maximale de 5V à 10V. Mesurez et ajustez la tension avant de la connecter à votre contrôleur de vitesse de broche. Une bonne façon de le faire est d'envoyer le gcode pour la vitesse de broche maximale comme ([M3 S24000](http://wiki.fluidnc.com/en/features/supported_gcodes#s-spindle-speed) ou tout autre maximum) et ensuite d'ajuster le potentiomètre jusqu'à ce que vous obteniez la tension maximale désirée. Il est préférable de régler la tension maximale avant de connecter votre VFD.

Le schéma des connexions avant et arrière ressemble à ceci. Elles sont isolées de l'ESP32 et connectent Out1 et Out2 à une masse commune sur le VFD.

![10v_fwdrev_schm.png](/hardware/10v_fwdrev_schm.png)

Exemple de section Config

```yaml
10V:
  forward_pin: gpio.15
  reverse_pin: gpio.14
  pwm_hz: 5000
  output_pin: gpio.13
  enable_pin: NO_PIN
  direction_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 0
  speed_map: 0=0.000% 1000=0.000% 24000=100.000%
  off_on_alarm: false

```

Voici un exemple de câblage d'un Huanyang pour un contrôle 10V. Vous devez également vous assurer que tous les registres sont configurés pour une commande de 10V.

![huany_10v_pinout.png](/hardware/huany_10v_pinout.png =x500)

---

**YL620**

Voici un exemple de câblage d'un YL620 pour un contrôle 10V. Vous devez également vous assurer que tous les registres sont configurés pour un contrôle 10V.

P00.00 = 400 ( fq 400 hz )

P00.01 = 1

P07.08 = 3

P03.12 = 100 ( fq mini )

P03.13 = 400 ( fq maxi )

pour les dip-switchs blancs dans le module rouge au dessus de la bande verte il faut mettre sur « on » le 2 et le 4 (activation 10 volts du Vfd) et laisser sur « off » le 1 et le 3

![yl620_10v_pinout.png](/hardware/yl620_10v_pinout.png =x450)

## Laser

Le laser peut être placé sur n'importe quelle sortie 5V. Si vous souhaitez également utiliser un autre type de broche, configurez-le d'abord et voyez quelles sont les entrées/sorties restantes. Réglez d'abord celui-ci et voyez quelles E/S restent.

## RS485

Le circuit RS485 utilise une puce MAX3485. Cela nécessite l'utilisation d'une broche **rts_pin** pour le contrôle de la direction des données.

Des diodes électroluminescentes (DEL) permettent de visualiser et de déboguer les problèmes de communication.

- DEL TX** (étiquetée io15) Vous devez voir la DEL TX clignoter plusieurs fois par seconde. Si ce n'est pas le cas, c'est que quelque chose ne va pas dans votre configuration du côté du contrôleur de la CNC.
- Le Rx doit clignoter au même rythme (immédiatement après) que le Tx lors de la communication avec le VFD. Si la DEL Rx reste allumée, essayez d'intervertir les fils du côté du VFD. Si elle ne s'allume pas du tout, il y a probablement un problème de configuration ou autre du côté du VFD. **Note:** Lorsqu'aucun fil RS485 n'est connecté, l'état de la LED n'a pas de sens. Ignorez ce voyant lorsque vous n'utilisez pas le RS485.
- DEL RTS** (étiquetée i014) Elle doit s'allumer en même temps que la DEL TX.

> Note : Le circuit est un convertisseur UART vers RS485. Les LEDs représentent l'état des IO côté UART. L'état d'inactivité d'un UART Tx est élevé, les clignotements TX vont donc de l'état allumé à l'état éteint. La LED RTS clignote de l'état éteint à l'état allumé. Il peut être difficile de voir les clignotements Tx off parce que la LED est brillante et que le temps d'arrêt est très court. Essayez de couvrir les autres DEL pour voir les clignotements.
{.is-info}

> RS485 est beaucoup plus compliqué à configurer que d'autres types de broches. Elle nécessite beaucoup de [configuration du côté du VFD](http://wiki.fluidnc.com/en/config/config_spindles#using-rs485-to-control-spindles) et un bon câblage. Si vous rencontrez des difficultés, vous devriez envisager d'utiliser la méthode 0-10V pour contrôler la broche. Il nous est très difficile de prendre en charge le RS485 à distance.
{.is-warning}

Voici une section typique du fichier de configuration RS485. Elle est spécifique au contrôleur 6x. Vous devez également configurer le VFD et faire en sorte que le câblage soit correct. Pour des informations générales sur la configuration du VFD, voir la [page wiki sur les broches] (http://wiki.fluidnc.com/en/config/config_spindles#using-rs485-to-control-spindles).

Pour ma Huanyang, je connecte la borne étiquetée **RS485 A** sur le contrôleur à **RS+** sur le VFD et **RS485 B** sur le contrôleur à **RS-** sur le VFD. Je n'utilise pas la borne de mise à la terre.

```
# Begin Huanyang
uart1:
  txd_pin: gpio.15
  rxd_pin: gpio.16
  rts_pin: gpio.14
  baud: 9600
  mode: 8N1

Huanyang:
  uart_num: 1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 0=25% 6000=25% 24000=100%
  off_on_alarm: false

```
# MOSFETs

Les (2) MOSFETs NPN ont une capacité de 3A en continu et de 5A en crête. Des diodes flyback sont connectées aux VMot pour les rendre sûrs pour une utilisation avec des charges inductives, telles que des relais et des solénoïdes.

Les MOSFETs utilisent gpio.4 et gpio.12. Ces broches d'E/S activent également des sorties 5V.

Les bornes VMot sont toujours connectées au VMot. Les bornes étiquetées avec les numéros des broches io passent à la masse lorsque les broches io sont actives. Si vous devez faire fonctionner des appareils avec d'autres tensions que la VMot, vous pouvez utiliser une alimentation en courant continu séparée, à condition qu'elle partage une masse commune avec le contrôleur. 

## Utilisation d'un relais.

Une utilisation typique du MOSFET est de contrôler directement un relais pour une broche ou un dispositif de refroidissement. Le circuit MOSFET possède un relais flyback intégré, il n'est donc pas nécessaire d'en ajouter un. Si le relais a un didoe intégré, assurez-vous que le VMot est du bon côté.

![6x_relay_wiring.png](/hardware/6x_relay_wiring.png =x400)

# Utilisation des servos RC

Les servos RC nécessitent un signal de commande PWM de 5V. Vous pouvez utiliser n'importe laquelle des sorties 5V. Vous devez également alimenter le servo. Vous pouvez utiliser la broche 5V au centre du contrôleur pour la plupart des servos. Si votre servo nécessite plus d'environ 1A, vous pouvez utiliser une alimentation séparée qui a une masse commune avec le contrôleur.

![rc_servo.png](/hardware/rc_servo.png =x400)

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
        output_pin: gpio.12
        min_pulse_us: 1000
        max_pulse_us: 2000
```

# Prise pour module d'extension

La prise du module d'extension est conçue pour être utilisée avec un module d'extension E/S afin de vous offrir plus d'entrées, de sorties et de connexions aux afficheurs et aux pendentifs. Certains modules existent, d'autres sont en cours de développement et devraient être disponibles à l'avenir.

La prise est similaire aux modules 6 packs, sauf qu'elle n'utilise que 2 broches d'E/S. Vous pouvez utiliser partiellement certains modules 6 packs. Vous pouvez utiliser partiellement certains modules 6 packs, mais seulement les fonctions qui utilisent les 2 premières broches E/S. Exemples : Module relais, module 5V (2 premières sorties uniquement), module d'entrée (2 premières entrées uniquement).

Vous devrez prévoir une entretoise pour soutenir le module. Vous pouvez utiliser un support fileté M3 de 11 mm de long ou cette [Entretoise imprimée en 3D (STL)](/3d_models/6_pack/1x_supp_slim.stl).

[Voici un module FluidDial simple](http://wiki.fluidnc.com/en/hardware/official/M5Dial_Pendant#rj12-connectors)

> Vous ne devez utiliser que des modules conçus pour être utilisés avec ce contrôleur. Les broches de la prise se connectent directement à l'ESP32 sans aucune protection contre le bruit ou les décharges électrostatiques. Les modules assurent généralement cette protection. Un câblage direct sur la prise d'extension risque d'endommager le contrôleur.
{.is-danger}

**Voici quelques modules que vous pouvez utiliser.**

- [Module d'affichage aditionelle](http://wiki.fluidnc.com/en/hardware/cnc_io_modules#simple-pendant-module)
- [Module d'entrée 4x](http://wiki.fluidnc.com/en/hardware/cnc_io_modules#h-4x-isolated-input-module) (seules 2 entrées peuvent être utilisées)
- [Module de sortie 5V](http://wiki.fluidnc.com/en/hardware/cnc_io_modules#h-5v-output) (seules 2 sorties peuvent être utilisées)
- [Module MOSFET](http://wiki.fluidnc.com/en/hardware/cnc_io_modules#mosfet) (seulement 2 sorties peuvent être utilisées)
- [Module RS485 isolé](http://wiki.fluidnc.com/en/hardware/cnc_io_modules#isolated-rs485)
- [Module relais](http://wiki.fluidnc.com/en/hardware/cnc_io_modules#relay-module)

## Affichage ou pendentif sur le connecteur d'extension.

Encore une fois, faites très attention au câblage.

Voici un exemple de fichier de configuration 

```yaml
uart1:
  txd_pin: gpio.25
  rxd_pin: gpio.27
  rts_pin: NO_PIN
  cts_pin: NO_PIN
  baud: 1000000
  mode: 8N1

uart_channel1:
  report_interval_ms: 75
  uart_num: 1
```

Voici une photo du module monté sur le contrôleur 6x. Les 5 premières broches vont dans la prise. Les autres sont à l'extérieur. Elles dépassent les composants de quelques millimètres. Vous devriez monter le module en utilisant une vis et une entretoise de 11mm.

![6x_fd_mounted.jpg](/hardware/fluiddial/6x_fd_mounted.jpg =x320)

# Exemple de fichier de configuration

Supprimez les caractères [comment](http://wiki.fluidnc.com/en/config/overview#comments) des fonctionnalités que vous souhaitez utiliser, mais faites attention à ne pas réutiliser les broches io. Vous verrez des avertissements dans les messages de démarrage si cela se produit.

Il existe également un [repo GitHub avec quelques exemples](https://github.com/bdring/fluidnc-config-files/tree/main/contributed/6x_CNC_Controller).

```Yaml
board: 6x
name: 6x Default
stepping:
  engine: I2S_STREAM
  idle_ms: 254
  pulse_us: 4
  dir_delay_us: 1
  disable_delay_us: 0

axes:
  shared_stepper_disable_pin: NO_PIN
  x:
    steps_per_mm: 800.000
    max_rate_mm_per_min: 5000.000
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
      limit_neg_pin: gpio.2:low:pu
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      standard_stepper:
        step_pin: I2SO.2
        direction_pin: I2SO.1
        disable_pin: I2SO.0

  y:
    steps_per_mm: 800.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 2
      positive_direction: true
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 200.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.26:low:pu
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      standard_stepper:
        step_pin: I2SO.5
        direction_pin: I2SO.4
        disable_pin: I2SO.7
        
        

	z:
    steps_per_mm: 800.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 300.000
    soft_limits: false
    homing:
      cycle: 1
      positive_direction: true
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 800.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.33:low    
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 1.000
      standard_stepper:
        step_pin: I2SO.10
        direction_pin: I2SO.9
        disable_pin: I2SO.8

	a:
    steps_per_mm: 53.400
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 960.000
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
      limit_neg_pin: gpio.32:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 3.000
      standard_stepper:
        step_pin: I2SO.13
        direction_pin: I2SO.12
        disable_pin: I2SO.15

  b:
    steps_per_mm: 808.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 200.000
    soft_limits: false
    homing:
      cycle: 1
      positive_direction: false
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 800.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.35:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 3.000
      standard_stepper:
        step_pin: I2SO.18
        direction_pin: I2SO.17
        disable_pin: I2SO.16
	c:      
    steps_per_mm: 808.000
    max_rate_mm_per_min: 5000.000
    acceleration_mm_per_sec2: 100.000
    max_travel_mm: 200.000
    soft_limits: false
    homing:
      cycle: 1
      positive_direction: false
      mpos_mm: 150.000
      feed_mm_per_min: 100.000
      seek_mm_per_min: 800.000
      settle_ms: 500
      seek_scaler: 1.100
      feed_scaler: 1.100

    motor0:
      limit_neg_pin: gpio.34:low
      limit_pos_pin: NO_PIN
      limit_all_pin: NO_PIN
      hard_limits: false
      pulloff_mm: 3.000
      standard_stepper:
        step_pin: I2SO.21
        direction_pin: I2SO.20
        disable_pin: I2SO.23
          
i2so:
  bck_pin: gpio.22
  data_pin: gpio.21
  ws_pin: gpio.17

spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18

sdcard:
  card_detect_pin: NO_PIN
  cs_pin: gpio.5

probe:
  pin: gpio.39:low
  toolsetter_pin: gpio.36:low

# Using MOSFETs (Check Spindle Pin Usage
# coolant:
  # flood_pin: gpio.12
  # mist_pin: gpio.4
  # delay_ms: 0

start:
  must_home: false

# Begin Huanyang  
uart1:
  txd_pin: gpio.15
  rxd_pin: gpio.16
  rts_pin: gpio.14
  baud: 9600
  mode: 8N1
  
Huanyang:
  uart_num: 1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 0=25% 6000=25% 24000=100%
  off_on_alarm: false
  
# #begin PWM
# pwm:
  # pwm_hz: 5000
  # direction_pin: NO_PIN
  # output_pin: gpio.13
  # enable_pin: gpio.14
  # disable_with_s0: false
  # s0_with_disable: true
  # spinup_ms: 0
  # spindown_ms: 0
  # tool_num: 0
  # speed_map: 0=0.000% 10000=100.000%
  # off_on_alarm: false

# #begin Laser
# Laser:
  # pwm_hz: 5000
  # output_pin: gpio.4
  # enable_pin: gpio.12
  # disable_with_s0: false
  # s0_with_disable: true
  # tool_num: 1
  # speed_map: 0=0.000% 255=100.000%
  # off_on_alarm: true

# #begin 10V
# 10V:
  # forward_pin: gpio.15
  # reverse_pin: gpio.14
  # pwm_hz: 5000
  # output_pin: gpio.13
  # enable_pin: NO_PIN
  # direction_pin: NO_PIN
  # disable_with_s0: false
  # s0_with_disable: true
  # spinup_ms: 0
  # spindown_ms: 0  
  # tool_num: 0
  # speed_map: 0=0.000% 1000=0.000% 24000=100.000%
  # off_on_alarm: false

```

# Fichiers sources

Tout est open source.

- [Fichiers de fabrication de circuits imprimés](https://oshwlab.com/bdring/6-pack-2-0_copy_copy_copy) (EasyEDA)
- [3D Models](https://grabcad.com/barton.dring-2/models) (GradCAD)

# Référence du brochage

![6x_pinout.png](/hardware/6x_pinout.png)



	
















