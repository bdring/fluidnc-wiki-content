---
title: 1.20 Résolution des problèmes liés au fichier de configuration
description: 
published: true
date: 2025-03-30T15:20:13.503Z
tags: fr
editor: markdown
dateCreated: 2025-03-18T18:40:18.156Z
---

# Dépannage des problèmes liés aux fichiers de configuration

## Désolé que vous soyez ici

Nous savons que la création de votre premier fichier de configuration fonctionnel peut être frustrante. Nous essayons continuellement de rendre les choses plus faciles. Nous voulons que les messages d'erreur soient plus utiles. Nous étudions également la possibilité d'un éditeur et d'un validateur en ligne. Vos commentaires nous sont utiles. Si vous pensez que quelque chose pourrait améliorer notre documentation, n'hésitez pas à nous le faire savoir.

## Édition du fichier

Vous devriez éditer avec une police de largeur fixe, afin de pouvoir voir l'alignement. Il est utile d'avoir un éditeur qui code les couleurs du fichier de configuration. Certains permettent même de réduire les niveaux. Voici quelques éditeurs qui sont bons.

- VS Code
- Bloc-notes++ 

En cas de problème, recherchez les déclarations de type [MSG ERR...] dans les [messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages). 

Certaines erreurs peuvent entraîner un plantage ou un redémarrage. Recherchez les messages précédant le plantage. 

## Vérifier les messages de démarrage

Le fichier de configuration est lu au démarrage. S'il y a des erreurs ou des avertissements, ils seront affichés sur le port série avec les lignes **MSG:ERR** ou **MSG:WARN**.

