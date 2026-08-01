---
title: 2.2 Commandes et réglages
description: les commandes et réglage disponible
published: true
date: 2025-03-25T19:16:55.517Z
tags: fr
editor: markdown
dateCreated: 2025-03-21T19:38:11.318Z
---

# Commandes et paramètres FluidNC

Les commandes et paramètres FluidNC utilisent le format $\<texte\>. Ils ne peuvent être utilisés qu'en mode veille.

Les commandes sont utilisées pour effectuer des actions (comme l'orientation ou la désactivation des moteurs) ou pour récupérer des informations (comme les décalages des codes g). Vous pouvez obtenir une liste complète de ces commandes avec la commande **$CMD**. De nombreuses commandes ont un format de nom complet ainsi qu'une version abrégée. Comme $Gcode/Mode et $G. De nombreux raccourcis de commande sont compatibles avec Grbl.

**Note:** Les détails de chaque commande seront ajoutés au fur et à mesure que le temps le permettra.

# Commandes

## $Alarm/Disable or $X

- Tente d'effacer l'état d'alarme (déverrouillage).

```
Grbl 3 [FluidNC v3.7,2 (wifi) '$' for help]
[MSG:INFO: '$H'|'$X' to unlock]
<Alarm|WPos:0.000,-80.000,-10.540|Bf:15,128|FS:0,0|WCO:0.000,80.000,10.540>
$X
[MSG:INFO: Caution: Unlocked]
ok
<Idle|WPos:0.000,-80.000,-10.540|Bf:15,128|FS:0,0|Ov:100,100,100>
```
## $Alarms/List or $A

- Cette fonction permet d'obtenir la description des numéros d'alarme. Vous pouvez obtenir la description d'un numéro spécifique comme ceci `$A=5`

## $Alarm/Send=<alarm_num>

Ceci est utilisé pour créer manuellement une [alarme](http://wiki.fluidnc.com/fr/support/alarm_and_error_codes#alarm-codes). Ceci peut être utilisé pour des tests ou dans un [code source conditionnel](http://wiki.fluidnc.com/fr/features/gcode_parameters_expressions#flow-control) pour arrêter un travail en cours avec une erreur.

```
$H
[MSG:Homed:Z]
[MSG:Homed:XY]
ok
<Idle|WPos:-48.000,89.000,44.577,0.000|Bf:15,128|FS:0,0>
$Alarm/Send=5
ok
[MSG:INFO: ALARM: Probe Fail Contact]
ALARM:5
<Alarm|WPos:-48.000,89.000,44.577,0.000|Bf:15,128|FS:0,0>
```

## $Build/Info or $I


- Il s'agit d'une ancienne commande de Grbl qui vous montrera un tas d'informations comme :

```
[VER:3.4 FluidNC v3.4.8:]
[OPT:MPHS]
[MSG: Machine: TMC2209 XY Servo Laser]
[MSG: Mode=AP:SSID=FluidNC:IP=192.168.0.1:MAC=AC-0B-FB-24-EE-C9]
```

  ## $Bye

- Redémarre le processeur

## $Channel/Info ou $CI

- Liste tous les canaux de communication destinés principalement aux développeurs.

```
$CI
uart
macros
```

## $Commands/List or $CMD

- Ceci montre toutes les commandes

```
$cmd
$FakeLaserMode or $32
$FakeMaxSpindleSpeed or $30
```
## $GPIO/Dump

- Sortcut : `GD`
- Affiche des informations détaillées sur toutes les broches gpio. Les broches configurées en entrée ont le préfixe `I`, et les broches configurées en sortie ont le préfixe `O`. L'état de la broche est soit `0` (bas), soit `1` (haut). Dans l'exemple ci-dessous, la broche 2, `GPIO2 I0`, signifie que gpio2 est configuré comme une entrée et a été lu comme un 0 logique, ou bas.

```none
0 GPIO0 I1
1 U0TXD
2 GPIO2 I0
3 U0RXD
4 GPIO4 I0
5 GPIO5 O1
6 SPICLK
7 GPIO7 O0 I1 SPIQ_out
8 GPIO8 O0 I0 SPID_out
9 GPIO9 O0 I1 SPIHD_out

Input Matrix
1 SPIQ_in 7

9 HSPIQ_in 19
10 HSPID_in 23
```

## $Errors/List or $E

- Cette liste contient la description des numéros d'erreur. Vous pouvez voir un numéro spécifique comme $E=5

## $FakeLaserMode or $32

- Cette commande est utilisée pour la compatibilité avec la commande Grbl, de sorte que les expéditeurs peuvent définir cette valeur. FluidNC est toujours en mode laser si un laser est configuré et s'il s'agit de la broche active.

## $FakeMaxSpindleSpeed or $30

- Cette commande est utilisée pour la compatibilité avec le laser Grbl, les expéditeurs peuvent donc définir cette valeur. FluidNC est toujours en mode laser si un laser est configuré et que la broche active est en mode laser.

## $Firmware/Info or $ESP800

```
$firmware/info
FW version: FluidNC v3.7,2-pre3 (FaultPin-cd7ec064) # FW target:grbl-embedded  # FW HW:Direct SD  # primary sd:/sd # secondary sd:none  # authentication:no # webcommunication: Sync: 81:192.168.0.1 # hostname:fluidnc(AP mode) # axis:3
```

## $GCode/Check ou $C

- Ceci active le mode de vérification du gcode. Il s'agit d'une ancienne fonction de Grbl qui vous permet d'exécuter le gcode virtuellement. La machine passera en revue tout le gcode sans bouger et vous dira si quelque chose a provoqué une alarme ou une erreur. Veillez à la désactiver pour quitter le mode de vérification.

## $GCode/Modes ou $G

- Affiche l'état de tous les gcodes modaux.

```
$G
[GC:G0 G54 G17 G21 G90 G94 M5 M9 T0 F0 S0]
```

## $GCode/Offsets ou $#

- Ceci montre tous les décalages sauvegardés dans la mémoire non volatile.

```
$#
[G54:0.000,80.000,10.540]
[G55:0.000,0.000,0.000]
[G56:0.000,0.000,0.000]
[G57:0.000,0.000,0.000]
[G58:0.000,0.000,0.000]
[G59:0.000,0.000,0.000]
[G28:6.000,77.000,30.000]
[G30:6.000,77.000,50.000]
[G92:0.000,0.000,0.000]
[TLO:0.000]
```
## $GCode/StartupLines ou $N

- Les lignes de démarrage sont des lignes de gcode qui sont exécutées au démarrage. Il y a (2) lignes que vous pouvez définir. $N0 et $N1. Elles ne doivent être utilisées que pour définir des modes tels que le mode pouce (G21), le mode relatif (G91), le système de coordonnées (G54, etc.). Réglez-les comme suit : $N0=G91. $N seul vous indiquera les valeurs actuelles.

## $GrblNames/List ou $L

- Affiche la liste des commandes ESPxxx et leurs équivalents textuels. Généralement réservé aux développeurs

```
$10 => $Report/Status
$ESP116 => $WiFi/Mode
$ESP100 => $Sta/SSID
$ESP101 => $Sta/Password
$ESP102 => $Sta/IPMode
$ESP105 => $AP/SSID
$ESP106 => $AP/Password
$ESP107 => $AP/IP
$ESP108 => $AP/Channel
$ESP112 => $Hostname
$ => $HTTP/BlockDuringMotion
$ESP120 => $HTTP/Enable
$ESP121 => $HTTP/Port
$ESP130 => $Telnet/Enable
$ESP131 => $Telnet/Port
```

## $GrblSettings/List or $$

- Il s'agit d'une ancienne commande Grbl qui affiche les paramètres $$. Nous ne supportons que $10 dans le style numérique de Grbl.

## $Grbl/Show ou $GS

- FluidNC émet alors la chaîne de démarrage Grbl. Cela peut être nécessaire pour certains expéditeurs.

## $Heap/Show ou $Heap

- Affiche la quantité actuelle d'espace libre et la plus petite quantité d'espace libre pour le tas de mémoire. Cela peut être utile pour déboguer les problèmes de FluidNC.

## $Help ou $

- Liste des commandes de base. C'est pour la compatibilité avec Grbl.

## $Home, $H, ou $H\<xxx\>

- Commandes de repérage. $H 

## $Jog ou $J

- [Utilisé pour le mode spécial ](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Jogging)[Grbl Jog mode](https://github.com/gnea/grbl/wiki/Grbl-v1.1-Jogging).

## $Limits/Show ou $Limits

- Voir cette page.

## $LocalFS/Backup

Écriture des fichiers du système de fichiers local sur la carte SD.

```
$LocalFS/Backup
[MSG:INFO: /localfs/config.yaml -> /sd/localfs/config.yaml]
[MSG:INFO: /localfs/favicon.ico -> /sd/localfs/favicon.ico]
[MSG:INFO: /localfs/index.html.gz -> /sd/localfs/index.html.gz]
[MSG:INFO: /localfs/macro1.g -> /sd/localfs/macro1.g]
[MSG:INFO: /localfs/macrocfg.json -> /sd/localfs/macrocfg.json]
```

## $LocalFS/Delete

- [Voir la page ](https://github.com/bdring/FluidNC/wiki/Local-File-System)[LocalFS](https://github.com/bdring/FluidNC/wiki/Local-File-System)


## $LocalFS/Format

## $LocalFS/List

Affiche les fichiers de la mémoire flash.

```
$LocalFS/List
[FILE: config.yaml|SIZE:0]
[FILE: favicon.ico|SIZE:18450]
[FILE: index.html.gz|SIZE:116654]
[FILE: macro1.g|SIZE:3]
[FILE: macrocfg.json|SIZE:919]
[/littlefs/ Free:44.00 KB Used:148.00 KB Total:192.00 KB]
```
## $LocalFS/ListJSON =path

## $LocalFS/Run

## $LocalFS/Show

Affiche le contenu d'un fichier (similaire à `cat`).

```
$LocalFS/Show=macrocfg.json
[]
 {
  "name": "$MD",
  "glyph": "remove",
  "filename": "/macro1.g",
  "target": "ESP",
  "class": "btn btn-danger",
  "index": 0
 },
 {
  "name": "",
  "glyph": "",
  "filename": "",
  "target": "",
  "class": "",
  "index": 1
 }
]
```
## $LocalFS/Size

```
$LocalFS/Size
LocalFS  Total:192.00 KB Used:148.00 KB
```
## $LocalFS/Hashes

Liste les hachages SHA-256 de tous les fichiers locaux

```
$LocalFS/Hashes
[MSG:INFO: config.yaml: "E899A382F65B179A8FF5898C703A0B78C5C1DA8F5AD5DB343BF751DEFD66E101"]
[MSG:INFO: favicon.ico: "B8B2871A343CA0F9A7A130213226962AD2BE4DFD28D7D8B756C3557569CB876D"]
[MSG:INFO: index.html.gz: "1819A3FE628608006AAFF4D497F96373A88A2B9011D867E0FFB35551CF4EAF13"]
[MSG:INFO: preferences.json: "9E61574525CC8DC3F0766A30A073A230145E8784AEC71B5CA8ED499932D636A3"]
ok
```
## $LocalFS/Rename =path

## $LocalFS/Migrate =path

## $LocalFS/Restore =path

## $Macros/Run ou $RM

- Envoyez [$Macros/Run= ](http://wiki.fluidnc.com/fr/config/macros)pour exécuter la [macro](http://wiki.fluidnc.com/fr/config/macros) définie dans votre fichier de configuration

## $Motor/Disable ou $MD

- Désactive manuellement les moteurs. Cela vous permet de les déplacer manuellement. Vous pouvez également désactiver un seul [axe](http://wiki.fluidnc.com/en/config/axes#idle_ms) avec $MD=. Le(s) moteur(s) se comporte(nt) de la même manière que si le temps [idle_ms :](http://wiki.fluidnc.com/fr/config/axes#idle_ms) avait expiré. Les moteurs seront réactivés lors de la prochaine commande de mouvement.

## $Motor/Enable ou $ME

- **[depuis v3.6.3]** Active manuellement les moteurs. Ceci verrouille les moteurs. Vous pouvez également activer un seul axe avec $ME=\<axis\>. Les moteurs reviendront au réglage idle_ms après le prochain déplacement et le retour au mode idle.

## $Motors/Init ou $MI

- Cette fonction est utilisée pour réinitialiser les moteurs. C'est principalement pour les types SPI et UART. Si vous oubliez de mettre le moteur sous tension au démarrage ou si vous modifiez un paramètre tel que le courant de fonctionnement, vous pouvez envoyer $MI pour réinitialiser les moteurs. Vous pouvez envoyer $MI pour réinitialiser les moteurs.

## $Notification/Send or $ESP600

- Envoie une notification en utilisant [la manière configurée](#notification_type). $ESP600=Texte.

## $Notification/Setup

## $Radio/État

- Obtient ou définit l'état de marche ou d'arrêt de la radio. $Radio/State=On ou Off.

## $Report/Interval ou $RI

- [Contrôles ](http://wiki.fluidnc.com/support/interface/automatic_reporting)[Rapports automatiques](http://wiki.fluidnc.com/support/interface/automatic_reporting) sur le canal d'émission

## $SD/Delete

- [Voir la page ](https://github.com/bdring/FluidNC/wiki/Local-File-System)[LocalFS](https://github.com/bdring/FluidNC/wiki/Local-File-System)

## $SD/List

Liste les fichiers présents sur la carte SD.

```
$SD/List
[DIR:.fseventsd]
[FILE:  fseventsd-uuid|SIZE:36]
[FILE:  00000000096737f7|SIZE:56]
[FILE:  00000000096737f8|SIZE:72]
[DIR:localfs]
[FILE:  config.yaml|SIZE:225]
[FILE:  favicon.ico|SIZE:1150]
[FILE:  index.html.gz|SIZE:116654]
[FILE:  macro1.g|SIZE:3]
[FILE:  macrocfg.json|SIZE:919]
[/sd/ Free:61.90 MB Used:120.50 KB Total:62.01 MB]
```

## $SD/ListJSON

## $SD/Run

## $SD/Show

Affiche le contenu d'un fichier sur la carte SD (similaire à `cat`).


```
$SD/Show=/sd/localfs/macro1.g
$MD
```

## $SD/Rename=current_name\>new_name

Renommer un fichier sur la carte SD.

```
$SD/Rename=foo.gcode>foo.nc
```

## $SD/Status ou $ESP200

## $Files/ListGcode=\<path>

- A utiliser avec les pendentifs et les afficheurs uart. Liste uniquement les fichiers gcode (.g .gc .gco .gcode .nc .ngc .ncc .txt .cnc .tap). La racine de la carte SD est prise en compte à moins que vous n'indiquiez un chemin d'accès. Chaque ligne doit être acquittée par 0xB2.

```gcode
$Files/ListGcode ; Liste tous les fichiers gcode dans le dossier racine de la carte SD
$File/ListGcode=/Folder1 ; Liste tous les fichiers gcode dans le Folder1 de la racine.
$File/ListGcode=/localfs/ ; Liste tous les fichiers gcode dans la racine du fichier local.
```

## $File/ShowHash

```
$File/ShowHash=index.html.gz
[JSON:{"signature":{"algorithm":"SHA2-256","value":"1819A3FE628608006AAFF4D497F96373A88A2B9011D867E0FFB355]
[JSON:51CF4EAF13"},"path":"index.html.gz"}]
```

## $File/SendJSON

## $File/ShowSome=\<lines>,\<path>

- À utiliser avec les pendentifs et les écrans uart. Affiche les lignes d'un fichier. La racine de la carte SD est prise en compte à moins que vous n'indiquiez un chemin. Chaque ligne doit être acquittée avec 0xB2 

```gcode
$File/ShowSome=10,frodo.nc ; afficher les 10 premières lignes
$File/ShowSome=10,20,frodo.nc ; affiche les lignes 10 à 20
```

## $Settings/Erase ou $NVX

- Efface les NVS (paramètres)

## $Settings/List ou $S

- Affiche la valeur de tous les paramètres

## $Settings/ListChanged ou $SC

- Ceci vous montre tous les paramètres NVS qui ont changé par rapport à la valeur par défaut. Vous pouvez l'utiliser pour les sauvegarder si vous prévoyez d'effacer l'ESP32.

## $Settings/Restore ou $RST

- Ceci rétablit les valeurs par défaut.

  - RST=$ rétablit les paramètres
  - RST=# Restaure les décalages du système G54, etc.
  - RST=* Restaure tout ce qui précède.

## $Settings/Stats ou $V

- Ceci vous montre l'état du système NVS (non volatile storage). Il se présente comme suit.

```
[MSG:INFO : NVS Used:191 Free:439 Total:630]
```

## $Sta/Setup ou $ESP103

## $Startup/Show ou $SS

- Cette commande vous permet de voir [les messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages) à tout moment. Si vous n'avez pas de port série connecté au moment du démarrage, il s'agit d'une autre façon de voir ces messages. Fonctionne à partir de l'interface WebUI ou de toute autre interface.

```
[MSG:INFO: FluidNC v3.7,1]
[MSG:INFO: Compiled with ESP32 SDK:v4.4.4]
[MSG:INFO: Local filesystem type is littlefs]
[MSG:INFO: Configuration file:6P_ss_XYZ.yaml]
[MSG:INFO: Machine 6 Pack StepStick XYZ]
...
ok
```
## $State ou $T

- Envoyer $System/Control=RESTART pour redémarrer le processeur

```
$state
State 1 (Alarm)
```

## $System/Control ou $ESP444

- Envoyer $System/Control=RESTART pour redémarrer le processeur

## $System/IP ou $ESP111

## $System/Sleep $SLP

## $System/Stats ou $ESP420

Affiche des informations sur l'état du microcontrôleur et les paramètres FluidNC.

```
$System/Stats
Chip ID: 26773
CPU Cores: 2
CPU Frequency: 240Mhz
CPU Temperature: 57.8°C
Free memory: 109.79 KB
SDK: v4.4.4
Flash Size: 4.00 MB
Sleep mode: Modem
Available Size for update: 1.88 MB
Available Size for LocalFS: 192.00 KB
Web port: 80
Data port: 23
Hostname: fluidnc
Current WiFi Mode: AP (08:3A:F2:22:3B:69)
SSID: FluidNC
Visible: Yes
Radio country set: 01
                      (channels 1-11, max power 20dBm)
Authentication: WPA2-PSK
Max Connections: 4
DHCP Server: Started
IP: 192.168.0.1
Gateway: 192.168.0.1
Mask: 255.255.255.0
Connected channels: 0
Disabled Mode: STA (08:3A:F2:A9:95:68)
Notifications: Disabled
FW version: FluidNC v3.7.11
```

Il est également possible d'obtenir ces informations sous forme d'objet JSON en envoyant la commande `[ESP420]json=yes` qui donnera une réponse comme celle-ci :

```
[JSON:{"cmd":"420","status":"ok","data":[{"id":"Chip ID","value":"30743"},{"id":"CPU Cores","value":"2"},{]
[JSON:"id":"CPU Frequency","value":"240Mhz"},{"id":"CPU Temperature","value":"51.7°C"},{"id":"Free memory]
[JSON:","value":"135.17 KB"},{"id":"SDK","value":"v4.4.7-dirty"},{"id":"Flash Size","value":"4.00 MB"},{"i]
[JSON:d":"Sleep mode","value":"Modem"},{"id":"Available Size for update","value":"1.88 MB"},{"id":"Availab]
[JSON:le Size for LocalFS","value":"192.00 KB"},{"id":"Web port","value":"80"},{"id":"Data port","value":"]
[JSON:23"},{"id":"Hostname","value":"fluidnc"},{"id":"Current WiFi Mode","value":"STA (48:E7:29:A3:17:78)"]
[JSON:},{"id":"Connected to","value":"WifiName"},{"id":"Signal","value":"78%"},{"id":"Phy Mode: ","va]
[JSON:lue":"11n"},{"id":"Channel: ","value":"1"},{"id":"IP Mode: ","value":"DHCP"},{"id":"IP: ","value":"1]
[JSON:92.168.1.30"},{"id":"Gateway: ","value":"192.168.1.1"},{"id":"Mask: ","value":"255.255.255.0"},{"id"]
[JSON::"DNS: ","value":"192.168.1.1"},{"id":"Disabled Mode","value":"AP (48:E7:29:A3:17:79)"},{"id":"FW ve]
[JSON:rsion","value":"FluidNC v3.9.2-pre2"}]}]
ok
```

## $WebUI/Help ou $ESP0

- Donne des informations détaillées sur les commandes de l'interface WebUI.

## $WebUI/Liste $ESP400

## $WebUI/Set ou $ESP401

## $WiFi/ListAPs ou ESP410

  - Ceci montrera tous les points d'accès Wifi que l'ESP32 peut voir avec les forces des signaux.
  
```
$wifi/listaps
{"AP_LIST":[
    {"SSID":"Temp wifi",
      "SIGNAL":"86",
      "IS_PROTECTED":"1"
    },
    {"SSID":"Barts-WLAN",
      "SIGNAL":"62",
      "IS_PROTECTED":"1"
    }
  ]
}
```

## $Xmodem/Receive ou $XR

- [Recevoir un fichier envoyé à FluidNC](http://wiki.fluidnc.com/fr/features/xmodem#sending-a-file-to-fluidnc)

## $Xmodem/Send or $XS

- [Envoyer un fichier depuis FluidNC](http://wiki.fluidnc.com/fr/features/xmodem#downloading-a-file-from-fluidnc)

# Réglages

Les paramètres sont utilisés pour définir les valeurs sauvegardées. La plupart des paramètres sont maintenant dans le fichier de configuration, mais il y en a quelques-uns comme **$Confg/Filename** qui doivent être en dehors du fichier de configuration. Vous pouvez tous les voir avec **\$S**.

## Compatibilité des paramètres de Grbl

 Nous ne prenons en charge que quelques paramètres standard de Grbl $<number>. Nous avons essayé de prendre en charge tous les paramètres susceptibles d'être utilisés dans le cadre d'un fonctionnement normal, comme **$10**. Les paramètres standard de Grbl qui sont utilisés pour configurer une machine ne sont pas pris en charge. En effet, FluidNC dispose de beaucoup plus de paramètres que Grbl.

**Voici une correspondance approximative entre les paramètres de Grbl et ceux de FluidNC.)

- $0 Step Pulse Microseconds ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#stepping))
- $1 Step idle delay, milliseconds ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#stepping))
- $2 Step port invert, mask (set per motor [dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $3 Inversion du port de direction, masque (défini par moteur [dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $4 Step enable invert, boolean (défini par moteur [dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $5 Inversion des broches de limite, booléen (défini par commutateur [dans le fichier de configuration](http://wiki.fluidnc.com/en/config/axes#axes))
- $6 Inversion de la sonde ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/probe))
- $10 Masque de rapport d'état (pris en charge)
- $11 Écart de jonction, mm ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/top_level_config_items#fluidnc-top-level-keys))
- $12 Tolérance de l'arc, mm ([dans le fichier de configuration](http://wiki.fluidnc.com/en/config/top_level_config_items#fluidnc-top-level-keys))
- $13 Rapport pouces, booléen ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/top_level_config_items))
- $20 Soft limits, booléen (peut être défini par axe [dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $21 Hard limits, booléen (peut être défini par moteur [dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $22 Cycle d'orientation ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $23 Inversion de la direction d'orientation 
- $24 Homing Feed ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $25 Homing Seek ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $26 Homing debounce (codé en dur dans le firmware)
- $27 homing pulloff (peut être réglé par moteur [dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $30 Max Spindle ([voir les cartes de vitesse](http://wiki.fluidnc.com/fr/config/spindle_speed_maps), FNC simulera une réponse)
- $31 Min Spindle Speed ([voir les cartes de vitesse](http://wiki.fluidnc.com/fr/config/spindle_speed_maps), FNC will fake a response) 
- $32 Laser Mode ([utiliser une broche laser](http://wiki.fluidnc.com/fr/config/config_spindles), le FNC simulera une réponse)
- $100-$102 Steps/mm ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $110-$112 Max Rates ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $120-$122 Accélérations ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
- $130-$132 Déplacements maximaux ([dans le fichier de configuration](http://wiki.fluidnc.com/fr/config/axes#axes))
  
## Comment les utiliser

Vous définissez la valeur en définissant une valeur comme ceci `$Config/Filename=test.yaml`. Vous pouvez voir la valeur actuelle en envoyant simplement le nom du paramètre comme `$Config/Filename`. Si vous n'envoyez qu'une partie du nom du paramètre comme `$STA`, tous les paramètres avec STA dans le nom seront affichés avec leurs valeurs actuelles.

Les paramètres ont différents types comme integer, float, String et Enum. Enum est une liste de valeurs. Vous pouvez voir le type valide en envoyant quelque chose comme `$Wifi/Mode=*`. Il répondra avec les valeurs valides **[MSG:INFO : Valid options : Off AP STA STA>AP]**.

La liste des paramètres varie selon que votre micrologiciel a été compilé pour le WiFi ou le Bluetooth. Vous trouverez ci-dessous une liste de tous les paramètres.

## $Start/Message

**[depuis v3.4.8]** Ceci définit le message de départ. Certains expéditeurs de Grbl Gcode attendent une valeur et une révision très spécifiques, ce qui vous permet de définir ce que vous voulez.

Accepte ces séquences de substitution :

\V - se développe en informations sur la version comme : 3.4
\B - se développe en informations de compilation comme : v3.4.6 (Devt-827770e-dirty)
\R - affiche des informations sur la radio comme : wifi
\H - se développe en : '' pour l'aide
  
La valeur par défaut est : Grbl \V [FluidNC \B (\R) \H] pour **Grbl 3.4 [FluidNC v3.4.8 (wifi) '' pour l'aide]**.

Start/Message=Grbl 1.1g [\H] donnerait \**Grbl 1.1g ['' pour l'aide]**

## $Firmware/Build

Informations supplémentaires pour le rapport [VER : ... :] émis en réponse à $I. La valeur par défaut est la chaîne vide, donc rien ne sera ajouté après le dernier : dans le rapport [VER : ... :]. Si vous définissez $Firmware/Build à « test », le rapport dira [VER : ... :test]

## $Report/Status

Contrôle le format des rapports d'état émis en réponse à «  ? ». C'est la même chose que le paramètre $10 du GRBL. Les valeurs sont les suivantes

**0** - Rapport sur les positions en coordonnées de travail, sans état de la mémoire tampon
**1** - Rapport sur les positions en coordonnées machine, sans état de la mémoire tampon
**2** - Déclarer les positions en coordonnées de travail, avec état de la mémoire tampon
**3** - Déclarer les positions en coordonnées machine, avec état tampon

## $Config/Filename

Ceci définit le nom du fichier à charger pour la configuration.

## $Message/Niveau

Ceci définit le niveau d'information qui est rapporté. Le niveau par défaut est **Info**. Les niveaux valides sont **None**, **Error**, **Warning**, **Info**, **Debug** et **Verbose**. **Debug** peut être utilisé pour donner des informations supplémentaires lors de la résolution de problèmes. Il est préférable d'utiliser **Info** pour un fonctionnement normal.

```
$Message/Level=Debug
$HX
[MSG:DBG: Homing Cycle X]
[MSG:DBG: Homing nextPhase FastApproach]
...
```
  
## $Notification/Type

Les types valides sont les suivants

- **NONE** - aucune notification ne sera envoyée

- **EMAIL** - la notification sera envoyée par courrier électronique

- **LIGNE**

- **PUSHOVER** - LA NOTIFICATION SERA ENVOYÉE SOUS FORME D'E-MAIL

## $Notification/T1

Dans le cas d'une notification par courrier électronique, il existe un nom de connexion pour le serveur smtp.

## $Notification/T2

Dans le cas d'une notification par courrier électronique, il existe un mot de passe pour le serveur smtp.

## $Notification/TS

 Dans le cas des notifications par courrier électronique, il y a une adresse électronique, une adresse de serveur SMTP et un port au format `email_address#smtp_server:port`. L'adresse électronique est utilisée à la fois pour l'expéditeur et le destinataire.

Par exemple, pour envoyer une notification par courriel à [fluidnc@fluidnc.com](mailto:fluidnc@fluidnc.com) en utilisant [brevo.com](http://brevo.com/), veuillez entrer ici :
`fluidnc@fluidnc.com#smtp-relay.brevo.com:465`

Si l'envoi de notifications ne fonctionne pas, essayez d'entrer l'adresse IP du serveur smtp au lieu de son nom. Pour l'envoi via [brevo.com](http://brevo.com/), vous devez entrer :
`fluidnc@fluidnc.com#1.179.115.1:465`
  
## $Telnet/Enable

True pour activer les connexions via TCP sur le port 23

## $HTTP/Enable

True pour activer les connexions HTTP sur le port donné par $HTTP/Port

## $HTTP/Port

Numéro de port pour les connexions HTTP, par défaut 80

## $HTTP/BlockDuringMotion

**[depuis v3.6.8]** Empêche de servir des fichiers depuis LocalFS lorsque la machine est en cours d'exécution

## $WiFi/Mode

La valeur est l'une des suivantes

- **Off** - Radio WiFi désactivée

- **STA** - Mode station (connecté à un point d'accès externe)

- **AP** - ESP32 est le point d'accès (à utiliser uniquement pour la configuration initiale ; non recommandé pour une utilisation en production)

- **STA>AP** - Essayer le mode station mais revenir au mode AP en cas d'échec.
  
## $WiFi/FastScan

## $Wifi/PsMode

Ceci définit le mode d'économie d'énergie du WiFi. Les options sont `None`, `Max` et `Min`. La valeur par défaut est `None` et est recommandée pour la plupart des gens à moins qu'il n'y ait des problèmes de surchauffe. [Les détails sur les modes sont ici](https://docs.espressif.com/projects/esp-idf/en/stable/esp32/api-guides/wifi.html#esp32-wi-fi-power-saving-mode). Demandez plus de détails sur les forums ESP32. Nous ne sommes pas des experts en la matière.

## $Sta/SSID

SSID du point d'accès externe pour le mode STA. [Voir ceci concernant l'utilisation de caractères non ascii comme les accents](http://wiki.fluidnc.com/en/support/faq#international-characters-in-wifi-ssids).

## $Sta/Mot de passe

Mot de passe du point d'accès externe pour le mode STA. [Voir ceci concernant l'utilisation de caractères non-ascii comme les accents](http://wiki.fluidnc.com/en/support/faq#international-characters-in-wifi-ssids).
  
## $Sta/IPMode

**DHCP** ou **Statique**

## $Sta/IP

Si $Sta/IPMode est **Static**, l'adresse IP à utiliser pour FluidNC

## $Sta/Passerelle

Si $Sta/IPMode est **Static**, l'adresse IP pour la passerelle

## $Sta/Netmask

Si $Sta/IPMode est **Static**, le masque de sous-réseau (typiquement 255.255.255.0)

## $AP/SSID

L'adresse IP à utiliser pour le mode AP (par défaut « FluidNC »)

## $AP/Mot de passe

Le mot de passe pour le mode AP (par défaut « 12345678 »)

## $AP/IP

L'adresse IP à utiliser pour le mode AP (par défaut 192.168.0.1)
  
## $AP/Pays

**[depuis v3.6.7]** Le domaine de régulation configuré pour l'AP. Affecte les canaux disponibles et la puissance d'émission maximale.

## $Hostname

Le nom d'hôte de cette instance FluidNC (par défaut « FluidNC »). Affecte l'accès via un nom MDNS tel que « fluidnc.local ».

## $Bluetooth/Nom

Le nom de cette instance FluidNC pour l'analyse Bluetooth (par défaut « FluidNC »).

## $SD/FallbackCS

# Commandes en temps réel

Les commandes en temps réel peuvent être envoyées à tout moment. Elles sont traitées immédiatement et ne sont pas placées dans le tampon des commandes. 

Si vous devez envoyer un caractère de commande en temps réel dans le cadre d'une autre commande (par exemple lors de la définition d'un mot de passe Wifi), vous devez l'encoder à l'aide d'un encodage URL. Pour tester l'encodage, vous pouvez utiliser https://www.urlencoder.org/.

## Commandes ASCII en temps réel 
  
Il existe 4 commandes ASCII qui peuvent être envoyées à partir du clavier.

  - `0x18` (CTRL+X) **Réinitialisation douce**
    - Arrête immédiatement et réinitialise Grbl en toute sécurité sans cycle d'alimentation.
    - Si la réinitialisation a lieu en cours de mouvement, Grbl déclenche une alarme pour indiquer que la position peut être perdue à la suite de l'arrêt du mouvement.
    - Si la réinitialisation a lieu à l'arrêt, la position est conservée et le repositionnement n'est pas nécessaire.
    - En mode maintien, le tampon de mouvement est effacé et la position n'est pas perdue.
    - Une broche de contrôle peut être utilisée pour cette fonction.
  - `?` **Interrogation sur l'état**
  - `!` **Maintien de l'alimentation**
    - Place le Grbl dans un état de suspension ou de maintien (HOLD). Si la machine est en mouvement, elle décélère jusqu'à l'arrêt, puis est suspendue.
    - La commande s'exécute lorsque le Grbl est dans un état IDLE, RUN ou JOG. Dans le cas contraire, elle est ignorée.
- En cas de jogging, une mise en attente de l'alimentation annule le mouvement de jogging et efface tous les mouvements de jogging restants dans la mémoire tampon du planificateur. L'état passe de JOG à IDLE ou DOOR, s'il a été détecté comme étant entrouvert pendant le maintien actif.
    - Une mise en attente de l'avance ne désactive pas la broche ou le liquide de refroidissement. Seulement le mouvement.
    - Une broche de contrôle peut être utilisée pour cette fonction.
  - `~` **Démarrage / Reprise du cycle**
    - Reprend un maintien d'alimentation, un état de porte de sécurité/stationnement lorsque la porte est fermée, et les états de pause du programme M0.
    - Si l'option de compilation parking est activée et que l'état de la porte de sécurité est prêt à reprendre, Grbl réactive la broche et le liquide de refroidissement, se remet en position, puis reprend.
    - Une broche de contrôle peut être utilisée pour cette fonction.
  
## Commandes ASCII étendues en temps réel

  - `0x84` **Porte de sécurité**
      - Cette commande déclenche la fonction de porte de sécurité. Elle fonctionne comme la [fonction d'interrupteur de contrôle](/config/control#safety_door_pin)
  - `0x85` **Jog Cancel** (Annuler le Jog)
    - Annule immédiatement l'état de jogging en cours par une mise en attente de l'avance et en effaçant automatiquement toutes les commandes de jogging restantes dans la mémoire tampon.
    - La commande est ignorée si elle n'est pas dans un état JOG ou si l'annulation de jogging est déjà invoquée et en cours de traitement.
    - Grbl retournera à l'état IDLE ou à l'état DOOR, si la porte de sécurité a été détectée comme entrouverte pendant l'annulation.
  - **Overrides** [Voir cette page](http://wiki.fluidnc.com/fr/features/speed_feed_overrides) pour les commandes en temps réel liées aux commandes d'annulation.
  
  
  

  

  



















































