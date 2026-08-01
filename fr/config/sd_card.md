---
title: 1.7 SD Card
description: configuration de la carte mémoir SD
published: true
date: 2026-08-01T19:40:56.256Z
tags: fr
editor: markdown
dateCreated: 2025-03-15T17:58:34.178Z
---

# Carte SD

![SD Card](http://www.buildlog.net/blog/wp-content/uploads/2018/08/pny_micro_sd_card-150x150.jpeg)

## Vue d'ensemble

Par défaut, aucune carte SD n'est configurée. Si vous voulez une carte SD, vous devez configurer **sdcard** et [**spi**](https://en.wikipedia.org/wiki/Serial_Peripheral_Interface) dans votre [config.yaml](http://wiki.fluidnc.com/fr/config/overview) . Si vous réussissez à configurer les deux, vous verrez des messages comme celui-ci :

```
[MSG:INFO: SPI SCK:gpio.18 MOSI:gpio.23 MISO:gpio.19]
[MSG:INFO: SD Card cs:gpio.5 detect:I2SO.27]
```

## Cartes SD prises en charge

Les cartes MMC ne sont pas prises en charge.

Les cartes SD de 2 Go ne sont pas prises en charge, car elles utilisent une taille de bloc interne différente de toutes les autres tailles.

Les cartes SD de 64 Go et plus ne sont prises en charge que si elles sont reformatées au format FAT-32.  Le format d'usine des cartes de grande taille est ExFAT, que les bibliothèques que nous utilisons ne gèrent pas.  Voir la section [Formatage des cartes](http://wiki.fluidnc.com/fr/config/sd_card#card-formatting) ci-dessous pour plus d'informations.

Nous utilisons une interface SPI. Toutes les cartes SD ne prennent pas en charge l'interface SPI. 

En général, les cartes anciennes et de petite taille fonctionnent bien, sauf dans les cas mentionnés ci-dessus.

# Fichier de configuration

## Section spi

Voici la section du fichier de configuration pour **spi** :

```yaml
spi:
  miso_pin: gpio.19
  mosi_pin: gpio.23
  sck_pin: gpio.18
```

- **miso_pin** doit être une broche native du microcontrôleur et avoir une capacité d'entrée
- **mosi_pin** doit être une broche native du microcontrôleur et avoir une capacité de sortie
- **sck_pin** doit être une broche native du microcontrôleur et avoir une capacité de sortie

Il est recommandé d'utiliser les [numéros de broches par défaut](http://wiki.fluidnc.com/fr/hardware/esp32_pin_reference#default-pin), car ils ont été testés de manière approfondie, mais d'autres broches peuvent fonctionner.

## sdcard Section

Vous avez besoin d'une section **sdcard** avec au moins la **cs_pin** définie. La **carte_detect_pin** est prise en charge, mais aucune fonctionnalité ne lui est associée, si ce n'est l'affichage de la carte dans les messages de démarrage.


Voici la section du fichier de configuration pour **sdcard** :

```yaml
sdcard:
  cs_pin: gpio.5
  card_detect_pin: NO_PIN
  frequency_hz: 8000000
```

- **cs_pin** Chip select pin. Capabilities native, output
- **card_detect_pin** Entrée des capacités
- <a id="frequency_hz"></a>**frequency_hz**
- Type : Entier
  - Plage de valeurs : 400000 à 20000000
  - Valeur par défaut : 8000000
  - Détails : Ce paramètre définit la vitesse d'horloge du bus SPI utilisé. Si vous avez des problèmes constants avec la carte SD, essayez des valeurs plus basses.

# Configuration du repli (Fallback)

Pour les systèmes qui utilisent les broches SPI par défaut, il existe un moyen d'accéder à la carte SD sans fichier de configuration.  Cela peut être utile pour les tests et d'autres situations où votre fichier de configuration est perdu.  Voir [$SD/FallbackCS](http://wiki.fluidnc.com/fr/config/sd_card#sdfallbackcs-access-sd-without-a-config-file) pour plus d'informations.

# Commandes de contrôle

Il est recommandé d'utiliser les commandes qui commencent par **\SD/**. Les versions numériques telles que [ESP210] sont toujours supportées et utilisées par certains expéditeurs, mais elles pourraient être supprimées un jour et le type **\$SD/** est plus facile à mémoriser et à supporter. Envoyer `$CMD` pour lister toutes les commandes et afficher les versions numériques de chaque commande.

Note : Si vous avez activé [authentication](https://github.com/bdring/Grbl_Esp32/wiki/Settings#authentication) (ce qui n'est pas le cas par défaut), vous devrez fournir un mot de passe pour certaines commandes. Envoyez `$SD/List pwd=admin` (ceci suppose que vous utilisez le mot de passe par défaut « admin ») pour lister les fichiers authentifiés avec le mot de passe « admin ».

## $SD/Status - Obtenir l'état de la carte SD

L'envoi de `$SD/Status` renvoie l'état actuel de la carte SD. 

## $SD/List - Obtenir le contenu de la carte SD

L'envoi de `$SD/List` permet d'obtenir la liste de tous les fichiers. Ceci est récursif et cherchera dans tous les sous-répertoires. Chaque fichier s'affichera comme suit :

  [FILE:/FOO.NC|SIZE:29547]

**/FOO.NC** est le nom du fichier, y compris le répertoire (dans ce cas, le répertoire est la racine). Les fichiers situés dans le répertoire racine sont précédés d'une barre oblique. Techniquement, il s'agit du nom approprié pour le fichier, mais vous n'avez pas besoin de l'utiliser avec les commandes si le fichier se trouve dans le répertoire racine.

Le nombre qui suit **SIZE:** est la taille du fichier. 

## $SD/Rename=ancien nom>nouveau nom

Renomme les fichiers existants sur la carte SD

Exemple : `$SD/Rename=foo.nc>bar.nc` renommera le fichier existant `foo.nc` en `bar.nc`.

## $SD/Run - Exécuter un fichier à partir de la carte SD

L'envoi de `$SD/Run=/Foo.nc` exécutera le fichier **/Foo.nc**

**Notes:**
- En mode alarme, cette commande échouera avec l'erreur 9
- Pour **Pause/Restart**, il suffit d'utiliser les commandes normales de démarrage du cycle grbl et de maintien de l'alimentation.
<!-- todo : que sont les « commandes normales de démarrage de cycle et de maintien de l'alimentation de grbl » ou où puis-je les trouver ? -->
- Pour **arrêter/quitter un fichier**, utilisez Grbl Reset. La meilleure façon de procéder est de faire un feed hold puis un Grbl Reset. La dernière ligne sera signalée. Gardez à l'esprit que la mise en attente aura arrêté un mouvement en cours et qu'il y aura d'autres mouvements dans la mémoire tampon. Le redémarrage et la réinitialisation de tous les éléments modaux sont très délicats et laissés à l'appréciation de l'expéditeur.
<!-- todo : qu'est-ce que le texte à taper « Grbl Reset » ? -->
- Erreurs** Toute erreur de gcode dans le fichier de la carte SD mettra fin à la tâche. Le numéro de ligne du fichier en cause sera signalé.
<!-- todo : un exemple de ligne ici serait bien comme dans Status ci-dessous. -->
- **Status** Lorsqu'un travail sur carte SD est en cours, le pourcentage d'octets terminés est ajouté à la chaîne de statut, comme dans l'exemple suivant **SD:45.5** :

  <Idle|WPos:195.000,144.000,19.000|Bf:15,128|FS:0.000,0.000|Pn:P|WCO:-195.000,-144.000,-19.000|SD:45.5> 

## $SD/Show=Foo.nc- Visualiser un fichier 

L'envoi de `$SD/Show=Foo.nc` affichera le contenu du fichier `Foo.nc`.


## Ajout ou téléchargement de fichiers sur la carte SD

A partir d'un programme de terminal tel que [Fluidterm](http://wiki.fluidnc.com/fr/fluidterm/fluidterm_usage), préfixez le nom local par **/sd** et le fichier sera téléchargé sur la carte SD. Envoyer `/sd/Foo.nc` téléchargera `Foo.nc` dans le répertoire racine.

Vous pouvez également ajouter des fichiers en déplaçant la carte SD vers un PC, ou [via l'interface Web](http://wiki.fluidnc.com/fr/config/overview#uploading).

## $SD/Delete - Supprimer un fichier

L'envoi de `$SD/Delete=/Foo.nc` supprimera `Foo.nc`.

## $SD/FallbackCS - Accéder à SD sans fichier de configuration

Envoyer `$SD/FallbackCS=5` configurera **GPIO 5** comme le pin de sélection de la carte SD à utiliser dans le cas où le fichier de configuration ne définit pas *cs_pin* dans la section sdcard (par exemple si le fichier de configuration est manquant).  Les broches SPI par défaut seront utilisées. Après avoir envoyé cette commande, vous devrez redémarrer le système pour l'appliquer et ainsi activer la carte SD.  Par la suite, chaque fois que le système ne pourra pas configurer la carte SD via le fichier de configuration, il configurera la carte SD avec les broches SPI par défaut et la broche CS.  Le GPIO 5 est le GPIO le plus couramment utilisé pour la sélection de la puce de la carte SD, mais vous devez bien sûr utiliser ce qui convient à votre matériel.

Si *$SD/FallbackCS* est mis à sa valeur par défaut de -1, il n'y aura pas de comportement de repli.  Dans ce cas, les informations manquantes dans les sections *spibus:* et *sdcard:* auront pour conséquence qu'aucune carte SD ne sera configurée et que les broches par défaut de ces fonctions ne seront pas initialisées.

# Formatage des cartes

FluidNC utilise des bibliothèques tierces pour accéder aux cartes SD. En général, les cartes les plus petites, les plus anciennes et les plus lentes fonctionnent le mieux.  Au fur et à mesure que les cartes deviennent plus grandes, il faut de plus en plus de mémoire RAM pour garder une trace de l'emplacement des fichiers.  Cela peut être un problème sur un ESP32, dont la RAM est limitée par rapport à celle d'un PC par exemple.

Certaines personnes rencontrent des difficultés lorsque les cartes SD ont été formatées par Windows, mais ont pu résoudre le problème en formatant avec [SD Card Formatter](https://sd-card-formatter.en.uptodown.com/windows).

Le format du système de fichiers doit être FAT-32.  ExFAT n'est pas pris en charge.  Les cartes modernes de plus de 32 Go sont généralement livrées avec le format ExFAT.  Pour utiliser une telle carte, vous devez utiliser un outil de partitionnement pour créer une partition ne dépassant pas 32 Go et la formater en FAT32.

# Noms de fichiers

La longueur maximale d'un nom de fichier ou de sous-répertoire est de 30 caractères.  Cette limite s'applique à chaque élément du chemin d'accès.  Le chemin d'accès global peut être plus long, mais il est préférable de ne pas dépasser une centaine de caractères, afin de ne pas dépasser la longueur d'une ligne de commande ou d'une autre mémoire tampon interne.  

## Taille des fichiers

FAT-32 limite la taille des fichiers individuels à 4 Go.  Cela ne devrait pas poser de problème, car les fichiers GCode individuels dépassent rarement quelques mégaoctets.

# Aide et dépannage

- **Taille de la carte SD** Assurez-vous qu'elle est inférieure à 64 Go et qu'elle n'est pas de 2 Go (en raison d'un problème de taille de bloc). En général, les cartes les plus petites et les moins rapides fonctionnent mieux.

- **Format de la carte** Formatez la carte avec FAT32.

- **Fichiers** Essayez de tester avec quelques fichiers seulement. Utilisez des noms de fichiers comportant des [caractères imprimables ASCII 8 bits](https://www.ascii-code.com/) et moins de 30 caractères.

 - **Vérifiez vos messages** de démarrage avec `$SS` pour voir si la carte a des erreurs de configuration ou d'autres informations sur la configuration de la carte SD. Beaucoup de contrôleurs ne supportent pas une broche physique de détection de carte sur la prise, donc un message de type ***card not found*** signifie que la carte n'a pas répondu.

- Essayez d'utiliser un terminal simple** Essayez d'utiliser un terminal simple comme [FluidTerm](http://wiki.fluidnc.com/fr/fluidterm/fluidterm_usage) ou le terminal avec [Web Installer](https://installer.fluidnc.com/). Cela simplifie les choses et peut aider à diagnostiquer le problème. Envoyez **$SD/List** à dans le terminal pour afficher le contenu. La réponse devrait ressembler à ceci, avec vos fichiers listés.

```
$sd/list
[DIR:System Volume Information]
[FILE:  WPSettings.dat|SIZE:12]
[FILE:  IndexerVolumeGuid|SIZE:76]
[FILE: myfile_1.nc|SIZE:38]
[FILE: myfile_2.nc|SIZE:13425]
[/sd/ Free:14.83 GB Used:128.00 KB Total:14.83 GB]
ok
```

- Essayez de diminuer la fréquence SPI** Dans la section [**sdcard:**](http://wiki.fluidnc.com/fr/config/sd_card#sdcard-section) de votre fichier de configuration, utilisez une fréquence inférieure à celle par défaut.

```yaml
sdcard :
  cs_pin : gpio.5
  card_detect_pin : NO_PIN
  frequency_hz : 400000
```

 - Les cartes SD sont très sensibles à la mise en page (connexions) et à la synchronisation. De nombreuses personnes ont signalé que leurs circuits faits à la main ne fonctionnaient pas. Certains de ces circuits fonctionnent avec les programmes d'exemple mais pas avec FluidNC. Les exemples utilisent une bibliothèque Espressif (société ESP32) différente de celle des exemples Arduino. La bibliothèque Arduino utilise une vitesse plus lente, vous pouvez donc essayer d'abaisser le paramètre [frequency_hz :](http://wiki.fluidnc.com/fr/config/sd_card#frequency_hz) à 10000000 ou 1000000. Nous sommes désolés, mais nous ne pouvons pas vous aider si votre circuit fait à la main ne fonctionne pas. 

