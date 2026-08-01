---
title: 6x CNC Contrôleurs annuler
description: Un contrôleur CNC complet pour 6 moteurs
published: false
date: 2025-04-01T19:00:19.916Z
tags: 
editor: markdown
dateCreated: 2025-03-20T18:29:14.152Z
---

<!DOCTYPE html>
<div class="page-contents v-content"><div class="contents"><div><p><img height="450" alt="6x_antenna_ver.jpg" src="/hardware/6x_antenna_ver.jpg"></p>
<h1 class="toc-header" id="overview"><a href="#overview" class="toc-anchor">¶</a> Vue d'ensemble</h1>
<p>Il existe (2) versions de ce contrôleur. On utilise un plug in ESP32 et on en a un intégré dans le contrôleur. Ils ont des pinces indentiques et à peu près le même emplacement de tous les connecteurs. Sauf indication contraire, cette page concerne les deux versions.</p>
<h1 class="toc-header" id="where-to-buy-it"><a href="#where-to-buy-it" class="toc-anchor">¶</a> Où l'acheter.</h1>
<ul>
<li>Les clients américains peuvent chez <a class="is-external-link" href="https://www.tindie.com/products/33366583/6x-cnc-controller-for-fluidnc-integrated-esp32/">Tindie</a></li>
<li>Les clients internationaux peuvent acheter via <a class="is-external-link" href="https://www.elecrow.com/6x-cnc-controller-for-fluidnc.html">Elecrow</a>.</li>
</ul>
<h1 class="toc-header" id="features"><a href="#features" class="toc-anchor">¶</a> Caractéristiques</h1>
<ul>
<li>(6) Connecteurs moteur pour drivers externes pas à pas (signaux 5v). Chaque moteur a des signaux distincts de pas, de direction et de validation. LED sont sur chaque signal pour aider à la configuration.</li>
<li>(8) Entrées pour interrupteurs (limites, sondes, commande)</li>
<li>Broches (plusieurs types pris en charge). Certains arrangements multi-broches sont possibles comme RS485 &amp; laser sur la même machine. <ul>
<li>RS485 Fuseaux VFD</li>
<li>0-10V les broches commandées avec des signaux de direction aller et retour supplémentaires</li>
<li>Contrôleurs de vitesse PWM avec signaux d'autorisation séparés en option</li>
<li>Broches commandées par relais (on/off).</li>
<li>BESC (Brushless Motor) broches à base</li>
<li>Lasers avec PWM et activer</li>
</ul>
</li>
<li>(2) 3A MOSFET pour conduire des relais, des solénoïdes et des vannes.</li>
<li>Les sorties non utilisées de broche 5V peuvent être utilisées pour n'importe quelle fonction de sortie (liquide de refroidissement, etc.)</li>
<li>Prise de carte micro SD pour le stockage local de fichiers gcode</li>
<li>Prise de module pour extensions GPIO et interfaces pendentifs.</li>
</ul>
<h1 class="toc-header" id="versions"><a href="#versions" class="toc-anchor">¶</a> Versions</h1>
<p>Actuellement, toutes les versions utilisent la même I/O. Les fichiers Config sont compatibles entre les versions.</p>
<ul>
<li><strong>V1.2</strong> Cette version est passée de l'antenne PCB ESP32 à la version de connecteur PCB. Cela <strong>n'a pas </strong>modifié la disposition des PCB parce que les 2 empreintes sont compatibles.</li>
</ul>
<h1 class="toc-header" id="getting-started"><a href="#getting-started" class="toc-anchor">commencer</a></h1>
<p>Le contrôleur est livré avec une version de FluidNC qui était en cours lorsque le contrôleur a été construit. Vous mettez à jour le firmware en utilisant  <a class="is-external-link" href="https://installer.fluidnc.com/">l'installateurweb ici </a>. Il est préférable de <strong>faire une mise à niveau</strong> et non une <strong>nouvelle installation</strong>.</p>
<p>Il est livré avec un fichier de config par défaut qui est principalement utilisé pour les essais en usine et ne fonctionnera probablement pas votre machine. Vous devrez <a class="is-external-link" href="http://wiki.fluidnc.com/en/config/overview">créer un fichier de configuration</a>  pour votre machine et le télécharger.</p>
<h1 class="toc-header" id="asking-for-help"><a href="#asking-for-help" class="toc-anchor">¶</a> Demander de l'aide</h1>
<p>Avant de demander de l'aide, veuillez rechercher toutes les zones de ce wiki. Vos questions ont probablement été posées avant et de longues réponses détaillées avec des photos, des dessins et des schémas sont sur ce wiki.</p>
<p>Consultez cette <a class="is-external-link" href="http://wiki.fluidnc.com/en/support/requesting_help">page d'aide </a>si vous avez encore des problèmes.</p>
<p>Veuillez poser toutes les autres questions via notre<a class="is-external-link" href="http://wiki.fluidnc.com/en/support/discord"> serveur discord</a>.</p>
<h1 class="toc-header" id="built-in-esp32"><a href="#built-in-esp32" class="toc-anchor">¶</a> Intéragire avec l'ESP32</h1>
<p>Il faut utilisé un connecteur USB-C. Une alimentation externe doit être allumée pour alimenter la puce USB. Vous n'obtiendrez pas de connexion à votre ordinateur si l'alimentation externe n'est pas allumée.</p>
<h1 class="toc-header" id="power-supply"><a href="#power-supply" class="toc-anchor">¶</a> Alimentation électrique</h1>
<p>Le contrôleur doit être alimenté par une alimentation électrique 12-30VDC. Cette tension primaire est appelée VMot sur le schéma et dans la documentation. Elle devrait pouvoir fournir un minimum de 2A. Si vous fixez des périphériques externes à l'une des connexions VMot, vous devez ajouter ces courants au minimum d'alimentation.</p>
<p>Il y a un en-tête au milieu du contrôleur pour accéder à toutes les tensions du contrôleur. Ceux-ci sont pour le courant faible seulement. Vous ne devriez pas tirer plus de 1A de l'une de ces connexions.</p>
<p>VMot est également accessible sur les terminaux MOSFET. Vous pouvez tirer jusqu'à 3A sur chacune de ces broches.</p>
<p>Vous ne devriez pas alimenter une broche ou un laser avec ce contrôleur. Utilisez un câblage séparé de votre alimentation électrique.</p>
<blockquote class="is-info">
<p>Vous ne pouvez pas alimenter le contrôleur avec l'USB seul. L'USB ne se connectera pas.</p>
</blockquote>
<blockquote class="is-warning">
<p>Soyez très prudent pour obtenir la polarité de tension correcte. Il n'y a pas de protection de polarité inverse, donc vous détruirez le contrôleur et probablement certains éléments connectés.</p>
</blockquote>
<p>Il existe un en-tête central qui permet à l'utilisateur d'accéder à ces tensions.</p>
<ul>
<li>3.3V 100mA max total</li>
<li>5V 500mA max total</li>
<li>VMot 1A par broche max.</li>
</ul>
<h1 class="toc-header" id="programming"><a href="#programming" class="toc-anchor">¶</a> Programmation</h1>
<p>Le contrôleur est programmé avec la révision en cours de FluidNC au moment de sa production. Il a également un fichier de config très basique qui est utilisé pour les tests. Il y a un fichier gcode de test qui fait clignoté la LED et déplace les moteurs. Vous devez vérifier les mises à jour avant d'utiliser le contrôleur. La version est affichée dans les messages de démarrage. Envoyer <code>$ss</code> pour les voir après avoir redémarrer. La version en cours de FluidNC sont <a class="is-external-link" href="https://installer.fluidnc.com/">listée ici</a>.</p>
<p>Appliquez la puissance au contrôleur via le bloc de la borne de puissance. Vérifiez que la LED 5v au milieu du PCB s'allume. Connectez un câble USB C de haute qualité au contrôleur. Connectez l'autre extrémité à un PC (Windows, Mac ou Linux).</p>
<p>Utilisez le navigateur Chrome pour vous connecter à la page de <a class="is-external-link" href="https://installer.fluidnc.com/">FluidNC Installateur Web</a>. Cliquez sur le bouton de connexion. Sélectionnez le port COM associé au contrôleur. L'appareil USB est un Silicon Labs CP2102. Si vous voyez plusieurs ports COM disponibles, cherchez un avec une description similaire. Sélectionnez-le et validé, la page Web s'y connecte.</p>
<p>Installez la version avec le plus grand nombre (dernière version). N'utilisez pas de versions de test à moins d'avoir reçu l'instruction de le faire pour aider à résoudre un problème de support.</p>
<p>Consultez la page<a class="is-internal-link is-valid-page" href="/installation"> d'installation générale</a>  pour plus d'informations et des méthodes alternatives.</p>
<h1 class="toc-header" id="motors"><a href="#motors" class="toc-anchor">¶</a> Moteurs</h1>
<p><img height="200" alt="external_stepper.jpg" src="/hardware/external_stepper.jpg"></p>
<p>Le contrôleur est conçu pour les modules externes de pilote pas à pas qui acceptent 5V, pas, direction, et des signaux d'activation. Ils utilisent tous des broches<a class="is-external-link" href="http://wiki.fluidnc.com/en/support/controller_design_guidelines#i2so-chips"> i2so</a>, donc vous devez utiliser I2S_STATIC ou I2S_STREAM dans <a class="is-external-link" href="http://wiki.fluidnc.com/en/config/axes#stepping">la section "steeping"</a> de votre fichier de config.</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">stepping:
  engine: I2S_static
  idle_ms: 255
  pulse_us: 4
  dir_delay_us: 4
  disable_delay_us: 0
  segments: 6