[FluidTerm](http://wiki.fluidnc.com/fr/fluidterm/fluidterm_usage) affiche automatiquement les messages de démarrage à chaque redémarrage du contrôleur FluidNC et met en évidence les problèmes dans une couleur différente.  D'autres interfaces utilisateur peuvent ou non afficher automatiquement les messages de démarrage.  Par exemple, l'interface WebUI ne les affiche pas parce qu'elle ne peut pas se connecter avant que les messages de démarrage n'aient été envoyés.  Vous pouvez contourner ce problème en envoyant la commande `$SS` dans le panneau de commande de WebUI, ou dans la console de n'importe quel autre programme de l'interface utilisateur.  D'autres interfaces utilisateur peuvent ne pas mettre en évidence les problèmes avec des couleurs différentes, vous devez donc rechercher attentivement les préfixes **MSG:ERR** ou **MSG:WARN**.

Voici un exemple sans problème.

![fluidterm.png](/support/fluidterm.png =x450)

## Impossible d'ouvrir le fichier de configuration

Si vous obtenez un message comme celui-ci (le nom du fichier peut être différent)...

```
[MSG:WARN: Cannot open configuration file: config.yaml]

```

FluidNC ne peut pas ouvrir le fichier de configuration. Le nom du fichier est défini avec `$Config/Filename=<votrefichier>`. Si vous ne l'avez pas défini, `config.yaml` est utilisé comme nom de fichier par défaut. Le problème le plus probable est qu'il ne trouve pas le fichier sur l'ESP32. 

Aucun fichier de configuration n'est installé pendant le processus d'installation du micrologiciel. Vous devez en télécharger un vous-même. **Note:** Si le firmware a été pré-installé sur votre contrôleur, un fichier de configuration peut avoir été installé. Vous pouvez lister tous les fichiers sur le contrôleur avec `$LocalFS/List`.

Liste de contrôle...

  - Assurez-vous d'avoir mis `$Config/Filename=<votrefichier>` à votre nom de fichier.
  - Vérifiez que le fichier est présent sur votre système de fichiers local avec `$LocalFS/List`
  - Vous pouvez vérifier que le fichier a un contenu correct et non corrompu avec `$LocalFS/Show=<votrefichier>`

> Soyez prudent lors de la mise à jour du micrologiciel. Si vous effectuez une installation complète, tous les fichiers seront effacés. Suivez les instructions pour ne mettre à jour que le micrologiciel.
{.is-info}

## Commencer par les premières erreurs signalées

Un problème avec une clé peut faire apparaître les clés suivantes comme mauvaises. La correction de la première erreur peut en corriger d'autres.

Exemple d'erreurs multiples causées par une clé mal placée.

```yaml
name: "TMC2209 XY Servo Laser"
board: "FluidNC Pen/Laser 2209 V2"

# bad indenting
  stepping:
  engine: RMT
  idle_ms: 255
``` 

Ces erreurs se produiront

```
[MSG:WARN: Ignored key stepping]]
[MSG:WARN: Ignored key engine]]
[MSG:WARN: Ignored key idle_ms]]
```

Dans ce cas, `stepping` est indenté alors qu'il ne devrait pas l'être. Le fichier dit que `stepping:` appartient à l'élément sous lequel il est indenté, qui est `board:`. `board:` n'a pas de clé appelée `stepping:`, donc la clé est ignorée.

puisque `stepping:` est erroné, `engine:` semble aussi être sous `board:`. La correction de stepping corrigera les 2 autres erreurs. 

## Touches ignorées

Si vous voyez des touches ignorées, il ne peut y avoir que 2 raisons


1. La clé n'existe pas. Recherchez dans le wiki le nom de la clé indiqué dans les messages. Vérifiez l'orthographe. 
2. La clé n'est pas valide pour l'élément sous lequel elle est indentée.

```
[MSG:ERR: Ignored key badkey]
[MSG:ERR: Ignored key pulloff_mm]
```

- **badkey** n'est pas une clé valide dans la section analysée
- **pulloff_ms** est une clé valide mais pas à l'endroit où elle a été trouvée dans le fichier

## Questions d'indentation

```yaml
item: value

group:
  item: value
  group:
    item0: value
    item1: value
```

L'animation ci-dessous montre comment l'indentation modifie la structure. Un élément peut se trouver au niveau de la racine, être un sous-élément du groupe ou avoir ses propres sous-éléments. Le niveau d'indentation est extrêmement important. L'utilisation d'un éditeur qui met en évidence l'indentation (Notepad++ illustré) peut s'avérer très utile. 

![indenting.gif](/config/indenting.gif =x160)

La hiérarchie du fichier de configuration représente la hiérarchie de la machine. Il y a des éléments ou des groupes d'éléments. Chaque groupe peut être composé de plusieurs éléments et sous-groupes. Ceci est indiqué par l'indentation. Les éléments en retrait sous un nom de groupe appartiennent à ce groupe. Si la mise en retrait est incorrecte, les éléments ne seront pas appliqués au bon groupe. Lorsque vous voyez des erreurs ou des avertissements concernant la mise en retrait, corrigez-les dans l'ordre où ils apparaissent dans les [messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages). Si une erreur se produit au début, elle peut causer beaucoup de problèmes par la suite, car une grande partie de la hiérarchie peut être brisée par un seul problème.

N'utilisez que des espaces pour l'indentation. N'utilisez pas de tabulations.

Si vous voyez quelque chose comme ceci dans vos [messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages).

```
[MSG:ERR : Skipping key motor0 indent 5 this Indent 4]
```

Ceci vous indique qu'il y a une touche `motor0` à l'indentation 5 et que l'indentation actuelle est de 4. Regardez toutes les touches `motor0` pour en trouver une à l'indentation 5 (5 espaces). Elle est probablement au mauvais niveau d'indentation.

## Message/Niveau

Vous pouvez modifier le niveau de notification des messages. Le niveau par défaut est « Info ». Si vous le changez en « Debug » avec $Message/Level=Debug, vous verrez beaucoup plus de messages. Il ne s'agit pas d'erreurs, mais ils peuvent vous aider à déterminer la cause du problème. Remarque : il y en aura des centaines.

```
[MSG:DBG: Setting up pin gpio.25:high]
[MSG:DBG: Attempting to set up pin: gpio index 25]
[MSG:DBG: Setting up pin gpio.35:low]
[MSG:DBG: Attempting to set up pin: gpio index 35]
```

## Voir l'état de la broche

Utilisez la commande [`$GPIO/Dump` ou `$GD`](http://wiki.fluidnc.com/fr/features/commands_and_settings#gpiodump) pour visualiser l'état des broches d'entrée/sortie. `I0` signifie que la broche est configurée comme une broche d'entrée avec une lecture basse (ou logique 0), tandis que `I1` signifie que la broche a une lecture haute (ou logique 1). `O0` signifie que la broche est configurée comme une sortie en lecture basse (ou logique 0), tandis que `O1` signifie que la broche est en lecture haute (ou logique 1). Vous devrez peut-être exécuter la commande `$GD` plusieurs fois pour lire l'état de toutes les broches.

```
$GD
0 GPIO0 I1
1 U0TXD
2 GPIO2 O0 ledc_hs_sig_out2
3 U0RXD
4 GPIO4 O1 I1 U2TXD_out
5 GPIO5 O1
6 SPICLK
7 GPIO7 O0 I0 SPIQ_out
8 GPIO8 O0 I0 SPID_out
9 GPIO9 O0 I1 SPIHD_out
10 GPIO10 O0 I0 SPIWP_out
11 GPIO11 O0 I1 SPICS0_out
12 MTDI
13 GPIO13 I1
14 MTMS
15 GPIO15 O0 ledc_hs_sig_out0
16 GPIO16 I1
17 GPIO17 I1
18 GPIO18 O0 I0 HSPICLK_out
23 GPIO23 O0 I0 HSPID_out
25 GPIO25 O0 I2S0O_BCK_out
26 GPIO26 O1 I2S0O_WS_out
27 GPIO27 O0 I2S0O_DATA_out23
32 GPIO32 I1
33 GPIO33 I1
34 GPIO34 I0
35 GPIO35 I1
36 GPIO36 I1
4 SPIWP_in 10
8 HSPICLK_in 18
9 HSPIQ_in 19
ok
```

## Limité à la plage

Si vous obtenez un message comme celui-ci...

```
[MSG:WARN : frequency_hz value 0 constrained to range (1000000,20000000)]
```

Cela signifie que la valeur que vous avez pour l'élément de configuration n'est pas dans la plage numérique valide pour cet élément de configuration. Dans ce cas, la plage est de 1000000 à 20000000 et vous avez 0. Si vous affichez la configuration actuelle avec `$CD`, elle affichera une valeur de 1000000. Mettez à jour votre fichier de configuration pour vous débarrasser de ce message.

## Voir le fichier de configuration sur l'ESP32

Utilisez la commande **\$localfs/Show=\<filename\>** pour visualiser le fichier. Le nom du fichier utilisé pour la configuration est indiqué dans les messages de démarrage. Vous pouvez également l'obtenir avec la commande **$Config/Filename**.

Vous pouvez également voir la configuration actuelle avec la commande **\$Config/Dump**. Cette commande sera probablement un peu différente du fichier. Elle vide les éléments de configuration dans l'ordre dans lequel ils sont stockés en interne et peut afficher certains éléments de configuration par défaut/valeurs d'éléments qui ne sont pas dans votre fichier.   

## Pin est déjà utilisé

Chaque code ne peut être utilisé qu'une seule fois. Recherchez le pin dans le fichier.

## Problèmes majeurs

Si le problème est vraiment grave, le firmware chargera une configuration par défaut. Celle-ci ne peut pas être utilisée pour contrôler votre machine, mais vous devriez toujours être en mesure de voir le réseau et l'interface WebUI pour vous aider à résoudre les problèmes.

## Reboots

Si des erreurs critiques surviennent lors du traitement du fichier de configuration, FluidNC forcera un redémarrage et reviendra à une configuration rudimentaire « sûre », de sorte que vous pourrez utiliser le fichier de configuration.

de pouvoir interagir avec le système pour résoudre les problèmes. Remarque : D'autres bogues, etc., qui provoquent un redémarrage peuvent accidentellement déclencher le chargement par Fluid d'une configuration sûre.

Les erreurs critiques se produisent généralement lorsque vous avez une clé correcte, mais que la valeur de cette clé n'est pas valide. 

Examinez les données du port série pour trouver des indices sur ce qui s'est passé.

```
[MSG:ERR: Configuration parse error: Expected a float value like 123.456 @ 1:8 near : 1.000foo]
Guru Meditation Error: Core  1 panic'ed (LoadProhibited). Exception was unhandled.
Core 1 register dump:
PC      : 0x400f710c  PS      : 0x00060f30  A0      : 0x800da284  A1      : 0x3ffb1f20
A2      : 0x3ffc1a64  A3      : 0x3f4044f0  A4      : 0x3ffb30f4  A5      : 0x00000000
...
```

Cela montre qu'une valeur flottante était attendue, mais qu'elle a été lue **1.000foo**. Recherchez cette valeur dans votre fichier de configuration et corrigez-la. Les espaces à la fin peuvent également provoquer des erreurs.

Veillez à consulter le reste des [messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages), bien au-dessus du point d'arrêt. Vous pouvez voir des messages [MSG:ERR...] concernant d'autres éléments qui pourraient contribuer au plantage. Il peut également y avoir des erreurs dans votre fichier de configuration qui ne forcent pas une réinitialisation, mais qui doivent être corrigées avant que vous puissiez utiliser la fonctionnalité concernée.

## Demander de l'aide

Si les informations contenues dans cette page ne vous ont pas aidé à résoudre votre problème, vous pouvez demander de l'aide sur [Discord](https://discord.gg/FeNc6teAzy) ou sur [Github issues](https://github.com/bdring/FluidNC/issues). Veuillez fournir toutes les informations ci-dessous.

- Une copie de vos [messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages).
- Votre fichier de configuration.


