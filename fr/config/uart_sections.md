---
title: 1.6  UART Sections
description: configuration UART
published: true
date: 2026-08-01T19:41:21.164Z
tags: fr
editor: markdown
dateCreated: 2025-03-15T16:19:58.696Z
---

# Sections UART

Vous pouvez définir des sections UART au niveau supérieur du fichier de configuration et y faire référence là où elles sont utilisées :


```yaml
uart1:
  txd_pin: gpio.0
  rxd_pin: gpio.4
  rts_pin: gpio.13
  baud: 115200
  mode: 8N1

uart2:
  txd_pin: gpio.22
  rxd_pin: gpio.21
  baud: 115200
  mode: 8N1
```

## uart0

uart0 is the USB serial console one; you cannot define or change it because it is so important for startup messaging.

## Other uarts

Within a Spindle class, you can still use the old syntax where there is a subordinate "uart:" subsection, or, alternatively, you can refer to an externally-defined uart section with:

```yaml
NowForever:
  uart_num: 1
  modbus_id: 1
```

Les périphériques UART Trinamic comme le TMC2208 et le TMC2209 ne supportent plus la sous-section subordonnée « uart : » (la faire fonctionner était tout simplement trop difficile) ; vous devez utiliser la section UART externe avec « uart_num : N » :

```yaml
axes:
  x:
    motor0:
      tmc_2209:
        uart_num: 2
        addr: 2
      ... 

  z:
    motor0:
      tmc_2209:
        uart_num: 2
        addr: 1
        ...        
```

Avec ce schéma, il devrait être possible d'utiliser, par exemple, 5 dispositifs TMC UART en utilisant deux UART, ce qui permet de contourner la limitation à 4 adresses de dispositifs.

Dynamixel2 est comme Trinamic ; vous devez utiliser « uart_num : N » :

```yaml
axes:
  x:
    motor0:
      dynamixel2:
        uart_num: 1
        id: 3
```
Le pilote Dynamixel, tel qu'il est écrit actuellement, ne peut utiliser qu'un seul UART pour tous les Dynamixels.

# Canaux UART

Les canaux UART créent une nouvelle interface Grbl sur un UART. Cette interface est conçue pour les écrans, les pendentifs et les contrôleurs externes. Elle peut utiliser un intervalle de rapport afin que le client n'ait pas besoin d'interroger l'état. Vous obtiendrez une mise à jour rapide de l'état en cas de changement majeur et des mises à jour régulières lorsque les axes se déplacent.