</code></pre>
<p>Toute sortie de moteur peut être utilisée pour n'importe quel axe ou numéro de moteur. Ils sont étiquetés Motor1 jusqu'à la motor 6. Voici les axes pour chaque moteur.</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml"># motor 1
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
</code></pre>
<h2 class="toc-header" id="motor-wiring"><a href="#motor-wiring" class="toc-anchor">¶</a> Câblage moteur</h2>
<p><img height="300" alt="external_stepper_wiring.jpg" src="/hardware/external_stepper_wiring.jpg"></p>
<p>La meilleure façon de câbler le moteur est d'utiliser une terre commune. Câblez la borne de masse du contrôleur à l'une des bornes (-) du conducteur pas à pas, puis la chaîne de daisy aux 2 autres bornes (-). Voir le fil noir dans l'image ci-dessus. Ensuite, câblez individuellement l'étape, dir, et activer les terminaux sur le contrôleur aux terminaux équivalents (+) sur les pilotes pas à pas. Si une fuction est révérée, comme activer ou modifier <a class="is-external-link" href="http://wiki.fluidnc.com/en/config/config_IO#output-pin-attributes">l'état actif </a>de la broche.</p>
<p><img width="400" alt="motor_wiring.png" src="/hardware/motor_wiring.png"></p>
<p>L'Ena, Stp et Dir LED sur le contrôleur 6x peuvent vous aider à vérifier les signaux. Les LED montrent l'état électrique du signal. Si le signal est haut (5v), la LED sera allumée. Si elle est faible (gnd), la LED est désactivée, selon que votre signal de désactivation est actif haut ou faible, déterminera si la LED est allumée ou éteinte lorsque vos moteurs se verrouillent. Vous devriez juste regarder pour voir si elle change lorsque vous envoyez <code>$MD</code> et <code>$ME</code>. La LED de direction sera allumée pour une direction et désactivée pour l'autre direction. L'étape LED sera typiquement moins brillante que les autres LED avec la luminosité proportionnelle à la vitesse. En effet, les signaux pas à pas sont des impulsions très courtes. Si vous inversez l'état actif du signal d'étape, l'activité LED sera également inversée.</p>
<h3 class="toc-header" id="closed-loop-motors"><a href="#closed-loop-motors" class="toc-anchor">¶</a> Moteurs en boucle fermée</h3>
<p>La plupart des moteurs en boucle fermée peuvent être utilisés. Voir <a class="is-external-link" href="http://wiki.fluidnc.com/en/support/external_stepper_motor_drivers#closed-loop-steppers-and-servo-motors">cette page du wiki</a>  pour plus de détails.</p>
<h1 class="toc-header" id="inputs"><a href="#inputs" class="toc-anchor">¶</a> Input</h1>
<p>Toutes les entrées s'activent en fermant le circuit à la masse. Vous pouvez utiliser les commutateurs N.O. et N.C aussi longtemps qu'une position se ferme à la terre.</p>
<p>Vous pouvez utiliser des interrupteurs électroniques comme des commutateurs de proximité ou inductifs aussi longtemps que le signal de sortie passe à la masse (généralement appelé NPN). Si les interrupteurs nécessitent une alimentation externe, vous devez connecter celle-ci ailleurs sur le contrôleur ou une alimentation externe qui partage un terrain commun. Dans n'importe quel état le commutateur ne devrait jamais mettre plus de 5V sur le bloc terminal. Souvent les types NPN auront une résistance de traction interne sur le signal à la tension +. C'est généralement environ 10k. Tant qu'il est 5k ou plus, il devrait être sûr de se connecter à l'entrée.</p>
<p>Toutes les entrées ont des résistances externes de traction à l'exception de gpio.2 et gpio.26. Vous devez ajouter l'attribut <em><strong>: pu</strong></em> à ceux-ci.</p>
<p>Pour les commutateurs normalement ouverts, vous avez besoin de l'attribut <strong>:low</strong> sur toutes les entrées. Pour les commutateurs normalement fermé, vous pouvez ajouter l'attribut<em><strong>:high</strong></em>, mais ce n'est pas nécessaire car c'est l'attribut par défaut dans FluidNC. </p>
<p>Exemple :</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">gpio.2:low:pu
gpio.36:low
gpio.39
</code></pre>
<p><strong>Exemple de câblage commutateur de proximité NPN.</strong></p>
<p>Connectez le fil brun à une tension compatible avec le capteur (typiquement 6-30v). Vous pouvez utiliser l'en-tête de tension au milieu du contrôleur. Connectez le fil bleu à n'importe quel sol. Connectez le fil noir aux <strong>entrées</strong> étiquetées io.xx.</p>
<p><img height="300" alt="npn_sw_wiring.png" src="/hardware/npn_sw_wiring.png"></p>
<p><strong>Avertissement : </strong>Certains circuits de commutation NPN peuvent avoir une résistance pullup à la tension positive. Si cette tension est supérieure à 1 volt ou 2 volt au-dessus de la 5V de l'autre côté de l'opto LED sur le circuit d'entrée du contrôleur 6x, elle peut créer un potentiel inverse néfaste sur la LED. Vous pouvez utiliser un compteur pour voir la tension du signal dans les états actif et inactif. Vous pouvez utiliser une diode pour empêcher et inverser la tension comme indiqué ci-dessous.</p>
<p><img height="450" alt="npn_diode.png" src="/hardware/npn_diode.png"></p>
<h1 class="toc-header" id="outputs"><a href="#outputs" class="toc-anchor">¶</a> Extrants</h1>
<p>Le contrôleur a beaucoup plus de connexions de sortie que les broches d'entrée/sortie. Il le fait en partageant des broches d'E/S. Par exemple, le MOSFET utilise les mêmes entrées/sorties que certaines des sorties 5V. Lorsque vous attribuez cette broche d'entrée/sortie, vous pouvez utiliser la sortie 5V ou le MOSFET. Ils sont liés et actifs en même temps. Vous ne pouvez pas les utiliser pour des fonctionnalités distinctes. Voir la carte des entrées/sorties.</p>
<h2 class="toc-header" id="i2so-outputs"><a href="#i2so-outputs" class="toc-anchor">¶</a> I2SO Extrants</h2>
<p>Les broches i2so sont généralement utilisées pour la commande du moteur, mais vous pouvez les utiliser pour d'autres fonctions de sortie numériques (on/off). Si par exemple vous n'utilisez pas un 6ème moteur, vous pouvez utiliser l'une de ces broches,  comme<code>mist_pin: i2so.23</code>. Voir plus sur <a class="is-external-link" href="http://wiki.fluidnc.com/en/config/config_IO#i2so-section">i2s0 broches ici</a>.</p>
<h1 class="toc-header" id="spindles"><a href="#spindles" class="toc-anchor">¶</a> Broches</h1>
<p>Beaucoup de broches partagent des sorties avec d'autres fonctionnalités. Gardez une trace des entrées/sorties que vous utilisez pour éviter les conflits.</p>
<h2 class="toc-header" id="pwm"><a href="#pwm" class="toc-anchor">¶</a> PWM</h2>
<p>Le PWM peut être mis sur n'importe laquelle des sorties 5V.</p>
<h2 class="toc-header" id="h-0-10v"><a href="#h-0-10v" class="toc-anchor">¶</a> 0-10V</h2>
<p>Ceci utilise un op-amp et un filtre passe-bas pour créer une tension analogique. Il peut être réglé avec un pot de garniture pour une tension maximale de 5V à 10V. Mesurez et réglez la tension avant de vous connecter à votre régulateur de vitesse de broche. Une bonne façon de le faire est d'envoyer le gcode pour max vitesse de broche comme <a class="is-external-link" href="http://wiki.fluidnc.com/en/features/supported_gcodes#s-spindle-speed">(M3 S24000</a> ou quel que soit votre max est) et puis ajuster le pot jusqu'à ce que vous obtenez la tension max désirée. Il est préférable de régler la tension max avant de se connecter à votre VFD.</p>
<p>Le schéma pour les connexions avant et arrière ressemble à cela. Ils sont isolés du ESP32 et se connectent Out1 et Out2 à un terrain commun sur le VFD.</p>
<p><img alt="10v_fwdrev_schm.png" src="/hardware/10v_fwdrev_schm.png"></p>
<p>Exemple de section Config</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">10V:
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

