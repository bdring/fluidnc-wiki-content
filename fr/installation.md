---
title: Installation de FluidNC
description: Téléchargement et compilation du fluideNC
published: true
date: 2026-08-01T19:37:16.696Z
tags: fr
editor: markdown
dateCreated: 2025-03-19T19:22:30.631Z
---

# FluidNC Web Installer

![installer1.png](/config/installer1.png =x400)

The [Web Installer](https://installer.fluidnc.com/) is now the recommended way to install, debug, maintain and upgrade FluidNC. See below if you want alternate methods.

In addition to installing FluidNC, [Web Installer has an easy way to setup WiFi](/en/features/wifi-quick-start)

# Utilisation de fichiers pré-compilés.

L'objectif de ce projet est de supprimer la nécessité de compiler pour la plupart des utilisateurs. 

 - Allez sur la [page du projet FluidNC] (https://github.com/bdring/FluidNC) sur Github
 - Cliquez sur le lien [releases link](https://github.com/bdring/FluidNC/releases) sur le côté droit de la page.
 - Cliquez sur la version que vous souhaitez. Vous devriez généralement utiliser la dernière version non « Pre ».
 - Téléchargez le fichier zip correspondant à votre système d'exploitation (**win64** pour Windows et **posix** pour Linux et Mac) à partir de la section **Assets** de la version. Vous n'avez **pas** besoin de télécharger le code source pour utiliser les fichiers pré-compilés.
 - Décompressez le fichier dans un dossier de votre ordinateur. N'essayez pas d'exécuter le programme à partir du fichier zip. Assurez-vous qu'il est complètement extrait avant de commencer. Sur certains systèmes d'exploitation, comme Windows, le dossier doit se trouver sur les lecteurs locaux, et non sur un dossier en réseau.
 - Connectez l'ESP32 via USB. Il est préférable de supprimer tous les autres périphériques USB/série lors de l'installation, car l'ESP32 pourrait essayer le mauvais périphérique.
 - Exécutez **install-wifi.bat** ou **install-bt.bat** (.sh sur d'autres systèmes d'exploitation). Assurez-vous que vous exécutez le script dans ce dossier. Il lancera FluidTerm après l'installation. Il y aura probablement quelques avertissements, mais ils devraient disparaître après l'étape suivante. Fermez FluidTerm et passez à l'étape suivante. 
 - Si vous effectuez une première installation, exécutez **install-fs.bat** (ou .sh) pour installer le système de fichiers, y compris l'interface Web. Si vous avez déjà un fichier de configuration ou d'autres fichiers sur un ESP32, ils seront supprimés, ce qui n'est pas recommandé pour la mise à jour du micrologiciel.
 - Vous pouvez remarquer un message comme celui-ci `E (38) SPIFFS : mount failed, -10025` lors de la première exécution du microprogramme. C'est normal. Il ne se produit qu'au premier démarrage et formate le système de fichiers flash. Cela peut prendre beaucoup de temps sur les ESP32s avec des mémoires flash plus grandes.
 - Vous devez maintenant charger un fichier de configuration. Les instructions pour le faire [sont ici](http://wiki.fluidnc.com/fr/config/overview).
 
 
## Dépannage

 - Si vous obtenez un message du type « Connexion .....___.....____..... » et qu'il finit par s'arrêter [voir cette entrée de la FAQ](http://wiki.fluidnc.com/fr/support/faq#when-loading-firmware-i-get-a-message-like-connecting-_______-and-it-eventually-times-out).
 - Certaines personnes ont résolu le problème en réduisant la vitesse de téléchargement. Essayez d'éditer le fichier install-wifi.bat (ou -bt) et de changer **--baud 921600** en **--baud 115200**, puis exécutez le script.
 - Windows 11. Certains rapports non confirmés indiquent que certains pilotes USB/série ne fonctionnent pas correctement avec les broches DTR et RTS utilisées pour démarrer le chargeur de démarrage. La plupart des gens n'ont pas de problème. Si vous avez une communication avec l'ESP32, mais qu'il ne charge pas le firmware, essayez d'utiliser un PC avec un autre système d'exploitation. Vous pouvez également rechercher le pilote de la puce USB. La puce est généralement un CP2102 (Silicon Labs) ou un CH340 (Jiangsu Qin Heng). Il se peut que le CH340 soit celui qui présente des problèmes.

Si vous obtenez une réponse étrange et répétitive comme celle-ci. Essayez d'utiliser le script **erase** dans les fichiers de version.
 
```
rst:0x10 (RTCWDT_RTC_RESET),boot:0x13 (SPI_FAST_FLASH_BOOT)
invalid header: 0xffffffff
...
```

## Fluidterm

Fluidterm est une console série qui se charge automatiquement lorsque vous téléchargez un micrologiciel. Elle affiche les messages de démarrage et vous permet d'interagir avec FluidNC. Pour la fermer, vous pouvez envoyer CTRL+] ou fermer la fenêtre. Vous pouvez la lancer à tout moment avec le programme **fluidterm.bat (ou .sh) qui se trouve dans ce dossier.

## Mise à jour du micrologiciel.

- Pour mettre à jour, exécutez les premières étapes ci-dessus, mais **n'installez pas** le système de fichiers.
- Si les notes de version indiquent que l'interface WebUI a été mise à jour, vous devez télécharger **index.html.gz** depuis le dossier wifi. Pour ce faire, utilisez le panneau du système de fichiers local.

<img src="/webui_local_files.png" width="400">

<hr>

<img src="/webui_local_files2.png" width="400">

## Mises à jour par voie hertzienne (OTA)

Si vous disposez d'un Wifi et que l'interface WebUI est en cours d'exécution, vous pouvez effectuer la mise à jour via l'onglet FluidNC. Cela n'écrasera pas votre fichier de configuration. Cliquez sur l'icône de nuage jaune pour télécharger votre fichier binaire compilé (.bin). Les binaires compilés se trouvent dans les dossiers **bt** ou **wifi** des versions téléchargées.

<img src="https://github.com/bdring/FluidNC/wiki/images/ota_icon.png" width="400">

Si la mise à jour affecte l'interface WebUI, vous devrez télécharger **index.html.gz** depuis le dossier [FluidNC/data](https://github.com/bdring/FluidNC/tree/main/FluidNC/data) du repo en cliquant sur l'icône verte du dossier dans l'image ci-dessus. 

# Compilation (Référence uniquement. Vous n'avez pas besoin de compiler)

## Utiliser VS Code & PlatformIO pour compiler

VS Code & PlatformIO est la seule méthode que nous offrons pour la compilation. Elle nous permet de contrôler beaucoup plus de choses que quelque chose comme l'IDE Arduino. Nous devons contrôler les bibliothèques et les versions. Les utilisateurs avancés peuvent utiliser d'autres méthodes, mais ne vous attendez pas à recevoir une aide détaillée à ce sujet.

## Options de compilation

FluidNC supporte à la fois la connectivité WiFi et Bluetooth. Ces bibliothèques ont un impact important sur la taille du firmware. Par défaut, seul le WiFi est activé. Vous pouvez utiliser l'un ou l'autre, les deux ou aucun en modifiant le fichier **platformio.ini**.

Veuillez utiliser git pour acquérir les fichiers sources du firmware. Cela garantira que la version affichée est exacte et qu'il y a un moyen pour nous de voir tous les changements que vous avez pu faire. **Si vous n'utilisez pas Git, nous ne pouvons pas vous aider.

Il y a une ligne vers le haut **deafault_envs = wifi** Changez-la comme ci-dessous.

- Pour Bluetooth uniquement **default_configs = bt**
- Pour WiFi et Bluetooth **default_configs = wifibt**
- Pour ni l'un ni l'autre **default_envs = noradio**

## Utiliser des ESP32 avec plus de mémoire

**Utilisateurs avancés uniquement**. Si vous avez besoin d'aide, vous n'êtes probablement pas encore un utilisateur avancé.
{.is-warning}

> La méthode d'installation standard fonctionne bien pour toutes les puces de 4M et plus. Vous n'avez simplement pas accès à la mémoire supplémentaire.
{.is-info}

La plupart des modules ESP32 ont 4Meg de mémoire. Nous utilisons un schéma de partition standard pour allouer cette mémoire. FluidNC s'attend à certaines sections dans la table de partition, nous avons donc quelques types recommandés pour les modules avec des mémoires plus grandes.

La seule façon de le faire est de compiler soi-même en modifiant le fichier platformio.ini. Nous devrions apporter des changements majeurs à notre système de distribution et à nos scripts d'installation pour permettre aux utilisateurs de choisir la taille de la mémoire. Nous ne considérons pas cela comme une priorité plus importante que beaucoup d'autres choses sur notre liste pour le moment.

Trouvez cette section du fichier platformio.ini et décommentez l'une de ces trois lignes.

```ini
board_build.partitions = min_spiffs.csv ; For 4M ESP32
; board_build.partitions = FluidNC/ld/esp32/app3M_spiffs1M_8MB.csv  ; For 8Meg ESP32
; board_build.partitions = FluidNC/ld/esp32/app3M_spiffs9M_16MB.csv ; For 16Meg ESP32
```
Vous pouvez obtenir des informations sur la taille de votre mémoire en lançant `esptool.exe flash_id` (syntaxe Win64). esptool est inclus dans les versions FluidNC et platformio avec le framework ESP32. Ces données sont également affichées lorsque vous utilisez nos scripts d'installation.

```
Detecting chip type... ESP32
Chip is ESP32-D0WD (revision 1)
Features: WiFi, BT, Dual Core, 240MHz, VRef calibration in efuse, Coding Scheme None
Crystal is 40MHz
MAC: 4c:11:ae:ea:7a:8c
Uploading stub...
Running stub...
Stub running...
Manufacturer: 20
Device: 4016
Detected flash size: 4MB
```

## Configuration


Vous devez créer et télécharger un [fichier de configuration](http://wiki.fluidnc.com/fr/config/overview) pour adapter le micrologiciel à votre machine. Si vous ne le faites pas, vous verrez ce message **[MSG:WARN : Cannot open config file:config.yaml]**. Ce message indique qu'il ne peut pas trouver le fichier par défaut appelé config.yaml. Dans ce mode, vous pouvez jouer avec une machine virtuelle à 3 axes. Vous pouvez l'actionner et essayer plusieurs choses. Vous ne pouvez rien faire qui nécessite un retour d'information de la part d'une machine réelle, comme le homing, le probing ou la lecture d'une carte SD.

Si vous disposez d'une définition de machine fonctionnelle provenant de Grbl_ESP32, vous pouvez utiliser une méthode automatisée. [Voir cette entrée de la FAQ](/support/faq#is-there-an-easy-way-convert-from-grbl_esp32).

La manière la plus simple de télécharger un fichier de configuration est de le faire via **FluidTerm**. 

- Utilisez la touche **CTRL+U** pour démarrer le processus.
- Sélectionnez le fichier que vous souhaitez télécharger
- Confirmez le nom de fichier sous lequel vous souhaitez le stocker (le nom par défaut est le même)
- Une fois le téléchargement terminé, vous devez indiquer à FluidNC de l'utiliser avec **$Config/Filename=<votrefichier.yaml>** Exemple : **$Config/Filename=my_cnc.yaml**

Vous pouvez également télécharger un fichier via l'interface WebUI. Veillez à envoyer **$Config/Filename=<votrefichier.yaml>** à la console et redémarrez FluidNC. Veillez à ce qu'il n'y ait pas d'espace devant le nom de fichier.

<img src="https://github.com/bdring/FluidNC/wiki/images/WebUI_upload.png" width="400">

Vous pouvez voir tous les fichiers qui ont été téléchargés sur le système de fichiers local avec la commande **$LocalFS/List**. C'est un bon moyen de vérifier si les fichiers ont été téléchargés.


## Versioning

Lorsque vous compilez vous-même, la version n'a pas de sens car nous ne savons pas si des modifications ont été apportées. La chaîne de version ressemblera à ceci 

```
[FluidNC v3.1.4 (Devt-a39e92c-dirty) (wifi) '$' pour l'aide]
```

Quelle que soit la valeur de `v3.x.x`, elle ne signifie rien de significatif. `(Devt-a39e92c-dirty)` indique la branche git et le dernier commit dont vous avez tiré le code source. dirty signifie qu'il y a eu un changement. 

## Soumettre des modifications

Quelles sont les [directives de demande d'extraction](/development/pull_request_guidelines) qui doivent être suivies.

## Décodage de la trace arrière (Windows)

En cas de plantage, un rapport **backtrace** est généralement imprimé sur le port série avant le redémarrage avec une configuration par défaut. Ce rapport liste l'adresse mémoire où le crash s'est produit et toutes les fonctions appelantes sur la pile. Cela ressemble à ceci.

```
Backtrace:0x400EE971:0x3FFB2540 0x400E40D1:0x3FFB26C0 0x40081B4A:0x3FFB26F0 0x400FCC78:0x3FFB2710 0x400E05F2:0x3FFB2730 0x401A823B:0x3FFB2750 0x400DAA6B:0x3FFB2770 0x400DA48A:0x3FFB2790 0x400DA6CE:0x3FFB27B0 0x400DDAE7:0x3FFB27E0 0x4010BF1E:0x3FFB2820
```

Dans le paquet FluidNC, nous incluons des fichiers appelés **wifi-firmware.elf** (Executable and Linkable Format) et **bt-firmware.elf** qui peuvent décoder les adresses des fonctions, des fichiers et des numéros de ligne.

Vous avez besoin d'un programme appelé **addr2line** pour effectuer le décodage. Il est installé avec platformio et c'est la meilleure façon de l'obtenir.

Pour la plupart des gens, addr2line se trouve à l'endroit indiqué ci-dessous. Vous devrez peut-être le rechercher s'il ne se trouve pas dans ce dossier. 

``` 
..\Users\<user>\.platformio\packages\toolchain-gccmingw32/bin/
```

Dans le dossier qui contient le fichier elf, envoyez cette ligne de commande avec \<user\> remplacé par votre nom d'utilisateur et \<addresses\> remplacé par les adresses de backtrace


```
C:\Users\<user>\.platformio\packages\toolchain-gccmingw32/bin/addr2line.exe -a <addresses> -e wifi-firmware.elf
```

Dans mon cas, la ligne de commande ressemblerait à ceci.

```
C:\Users\barto\.platformio\packages\toolchain-gccmingw32/bin/addr2line.exe -a 0x400EE979:0x3FFB2540 0x400E40D1:0x3FFB26C0 0x40081B4A:0x3FFB26F0 0x400FCC80:0x3FFB2710 0x400E05F2:0x3FFB2730 0x401A8243:0x3FFB2750 0x400DAA6B:0x3FFB2770 0x400DA48A:0x3FFB2790 0x400DA6CE:0x3FFB27B0 0x400DDAE7:0x3FFB27E0 0x4010BF26:0x3FFB2820 -e firmware.elf
```

## Backtrace Decoding (macOS)

**addr2line** does not come packaged with the macOS PlatformIO installer, but it is available via both **macports** and **brew** as part of the GNU Binutils package.

### Brew Installation

```
brew install binutils
```

### Installation de Macports

```
port install binutils
```

Veuillez noter où **binutils** est installé car cela peut varier entre les deux outils d'empaquetage.  Brew l'installe dans `/usr/local/opt/binutils/bin/`.


En suivant l'exemple **backtrace** montré ci-dessus, la syntaxe pour exécuter **addr2line** ressemblerait à ceci (en supposant que votre cwd est le répertoire racine de FluidNC et que vous exécutez un build wifi) :

```
/usr/local/opt/binutils/bin/addr2line -a 0x400EE979:0x3FFB2540 0x400E40D1:0x3FFB26C0 0x40081B4A:0x3FFB26F0 0x400FCC80:0x3FFB2710 0x400E05F2:0x3FFB2730 0x401A8243:0x3FFB2750 0x400DAA6B:0x3FFB2770 0x400DA48A:0x3FFB2790 0x400DA6CE:0x3FFB27B0 0x400DDAE7:0x3FFB27E0 0x4010BF26:0x3FFB2820 -e .pio/build/wifi/firmware.elf
```

## Comprendre les backtraces

Une trace de retour ressemble à ceci. La première ligne a provoqué l'erreur. La ligne suivante est ce qui a appelé la ligne précédente. Vous pouvez remonter l'erreur jusqu'au début.

Dans ce cas, l'erreur commence à Main.cpp et se termine par strlen. Vous pouvez consulter le code source pour voir ce que fait chaque ligne.

```
/builds/idf/crosstool-NG/.build/HOST-x86_64-w64-mingw32/xtensa-esp32-elf/src/newlib/newlib/libc/machine/xtensa/strlen.S:43
0x4010f61a
C:/Users/barto/.platformio/packages/framework-arduinoespressif32/cores/esp32/Print.h:67
0x40119511
C:/Users/barto/.platformio/packages/framework-arduinoespressif32/cores/esp32/Print.cpp:89
0x400e4662
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Configuration/../MyIOStream.h:33
0x400e481d
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Machine/Macros.cpp:15
0x400f1e61
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Protocol.cpp:1110
0x400f1ee9
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Protocol.cpp:805
0x400f2266
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Protocol.cpp:339
0x400f2515
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Protocol.cpp:269
0x400e55ed
C:\Users\barto\Documents\GitHub\FluidNC/FluidNC/src/Main.cpp:147
0x4011af91
C:/Users/barto/.platformio/packages/framework-arduinoespressif32/cores/esp32/main.cpp:50
```