Nous disposons de [code de démarrage](https://github.com/bdring/PendantsForFluidNC) si vous souhaitez créer votre propre affichage ou interface.

```yaml
uart_channel1:
   uart_num: 2
   report_interval_ms: 75
   message_level: info
```

- <a id="uart_num"></a>**uart_num:**
  - Type : [Integer](http://wiki.fluidnc.com/fr/config/overview#integer)
  - Portée : Voir détails
  - Valeur par défaut : 0
  - Détails : Ceci le connecte à une section uart précédemment définie.

<a id="report_interval_ms"></a>**report_interval_ms:**
  - Type : [Integer](/config/overview#integer)
  - Plage de valeurs : 50 - 5000 (millisecondes)
  - Valeur par défaut : 0
  - Détails : Cette fonction définit l'intervalle de rapport pendant le mouvement. Il est généralement utilisé pour mettre à jour les compteurs numériques. Si vous le mettez à zéro, il sera désactivé. Idéalement, il devrait être égal à 0 ou à 50-5000 pour éviter de surcharger le processeur.

- <a id="message_level"></a>**message_level:**
  - Type : [Énumération](http://wiki.fluidnc.com/fr/config/overview#integer#enum) 
  - Plage de valeurs : None|Error|Warn|Info|Debug|Verbose
  - Valeur par défaut : Verbose
  - Détails : Cette fonction permet de limiter les messages qui seront envoyés à ce canal. Cette fonction est utile pour les afficheurs et les pendentifs qui n'ont pas besoin des messages et qui préfèrent ne pas avoir à les traiter.  Seuls les messages dont le niveau est inférieur ou égal à la valeur choisie seront envoyés au canal.  La valeur de configuration globale **\$Message/Level** s'applique également, limitant les messages à tous les canaux.  L'élément **message_level** spécifique au canal est une restriction supplémentaire, de sorte que seuls les messages dont le niveau est inférieur ou égal à la valeur la plus faible entre **\$Message/Level** et **message_level** seront envoyés à ce canal.

Le nouveau canal acceptera des entrées tout comme le canal série USB, les canaux telnet, les canaux websocket, etc.

Vous pouvez également utiliser uart_channel1 ou uart_channel2. uart_channel0 est le canal série USB implicite et est toujours activé par défaut.

Il n'y a que trois UART physiques sur l'ESP32, donc si vous essayez d'en faire trop, vous serez à court d'UART.  Si vous utilisez un UART pour une broche VFD et un autre pour les pilotes TMC, vous ne pouvez pas créer un autre uart_channel .  Les UART ne peuvent être partagés qu'entre des appareils similaires, comme plusieurs pilotes TMC ou plusieurs broches VFD modbus.

## Rapport automatique

[Voir cette page](http://wiki.fluidnc.com/fr/support/interface/automatic_reporting)

# Proposition de caractéristique (E/S de canal)

> Rien de tout cela ne figure dans les microprogrammes publiés. Voir la discussion [ici](https://discord.com/channels/780079161460916227/1156578797987045488). Cette section de la page wiki ne fait que rassembler les informations de la discussion sur Discord.
{.is-info}

## Aperçu

Ceci couvre les moyens d'ajouter des E/S sur un canal UART. Par exemple, un MCU avec des entrées (commutateurs, etc.) et des sorties pourrait être connecté via UART : Un MCU avec des entrées (interrupteurs, etc.) et des sorties pourrait être connecté via UART. Cela pourrait être utilisé par les expéditeurs, l'interface WebUI ou les websockets. 

## Rapports d'état des broches d'entrée

Lorsqu'une broche d'entrée change d'état, ou immédiatement après l'initialisation de la broche, la nouvelle valeur est signalée par une séquence de deux caractères qui codent le numéro de la broche et son état.  La séquence est la suivante :

Pour les broches inactives, le premier caractère est 0xc4 et le second est 0x80+numéro de broche.  Pour les broches actives, le premier caractère est 0xc5 et le second 0x80+numéro_broche.

(Ce codage est une représentation UTF8 de 0x100+nombre_de_broches pour les broches inactives et de 0x140+nombre_de_broches pour les broches actives).

## Commandes

Les commandes suivantes sont actuellement définies.  Un IO Expander doit soit ignorer les commandes qu'il ne reconnaît pas, soit, si l'expandeur implémente le passthrough série, les transmettre au port passthrough.

### Commande INI

La commande INI initialise une broche et définit ses caractéristiques.  Le paramètre de **INI:** est **pin_spec=key,key,...**, les valeurs des clés étant celles décrites.  Si le pin peut être initialisé avec les caractéristiques données, l'expandeur doit répondre par **Expander_ACK** ; sinon il doit répondre par **Expander_NAK**.  Après l'ACK ou le NAK, si la broche est une entrée, l'extenseur doit envoyer un rapport de valeur de broche avec la valeur actuelle de la broche.


Le format de la commande INI est **[INI:<pin_spec>=<pin_type>\<attributes\>]**.
**<pin_spec>** est le nom d'une broche sous la forme **io.N**, où **N** est un nombre compris entre 0 et 63.
**<pin_type>** est l'un de **in**, **out**, ou **pwm**
**<attributes\>** est zéro ou plusieurs valeurs de la liste ci-dessous, chacune précédée d'une virgule.  L'ordre des attributs n'a pas d'importance.

- Niveau actif - **low, high** (par défaut : high) - s'applique à toutes les broches
- Contrôle pullup - **pu, pd** (par défaut : no pull resistor) - s'applique aux broches d'entrée
- Fréquence PWM - **hz:N** (par défaut : 5000) - s'applique aux broches PWM

Par exemple :

```
[INI: io.1=in,low,pu]        ; Initialize io1 as an input with pullup, active low
[INI: io.2=out]              ; Initialize io2 as an output, active high (default)
[INI: io.3=pwm,hz:5000,low]  ; Initialize io3 as pwm at 5000 Hz, active low

```

Les commandes INI transmises par FluidNC à l'expandeur sont acquittées par **Expander_ACK**(0xB2) si la commande a réussi ou **Expander_NAK** (0xB3) si la commande a échoué.  L'absence d'initialisation 

### Séquence de codes d'octets SET

De la même manière que pour les rapports d'état des broches d'entrée, l'état d'une broche de sortie ou d'une broche PWM peut être défini à l'aide d'une courte séquence de code UTF-8.  Alors que les rapports d'entrée vont de l'expandeur à FluidNC, les séquences SET vont dans la direction opposée, de FluidNC à l'expandeur. Pour les broches de sortie ordinaires à deux états, la séquence **0xC4, 0x80+numéro de broche** met une broche à l'état inactif, tandis que **0xC5, 0x80+numéro de broche** la met à l'état actif.  C'est l'encodage UTF-8 des nombres `0x100+numéro_pin` pour l'état inactif, `0x140+numéro_pin` pour l'état actif.

Le réglage du rapport cyclique d'une broche PWM nécessite une séquence plus longue pour tenir compte non seulement des 6 bits du numéro de la broche, mais aussi des bits supplémentaires pour le rapport cyclique.  Le rapport cyclique est représenté par un nombre de 0 à 1000 inclus, où 0 est toujours inactif, 1000 est toujours actif, et les valeurs intermédiaires représentent des rapports cycliques proportionnels.  L'encodage est la représentation UTF-8 du nombre `0x10000 + pin_number * 0x400 + duty_cycle` qui est une séquence de 4 octets.  En binaire, c'est `1ppppdddddddddd` où `p` est un bit de numéro de pin et `d` est un bit de cycle de travail.  La séquence d'octets selon les règles d'encodage UTF-8 est, en binaire, `11110000 1001pppp 10ppdddd 10dddddd`.  En hexadécimal, c'est `0xf0, 0x90+(pin_num>>2), 0x80+((pin_num&3)<<4)+(duty_cycle>>6), 0x80+(duty_cycle&0x3f)`.  Une routine d'encodage UTF-8 générerait la séquence avec `utf8_encode(0x10000 + (pin_number << 10) + duty_cycle)`.

La représentation du cycle de service sur 10 bits code directement les pourcentages à un point décimal de 0,0 % à 100,0 %.

Une séquence SET qui réussit n'est pas acquittée.  Un SET qui échoue (en raison, par exemple, d'un numéro de broche qui n'est pas initialisé) répond par **Expander_NAK** (0xB3).

### Expander Startup

Lorsque l'Expander démarre, il envoie **Expander_RST** (0xB4) à FluidNC.  Si FluidNC reçoit **Expander_RST** alors qu'il a déjà configuré l'Expander (en envoyant des commandes INI), FluidNC doit supposer que l'Expander s'est planté et qu'il ne traitera plus les séquences SET ou n'enverra plus de rapports sur l'état des broches d'entrée, et FluidNC doit donc entrer en état d'alarme avec le code Allarm « ExpanderReset ».  Si l'expandeur et FluidNC démarrent simultanément, par exemple s'ils sont alimentés en même temps, il est probable que l'expandeur démarre beaucoup plus rapidement que FluidNC et que FluidNC ne voit pas le **Expander_RST** parce que le canal uart correspondant n'est pas encore prêt à recevoir des caractères.  C'est un comportement correct, car FluidNC ne doit s'alarmer que s'il voit **Expander_RST** après que FluidNC a configuré l'expandeur.

### Exemple de configuration (partiel)

```yaml
# For 6x Controller
uart1:
  txd_pin: gpio.27
  rxd_pin: gpio.25
  baud: 921600
  mode: 8N1

uart_channel1:
  report_interval_ms: 75
  uart_num: 1

user_outputs:
  digital0_pin: uart_channel1.0
  digital1_pin: uart_channel1.1
  digital2_pin: uart_channel1.2
  digital3_pin: uart_channel1.3
  digital4_pin: uart_channel1.4
  digital5_pin: uart_channel1.5
  digital6_pin: uart_channel1.6
  digital7_pin: uart_channel1.7

coolant:
  mist_pin: uart_channel1.8
  flood_pin: uart_channel1.9
```

### Erreurs

Le dispositif doit signaler une erreur via NAK s'il ne peut pas se conformer.

### Renvoi

Il est possible de fabriquer un expandeur IO avec un second canal UART qui peut être utilisé pour un pendant en aval.  Dans ce cas, l'expandeur doit transmettre tout ce qu'il reçoit sur son UART primaire à l'UART en aval, et de la même manière, il doit envoyer tout ce qu'il reçoit sur son UART en aval à son UART primaire.  Pour éviter les goulets d'étranglement et les dépassements de mémoire tampon, les deux UART doivent utiliser la même vitesse de transmission.


 