</code></pre>
<p>Voici un exemple de la façon de câbler un Huanyang pour le contrôle 10V. Vous devez vous assurer que tous les registres sont configurés pour le contrôle 10V.</p>
<p><img height="500" alt="huany_10v_pinout.png" src="/hardware/huany_10v_pinout.png"></p>
<hr>
<p><strong></strong></p>
<p>Voici un exemple de la façon de câbler un YL620 pour le contrôle 10V. Vous devez vous assurer que tous les registres sont configurés pour le contrôle 10V.</p>
<p>P00.00 = 400 (fq 400 hz)<br> <br> <br> P03.12 = 100 (fq mini)<br> P03.13 = 400 (fq maxi)<br> pour les bascules blanches dans le module rouge au-dessus de la bande verte, vous devez mettre « on » les 2 et les 4 (activation 10 volts du Vfd) et laisser « off » les 1 et 3</p>
<p><img height="450" alt="yl620_10v_pinout.png" src="/hardware/yl620_10v_pinout.png"></p>
<h2 class="toc-header" id="laser"><a href="#laser" class="toc-anchor">¶</a> Laser</h2>
<p>Le laser peut être placé sur l'une quelconque des sorties 5V. Si vous voulez également utiliser un autre type de broche. Réglez-le en premier et voyez ce qu'il reste.</p>
<h2 class="toc-header" id="rs485"><a href="#rs485" class="toc-anchor"></a></h2>
<p>Le circuit RS485 utilise une puce MAX3485. Cela nécessite l'utilisation d'un <strong>rts_pin</strong> pour le contrôle de la direction des données.</p>
<p>Il y a des LED pour montrer et aider à déboguer les problèmes de communication.</p>
<ul>
<li><strong>TX LED</strong> (étiqueté io15) Vous devriez voir le TX clignoter quelques fois par seconde. Si vous ne le faites pas, quelque chose ne va pas dans votre configuration côté contrôleur CNC.</li>
<li><strong>Rx LED</strong> (étiqueté (RS485 Rx) Le Rx doit clignoter au même rythme (immédiatement après) que le Tx LED lorsqu'il communique avec le VFD. Si la LED Rx reste allumée, essayez de changer les fils du côté VFD. S'il ne s'allume pas du tout, il y a probablement un problème de configuration ou autre côté VFD. <strong>Note :</strong> Lorsque aucun fil RS485 n'est connecté, l'état de la LED est vide de sens. Ignorer cette LED lorsque vous n'utilisez pas RS485.</li>
<li><strong>RTS_LED</strong> (étiqueté i014) Ceci devrait éclairer le même temps que le TX_LED.</li>
</ul>
<blockquote class="is-info">
<p>Note : Le circuit est un convertisseur UART to RS485. Les LED représentent l'état de l'UART côté OI. L'état de ralenti d'un UART Tx est élevé, de sorte que les clignotements TX sont de mise. Il peut être difficile de voir le Tx off clignote parce que la LED est lumineuse et le temps d'arrêt est si bref. Essayez de couvrir l'autre LED pour voir les clignotants.</p>
</blockquote>
<blockquote class="is-warning">
<p>RS485 est beaucoup plus compliqué à installer que d'autres types de broches. Il nécessite beaucoup de <a class="is-external-link" href="http://wiki.fluidnc.com/en/config/config_spindles#using-rs485-to-control-spindles">configuration côté VFD et</a> un bon câblage. Si vous avez des problèmes, vous devriez envisager d'utiliser la méthode 0-10V pour contrôler la broche. Il est très difficile pour nous de soutenir RS485 à distance.</p>
</blockquote>
<p>Voici une section typique RS485 config file. Ceci est spécifique au contrôleur 6x. Vous devez également configurer le VFD et obtenir le câblage correct. Pour des informations générales sur la configuration VFD, voir la <a class="is-external-link" href="http://wiki.fluidnc.com/en/config/config_spindles#using-rs485-to-control-spindles">page</a> wiki de broche.</p>
<p>Pour mon Huanyang, je connecte le terminal étiqueté <strong>RS485 A</strong> sur le contrôleur à <strong>RS</strong> + sur le VFD et <strong>RS485</strong> B sur le contrôleur à <strong>RS-</strong> sur le VFD. Je n'utilise pas le terminal au sol.</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-"># Begin Huanyang
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
</code></pre>
<h1 class="toc-header" id="mosfets"><a href="#mosfets" class="toc-anchor">¶</a> MOSFET</h1>
<p>Les (2) NPN MOSFET sont notés pour 3A continu et 5A pic. Il existe des diodes de retour d'air connectées à VMot pour les rendre sûres pour une utilisation avec des charges inductives, comme des relais et des solénoïdes.</p>
<p>Les MOSFET utilisent gpio.4 et gpio.12. Ces broches d'entrée/sortie activent également les sorties 5V.</p>
<p>Les terminaux VMot sont toujours connectés à VMot. Les terminaux marqués avec les numéros io pin passent à la masse lorsque les broches io sont actives. Si vous avez besoin de faire fonctionner des appareils avec d'autres tensions que VMot, vous pouvez utiliser une alimentation en courant continu séparée tant qu'elle partage un terrain commun avec le contrôleur.</p>
<h2 class="toc-header" id="using-a-relay"><a href="#using-a-relay" class="toc-anchor">¶</a> Utilisation d'un relais.</h2>
<p>Une utilisation typique du MOSFET est de commander directement un relais pour une broche ou un dispositif de refroidissement. Le circuit MOSFET dispose d'un relais intégré de retour d'air, vous n'avez donc pas besoin d'en ajouter un. Si le relais a un intégré didoe assurez-vous d'obtenir le VMot sur le bon côté.</p>
<p><img height="400" alt="6x_relay_wiring.png" src="/hardware/6x_relay_wiring.png"></p>
<h1 class="toc-header" id="rc-servo-usage"><a href="#rc-servo-usage" class="toc-anchor">¶</a> RC Servo Utilisation</h1>
<p>Les servos RC nécessitent un signal de commande PWM de 5v. Vous pouvez utiliser n'importe laquelle des sorties 5V. Vous devez également alimenter le servo. Vous pouvez utiliser la broche 5V au centre du contrôleur pour la plupart des servos. Si votre servo nécessite plus d'environ 1A, vous pouvez utiliser une alimentation séparée qui a un terrain commun avec le contrôleur.</p>
<p><img height="400" alt="rc_servo.png" src="/hardware/rc_servo.png"></p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">  z:
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
</code></pre>
<h1 class="toc-header" id="expansion-module-socket"><a href="#expansion-module-socket" class="toc-anchor">¶</a> Module d'expansion Socket</h1>
<p>La prise de module d'expansion est conçue pour être utilisée avec un module d'entrée/sortie pour vous donner plus d'entrées, de sorties et de connexions aux afficheurs et aux pendentifs. Certains modules existent et d'autres sont en cours d'élaboration et devraient être disponibles à l'avenir.</p>
<p>Le socket est similaire aux 6 modules de pack sauf qu'il utilise seulement 2 broches E/S. Vous pouvez utiliser partiellement quelques 6 modules de pack, mais seulement les fonctionnalités qui utilisent les 2 premières broches d'E/S. Exemples : Module relais, module 5V (2 premières sorties seulement), Module d'entrée (2 premières entrées seulement).</p>
<p>Vous devrez fournir un espaceur pour supporter le module. Vous pouvez soit utiliser une borne filetée de 11mm de long M3 ou cet <a class="is-asset-link" href="/3d_models/6_pack/1x_supp_slim.stl">espaceur imprimé en 3D (STL).</a></p>
<p><a class="is-external-link" href="http://wiki.fluidnc.com/en/hardware/official/M5Dial_Pendant#rj12-connectors">Voici un simple module de cadran en ligne</a></p>
<blockquote class="is-danger">
<p>Vous ne devriez utiliser que des modules conçus pour être utilisés avec ce contrôleur. Les broches de prise se connectent directement au ESP32 sans bruit ni protection ESD. Les modules assurent généralement cette protection. Le câblage direct à la prise d'expansion endommagera probablement le contrôleur.</p>
</blockquote>
<p><strong>Voici quelques modules que vous pouvez utiliser.</strong></p>
<ul>
<li><a class="is-external-link" href="http://wiki.fluidnc.com/en/hardware/cnc_io_modules#simple-pendant-module">Module d'affichage pendentif</a></li>
<li><a class="is-external-link" href="http://wiki.fluidnc.com/en/hardware/cnc_io_modules#h-4x-isolated-input-module">Module d'entrée 4x</a> (seulement 2 entrées peuvent être utilisées)</li>
<li><a class="is-external-link" href="http://wiki.fluidnc.com/en/hardware/cnc_io_modules#h-5v-output">Module</a> de sortie 5V (seulement 2 sorties peuvent être utilisées)</li>
<li><a class="is-external-link" href="http://wiki.fluidnc.com/en/hardware/cnc_io_modules#mosfet">Module</a> MOSFET (seulement 2 sorties peuvent être utilisées)</li>
<li><a class="is-external-link" href="http://wiki.fluidnc.com/en/hardware/cnc_io_modules#isolated-rs485"></a></li>
<li><a class="is-external-link" href="http://wiki.fluidnc.com/en/hardware/cnc_io_modules#relay-module">Module relais</a></li>
</ul>
<h2 class="toc-header" id="display-or-pendant-on-the-expansion-connector"><a href="#display-or-pendant-on-the-expansion-connector" class="toc-anchor">¶</a> Afficher ou pendentif sur le connecteur d'expansion.</h2>
<p>Encore une fois, soyez très prudent avec le câblage.</p>
<p>Voici un exemple de section de fichier config</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">uart1:
  txd_pin: gpio.25
  rxd_pin: gpio.27
  rts_pin: NO_PIN
  cts_pin: NO_PIN
  baud: 1000000
  mode: 8N1

uart_channel1:
  report_interval_ms: 75
  uart_num: 1
</code></pre>
<p>Voici une photo du module monté sur le contrôleur 6x. Les 5 premières broches entrent dans la prise. Les autres sont à l'extérieur. Ils dégagent les composants de plusieurs millimètres. Vous devez monter le module à l'aide d'une vis et d'une entretoise de 11mm.</p>
<p><img height="320" alt="6x_fd_mounted.jpg" src="/hardware/fluiddial/6x_fd_mounted.jpg"></p>
<h1 class="toc-header" id="example-config-file"><a href="#example-config-file" class="toc-anchor">¶</a> Exemple Config File</h1>
<p><a class="is-external-link" href="http://wiki.fluidnc.com/en/config/overview#comments">Supprimez les caractères</a> de commentaire des fonctionnalités que vous voulez utiliser, mais soyez conscient de ne pas réutiliser les broches io. Vous verrez les avertissements dans les messages de début si cela se produit.</p>
<p>Il y a aussi un <a class="is-external-link" href="https://github.com/bdring/fluidnc-config-files/tree/main/contributed/6x_CNC_Controller">repo GitHub avec quelques exemples.</a></p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-Yaml">`board: 6x
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
  # off_on_alarm: false`

</code></pre>
<h1 class="toc-header" id="source-files"><a href="#source-files" class="toc-anchor">¶</a> Fichiers sources</h1>
<p>Tout est open source.</p>
<ul>
<li><a class="is-external-link" href="https://oshwlab.com/bdring/6-pack-2-0_copy_copy_copy">Fichiers</a> de fabrication de PCB (EasyEDA)</li>
<li><a class="is-external-link" href="https://grabcad.com/barton.dring-2/models">Modèles</a> 3D (GradCAD)</li>
</ul>
<h1 class="toc-header" id="pinout-reference"><a href="#pinout-reference" class="toc-anchor">¶</a> Référence Pinout</h1>
<p><img alt="6x_pinout.png" src="/hardware/6x_pinout.png"></p>
</div></div>
