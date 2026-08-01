---
title: 3.1 Foire aux questions
description: 
published: true
date: 2025-03-24T20:23:26.616Z
tags: fr
editor: markdown
dateCreated: 2025-03-24T20:21:48.826Z
---

# Questions fréquemment posées

## Existe-t-il un moyen facile de convertir Grbl_ESP32 ?

Oui, créez un [nouveau problème sur le repo Grbl_ESP32](https://github.com/bdring/Grbl_Esp32/issues/new/choose). Sélectionnez le modèle de traduction et suivez les instructions. Dans les coulisses, un robot magique créera un fichier de configuration basé sur votre fichier de définition de la machine. Il vous sera renvoyé en tant que réponse à votre problème.

Le programme de traduction convertit le fichier machine.h de Grbl_ESP32 en un fichier config.yaml de FluidNC.  Le fichier machine.h est utilisé lors de la compilation de Grbl_ESP32 pour votre carte et votre machine.  FluidNC n'a pas besoin d'être compilé ; vous installez un programme précompilé sur votre ESP32, puis vous téléchargez le petit fichier texte [config.yaml](http://wiki.fluidnc.com/fr/config/overview) dans un fichier local sur le module ESP32.  A chaque démarrage, FluidNC lit le fichier config.yaml et se configure en conséquence.

Le traducteur ne gère pas tous les paramètres de Grbl_ESP32, seulement ceux qui sont définis à la compilation via le fichier machine.h.  Beaucoup de paramètres Grbl_ESP32 $, comme ceux pour les pas par axe_par_mm et autres, doivent être transférés dans le fichier config.yaml en l'éditant avec un éditeur de texte avant de le télécharger dans l'ESP32.  Vous devez inspecter le fichier config.yaml et essayer de comprendre chaque ligne, en vous assurant qu'elle correspond à votre machine.  Le traducteur fait un bon travail en assignant les broches aux fonctions et en créant la structure globale, mais les valeurs numériques comme les pas, l'accélération, les vitesses, etc. devront être ajustées.  Prenez le temps de comprendre config.yaml et vous aurez une transition facile.


FluidNC a beaucoup plus de fonctionnalités qui ne peuvent pas être définies à partir des seules informations de Grbl_ESP32. Celles-ci seront ajoutées par défaut. Lisez le fichier créé pour voir si vous souhaitez modifier les valeurs par défaut.

## Lors du chargement du firmware, j'obtiens un message du type `Connecting .....___.....____.....` et il finit par s'arrêter.

L'application de programmation doit redémarrer l'ESP32 pendant que gpio.2 est dans un état bas pour le mettre en mode bootloader. Les broches de contrôle USB/Série font normalement cela sur du matériel bien conçu. Certains matériels, en particulier les anciens kits de développement, ont des difficultés à maintenir la broche de démarrage dans l'état bas suffisamment longtemps. 

> Vous pouvez également avoir des circuits liés à cette broche qui la maintiennent dans le mauvais état. Si vous avez un interrupteur qui utilise cette broche, essayez de changer son état.
{.is-warning}

La plupart des modules du kit de développement ont également un bouton de démarrage connecté à gpio.2. Si vous maintenez ce bouton enfoncé pendant que l'ESP32 redémarre, puis le relâchez lorsque vous voyez apparaître le message `Connecting .....___`. Cela résoudra généralement le problème. 

Certains matériels mal conçus ne peuvent pas redémarrer l'ESP32. Dans ce cas, maintenez le bouton de démarrage enfoncé, cliquez sur le bouton de réinitialisation (souvent étiqueté EN), puis relâchez le bouton de démarrage lorsque vous voyez apparaître le message « Connecting .....___ ».

Si les idées ci-dessus ne vous aident pas et que vous utilisez un module amovible, essayez de programmer le module lorsqu'il est retiré du contrôleur.

Il ne s'agit pas d'un problème lié à notre micrologiciel ou à nos scripts d'installation. Ne nous faites pas part de votre frustration. Contactez le fournisseur de votre pièce.

## Pourquoi ai-je des erreurs « esp_core_dump_flash » lors du démarrage ?

Les erreurs de ce type au début des messages de démarrage sont le résultat de modifications récentes apportées à la bibliothèque Espressif. Il n'y a pas de problème avec votre démarrage. Nous espérons pouvoir bientôt modifier la bibliothèque pour éviter ces messages effrayants.

```
E (602) esp_core_dump_flash : Aucune partition core dump trouvée !
E (602) esp_core_dump_flash : Aucune partition core dump trouvée !
```

## J'obtiens Error 152 : La configuration n'est pas valide.

Cela signifie qu'une erreur s'est produite au démarrage à cause de votre fichier de configuration. Vous devriez [vérifier vos messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages) pour les erreurs.

## Problèmes d'interrupteur de fin de course et d'autoguidage

Suivez [cet organigramme](http://wiki.fluidnc.com/fr/support/setup/limit_switches) pour résoudre vos problèmes avant de demander de l'aide. 

## Comment inverser l'état d'une broche ?

Cette opération s'effectue au niveau de l'affectation des broches à l'aide de l'attribut **:high** ou **:low**. La valeur par défaut est **:high**.

Pour les commutateurs, si votre broche est définie comme **gpio.32** ou **gpio.32:high**, remplacez-la par **gpio.32:low** pour l'inverser. Si elle est définie comme **gpio.32:low**, changez-la en **gpio.32:high**.

Cela fonctionne de la même manière pour les broches de sortie. Si votre broche de sortie fonctionne à l'envers, inversez l'attribut **:high** **:low**. Une broche de direction de moteur est un autre exemple. Si votre moteur fonctionne à l'envers, inversez l'attribut high/low sur la broche de direction.

Cela fonctionne également pour les signaux PWM. Si vous voulez un signal PWM inversé, inversez l'attribut high/low.

[Voir cette page wiki](http://wiki.fluidnc.com/fr/config/overview#pin_declaration).

## Pourquoi l'erreur suivante se produit-elle : Le bus I2SO doit être configuré pour ce type de pas.

Si vous utilisez des broches I2SO, vous devez avoir une section i2so : valide dans votre fichier de configuration. Il s'agit d'une erreur fatale qui entraînera le redémarrage de l'ESP32 avec une configuration par défaut.

## Pourquoi est-ce que je perds la connexion USB ?

Le micrologiciel et l'unité centrale ESP32 n'ont pratiquement rien à voir avec cela. Nous ne pouvons que suggérer de bonnes pratiques de câblage. [Voir cette page pour plus d'informations](https://github.com/bdring/FluidNC/wiki/Serial-Port-Usage#troubleshooting)

## Pourquoi est-ce que je vois 2 réponses « ok » lorsque j'envoie des commandes au port série ?

Toutes les commandes envoyées doivent être terminées par un retour chariot (CR) ou un saut de ligne (LF). Votre terminal de port série ajoute ce caractère lorsque vous appuyez sur la touche Entrée. Vous devriez pouvoir déterminer s'il envoie un CR, un LF ou les deux lorsque vous appuyez sur la touche Entrée. Idéalement, il s'agit d'un CR ou d'un LF. S'il envoie les deux, FluidNC considérera qu'il a reçu 2 commandes. L'une avec une commande et l'autre vide. Il acceptera les deux. Ce mode de fonctionnement est acceptable.

## Le moteur se déplace de façon erratique

Vérifiez le câblage. Si un moteur bégaie, se déplace dans des directions aléatoires ou est très faible, c'est le **symptôme classique** d'une mauvaise connexion de l'un des 4 fils du moteur. Seule une des deux bobines est utilisée.

Vous pouvez déterminer quels fils appartiennent à chaque bobine en mesurant la résistance à l'aide d'un appareil de mesure. La résistance ne doit être que de quelques ohms. Une autre méthode consiste à relier deux fils ensemble et à voir si le moteur a plus de mal à tourner. S'il est plus difficile de faire tourner le moteur, ces fils appartiennent à la même bobine. 

## Détermination des pas par mm.

Pour FluidNC, le terme **pas_par_mm** est utilisé car c'est le terme générique utilisé par les constructeurs de CNC. Le microprogramme envoie en fait des impulsions de signal par mm. C'est la même chose que les pas seulement si vous n'utilisez pas le micro-pas (1 impulsion = 1 pas complet). 

Vous devez calculer cette valeur en fonction de votre machine. En règle générale, les vis d'entraînement, les rapports de poulie, les courroies, etc. doivent être pris en compte dans ce calcul. Il existe de nombreuses ressources et calculatrices sur Internet pour vous aider dans cette tâche.

Vous devez soigneusement tester votre calcul en effectuant un petit jogging de 10 mm par exemple et en mesurant le mouvement. Si vous mesurez 20 mm, vous devez réduire de moitié votre **pas_par_mm**. Si vous vous êtes déplacé de 5 mm, vous devez le doubler. En gros, divisez la distance de jogging par la distance de déplacement réelle et multipliez le résultat par votre valeur actuelle de pas_par_mm.

Exemple : steps_per_mm=160, jog amount=10, move=20

nouveau pas_par_mm = 10/20\*160 = 80

Note : Si vos mesures sont très proches, mais pas exactement identiques à vos calculs, il peut s'agir d'une erreur de mesure ou d'une certaine lenteur dans votre système. « Il est difficile d'éliminer ces erreurs parce qu'elles ne sont pas linéaires en fonction de la distance. Essayez de faire des mouvements plus longs pour le vérifier.

Note : La machine est toujours réglée en mm même si vous utilisez des pouces.

Si vous obtenez un **pas_par_mm** élevé (plus de 100) et que vous utilisez le micropas, vous devriez envisager d'utiliser une valeur de micropas plus faible. Un micropas élevé limitera la vitesse de déplacement de votre machine et vous obtiendrez des avertissements de configuration si vous dépassez cette valeur.  De toute façon, la plupart des bricolages ne sont pas plus précis que 100 pas par mm.

## Saute les pas

 - Votre valeur [stepping/pulse_us](http://wiki.fluidnc.com/fr/config/axes#pulse_us) est peut-être trop rapide. Elle peut être de 10us pour les pilotes externes, en particulier ceux qui sont bon marché (TB6560, TB6600, etc.).


## Les axes ne vont pas exactement là où je leur demande d'aller.

FluidNC est conçu pour travailler par étapes. Il ne peut pas être plus précis que les pas par mm pour l'axe. Si vous avez 100 pas par mm et que vous essayez d'aller à 0,333, vous n'irez probablement qu'à 0,33. Cette valeur peut être décalée par rapport à ce que vous pensez qu'elle devrait être, en fonction de la plage de l'axe et de l'endroit où vous l'avez mis à zéro. Il peut également y avoir d'autres problèmes d'arrondi. La précision doit être de l'ordre de +/- 1 à 2 pas.

FluidNC connaît toujours la position exacte en pas, de sorte que ce décalage ne s'accumule pas sur plusieurs déplacements, mais peut varier légèrement en fonction des cycles de positionnement et des changements de décalage de la machine.

## Les moteurs ne bougent pas

Il peut y avoir d'innombrables raisons à cela, depuis les problèmes d'alimentation et de configuration jusqu'aux utilisateurs qui ne comprennent pas comment déplacer les moteurs. Suivez ces étapes avec précision afin d'identifier le problème.

- Les étapes ci-dessous supposent toutes qu'il n'y a pas d'erreurs dans les [messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages). Corrigez les erreurs avant de continuer.

- Écoutez et sentez vos moteurs** Font-ils parfois un bruit sourd, un clic ou un bourdonnement, ou vibrent-ils lorsque vous essayez de vous déplacer ? Si c'est le cas, essayez de réduire votre **vitesse_max_mm_par_min:** et **accélération_mm_par_sec2:** de 50 %.

- **Activation des moteurs**. Les pilotes de moteur peuvent être activés et désactivés. La désactivation des moteurs vous permet de les déplacer manuellement. Vous pouvez également les désactiver automatiquement après chaque déplacement, afin qu'ils restent froids lorsqu'ils ne sont pas utilisés. Si cela ne fonctionne pas correctement, il se peut que les moteurs ne soient pas activés lorsque vous essayez de les déplacer. Un moteur qu'il est difficile de faire tourner manuellement est dit « bloqué ».  On entend souvent un bruit sourd lorsqu'un moteur se bloque.
 
 - **Tester l'activation** Vous pouvez envoyer des commandes dans FluidTerm et dans la console WebUI pour activer et désactiver les moteurs. La commande **\$Motor/Enable** (ou \$**ME**) active tous les moteurs et **\$Motor/Disable** (ou **\$MD**) désactive tous les moteurs. Essayez de tourner le moteur à la main. S'il est difficile à tourner, il est probablement activé. Envoyez chaque commande et essayez ensuite de faire tourner le moteur.

 - Il ne se verrouille pas après l'une ou l'autre commande.
      - Les pilotes sont-ils alimentés en électricité ?
      - La broche d'activation est-elle définie ? En fonction de votre carte, vous avez besoin soit d'une [partagée](http://wiki.fluidnc.com/fr/config/axes#axes) sous la section des axes, soit d'une [sous le pilote de l'axe](http://wiki.fluidnc.com/fr/config/axes#pulloff_mm).
      - Pilotes externes. La plupart des pilotes externes disposent d'une borne d'activation/désactivation, mais ils sont activés par défaut si vous ne les connectez pas, de sorte que la présence d'un signal actif désactive le pilote. Essayez-le sans connexion.
    - Il est inversé** S'il est verrouillé avec $MD et déverrouillé avec $ME. Vous devez [inverser l'état actif](http://wiki.fluidnc.com/fr/support/faq#how-do-i-invert-a-pin-state) de la broche de désactivation.
- **Les moteurs se verrouillent et se déverrouillent correctement**.

  - Vérifiez le câblage de la marche et de la direction. Les broches pourraient-elles être inversées, vérifiez-les et échangez-les éventuellement.

## Les moteurs tournent à l'envers

Modifier l'attribut [état actif](http://wiki.fluidnc.com/fr/config/config_IO#output-pin-attributes) de la broche. Vous pouvez également intervertir les **2** fils du moteur avec **une** bobine d'un moteur pas à pas pour l'inverser.

## Espace machine (Mpos)

Si vous avez des difficultés à comprendre l'espace machine, [voir cette page](https://github.com/bdring/FluidNC/wiki/Machine-Space-and-Homing). 

## Il se bloque au démarrage du Wifi.

Il y a un gros pic de puissance lorsque les radios s'allument. Cela peut provoquer un plantage si le 3,3V ne peut pas gérer le pic. Essayez d'ajouter une capacité entre 3,3V et la masse. Généralement, elle est d'environ 47uF. Voyez si 100uF peut aider.

## L'Ethernet câblé est-il supporté ?

Non. Ce n'est pas pris en charge et nous n'avons pas l'intention de le faire pour le moment.

## Question de caractère spécial

Le protocole Grbl exige que certains caractères exécutent immédiatement certaines fonctions, quel que soit le contexte. Il s'agit des caractères '?', '!' et '~'. Le caractère '?', par exemple, demande l'état actuel. Si vous essayez d'utiliser ce caractère lors de la définition d'un mot de passe, le système utilisera le caractère pour obtenir l'état à la place. Si vous essayez de définir le mot de passe à « Hello?World », il le définira à « HelloWorld » et enverra l'état.

Cela se produit pour les connexions série, Bluetooth et telnet. Vous **pouvez** utiliser ces caractères dans les champs de l'interface WebUI. Pour définir le mot de passe indiqué ci-dessus, créez une connexion AP et utilisez l'interface WebUI pour définir le mot de passe. Revenez ensuite au mode STA.

Vous pouvez également échapper aux caractères spéciaux en série, BT et telnet...

- ! - %21
- ? - %3F
- ~ - %75

et le caractère d'échappement % doit lui-même être échappé :

- % - %25

(Ce codage est le même que celui utilisé sur le web pour les URI/URL).


## Caractères internationaux et espaces dans les SSIDs WiFi

Le protocole de ligne GRBL ne gère que l'ASCII américain ; il ne peut pas transmettre directement les caractères internationaux ou les espaces. 

Si votre SSID WiFi contient un caractère non ASCII comme, par exemple **ä**, il existe une astuce pour entrer ce caractère lors de la configuration du SSID avec **\$Sta/SSID=*quelque chose*** .  Vous pouvez remplacer le caractère par une « séquence d'échappement » spéciale.  [Ce convertisseur en ligne](https://onlineutf8tools.com/convert-utf8-to-hexadecimal) vous aidera. 

Si vous collez le **ä** dans la case de gauche, la case de droite affichera **0xc3 0xa4**.  Remplacez **0x** par **%** et omettez l'espace intermédiaire pour saisir la séquence dans la valeur \$Sta/SSID.  Par exemple, si votre SSID est **Säx**, vous devez écrire **S%c3%a4x** dans le champ Sta/SSID de l'interface web ou **$Sta/SSID=S%c3%a4x** dans l'invite de commande.

Si vous utilisez un espace dans votre SSID, remplacez-le par **%20**. Par exemple, si votre SSID est **Pingouin volant**, vous devez écrire **Flying%20Pinguin** dans le champ Sta/SSID de l'interface web ou **$Sta/SSID=Flying%20Pinguin** dans l'invite de commande.

## Éléments du fichier de configuration ignorés

Si vous obtenez un message du type **WARN : Clé ignorée \<nom de la clé\>**, cela signifie que le nom de la clé est erroné ou qu'elle se trouve au mauvais endroit. Il peut s'agir d'un nom de clé valide, mais s'il n'est pas placé dans la bonne section avec le niveau d'indentation approprié, il sera ignoré. Vérifiez l'orthographe, l'emplacement et le retrait de la clé dans le message.

## Avertissement sur le fichier de configuration : \N<Pin\Nne prend pas en charge \N<quelque chose\N

Les broches de l'ESP32 sont assez flexibles mais certaines ont des restrictions. Si vous obtenez un avertissement du type « [MSG:WARN : gpio.34 does not support :pu attribute] », cela signifie que vous demandez à une broche de faire quelque chose qu'elle ne peut pas faire. Dans l'exemple, la broche ne supporte pas l'attribut pull up. Vous pouvez [voir cette page](https://github.com/bdring/FluidNC/wiki/ESP32-Pin-Reference) pour plus de détails sur les broches de l'ESP32.

Les broches d'extension I2SO sont très limitées et ne peuvent effectuer que des sorties numériques (marche/arrêt). 

## Pourquoi est-ce que j'obtiens des erreurs bizarres lors du téléchargement des fichiers de configuration ?

Essayez de supprimer un fichier de configuration inutilisé. Il se peut qu'il n'y ait pas assez d'espace. Utilisez `$localfs/list` pour voir le contenu du système de fichiers local. Utilisez `$LocalFS/Delete=<file>` pour supprimer des fichiers.

## Que signifie « No homing cycles defined » ?

Vous obtiendrez cette erreur si vous essayez d'effectuer un homing avec **\$H** et que vous n'avez pas de cycles de homing dans votre configuration. Les [cycles de positionnement](http://wiki.fluidnc.com/fr/config/axes#homing) sont définis pour chaque axe. La valeur par défaut est `cycle : 0`. Vous devez en avoir au moins un qui n'est pas 0 pour utiliser **\$H**.

Si vous avez une erreur majeure dans votre fichier de configuration, il redémarre avec une configuration par défaut très basique qui n'a pas de cycles de retour à la maison. Le but de cette configuration est de vous donner juste assez de possibilités d'utilisation pour résoudre les problèmes.

## L'ESP32 a paniqué et a redémarré.

Il peut s'agir d'une réaction normale à un mauvais fichier de configuration. FluidNC force un redémarrage pour entrer dans un état par défaut où vous pouvez résoudre le problème. Si vous regardez le texte avant la panique, vous verrez probablement une erreur [MSG:ERR :...].

Vous devez utiliser FluidTerm (ou un terminal série) pour voir ces messages car ils sont affichés avant que le WiFi ou le Bluetooth ne soient activés. 

Dans ce cas, le fichier de configuration contenait plus d'une utilisation de gpio.35.

[MSG:ERR : ERR : gpio.35 - Pin is already used].

Corrigez le problème, rechargez le fichier et redémarrez. Note : Il redémarre à la première erreur qu'il voit, donc l'erreur suivante ne sera pas affichée. Il se peut que plusieurs corrections et redémarrages soient nécessaires si vous ne corrigez pas toutes les erreurs en même temps.

```
Resetting MCU

[MSG:INFO: FluidNC v3.7.4 (NewAlarms-3b4cc9f5)]
[MSG:INFO: Compiled with ESP32 SDK:v4.4.4]
[MSG:INFO: Local filesystem type is littlefs]
[MSG:INFO: Configuration file:6P_ss_XYZ.yaml]
[MSG:ERR: ERR: gpio.35 - Pin is already used.]
Guru Meditation Error: Core  1 panic'ed (LoadProhibited). Exception was unhandled.

Core  1 register dump:
PC      : 0x4008d038  PS      : 0x00060430  A0      : 0x801d2d04  A1      : 0x3ffb1910
A2      : 0x00000007  A3      : 0x00000003  A4      : 0x000000ff  A5      : 0x0000ff00
A6      : 0x00ff0000  A7      : 0xff000000  A8      : 0x002e0455  A9      : 0x3ffb1be0
A10     : 0x00000003  A11     : 0x00060423  A12     : 0x00060420  A13     : 0x00000015
A14     : 0x00ff0000  A15     : 0xff000000  SAR     : 0x00000017  EXCCAUSE: 0x0000001c
EXCVADDR: 0x00000007  LBEG    : 0x4008d059  LEND    : 0x4008d069  LCOUNT  : 0xffffffff

Backtrace: 0x4008d035:0x3ffb1910 0x401d2d01:0x3ffb1920 0x401cf9fd:0x3ffb1c30 0x400ec686:0x3ffb1cf0 0x400d6daa:0x3ffb1e40 0x400e1331:0x3ffb1e70 0x400ee0a3:0x3ffb1ea0 0x400e25a6:0x3ffb1ec0 0x400e1abf:0x3ffb1f10 0x400e2124:0x3ffb1f30 0x400e25a6:0x3ffb1f60 0x400e2ad1:0x3ffb1fb0 0x400e3099:0x3ffb2030 0x400e31fd:0x3ffb2230 0x400e4574:0x3ffb2260 0x4011a2f6:0x3ffb2290

[MSG:INFO: FluidNC v3.7.4 (NewAlarms-3b4cc9f5)]
[MSG:INFO: Compiled with ESP32 SDK:v4.4.4]
[MSG:INFO: Local filesystem type is littlefs]
[MSG:ERR: Skipping configuration file due to panic]
[MSG:INFO: Using default configuration]
[MSG:INFO: Axes: using defaults]
[MSG:INFO: Machine Default (Test Drive)]
```

## L'ESP32 est bloqué dans une boucle de démarrage et je ne peux pas me connecter avec FluidTerm

Il peut s'agir d'un bloc d'alimentation défectueux ou sous alimenté. Dans certains cas, vous pouvez entendre l'un des moteurs faire un bruit sourd ou un clic. Si le débranchement d'un des moteurs permet de démarrer, il s'agit probablement du problème.

## Puis-je utiliser un joystick pour faire du jogging ?

Vous ne pouvez pas connecter un joystick directement à FluidNC. Cela utiliserait beaucoup de broches d'entrée/sortie et il existe de nombreux types de joystick, ce qui rendrait le micrologiciel trop lourd et compliqué.

De nombreux expéditeurs de code source prennent en charge les joysticks (l'interface WebUI ne le fait pas). Vous pourriez mettre le joystick sur le PC et utiliser un émetteur de code source qui supporte les joysticks, comme UGS.

Vous pouvez créer un pendentif avec un joystick, cela nécessiterait un MCU externe et utiliserait le protocole Grbl sur des canaux UART. Le jogging en temps réel d'un joystick est une tâche compliquée et nous ne pouvons pas vous aider à ce sujet. Il y a quelques [bonnes informations sur le repo Grbl](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Jogging) et vous pouvez aussi regarder le code source open source gcode seners.

La plupart des gens utilisent des encodeurs à cadran sur des pendentifs pour le jogging.

