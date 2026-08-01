---
title: 3.2 Comment demander de l'aide
description: 
published: true
date: 2025-04-01T19:00:50.144Z
tags: fr
editor: markdown
dateCreated: 2025-03-19T19:49:06.785Z
---

# Demande d'aide pour des problèmes de matériel.

Les développeurs consacrent la majeure partie de leur temps au développement et au support du firmware FluidNC. La prise en charge des problèmes matériels n'est pas une priorité pour nous. La priorité est encore plus faible si vous ne soutenez pas le projet ou si vous n'utilisez pas [matériel pris en charge](/hardware/existing_hardware).

Vous pouvez toujours poser la question sur notre Discord et GitHub, mais les développeurs peuvent laisser le reste de la communauté y répondre.

# Demande d'aide pour FluidNC

Lorsque vous demandez de l'aide via un « Rapport de problème » [GitHub Issue](https://github.com/bdring/FluidNC/issues/new?assignees=&labels=triage&template=problem.yml&title=Problem%3A+) (de préférence) ou [Discord](https://discord.gg/MDsRDeNsTE), nous aimerions que vous nous fournissiez les informations suivantes.

## Messages de démarrage de FluidNC

> Ne demandez pas d'aide avant d'avoir lu les messages de démarrage. **Pour la plupart des questions, l'origine du problème est indiquée dans les messages de démarrage. Si vous ne comprenez pas les erreurs et les avertissements, [lisez cette page](http://wiki.fluidnc.com/fr/support/troubleshooting_config_files).
{.is-success}

