---
title: 2.3 FluidNC Wifi et configuration Bluetooth
description: configuration du wifi et du bluetooth
published: true
date: 2025-06-24T20:22:20.664Z
tags: fr
editor: markdown
dateCreated: 2025-03-21T07:02:22.771Z
---

# Configuration du Wifi et du Bluetooth de FluidNC

## Démarrage rapide pour l'installation du WiFi

Les utilisateurs novices peuvent configurer le WiFi à l'aide de ce [Guide de démarrage rapide du WiFi] (/en/features/wifi-quick-start).  De plus amples détails sur les sujets avancés sont donnés ci-dessous

## Wifi ou Bluetooth

L'ESP32 ne peut pas faire du wifi et du Bluetooth en même temps car il n'y a qu'une seule radio. Les deux utilisent beaucoup d'espace de code, c'est pourquoi nous avons 2 versions du firmware pré-compilé (wifi & bt). Installez celle que vous prévoyez d'utiliser. Vous pouvez toujours choisir les options noradio et wifibt si vous compilez vous-même. [Voir cette page](https://github.com/bdring/Grbl_Esp32/wiki/FluidNC-Compiling) pour plus de détails.

## Paramètres WiFi

Toutes les options de la radio sont réglées avec les commandes `$` et non via le fichier de configuration. Ceci a été fait pour s'assurer que vous avez une configuration radio stable pendant que vous développez et peaufinez votre fichier de configuration. La liste des paramètres disponibles dépend de l'utilisation du WiFi ou du Bluetooth. Vous ne verrez pas les options Bluetooth lorsque vous utilisez le firmware WiFi.

Pour modifier l'un de ces paramètres, vous pouvez utiliser [FluidTerm](fr/fluidterm/fluidterm_usage) pour vous connecter à l'interface série USB, puis taper une commande comme :

```
$Sta/SSID=MyWifiSSID
```

Vous trouverez ci-dessous tous les paramètres.

**STA** se réfère à « Station » qui serait votre wifi local. Envoyez `$STA` pour voir toutes les valeurs actuelles.
- **$Sta/SSID** Il s'agit du SSID (service set identifier) de votre routeur WiFi local. Voir [Caractères internationaux dans les SSID](/support/faq#international-characters-in-wifi-ssids) si votre SSID contient un espace ou des caractères non-US-ASCII.
- **$Sta/Password** Il s'agit du mot de passe de votre routeur WiFi local.
- **$Sta/IPMode** (DHCP ou Static) Généralement, votre routeur vous donne une adresse à utiliser au moment de la connexion. Utilisez **DHCP** pour ce mode. Si vous avez configuré votre routeur pour utiliser une adresse spécifique, utilisez le mode **Statique**.
- **$Sta/IP** Définissez une adresse IP si vous utilisez le mode **Static**, sinon la valeur est ignorée.
- **$Sta/Passerelle**
- **$Sta/Netmask*
- **$STA/SSDP/Enable** (Depuis 3.7.7) Mettez cette valeur à true (par défaut) pour activer SSDP et mDNS. Vous verrez quelque chose comme ceci dans les messages de démarrage `[MSG:INFO : Start mDNS with hostname:http://fluidnc.local/]`. Si c'est faux, vous gagnez un peu de mémoire, mais vous devez utiliser l'adresse IP pour l'URL de navigation. Cela peut être utile si vous manquez de mémoire.
- **$Sta/MinSecurity** Valeurs : OPEN, WEP, WPA-PSK, WPA2-PSK (par défaut), WPA-WPA2-PSK, WPA3-PSK, WPA2-WPA3-PSK, WAPI-PSK, or WPA3-ENT-192.

**AP** signifie « Access Point » (point d'accès). Il s'agit d'un point d'accès WiFi sur l'ESP32. Envoyez `$AP` pour voir toutes les valeurs actuelles.

- **$AP/SSID** Il s'agit du nom SSID du point d'accès. La valeur par défaut est « FluidNC »
- **$AP/Password** Le mot de passe n'est pas affiché lorsque vous demandez la valeur actuelle. Le mot de passe par défaut est « 12345678 ».
- **$AP/IP** L'IP statique utilisée par l'AP pour lui-même.
- **$AP/Canal**
- **$AP/Country** \[depuis v3.6.7\] Le domaine réglementaire configuré pour l'AP. Affecte les canaux disponibles et la puissance d'émission maximale. Voir cette [liste de codes à 2 lettres](https://github.com/bdring/FluidNC/blob/main/FluidNC/src/WebUI/WifiConfig.cpp#L47)

Autres paramètres

- **$Hostname**
- **$HTTP/Enable**
- **$HTTP/Port**
- **$HTTP/BlockDuringMotion** [depuis v3.6.8] Empêche de servir des fichiers de LocalFS lorsque la machine est en marche
- **$Telnet/Enable**
- **$Telnet/Port**
- **$WiFi/Mode** (AP, Off, STA ou STA>AP) Il s'agit du mode que le wifi utilisera. STA>AP signifie qu'il tentera d'utiliser STA, puis reviendra au mode AP.
- $Notification/Type
- $Notification/T1
- $Notification/T2
- $Notification/TS

## Mots de passe

Aucune commande ne permet de connaître le mot de passe actuel. Ceci offre un peu de sécurité. Une personne ayant un accès direct à l'ESP32 peut vider la mémoire flash et trouver le mot de passe. Pour une meilleure sécurité, il est conseillé d'utiliser un pare-feu de réseau.

**Note:** Votre console ne sait pas que vous envoyez un mot de passe, il s'affiche donc au fur et à mesure que vous le tapez.

## Mode Wifi AP

Dans ce mode, FluidNC devient son propre point d'accès wifi. Les [messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages) indiquent qu'il a créé un point d'accès avec le SSID « FluidNC ». Vous pouvez vous y connecter avec votre ordinateur, votre tablette ou votre téléphone. Le mot de passe par défaut est « 12345678 ». L'adresse IP est 192.168.0.1.

> Le mode AP n'est pas recommandé pour la production, mais uniquement pour la configuration initiale. Il affecte les performances de votre machine et peut provoquer des pannes au bout d'un certain temps. Passez en mode STA ou STA>AP après la configuration de FluidNC. Si vous n'avez pas de point d'accès WiFi externe auquel vous connecter en mode STA, vous pouvez configurer un réseau privé à l'aide d'un routeur WiFi qui n'a pas besoin d'être connecté à des réseaux externes.  Le routeur peut être un vieux routeur lent - peut-être un routeur hors service - car la vitesse du WiFi de l'ESP32 est limitée à environ 30 mBits/sec, ce qui est plus que suffisant pour l'interface WebUI. 
{.is-warning}

```
[MSG:INFO: AP SSID FluidNC IP 192.168.0.1 mask 255.255.255.0 channel 1]
[MSG:INFO: AP started]
[MSG:INFO: WiFi on]
[MSG:INFO: Captive Portal Started]
[MSG:INFO: HTTP started on port 80]
[MSG:INFO: Telnet started on port 23]
```
## WiFi STA Adresse DHCP

Dans ce mode, votre routeur attribue une adresse. Vous pourrez la voir dans les [messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages). Dans le cas ci-dessous, il s'agit de `192.168.1.19`. C'est l'adresse que vous utiliserez dans votre navigateur web.

```
[MSG:INFO: STA SSID Barts-WLAN DHCP]
[MSG:INFO: Connecting.]
[MSG:INFO: Connecting..]
[MSG:INFO: Connecting...]
[MSG:INFO: Connected - IP is 192.168.1.19]
[MSG:INFO: WiFi on]
[MSG:INFO: Start mDNS with hostname:http://fluidnc.local/]
[MSG:INFO: SSDP Started]
[MSG:INFO: HTTP Started]
[MSG:INFO: Telnet Started on port 23]
```
## WebUI

La [WebUI](http://wiki.fluidnc.com/fr/features/webui) est l'interface utilisateur basée sur le navigateur web.

# Dépannage

## Échec de la connexion

Voici un exemple d'échec de connexion en mode STA et de passage en mode AP.

```
[MSG:INFO: STA SSID Barts-WLAN DHCP]
[MSG:INFO: Connecting.]
[MSG:INFO: Connecting..]
[MSG:INFO: Connecting...]
[MSG:INFO: Connecting....]
[MSG:INFO: Connecting.]
[MSG:INFO: Connecting..]
[MSG:INFO: Connecting...]
[MSG:INFO: Connecting....]
[MSG:INFO: Connecting.]
[MSG:INFO: Connecting..]
[MSG:INFO: AP SSID FluidNC IP 10.0.0.1 mask 255.255.255.0 channel 1]
[MSG:INFO: AP started]
[MSG:INFO: WiFi on]
[MSG:INFO: Captive Portal Started]
[MSG:INFO: HTTP Started]
[MSG:INFO: Telnet Started on port 23]

```

<!-- 220322_1728: The following are my version of the excellent remarcks by Mitch, here: https://discord.com/channels/780079161460916227/955882703520145488 -->

## Se connecter à un réseau externe

L'utilisation du mode AP pour la production n'est pas recommandée, utilisez-le uniquement pour la configuration initiale.  Le code de base AP d'Espressif semble avoir des problèmes que nous n'avons pas pu isoler, et qui pourraient être trop profonds dans le SDK pour que nous puissions les résoudre.  En guise de solution de contournement, envisagez d'utiliser un AP externe dédié.  Il n'est pas nécessaire qu'il s'agisse d'un appareil moderne à haute performance, un vieil appareil provenant de la boîte à ordures fera probablement l'affaire.

Les utilisateurs ont l'habitude d'utiliser des tablettes connectées en WiFi avec l'interface WebUI.  La tablette et le contrôleur FluidNC peuvent se connecter à un réseau externe qui peut être un ensemble de routeurs datant de quelques générations.  Une performance encore meilleure serait attendue d'un AP dédié.

## Utilisation d'un câble USB/série

L'USB est toujours disponible comme solution de repli - et FluidNC passera également en mode AP s'il ne parvient pas à se connecter à un AP externe en mode STA. 

Vous ne pouvez pas utiliser l'interface WebUI via une connexion USB. Vous devez utiliser un autre émetteur comme [UGS](https://winder.github.io/ugs_website/) sur un ordinateur connecté.  Il existe également des émetteurs qui fonctionnent sur des ordinateurs connectés via Bluetooth ou via une connexion série (moyennant quelques efforts supplémentaires pour intégrer un port série USB dans la configuration matérielle/logicielle de la tablette).

## Utilisation de Bluetooth

Si vous avez des problèmes de connexion WiFi, peut-être que Bluetooth serait plus fiable dans votre environnement spécifique, c'est impossible à savoir.  Vous n'avez qu'à essayer.

## Bruit électrique

Les broches ou autres moteurs à haute puissance peuvent générer beaucoup de bruit électrique qui peut causer des interférences avec les radios WiFi et Bluetooth.  Une façon de déterminer s'ils font partie du problème est d'exécuter des travaux de test de « coupe d'air » avec la broche éteinte, pour voir si les déconnexions s'arrêtent.

<!-- 220322_1757: what terms would be a good start for searching? -->

## Puissance du signal

Vérifiez la force du signal du WiFi cible avec `$Wifi/ListAPs`. Il est au format JSON car il est principalement utilisé par l'interface WebUI et les expéditeurs.

```
{« AP_LIST »:[{« SSID »:« Barts-WLAN »,« SIGNAL »:« 82 »,« IS_PROTECTED »:« 1 »},{« SSID »:« 4ag2hc1lj2ek7 »,« SIGNAL »:« 32 »,« IS_PROTECTED »:« 1 »},{« SSID »:« TheWIFI-2 »,« SIGNAL »:« 30 »,« IS_PROTECTED »:« 1 »}]}
```
## Caractères spéciaux

Les SSID et les mots de passe utilisent souvent des caractères spéciaux. [Voir cette note de la FAQ sur les limitations de caractères](http://wiki.fluidnc.com/fr/support/faq#special-character-issue).

# Méthodes de communication Wifi

## Telnet

Si vous avez `$Telnet/Enable=True`, vous pouvez communiquer via telnet avec le même protocole que le protocole série. Le port par défaut est 23 et est défini par **$Telnet/Port**. S'il est activé, vous devriez le voir dans vos [messages de démarrage](http://wiki.fluidnc.com/fr/support/requesting_help#fluidnc-startup-messages).

```
[MSG:INFO : Telnet démarré sur le port 23]

```

## Websockets

Si vous vous connectez via un websocket (sur $http/port +1, par exemple 81), vous disposez d'une connexion en continu à FluidNC qui se comporte comme une connexion série.  Vous envoyez des lignes délimitées par de nouvelles lignes comme vous le feriez en série, et vous obtenez les mêmes réponses ok ou erreur.  Le contrôle de flux est le même que pour une connexion série, comme documenté sur le bon vieux wiki Grbl.

## Télécharger avec curl

```
curl -F upload=@test.nc http://192.168.1.31/upload

```

Ceci téléchargera le fichier `test.nc` sur la carte SD à l'adresse 192.168.1.31

```
curl -F file=@test.nc http://192.168.1.31/files

```

Ceci téléchargera le fichier `test.nc` sur le localfs (flash) de l'ESP32 à l'adresse 192.168.1.31




















