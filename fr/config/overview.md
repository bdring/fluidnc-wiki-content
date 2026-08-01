---
title: 1.1 Config fichier Vue d'ensemble
description: Informations générales sur les fichiers de configuration
published: true
date: 2026-08-01T19:40:45.948Z
tags: fr
editor: markdown
dateCreated: 2025-03-14T21:16:31.886Z
---

# Vue d'ensemble

Avec FluidNC, tout le monde utilise le même micrologiciel. C'est une bonne chose, mais la machine de chacun peut être différente. Vous résolvez ce problème en créant un fichier de configuration de la machine qui décrit votre machine.

Le fichier de configuration est un fichier texte que vous téléchargez vers FluidNC. FluidNC lit ce fichier au démarrage pour adapter le micrologiciel à votre machine. S'il ne trouve pas le fichier de configuration, il crée un fichier de configuration par défaut très simple. Cette configuration active juste assez de fonctions pour que vous puissiez interagir avec FluidNC et télécharger votre fichier de configuration, de sorte que le port série est le seul moyen de les voir.

Lors du démarrage, FluidNC utilise le port série pour vous informer des problèmes rencontrés avec votre fichier de configuration. En cas de problème, FluidNC abandonne et crée le même fichier par défaut que celui décrit ci-dessus. Vous devriez utiliser [FluidTerm](http://wiki.fluidnc.com/fr/fluidterm/fluidterm_usage) pour tester de nouveaux fichiers de configuration. Les erreurs se produisent avant que le WiFi ou le Bluetooth ne puisse être connecté.

Vous pouvez charger plusieurs fichiers de configuration et passer de l'un à l'autre. Vous indiquez à FluidNC lequel utiliser avec la commande **$Config/Filename=<votre_filename>**.

Il existe de nombreux [exemples de fichiers de configuration](https://github.com/bdring/fluidnc-config-files).  Il est peu probable que l'un d'entre eux corresponde exactement à votre machine, car les machines sont très différentes.  Au lieu de charger un exemple et d'espérer qu'il fonctionne, vous devriez étudier les exemples et comprendre comment les différents éléments s'appliquent à votre situation, en utilisant la documentation ci-dessous comme guide.

[FluidNC Web Installer](http://wiki.fluidnc.com/fr/installation#fluidnc-web-installer) est un utilitaire d'installation graphique qui vous aide à créer et à télécharger un fichier de configuration.

## Spécification du format de fichier

Notre format est un sous-ensemble très simple de [YAML] (https://en.wikipedia.org/wiki/YAML). Pour garder le firmware simple, seules les fonctionnalités dont nous avons besoin sont prises en charge.

YAML utilise des caractères d'espacement pour créer une structure à plusieurs niveaux. Il est recommandé d'utiliser deux caractères d'espacement pour chaque indentation. Il utilise un format **clé : valeur**. La valeur est facultative et peut avoir des paramètres facultatifs comme **key : value:param1:param2**. Les lignes vides entre les sections sont encouragées pour faciliter la lecture. Le format de chaque clé est spécifié quelque part sur ce wiki.

```yaml 
name: "TMC2209 XY Servo Laser"
board: "FluidNC Pen/Laser 2209 V2"

stepping:
  engine: RMT
  idle_ms: 255
  dir_delay_us: 1
  pulse_us: 2
  disable_delay_us: 0
```

**Commentaires** <a id="comments"></a> Les commentaires sont des lignes ignorées par le microprogramme. Ils sont utilisés comme notes à vous-même ou ils peuvent être utilisés pour dire au microprogramme d'ignorer la ligne. Chaque commentaire doit être sur sa propre ligne, et est créé en commençant la ligne par `#`. Les commentaires après une paire clé-valeur ne sont pas supportés.

```
# This comment will work
motor0
   limit_all_pin: gpio.16:low:pu


motor0  # This comment will cause an error
   limit_all_pin: gpio.16:low:pu
```

- **Les touches non supportées** seront ignorées et afficheront une erreur au démarrage comme `[MSG:ERR : Ignored key frodo]`. Si vous voyez cela sur ce que vous pensez être une touche valide, vous avez probablement un problème d'indentation. La touche doit être supportée pour la section sous laquelle elle est indentée.
- **Ajoutez un espace vide** après les deux points de la clé, comme `board : 6 Pack`
- **Pas d'espace** après les deux points pour les paramètres de valeur. 
- **La dernière ligne doit avoir une fin de ligne**, il faut donc avoir au moins une ligne vide à la fin du fichier.
- **L'indentation est essentielle.** Tous les sous-éléments d'une section doivent avoir exactement le même niveau d'indentation. Utilisez des espaces **N'utilisez pas de tabulations**.
- **La longueur du nom de fichier**, y compris « .yaml », ne doit pas dépasser 30 caractères.

## Data Types

Les descriptions détaillées de chaque élément du fichier de configuration vous indiqueront le type de données à utiliser. Dans de nombreux cas, les valeurs seront limitées à une plage par l'élément de configuration. Par exemple : step_per_mm est un Float, mais il doit être positif. L'utilisation d'une valeur non valide peut entraîner une erreur ou limiter la valeur à l'intervalle.

 - <a id="boolean"></a>**Boolean** Vrai ou faux
 - <a id="float"></a>**Float** Un nombre avec jusqu'à 3 décimales.
 - <a id="integer"></a>**Integer** N'utilisez pas de décimale, sinon vous obtiendrez une erreur car l'analyseur pensera qu'il s'agit d'une valeur flottante. La spécification de l'élément vous indiquera la plage valide.
 - <a id="string"></a>**String** Une chaîne de caractères. La longueur maximale générale est de 255, mais des cas spécifiques peuvent la limiter à une longueur inférieure..
 - <a id="pin"></a>**Pin** C'est une épingle d'E/S. Pour en savoir plus, voir à leur [sujet](http://wiki.fluidnc.com/fr/config/config_IO).
 - <a id="uart"></a>**UartData** Elle est utilisée pour spécifier les informations relatives au mode UART, comme « 8N1 »
 - <a id="enum"></a>**Enumeration** Une liste de valeurs acceptables. Exemple : « homing_mode » peut être « StealthChop, CoolStep, ou StallGuard » ».
 - <a id="speed_map"></a>**Speed Map** Une chaîne spécialement formatée pour configurer les vitesses de broche. [lire la suite](http://wiki.fluidnc.com/fr/config/spindle_speed_maps)

**Astuce:** Si vous utilisez un éditeur qui met en évidence la syntaxe yaml, il mettra en évidence les clés et les valeurs du fichier de configuration. Certains permettent même de réduire les sections. Lorsque vous postez dans les problèmes Github, les messages Discord, et partout où Markdown est utilisé, vous pouvez ajouter **yaml** après les 3 backticks initiaux dans les blocs de code pour mettre en évidence le code.  

## Téléchargement

Vous pouvez télécharger un fichier de configuration par WiFi en utilisant le bouton de téléchargement de fichier dans l'onglet ESP3D. Il s'agit de l'icône de dossier verte.

<img src="https://github.com/bdring/Grbl_Esp32/wiki/images/webui_localfs_upload_btn.png" width="400">

Si vous téléchargez un fichier nommé « config.yaml » dans le dossier racine du système de fichiers local,

FluidNC l'utilisera sans aucune configuration supplémentaire.  Si vous souhaitez utiliser un nom différent, vous devez également modifier le paramètre `$Config/Filename` en fonction du nouveau nom. Par exemple, la commande suivante envoyée par le conseil série changera le nom du fichier de configuration en my_machine.yaml : `$Config/Filename=my_machine.yaml`

Vous pouvez également télécharger en utilisant [Fluidterm](http://wiki.fluidnc.com/en/fluidterm/fluidterm_usage). Appuyez sur CTRL+U et sélectionnez le fichier.

Vous pouvez visualiser le contenu du fichier en FLASH avec `$LocalFS/Show=\<filename\>`

Vous pouvez voir tous les fichiers du système de fichiers local avec `$LocalFS/List`

## Aide en cas de problème

Voir [Résolution des problèmes liés aux fichiers de configuration](http://wiki.fluidnc.com/fr/support/troubleshooting_config_files).

## Live Changes (Tuning)

De nombreuses valeurs de configuration peuvent être définies lorsque le micrologiciel est en cours d'exécution. C'est généralement le cas lors de la mise au point d'une machine. Par exemple, si vous essayez de déterminer la meilleure accélération pour un axe, vous pouvez essayer plusieurs valeurs pour voir ce qui fonctionne le mieux.

Certaines fonctions ne peuvent pas être modifiées en cours d'exécution. Elles ne prennent effet qu'après un redémarrage. Il s'agit de caractéristiques telles que la définition des broches. Vous devez éditer le fichier de configuration pour les modifier.

Pour voir la valeur actuelle d'un paramètre, envoyez `$` plus la hiérarchie YAML complète de ce paramètre. Par exemple, envoyez `$/axes/x/steps_per_mm` pour voir cette valeur. Vous pouvez voir n'importe quelle branche de la hiérarchie en envoyant la hiérarchie de cette section. Par exemple, pour voir tout ce qui concerne l'axe des x, envoyez `$/axes/x`.

Pour modifier les paramètres, vous envoyez une commande `$` qui est la hiérarchie YAML complète pour ce paramètre. Par exemple, envoyez `$/axes/x/steps_per_mm=80` pour changer la résolution de l'axe des x. Les modifications n'affectent que les valeurs en mémoire volatile. Vous devez modifier le fichier YAML si vous voulez que les changements soient permanents. Si vous envoyez la commande `$Config/Dump` (ou `$CD`) vous pouvez voir la définition complète en mémoire.

L'ordre des clés dans le fichier n'a pas d'importance tant que la hiérarchie est respectée. Le fichier sera affiché ou enregistré dans l'ordre dans lequel FluidNC le stocke en mémoire. Par conséquent, le fichier sauvegardé peut ne pas ressembler au fichier original que vous avez créé. Les clés qui ont été ignorées ne seront pas sauvegardées. Les clés que vous avez omises mais qui ont des valeurs par défaut seront ajoutées au fichier.

### Sauvegarde des modifications en direct

La commande `$CD` peut également sauvegarder les modifications dans un fichier. `$CD=\<nom_du_fichier\>`sauvegarde la configuration actuelle dans le nom de fichier spécifié. Si vous spécifiez un nouveau nom de fichier, vous devez changer votre $Config/Filename pour ce fichier.

Assurez-vous qu'il y a suffisamment de place pour le fichier avant de le sauvegarder. L'ESP32 n'a pas beaucoup d'espace. Il ne peut contenir que 2 ou 3 fichiers YAML à la fois. Vérifiez l'espace libre avant de sauvegarder en affichant le contenu du système de fichiers local avec la commande `$localfs/list`. 

> Il y a quelques inconvénients à sauvegarder de cette manière. Il ne ressemblera pas vraiment à votre fichier original. Si vous avez des commentaires, ils ne figureront pas dans le fichier sauvegardé. Le fichier sera généralement beaucoup plus volumineux, car les valeurs par défaut seront enregistrées. Vous ne disposerez pas non plus d'une sauvegarde en dehors du contrôleur, à moins que vous ne téléchargiez le fichier. La plupart des utilisateurs expérimentés ont tendance à ne pas utiliser la méthode `$CD=`. Ils modifient le fichier en externe et le téléchargent à nouveau. L'installateur Web dispose d'un bon flux de travail pour effectuer cette opération.
{.is-warning}

### Noms et unités

Tous les noms des éléments de configuration comprennent un suffixe décrivant les unités ou le type. Exemples...

- **step_pin:** La valeur doit être une broche
- **pulse_us:** La valeur doit être exprimée en microsecondes.
- **max_travel_mm** La valeur doit être en millimètres.
- **r_sense_ohms** La valeur doit être exprimée en ohms.
- **run_amps** Courant de marche en ampères

N'incluez pas les unités dans votre valeur, mais seulement le nombre, la chaîne, etc.

### Valeurs par défaut

La plupart des touches ont des valeurs par défaut. Pour les broches, il s'agit généralement de NO_PIN. Si vous n'utilisez pas une broche, comme une activation sur une broche, vous n'avez pas besoin de la spécifier dans votre fichier YAML. Si vous faites un $CD (config dump), vous verrez toutes les clés, même si vous ne les avez pas spécifiées dans votre fichier YAML.

## Documentation of each section

- Top level items (no indent)
- [stepping:](http://wiki.fluidnc.com/fr/config/axes)
- [axes:](http://wiki.fluidnc.com/fr/config/axes)
  - [Motor](http://wiki.fluidnc.com/fr/config/axes)
- [spi:](http://wiki.fluidnc.com/fr/config/sd_card)
- [sdcard:](http://wiki.fluidnc.com/fr/config/sd_card)
- [control:](http://wiki.fluidnc.com/fr/config/control)
- [coolant:](http://wiki.fluidnc.com/fr/config/coolant)
- [probe:](http://wiki.fluidnc.com/fr/config/probe)
- [macros:](http://wiki.fluidnc.com/fr/config/macros)
- [user_outputs:](http://wiki.fluidnc.com/fr/config/user_outputs)
- [spindles](http://wiki.fluidnc.com/fr/config/config_spindles)
- [start:](http://wiki.fluidnc.com/fr/config/start_group)

## Exemple de fichiers de configuration

Il est fortement recommandé de commencer par un fichier de configuration existant qui est proche de ce que vous souhaitez.

Voici quelques endroits où les trouver. Note : ils fonctionnaient tous au moment où ils ont été postés, mais ne sont pas activement maintenus.

Nous avons un [repo Github de fichiers d'exemple](https://github.com/bdring/fluidnc-config-files)

Certains exemples du 6 Pack se trouvent dans le 6 Pack [GitHub Repo](https://github.com/bdring/6-Pack_CNC_Controller/tree/main/FluidNC_configs)

De nombreux autres contrôleurs ont des exemples sur leurs [pages wiki](http://wiki.fluidnc.com/en/hardware/existing_hardware).

```yaml
name: "ESP32 Dev Controller V4"
board: "ESP32 Dev Controller V4"

stepping:
  engine: RMT
  idle_ms: 250
  dir_delay_us: 1
  pulse_us: 2
  disable_delay_us: 0

axes:
  shared_stepper_disable_pin: gpio.13:low

  x:
    steps_per_mm: 800
    max_rate_mm_per_min: 2000
    acceleration_mm_per_sec2: 25
    max_travel_mm: 1000
    homing:
      cycle: 2
      mpos_mm: 10
      positive_direction: false

    motor0:
      limit_neg_pin: gpio.17:low:pu
      stepstick:
        direction_pin: gpio.14
        step_pin: gpio.12
    motor1:
      null_motor:

  y:
    steps_per_mm: 800
    max_rate_mm_per_min: 2000
    acceleration_mm_per_sec2: 25
    max_travel_mm: 1000
    homing:
      cycle: 2
      mpos_mm: 10
      positive_direction: false

    motor0:
      limit_all_pin: gpio.4:low:pu
      stepstick:
        direction_pin: gpio.15
        step_pin: gpio.26
    motor1:
      null_motor:

  z:
    steps_per_mm: 800
    max_rate_mm_per_min: 2000
    acceleration_mm_per_sec2: 25
    max_travel_mm: 1000
    homing:
      cycle: 1
      mpos_mm: 10
      positive_direction: true

    motor0:
      limit_all_pin: gpio.16:low:pu
      stepstick:
        direction_pin: gpio.33
        step_pin: gpio.27
    motor1:
      null_motor:

spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18

sdcard:
  cs_pin: gpio.5
  card_detect_pin: NO_PIN

coolant:
  flood_pin: gpio.25:high
  mist_pin:  gpio.21:low
      
probe:
  pin: gpio.32:low:pu

PWM:
  pwm_hz: 5000
  output_pin: gpio.2:low
  enable_pin: gpio.22
  direction_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 0
  speed_map: 0=0% 10000=100%
```

Il y a également un dossier [example configs](https://github.com/bdring/FluidNC/tree/main/example_configs) dans le dossier racine du repo.

## Référence du développeur

Pour que le fichier de configuration reste cohérent et relativement autodescriptif, les règles de dénomination suivantes doivent être respectées.

1. Tous les mots-clés pour les broches doivent avoir un suffixe **_pin**. Exemple **direction_pin:**
2. Tout mot-clé désignant un nombre avec une unité doit avoir l'unité comme suffixe. Exemple : **spinup_ms:**
   1. Utiliser « per » si nécessaire, comme « _mm_per_min »
   2. Utilisez 2 pour le carré, comme « _mm_per_sec2 »
   