Lorsque FluidNC démarre, il envoie un certain nombre de messages qui décrivent la version du micrologiciel et la configuration. Ces messages sont très utiles pour les personnes qui tentent de vous aider à résoudre votre problème. Les messages sont envoyés au port [USB/Série](https://github.com/bdring/FluidNC/wiki/Serial-Port-Usage) lors du démarrage de FluidNC. Utilisez [FluidTerm](http://wiki.fluidnc.com/fr/fluidterm/fluidterm_usage) ou le terminal de [Web Installer](https://installer.fluidnc.com/) pour vous connecter au port série.

> Si l'utilisation du port USB/Série n'est pas possible, vous pouvez obtenir une copie des messages de démarrage de la console WebUI à l'aide de la commande `$Startup/Show` ou `$SS`.
{.is-info}

Vous pouvez cliquer sur le bouton de réinitialisation du module ESP32 (de préférence) ou envoyer `$Bye` via le moniteur série pour forcer une réinitialisation et voir les messages de démarrage. Ils ressembleront au texte ci-dessous. Veuillez ne pas inclure d'autre texte que les lignes [MSG .....].

> Ces messages contiennent des erreurs et des avertissements. Essayez de résoudre ces problèmes **avant de demander de l'aide**.
{.is-info}

Il ne doit contenir que la ligne INFO. Aucune ligne ERR ou WARN.


```
[MSG:INFO: FluidNC v3.2.4]
[MSG:INFO: Compiled with ESP32 SDK:v3.3.4-432-g7a85334d8]
[MSG:INFO: Configuration file:soft_liim.yaml]
[MSG:INFO: Kinematics: using defaults]
[MSG:INFO: Increasing stepping/pulse_us to the IS2 minimum value 4]
[MSG:INFO: Defaulting to Cartesian kinematics]
[MSG:INFO: Machine Root V4]
[MSG:INFO: Board Root Controller V1]
[MSG:INFO: I2SO BCK:gpio.22 WS:gpio.21 DATA:gpio.12]
[MSG:INFO: SPI SCK:gpio.18 MOSI:gpio.23 MISO:gpio.19]
[MSG:INFO: SD Card cs_pin:gpio.5 dectect:NO_PIN]
[MSG:INFO: Stepping:I2S_stream Pulse:4us Dsbl Delay:5us Dir Delay:5us Idle Delay:255ms]
[MSG:INFO: User Digital Output:0 on Pin:I2SO.21]
[MSG:INFO: Axis count 3]
[MSG:INFO: Axis X (0.000,490.000)]
[MSG:INFO:   Motor0]
[MSG:INFO:     Standard Stepper Step:I2SO.5 Dir:I2SO.6 Disable:I2SO.7]
[MSG:INFO:     All Limit gpio.2]
[MSG:INFO: Axis Y (0.000,736.000)]
[MSG:INFO:   Motor0]
[MSG:INFO:     Standard Stepper Step:I2SO.2 Dir:I2SO.3 Disable:I2SO.4]
[MSG:INFO:     Pos Limit gpio.15]
[MSG:INFO:   Motor1]
[MSG:INFO:     Standard Stepper Step:I2SO.15 Dir:I2SO.0 Disable:I2SO.1]
[MSG:INFO:     Pos Limit gpio.26]
[MSG:INFO: Axis Z (-158.000,0.000)]
[MSG:INFO:   Motor0]
[MSG:INFO:     Standard Stepper Step:I2SO.12 Dir:I2SO.13 Disable:I2SO.14]
[MSG:INFO:     All Limit gpio.27]
[MSG:INFO: Kinematic system: Cartesian]
[MSG:INFO: Using spindle NoSpindle]
[MSG:INFO: Probe Pin: gpio.32]
[MSG:INFO: Connecting to STA SSID:Barts-WLAN]
[MSG:INFO: Connecting.]
[MSG:INFO: Connecting..]
[MSG:INFO: Connected - IP is 192.168.1.16]
[MSG:INFO: WiFi on]
[MSG:INFO: Start mDNS with hostname:http://fluidnc.local/]
[MSG:INFO: SSDP Started]
[MSG:INFO: HTTP started on port 80]
[MSG:INFO: Telnet started on port 23]

Grbl 3.2 [FluidNC v3.2.4 (wifi) '$' for help]
[MSG:INFO: '$H'|'$X' to unlock]
```

Vous devriez consulter les messages avant de demander de l'aide. Si vous voyez des erreurs (ERR) comme `[MSG:ERR : Ignored key direction]`, vous pouvez remarquer que vous avez mal orthographié direction dans votre fichier de configuration. Recherchez également les avertissements (WARN). 

## Type de contrôleur

Quel type de contrôleur utilisez-vous ? S'il s'agit d'un contrôleur conçu sur mesure, veuillez le décrire et inclure des photos et des schémas.

## Messages de démarrage de l'ESP32

L'ESP32 produit un tas de textes au démarrage. Ce sont des choses assez ésotériques, et nous n'avons généralement pas besoin de les voir lorsque vous demandez de l'aide. La partie rst : indique la raison du démarrage.

- 0x1, Vbat power on reset (réinitialisation de l'alimentation)
- 0x3, Réinitialisation logicielle du noyau numérique
- 0x4, Réinitialisation du noyau numérique par l'ancien chien de garde
- 0x5, Réinitialisation du noyau numérique en sommeil profond
- 0x6, Réinitialisation par le module SLC, réinitialisation du noyau numérique
- 0x7, Timer Group0 Watch dog reset digital core
- 0x8, Timer Group1 Remise à zéro du noyau numérique par le chien de garde
- 0x9, RTC Watch dog Reset digital core
- 0xa, Instrusion testée pour réinitialiser le CPU
- 0xb, Réinitialisation de l'unité centrale par le groupe de temps
- 0xc, Réinitialisation du logiciel de l'unité centrale
- 0xd, RTC Watch dog Reset CPU
- 0xe, pour l'unité centrale APP, réinitialisée par l'unité centrale PRO
- 0xf, réinitialisation lorsque la tension vdd n'est pas stable
- 0x10, RTC Watch dog reset digital core and rtc module

En voici un exemple.

```
ets Jun  8 2016 00:22:57

rst:0xc (SW_CPU_RESET),boot:0x13 (SPI_FAST_FLASH_BOOT)
configsip: 0, SPIWP:0xee
clk_drv:0x00,q_drv:0x00,d_drv:0x00,cs0_drv:0x00,hd_drv:0x00,wp_drv:0x00
mode:DIO, clock div:1
load:0x3fff0018,len:4
load:0x3fff001c,len:1044
load:0x40078000,len:10124
load:0x40080400,len:5856
entry 0x400806a8
```  

## Versions diffusées

Ce message indique la version. Une version publiée typique ressemble à ceci.

```
Grbl 3.2 [FluidNC v3.2.4 (wifi) '$' pour l'aide]
```

- **Grbl 3.2** Ceci est utilisé parce que beaucoup d'expéditeurs de gcode Grbl l'utilisent pour reconnaître un firmware compatible Grbl. 

- **FluidNC v3.2.4** C'est la version. vous pouvez la comparer à la version actuelle [ici](https://github.com/bdring/FluidNC/releases).

- **(wifi)** Mode radio pour lequel le code a été compilé.

## Version Git non publiée

Si vous utilisez un micrologiciel qui n'a pas été compilé par notre système de publication, le message ressemblera à ceci.

```
Grbl 3.2 [FluidNC v3.2.1 (Devt-865526c-dirty) (wifi) '$' pour l'aide]
```

 - **(Devt-865526c-dirty)** Devt fait référence à la branche git, 865526c fait référence à l'identifiant du commit. dirty signifie que ce code a été modifié.

Si vous demandez de l'aide, veuillez nous indiquer les modifications que vous avez apportées.

## Version n'utilisant pas Git.

Ceci n'est pas recommandé et nous ne le supportons pas. L'information sur la version ne nous dira rien.

## Affichage du fichier de configuration.

Vous pouvez afficher le fichier de configuration tel qu'il est sauvegardé sur l'ESP32 avec `$Localfs/Show=\<filename>` comme `$Localfs/Show=config.yaml`

Vous pouvez afficher la configuration telle qu'elle est stockée dans la RAM de l'ESP32 avec `$Config/Dump` ou `$CD`. Le fichier en RAM sera probablement différent de celui sauvegardé, car des sections manquantes et des valeurs corrigées peuvent être utilisées. **Ne postez pas ceci.** Cela ne nous aidera pas à résoudre votre problème.

### Coller le fichier de configuration sur Github

Veillez à utiliser des blocs de code markdown avec les 3 backticks et le mot-clé yaml. Sinon, c'est difficile à lire et l'indentation requise est perdue. Cela devrait ressembler à ceci lors de la 

````
```yaml
name: "ESP32 DM556 Plasma 3 Axis"
board: "ESP32 Dev Controller V4"

stepping:
  engine: RMT
  idle_ms: 250
  dir_delay_us: 0
``
````

...et ceci lors de la prévisualisation du problème. La couleur peut être différente selon le serveur web utilisé.

 ```yaml
name: "ESP32 DM556 Plasma 3 Axis"
board: "ESP32 Dev Controller V4"

stepping:
  engine: RMT
  idle_ms: 250
  dir_delay_us: 0
```

## Paramètres

Envoyez $S via le terminal série pour obtenir tous vos paramètres. Les paramètres se présentent comme suit.

```
$Config/Filename=tmc2209_huanyang.yml
$Message/Level=Info
$Report/Status=1
$Firmware/Build=
```

## Changements personnalisés pour FluidNC.

Si vous avez apporté des modifications au code de FluidNC, veuillez nous dire exactement ce qui a été modifié et pourquoi.

## GCode

Si le problème survient lors de l'envoi du gcode, veuillez joindre le fichier gcode et indiquer le programme qui a généré le gcode.

## Comment êtes-vous interfacé avec FluidNC ?

Veuillez nous indiquer si vous utilisez un émetteur de gcode, l'interface WebUI, etc.

## Lire la page des questions fréquemment posées

[FluidNC FAQ](/support/faq)

## Affichage du texte de débogage

FluidNC envoie de nombreux messages de débogage qui sont filtrés par défaut. Vous pouvez les voir en définissant **$Message/Niveau=Debug** Les options sont...


- Aucun
- Erreur
- Avertissement
- Info
- Débogage
- Verbeux

Quel que soit le niveau sélectionné, vous verrez également les messages de niveau inférieur au-dessus de celui-ci. Info est le niveau par défaut.

## Donner une description détaillée du problème

Ne dites pas « L'axe X va à l'envers ». Dites quelque chose comme « L'axe X se déplace normalement avec le jogging, mais va dans le mauvais sens lorsque j'essaie de le faire tourner à la maison ».

La version est indiquée en haut des messages de démarrage. Vous pouvez également obtenir une version plus détaillée à l'aide de la commande **$I**.

`[VER:FluidNC 3.0-main-8dd3f6a :]` Ceci indique la version **3.0** de la branche **main** et du commit **8dd3f6a.

Dites-nous quelles commandes vous envoyez. Le simple fait de dire « quand je déplace l'axe » peut signifier une douzaine de choses, comme le jogging, le homing, etc.

