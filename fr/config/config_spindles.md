---
title: 1.14 Broche et VFD
description: configuration des borches et variateur
published: true
date: 2026-08-01T19:40:11.902Z
tags: fr
editor: markdown
dateCreated: 2025-03-16T12:01:26.388Z
---

<!DOCTYPE html><html><div class="page-contents v-content"><div class="contents"><div><h1 class="toc-header" id="spindles"><a href="#spindles" class="toc-anchor">¶</a> Broches</h1>
<p>Il supporte plusieurs broches sur une machine. Les broches peuvent être commandées par différentes interfaces matérielles comme les relais, PWM, DAC, ou RS485 interfaces série à VFD. Les lasers sont traités comme des broches.</p>
<p>Chaque broche se voit attribuer une gamme de numéros d'outils. Vous changez les broches en émettant la commande GCode « M6 Tn », avec le numéro de l'outil. Les numéros d'outil dans la plage assignée pour une broche donnée activeront cette broche et le numéro détaillé dans la gamme pourrait être utilisé pour sélectionner l'outil spécifique sur la broche. Cela vous permet, par exemple, d'avoir une seule machine avec une broche ATC et un laser. Un seul fichier GCode pourrait vous permettre de graver et de découper une partie. Vous pourriez également avoir un portique avec à la fois une broche à poulie à haut couple à basse vitesse et une broche à entraînement direct à haute vitesse.</p>
<h2 class="toc-header" id="h-0-10v"><a href="#h-0-10v" class="toc-anchor">¶</a> 0-10V</h2>
<img width="300" src="https://github.com/bdring/FluidNC/wiki/images/10V_spin_example.png">
<p>0-10V commande est conçue pour les contrôleurs de broche qui ont une entrée de commande 0-10V ainsi que des broches séparées pour l'avant et le sens inverse. Le ESP32 ne peut pas générer directement un signal 0 to 10V, mais certains contrôleurs de l'ENC ont un circuit adaptateur qui génère une tension analogique 0 to 10V à partir d'un ESP32 GPIO impulsé avec une forme d'onde de modulation de largeur d'impulsion (PWM). Le type de<a class="is-internal-link is-valid-page" href="/en/config/config_spindles#pwm"> broche PWM de base</a>  peut également être utilisé avec de tels adaptateurs matériels, mais il ne supporte pas de broches de direction avant et arrière séparées. Si vous n'avez pas besoin de ce style de contrôle de direction, vous pouvez utiliser le type de broche PWM.</p>
<ul>
    <li>
        <p><a id="pookie"></a><strong>forward_pin :</strong></p>
            <ul>
                <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#pin">Pin</a></li>
                <li>Gamme : gpio ou i2so</li>
                <li>Par défaut : NO_PIN</li>
                <li>Détail : Ceci est utilisé pour signaler la rotation avant si vous avez des broches séparées pour l'avant et l'inverse. Il peut rester allumé après M5, mais s'éteint après M4.</li>
            </ul>
    </li>
    <li>
        <p><a name="reverse_pin"></a><strong>reverse_pin :</strong></p><a name="reverse_pin"></a>
        <ul><a name="reverse_pin"></a>
            <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#pin">Pin</a>
            </li>
            <li>Gamme : gpio ou i2so</li>
            <li>Par défaut : NO_PIN</li>
            <li>Détails : Ceci est utilisé pour signaler la rotation inverse si vous avez des broches séparées pour l'avant et l'inverse. Il peut rester allumé après M5, mais s'éteint après M3.</li>
        </ul>
    </li>
    <li>
    <p><a name="pwm_hz"></a><strong>pwm_hz :</strong></p><a name="pwm_hz"></a>
        <ul><a name="pwm_hz"></a>
            <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#integer">Entier</a></li>
            <li>Plage : 1 à 20000000</li>
            <li>Par défaut : 5000</li>
            <li>Détails : C'est la fréquence du signal PWM. La précision (nombre de bits) du signal PWM est basée sur la fréquence. 20000000 ne vous donnera que 4 bits de précision. Chaque fois que vous divisez le pwm_freq par 2, vous obtenez un autre peu de précision.</li>
    </ul>
    </li>
    <li>
    <p><a name="output_pin"></a><strong>output_pin :</strong></p><a name="output_pin"></a>
        <ul><a name="output_pin"></a>
            <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#pin">Pin</a></li>
            <li>Gamme : gpio</li>
            <li>Par défaut : NO_PIN</li>
            <li>Détails : C'est la broche que le signal PWM de sortie est mis sur. Il s'éteint avec M5. La valeur<a href="#s0_with_disable"> 0_with_disable</a> peut affecter cette broche </li>
        </ul>
    </li>
    <li>
    <p><a name="enable_pin"></a><strong>enable_pin :</strong></p><a name="enable_pin"></a>
        <ul><a name="enable_pin"></a>
            <li>Type : <a class="is-external-link" href="https://github.com/bdring/FluidNC/wiki/FluidNC-Config-File-Overview#pin">Pin</a></li>
            <li>Gamme : gpio ou i2so</li>
            <li>Par défaut : NO_PIN</li>
            <li>Détails : Cette broche peut être utilisée comme broche de validation. La valeur<a href="#disable_with_s0"> disable_with_s0</a> peut affecter cette broche.</li>
        </ul>
    </li>
    <li>
        <p><a name="direction_pin"></a><strong>direction_pin :</strong></p><a name="direction_pin"></a>
        <ul><a name="direction_pin"></a>
            <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#pin">Pin</a></li>
            <li>Gamme : gpio ou i2so</li>
            <li>Par défaut : NO_PIN</li>
            <li>Détails :</li>
        </ul>
    </li>
    <li>
        <p><a name="disable_with_s0"></a><strong>disable_with_s0 :</strong></p><a name="disable_with_s0"></a>
        <ul><a name="disable_with_s0"></a>
            <li> Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#boolean">Booléen</a></li>
            <li>Défaut : faux</li>
            <li>Détails : Par défaut, la désactivation est contrôlée par M5. Si vous voulez également qu'il désactive lorsque la vitesse est réglée à 0 (S0), définissez ceci à true.</li>
        </ul>
    </li>
    <li>
        <p><a name="s0_with_disable"></a><strong>s0_with_disable :</strong></p><a name="s0_with_disable"></a>
        <ul><a name="s0_with_disable"></a>
            <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#boolean">Booléen</a></li>
            <li>Par défaut : true</li>
            <li>Détails : Par défaut, le signal de vitesse est contrôlé par la valeur de vitesse. Il restera allumé même en mode M5. Si vous voulez qu'il passe à la valeur S0 avec M5, définissez ceci à true.</li>
        </ul>
    </li>
    <li>
        <p><a name="spinup_ms"></a><strong>spinup_ms :</strong></p><a name="spinup_ms"></a>
        <ul><a name="spinup_ms"></a>
            <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#integer">Entier</a></li>
            <li>Plage : 0 à 20000 (millisecondes)</li>
            <li>Par défaut : 0</li>
            <li>Détails : C'est le temps qui sera donné pour que la broche tourne jusqu'à un régime maximal tel que défini dans la carte de vitesse. Le gcode suivant le changement de vitesse attendra que la rotation soit terminée. Le temps est proportionnel au changement de régime. Si le changement de RPM n'est que la moitié de la pleine échelle, le retard ne sera que la moitié de la valeur spinup_ms.</li>
        </ul>
    </li>
    <li>
        <p><a name="spindown_ms"></a><strong>spindown_ms :</strong></p><a name="spindown_ms"></a>
        <ul><a name="spindown_ms"></a>
            <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#integer">Entier</a></li>
            <li>Gamme : gpio</li>
            <li>Par défaut : 0 à 20000 (millisecondes)</li>
            <li>Détails : L'action est la même que <a href="#spinup_ms">spinup_ms</a> sauf qu'elle s'applique lorsque la valeur de RPM baisse.</li>
        </ul>
    </li>
    <li>
        <p><a name="tool_num"></a><strong>tool_num :</strong></p><a name="tool_num"></a>
        <ul><a name="tool_num"></a>
            <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#pin">Pin</a></li>
            <li>Plage : 0 à 255</li>
            <li>Par défaut : 0</li>
            <li>Détails : Cela définit la gamme de numéros d'outils pour cette broche. Si vous avez plusieurs broches, vous devez configurer une plage pour les deux broches. Lorsque vous spécifiez un numéro d'outil avec la commande gcode M6 Tnnn, il passera à l'outil qui couvre cette plage. La valeur maximale est 255. Voir <a class="is-internal-link is-valid-page" href="/en/config/config_spindles#using-multiple-spindles">plus ici</a></li>
        <ul>
            <li>Avec 1 Broche : Peu importe quelle est la valeur, mais définissez-la à 0.</li>
            <li>Avec plusieurs broches : Réglez la première broche à 0 et les autres broches à des valeurs plus élevées. Chaque broche devrait avoir un numéro unique. Si vous avez une broche relais avec <strong>tool_num : 0</strong> et un laser avec <strong>tool_num : 100,</strong> tous les numéros d'outils de 0 à 100 utiliseront le relais et tous les numéros d'outils de 100 à 255 utiliseront le laser. Envoyez M6T100 pour utiliser le laser.</li>
        </ul>
    </li>
    <li>
        <p><a name="speed_map"></a><strong>speed_map :</strong><p><a name="speed_map"></a>
        <ul><a name="speed_map"></a>
            <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#pin">Pin</a></li>
            <li>Détails : Cela vous permet d'affiner les vitesses. Vous pouvez linéariser le RPM vs. PWM sur toute la gamme et vous pouvez définir des vitesses minimales. C'est une fonctionnalité très complète qui a sa <a class="is-external-link" href="http://wiki.fluidnc.com/en/config/spindle_speed_maps">propre page.</a></li>
        </ul>
    </li>
    <li>
        <p><a name="off_on_alarm"></a><strong>off_on_alarm :</strong></p><a name="off_on_alarm"></a>
        <ul><a name="off_on_alarm"></a>
            <li>Type : <a class="is-internal-link is-invalid-page" href="/en/config/config_overview#boolean">Booléen</a></li>
            <li>Par défaut : false (fonctionne comme Grbl standard)</li>
            <li>Détails : Le fait de mettre cela à vrai va éteindre la broche chaque fois qu'une alarme se produit. Si vous utilisez une porte de sécurité, vous pouvez activer cela parce que la fonction de stationnement ne fonctionne pas en mode alarme.</li>
        </ul>
    </li>
</ul>
<p></p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">10V:
  forward_pin: gpio.13
  reverse_pin: gpio.17
  pwm_hz: 5000
  output_pin: gpio.4
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
<h3 class="toc-header" id="huanyang-registers-for-0-10v-control"><a href="#huanyang-registers-for-0-10v-control" class="toc-anchor">¶</a> Huanyang Registres pour le contrôle 0-10V</h3>
<ul>
<li>PD001 (Source des commandes d'exécution) Valeur 1 : (Terminal externe)</li>
<li>PD002 (Source de fréquence) Valeur 1 : (Potentiomètre externe)</li>
</ul>
<h2 class="toc-header" id="dac"><a href="#dac" class="toc-anchor">¶</a> CAD</h2>
<p>Le CAD utilise les ESP32 intégrés dans le matériel du CAD. Cela ne peut être utilisé que sur gpio.25 et gpio.26. Il délivre une tension analogique 0-3.3V (non PWM). Dans la plupart des cas, un PWM sera meilleur. La résolution DAC est de seulement 8 bits (0-255) et un PWM peut être jusqu'à 16 bits (0-65535).</p>
<p></p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">DAC:
  output_pin: gpio.25
  enable_pin: NO_PIN
  direction_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 100
  speed_map: 0=0.000% 255=100.000%
  off_on_alarm: false
</code></pre>
<h2 class="toc-header" id="using-rs485-to-control-spindles"><a href="#using-rs485-to-control-spindles" class="toc-anchor">¶</a> Utilisation de RS485 pour contrôler les broches</h2>
<p> Les cartes adaptatrices UART to RS485 sont peu coûteuses et fonctionnent généralement en courant continu 3.3V ou 5V.</p>
<p>Vous devez spécifier les paramètres UART dans une <a class="is-internal-link is-valid-page" href="/en/config/uart_sections">uart_section </a>du fichier config. Nous vous recommandons fortement de spécifier ceci comme un séparé <code>uart&lt;number&gt;</code> et se référer au numéro UART dans la configuration de votre broche en utilisant <code>uart_num</code>. L'ancienne façon de spécifier les paramètres UART à l'intérieur de la section broche ne vous a pas permis de définir le numéro UART et pourrait causer des conflits si vous définissiez plusieurs UART.</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">uart1:
  txd_pin: gpio.14
  rxd_pin: gpio.15
  rts_pin: gpio.13
  baud: 9600
  mode: 8N1
</code></pre>
<p> <code>rts_pin</code> est utilisé pour le contrôle de la direction des communications. Certaines puces d'adaptateur RS485 contrôlent automatiquement la direction et n'ont pas besoin d'un <code>rts_pin</code>.</p>
<p>Vous devriez alimenter votre adaptateur RS485 avec 3.3v. Sinon, les signaux de retour vers le ESP32 pourraient être endommagés.</p>
<h3 class="toc-header" id="rs485-wiring"><a href="#rs485-wiring" class="toc-anchor">¶</a> RS485 Câblage</h3>
<p>RS485 terminaux peuvent être étiquetés A et B ou + et -. Typiquement (A se connecte à -) et (B se connecte à +), mais beaucoup de gens ont trouvé que les 2 fils doivent être échangés. Souvent, il y a un fil de terre. La plupart des gens ont plus de chance sans connexion au sol entre le contrôleur et VFD. RS485 est un signal différentiel, il n'a donc pas besoin de référence au sol.</p>
<p>Vous devriez utiliser une paire de fils torsadés de 20 à 22 AWG. Si le câble est blindé connectez le fil de blindage à la masse à une extrémité seulement.</p>
<h2 class="toc-header" id="leds"><a href="#leds" class="toc-anchor">¶</a> LED</h2>
<p>Si vous avez Tx et Rx LED côté contrôleur, Tx devrait clignoter quelques fois par seconde. La LED Rx devrait clignoter juste après. Il le fait si rapidement qu'ils peuvent sembler cligner en même temps. Si la LED Rx reste allumée, essayez d'échanger A et B à l'extrémité du contrôleur.</p>
<h2 class="toc-header" id="variable-frequency-drives-vfd-controlled-with-rs485"><a href="#variable-frequency-drives-vfd-controlled-with-rs485" class="toc-anchor">¶</a> Lecteurs de fréquences variables (VFD) contrôlés avec RS485</h2>
<p>Ces broches sont commandées par une liaison RS485. Ajoutez une définition de haut niveau pour l'un des modèles VFD pris en charge à votre fichier config :</p>
<ul>
<li><a href="#huanyang-vfd-with-rs485"><code>Huanyang
</code></a></li>
<li><a href="#yl620-rs485"><code>YL620</code></a></li>
<li><a href="#h100-rs485"><code>H100</code></a></li>
<li><a href="#p2-series-inverters-rs485"><code>H2A</code></a></li>
<li><a href="#nowforever-rs485"><code>NowForever</code></a></li>
<li>Danfoss VLT 2800</li>
<li>Siemens v20</li>
</ul>
<p>VFD contrôlés avec RS486 sont un peu plus compliqués à mettre en place par rapport au contrôle PWM, mais ils offrent plusieurs avantages. Ils surveillent constamment la broche. S'il apparaît que la broche ne fonctionne pas à la vitesse spécifiée, le travail sera arrêté. Il est important que le VFD soit entièrement activé avant que le ESP32 ne soit activé. Certains prennent plusieurs secondes avant d'être prêts à communiquer. Ne pas faire le cycle de puissance du VFD lorsque le ESP32 est allumé. Il peut interrompre les communications et causer des problèmes.</p>
<blockquote class="is-info">
<p>Nous recommandons le Huanyang VFD pour les nouveaux utilisateurs. Les développeurs de micrologiciels de l'entreprise ont ce VFD et peuvent aider à déboguer les problèmes. Nous ne pouvons pas trop aider avec les autres types.</p>
</blockquote>
<blockquote class="is-info">
<p>La plupart des VFD peuvent également être commandés par un signal 0-10V. Cette méthode est plus facile à déboguer par de nouveaux utilisateurs avec un voltmètre simple.</p>
</blockquote>
<blockquote class="is-warning">
<p>La plupart des problèmes sont dus à des problèmes de matériel, de câblage ou de configuration VFD. Vérifiez le câblage RS485. Essayez d'échanger les lignes de données. Parfois, il fonctionne mieux sans le fil de terre. Assurez-vous que les paramètres VFD sont réglés correctement et que le RS485 est la source de contrôle primaire. RS485 peut être délicat et les développeurs de l'entreprise refuseront probablement d'aider avec du matériel bon marché et le câblage hacky.</p>
</blockquote>
<blockquote class="is-info">
<p><strong>VFD RS485 Message</strong> sans réponse Ceci est normal si votre VFD n'est pas connecté, pas alimenté ou connecté correctement. RS485 peut être compliqué pour les non-ingénieurs. Nous ne pouvons pas vous aider à corriger cela gratuitement <strong>(donnez sérieusement gros avant de demander). Veuillez lire l'Internet</strong> sur comment RS485 fonctionne et comment le câbler. </p>
</blockquote>
<h3 class="toc-header" id="the-best-way-to-get-started"><a href="#the-best-way-to-get-started" class="toc-anchor">¶</a> La meilleure façon de commencer.</h3>
<ol>
<li>
<p>Faites fonctionner votre VFD et votre broche en mode de contrôle manuel. Il n'est pas logique d'essayer RS485 jusqu'à ce que vous sachiez que le VFD fonctionne correctement. Testez tout, comme min RPM, max RPM, tournez vers le haut et vers le bas, en avant et en arrière.</p>
</li>
<li>
<p>Branchez votre adaptateur RS485 au VFD. Les appareils sont généralement étiquetés avec les symboles A et B ou + et -. Câblez les mêmes symboles ensemble. Si vous avez A/B à une extrémité et +/- à l'autre, A va à - et B va à +. Fil de terre à terre.</p>
</li>
<li>
<p>Si les choses ne fonctionnent pas, essayez de changer les fils A/B ou +/- à une extrémité. Si cela ne fonctionne pas, essayez d'enlever le fil de connexion au sol avec les deux combinaisons du câblage A/B, +/-.</p>
</li>
<li>
<p>Vérifiez que vous êtes en mode contrôle RS485. Vérifiez que les réglages de taux baud correspondent à chaque extrémité.</p>
</li>
</ol>
<h2 class="toc-header" id="huanyang-vfd-with-rs485"><a href="#huanyang-vfd-with-rs485" class="toc-anchor">¶</a> Huanyang VFD avec RS485</h2>
<p><a class="is-external-link" href="https://bulkman3d.com/wp-content/uploads/2019/01/HY01D523B-VFD-Manual.pdf">Manuel d'exploitation PDF</a></p>
  <br><img width="300" src="https://github.com/bdring/FluidNC/wiki/images/huanyang_std.png">
<p> C'est le Huanyang VFD standard (tous les niveaux de puissance). Les numéros de pièces commencent par Hy, comme HY02D223B-T. Le contrôle est via RS485.</p>
<p>Les registres VFD doivent être mis en place avant leur utilisation. Il ne changera aucun des registres. Lisez votre documentation VDF sur la façon de le faire. Voici quelques valeurs typiques qui fonctionnent pour la plupart des broches.</p>
<table>
<thead>
<tr>
<th>Register</th>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>PD001</td>
<td>2</td>
<td>RS485 Control of run command</td>
</tr>
<tr>
<td>PD002</td>
<td>2</td>
<td>RS485 Control of frequency</td>
</tr>
<tr>
<td>PD004</td>
<td>400.00</td>
<td>Base frequency as rated on spindle</td>
</tr>
<tr>
<td>PD005</td>
<td>400.00</td>
<td>Maximum frequency Hz (400Hz * 60sec/min = 24000rpm)</td>
</tr>
<tr>
<td>PD011</td>
<td>100.00</td>
<td>Minimum speed in Hz (Typ. Air cooled 120, Water cooled 100)</td>
</tr>
<tr>
<td>PD014</td>
<td>6.0</td>
<td>Acceleration time in seconds</td>
</tr>
<tr>
<td>PD015</td>
<td>6.0</td>
<td>Deceleration time</td>
</tr>
<tr>
<td>PD023</td>
<td>1</td>
<td>Enable reverse</td>
</tr>
<tr>
<td>PD141</td>
<td>220.0</td>
<td>Spindle Voltage</td>
</tr>
<tr>
<td>PD142</td>
<td>3.7</td>
<td>Max current (typ. 0.8kw=3.7)</td>
</tr>
<tr>
<td>PD143</td>
<td>2</td>
<td>Poles</td>
</tr>
<tr>
<td>PD144</td>
<td>3000</td>
<td>Revolutions at 50Hz</td>
</tr>
<tr>
<td>PD163</td>
<td>1</td>
<td>RS485 Modbus address</td>
</tr>
<tr>
<td>PD164</td>
<td>1</td>
<td>Baud rate of 9600</td>
</tr>
<tr>
<td>PD165</td>
<td>3</td>
<td>RS485 Mode RTU, 8N1</td>
</tr>
</tbody>
</table>

<p>Les vitesses min et max définies dans le VFD seront affichées dans les messages de démarrage. Ils peuvent être diffusés à travers les messages, parce qu'ils viennent d'une tâche distincte.</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-">[MSG:INFO: Huanyang PD005,PD011 Freq range (100,400) Hz (6000,24000) RPM]
[MSG:INFO: Huanyang PD144 Rated RPM @ 50Hz:3000]
[MSG:INFO: Huanyang PD143 Poles:2]
[MSG:INFO: Huanyang PD014 Accel:6.000]
[MSG:INFO: Huanyang PD015 Decel:6.000]
</code></pre>
<p>Une vitesse minimale est typique avec les broches VFD car elles manquent de puissance et peuvent surchauffer à des vitesses plus faibles. Un bon <a class="is-external-link" href="http://wiki.fluidnc.com/en/config/spindle_speed_maps"></a>réglage de linéarisation de vitesse pour les valeurs ci-dessus serait...</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">speed_map: 0=0% 0=25% 6000=25% 24000=100%
</code></pre>
<p>La vitesse minimale de 6000 est de 25 % de la vitesse maximale de 24000. Ce réglage signifierait que toutes les valeurs comprises entre 0 et 6000 donneraient toujours 6000 RPM.</p>
<p>Vérifiez la documentation de votre adaptateur RS485 pour connaître les méthodes de câblage et les connexions appropriées. <a class="is-external-link" href="https://github.com/bdring/6-Pack_CNC_Controller/wiki/RS485-Modbus-Module">Voici quelques informations sur le module RS485.</a></p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">uart1:
  txd_pin: gpio.14
  rxd_pin: gpio.15
  rts_pin: gpio.13
  baud: 9600
  mode: 8N1 
Huanyang:
  uart_num: 1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 0=25% 6000=25% 24000=100%
  off_on_alarm: false
</code></pre>
<blockquote class="is-info">
<p>Le VFD fournit de la rétroaction à l'Entremise NC. Nous nous en servons pour nous assurer que la broche tourne à la bonne vitesse. Si elle ne fonctionne pas à la vitesse demandée, elle s'arrête avec une alarme après quelques secondes. Cela pourrait être dû à de nombreuses raisons. Une raison est que le VFD a un réglage de fréquence max et min. Si vous demandez une vitesse inférieure au min, elle fonctionnera au minimum. La même condition s'applique au maximum. Par conséquent, si vous demandez une vitesse supérieure à 0, mais en dehors de la plage. La vitesse déclarée ne correspondra pas à votre vitesse demandée et s'arrêtera. Vous recevrez un message d'avertissement sur la console série pourquoi cela se produit. Ce problème peut être résolu en utilisant le bon type de <a class="is-external-link" href="http://wiki.fluidnc.com/en/config/spindle_speed_maps"> speed_map</a>.</p>
</blockquote>
<h2 class="toc-header" id="yl620-rs485"><a href="#yl620-rs485" class="toc-anchor">¶</a> YL620 (RS485)</h2>
<p>YL620 est un VFD chinois fabriqué par Yalang.</p><br>
<p><a class="is-external-link" href="https://bulkman3d.com/wp-content/uploads/2019/08/YL620-A-Inverter-Manual.pdf">Manuel</a></p><br>
  <img width="300" src="https://bulkman3d.com/wp-content/uploads/2021/11/1-1_proc-1.webp"><br>
<p>Ils peuvent être contrôlés par 0-10V analogique ou par RS485 (Modbus). </p>
<p>Les registres VFD doivent être mis en place avant leur utilisation. Il ne changera aucun des registres. Lisez votre documentation VFD sur la façon de le faire. Voici quelques valeurs typiques qui fonctionnent pour la plupart des broches.</p>
<p>Les valeurs de Hz données ci-dessous indiquent la fréquence qui est envoyée au moteur. <br> Moteur à 2 pôles tournera une fois par Hz, donc pour obtenir RPM vous multipliez Hz (cycles/sec) fois<br> 60 (sec/min). Donc un moteur à 2 pôles à 400 Hz tourne à 400 * 60 = 24 000 RPM nominalement. <br> pratique, il fonctionnera un peu plus lentement en raison d'un facteur réel appelé « glissement ». <br> le moteur nominal pourrait effectivement fonctionner à 23 500 sans charge et 23 000 tr/min sous charge.</p>
<table>
<thead>
<tr>
<th>Register</th>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>P00.00</td>
<td>4000</td>
<td>Main frequency in deci-HZ - 4000 is 400.0 Hz</td>
</tr>
<tr>
<td>P00.01</td>
<td>3</td>
<td>Command Source. 3 is for control via RS485</td>
</tr>
<tr>
<td>P03.00</td>
<td>3</td>
<td>RS485 Baud Rate. 3 is for 9600</td>
</tr>
<tr>
<td>P03.01</td>
<td>1</td>
<td>Modbus Address.  Typically you want to use 1.</td>
</tr>
<tr>
<td>P03.02</td>
<td>2</td>
<td>RS485 Data format. 2 is 8 data bits, 1 stop bit, no parity</td>
</tr>
<tr>
<td>P03.08</td>
<td>1000</td>
<td>Lowest frequency in deci-Hz - 1000 is 100.0Hz</td>
</tr>
</tbody>
</table>

<p>Une vitesse minimale est typique avec les broches VFD car elles manquent de puissance et peuvent surchauffer à des vitesses plus faibles. Un bon <a class="is-external-link" href="https://github.com/bdring/FluidNC/wiki/Spindle-Speed-Linearization"></a>réglage de linéarisation de vitesse pour les valeurs ci-dessus serait...</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">speed_map: 0=0% 0=25% 6000=25% 24000=100%
</code></pre>
<p>La vitesse minimale de 6000 est de 25 % de la vitesse maximale de 24000. Ce réglage signifierait que toutes les valeurs comprises entre 0 et 6000 donneraient toujours 6000 RPM.</p>
<p>Vérifiez la documentation de votre adaptateur RS485 pour connaître les méthodes de câblage et les connexions appropriées. <a class="is-external-link" href="https://github.com/bdring/6-Pack_CNC_Controller/wiki/RS485-Modbus-Module">Voici quelques informations sur le module RS485.</a></p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">uart1:
  txd_pin: gpio.14
  rxd_pin: gpio.15
  rts_pin: gpio.13
  baud: 9600
  mode: 8N1    
YL620:
  uart_num: 1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 0=25% 6000=25% 24000=100%
  off_on_alarm: false
</code></pre>
<p><strong>Notes</strong> importantes La VFD fournit de la rétroaction à la VFD. Nous nous en servons pour nous assurer que la broche tourne à la bonne vitesse. Si elle ne fonctionne pas à la vitesse demandée, elle s'arrête avec une alarme après quelques secondes. Cela pourrait être dû à de nombreuses raisons. Une raison est que le VFD a un réglage de fréquence max et min. Si vous demandez une vitesse inférieure au min, elle fonctionnera au minimum. La même condition s'applique au maximum. Par conséquent, si vous demandez une vitesse supérieure à 0, mais en dehors de la plage. La vitesse déclarée ne correspondra pas à votre vitesse demandée et s'arrêtera. Vous recevrez un message d'avertissement sur la console série pourquoi cela se produit. Ce problème peut être résolu en utilisant le bon type de <a class="is-external-link" href="http://wiki.fluidnc.com/en/config/spindle_speed_maps">speed_map.</a></p>
<h2 class="toc-header" id="h100-rs485"><a href="#h100-rs485" class="toc-anchor">¶</a> H100 (RS485)</h2>
<img width="300" src="https://github.com/bdring/FluidNC/wiki/images/h100_VFD.png"><br>
<p> Les numéros de pièces ressemblent généralement à H100-xxx.</p>
<p>Les registres VFD doivent être mis en place avant leur utilisation. Il ne changera aucun des registres. Lisez votre documentation VDF sur la façon de le faire.</p>
<p>Les sections les plus pertinentes sont les suivantes :</p>
<p>F011 (fréquence min)<br> F005 (fréquence max)<br> Les vitesses min et max définies dans le VFD seront affichées dans les messages de démarrage. Ils peuvent être diffusés à travers les messages, parce qu'ils viennent d'une tâche distincte.</p>
<p>[MSG : INFO : VFD : Vitesse maximale : 24000rpm]<br> [MSG : INFO : VFD : Vitesse min : 6000rpm]</p>
<p>Une vitesse minimale est typique avec les broches VFD car elles manquent de puissance et peuvent surchauffer à des vitesses plus faibles. </p>
<p>Si vous ne spécifiez pas le speed_map, le firmware mettra automatiquement les valeurs par défaut en fonction des fréquences qui sont définies dans le VFD. Spécifiez seulement un speed_map si vous utilisez une boîte de vitesses ou une autre contravention.</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">uart1:
  txd_pin: gpio.26
  rxd_pin: gpio.16
  rts_pin: gpio.4
  baud: 9600
  mode: 8N1
H100:
  uart_num: 1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 0=25% 6000=25% 24000=100%
</code></pre>
<h2 class="toc-header" id="p2-series-inverters-rs485"><a href="#p2-series-inverters-rs485" class="toc-anchor">¶</a> Inverseurs de la série P2 (RS485)</h2>
<img width="300" src="https://github.com/bdring/FluidNC/wiki/images/h2a.png">
<p>Les onduleurs de la série Huanyang P2, également nommés 'H2A/H2B/H2C' ou parfois 'P2A' sont également supportés. Ce produit a été conçu pour être la 2ème génération de l'onduleur Huanyang populaire de <a class="is-external-link" href="http://hy-electrical.com">hy-electrical.com</a>. Ces VFD sont petits, et les VFD de faible puissance sont généralement blancs ou gris. L'autocollant du côté de l'onduleur indique clairement qu'il s'agit de l'onduleur en question.</p>
<p>Le manuel peut malheureusement être un peu déroutant à certains moments quand il s'agit de mettre en place la connexion RS485.</p>
<p>Au sommet de la boîte se trouve un connecteur RS485 avec une borne à vis à 4 fils. Le câblage devrait utiliser ces 4 broches :</p>
<ul>
<li>GND = GND d'Arduino</li>
<li>A = RS + 485</li>
<li>B = RS-485</li>
<li>VCC = 5V d'Arduino</li>
</ul>
<p>Préférez utiliser un fil blindé pour le connecteur, et ne jamais exécuter ce fil à côté d'un fil 220V, pas à pas ou broche. En outre, broyer une extrémité du blindage.</p>
<p><strong>TOUJOURS lire</strong> le manuel pour les VFD ! Ceci est impératif pour obtenir la vitesse du moteur etc. tout correct. Les inverseurs de la série H2x utilisent des valeurs de RPM réelles, donc vous devez les définir en conséquence, ou l'appareil ne fonctionnera pas correctement. A côté de cela, vous devez définir certains paramètres pour que RS485 fonctionne correctement, notamment :</p>
<table>
<thead>
<tr>
<th>Setting</th>
<th>Value</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>F0.02</td>
<td>7</td>
<td>Set RS485 mode</td>
</tr>
<tr>
<td>F0.04</td>
<td>2</td>
<td>Set RS485 mode</td>
</tr>
<tr>
<td>F0.09</td>
<td>4</td>
<td>Set RS485 mode</td>
</tr>
<tr>
<td>F9.00</td>
<td>4</td>
<td>19200 baud</td>
</tr>
<tr>
<td>F9.01</td>
<td>0</td>
<td>8,N,1 parity</td>
</tr>
<tr>
<td>F9.02</td>
<td>1</td>
<td>ModBus address</td>
</tr>
<tr>
<td>F9.05</td>
<td>0</td>
<td>Non-standard modbus mode</td>
</tr>
<tr>
<td>F9.07</td>
<td>0</td>
<td>Write operations responded</td>
</tr>
</tbody>
</table>

<p>Nous recommandons de régler 19200,8N1 pour ce VFD. Pendant la synchronisation des broches, il peut y avoir un peu de communication, et 2400 baud pourrait vous mettre en difficulté. 19200 est plus que suffisant pour tout ce que vous voulez jeter sur un VFD. Utiliser des taux de baud encore plus élevés entraînera probablement juste des erreurs.</p>
<h2 class="toc-header" id="nowforever-rs485"><a href="#nowforever-rs485" class="toc-anchor">¶</a> CentreForever (RS485)</h2>
<p>Fabricant : Shenzhen CentreForever Electronics Technology CO., LTD.<br> Site web : <a class="is-external-link" href="http://www.nowforever.cn/">http://www.nowforever.cn/</a></p>
<p><img alt="D/E Series picture" src="http://www.nowforever.cn/upload/image/E100-1.png"></p>
<p>La série D de VFD se trouve dans la boîte de contrôle des routeurs chinois CNC6040 cnc.<br> Malheureusement, il n'y a pas de manuel pour la série D, donc toutes ces informations sont basées sur le manuel pour la série E.<br> Cependant, il y a un tableau de comparaison fait par quelqu'un d'autre qui montre que presque tous les paramètres sont les mêmes.</p>
<p>Le manuel de la série E peut être trouvé en ligne à différents endroits en recherchant le <em>manuel</em> de la série e100 de la recherche en utilisant votre moteur de recherche préféré.<br> Tableau de comparaison (allemand, contient également un lien pour le manuel de la série e) : <a class="is-external-link" href="http://moh-computer.de/frequenzumformer-parameter/">http://moh-computer.de/frequenzumformer-parameter/</a></p>
<p><br> Il devrait également fonctionner pour d'autres VFD de la série D ainsi que pour la série E puisque son manuel a été utilisé pour la référence des paramètres et des détails du protocole.</p>
<p>Si le contrôle du VFD par RS485 ne fonctionne pas pour une raison ou une autre, les séries D et E supportent également une interface 0-10V.<br> Il s'agit notamment de contrôler la direction par une autre entrée du VFD. (Voir le manuel pour plus de détails)</p>
<p>Voici une sélection des paramètres nécessaires pour faire communiquer les VFD (séries D et E) avec la Société NC :</p>
<p><strong>Sélection de RS485 comme source de contrôle et de fréquence :</strong></p>
<table>
<thead>
<tr>
<th>Register</th>
<th>Value</th>
<th>Description</th>
<th>Possible Values</th>
</tr>
</thead>
<tbody>
<tr>
<td>P0-000</td>
<td>2</td>
<td>Command source</td>
<td>0: Keypad<br>1: Control inputs<br>2: RS485</td>
</tr>
<tr>
<td>P0-001</td>
<td>0</td>
<td>Frequency source</td>
<td>0: main frequency source<br>1: auxiliary frequency source<br>2: main + aux<br>3: max(main, aux)<br>4: selectd by control input</td>
</tr>
<tr>
<td>P0-002</td>
<td>6</td>
<td>Main frequency source selection</td>
<td>0: Keypad Potentiometer<br>1: Keypad Up Down Arrow<br>2: AIN1<br>3: AIN2<br>4: Multistep speed<br>5: PID<br>6: RS485<br>7: Internal PLC</td>
</tr>
</tbody>
</table>
<p><strong>RS485 parameters:</strong></p>
<table>
<thead>
<tr>
<th>Register</th>
<th>Value</th>
<th>Description</th>
<th>Possible Values</th>
</tr>
</thead>
<tbody>
<tr>
<td>P0-055</td>
<td>any free address between 1 and 31</td>
<td>Address of VFD</td>
<td>1- 31: slave addresses<br>2: master address</td>
</tr>
<tr>
<td>P0-056</td>
<td>2 works just fine</td>
<td>Baudrate</td>
<td>0: 2400bps<br>1: 4800bps<br>2: 9600bps<br>3: 19200bps<br>4: 38400bps</td>
</tr>
<tr>
<td>P0-057</td>
<td>0</td>
<td>Data framing</td>
<td>0:1 start bit, 8 data bits, no parity, 1 stop bit<br>1: 1 start bit, 8 data bits, even parity, 1 stop bit<br>2: 1 start bit, 8 data bits, odd parity, 1 stop bit</td>
</tr>
</tbody>
</table>
<p><strong>Setting min and max speed:</strong></p>
<table>
<thead>
<tr>
<th>Register</th>
<th>Value</th>
<th>Description</th>
<th>Possible Values</th>
</tr>
</thead>
<tbody>
<tr>
<td>P0-007</td>
<td>Whatever your spindle can handle</td>
<td>Max frequency</td>
<td>Min frequency - 600hz</td>
</tr>
<tr>
<td>P0-008</td>
<td>Whatever your spindle can handle</td>
<td>Min frequency</td>
<td>0 - Max frequency</td>
</tr>
</tbody>
</table>
<p><strong>The following registers are read / written to by FluidNC:</strong></p>
<p><strong>Read access only:</strong></p>
<table>
<thead>
<tr>
<th>Register</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>0x007</td>
<td>Max frequency in hz * 100, same as config parameter P0-007</td>
</tr>
<tr>
<td>0x008</td>
<td>Min frequency in hz * 100, same as config parameter P0-008</td>
</tr>
<tr>
<td>0x300</td>
<td>Current fault number<br>0 = no fault<br>1-18 = fault number</td>
</tr>
<tr>
<td>0x500</td>
<td>VFD status<br>Bit 0: run, 1=run, 0=stop<br>Bit 1: direction, 1=ccw, 0=cw<br>Bit 2: control, 1=local, 0=remote<br>Bit 3: sight fault, 1=fault, 0=no fault<br>Bit 4: fault, 1=fault, 0=no fault<br>Bit 5-15: reserved</td>
</tr>
<tr>
<td>0x502</td>
<td>Current output frequency in hz * 100</td>
</tr>
</tbody>
</table>
<p><strong>Write access only:</strong></p>
<table>
<thead>
<tr>
<th>Register</th>
<th>Description</th>
</tr>
</thead>
<tbody>
<tr>
<td>0x900</td>
<td>VFD control<br>Bit 0: run, 1=run, 0=stop<br>Bit 1: direction, 1=ccw, 0=cw<br>Bit 2: jog, 1=jog, 0=stop<br>Bit 3: reset, 1=reset, 0=dont reset<br>Bit 4-15: reserved</td>
</tr>
<tr>
<td>0x901</td>
<td>Speed to be set in hz * 100</td>
</tr>
</tbody>
</table>

<p>Exemple YAML config :</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">uart1:
  txd_pin: gpio.14
  rxd_pin: gpio.15
  rts_pin: gpio.13
  baud: 9600
  mode: 8N1   
NowForever:
  uart_num: 1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 24000=100%
  off_on_alarm: false
</code></pre>
<h2 class="toc-header" id="danfoss-vlt-2800"><a href="#danfoss-vlt-2800" class="toc-anchor">¶</a> Danfoss VLT 2800</h2>
<p>Contribution via ce <a class="is-external-link" href="https://github.com/bdring/FluidNC/pull/1128">PR</a></p>
<h2 class="toc-header" id="siemens-v20"><a href="#siemens-v20" class="toc-anchor">¶</a> Siemens v20</h2>
<p>Contribution via ce <a class="is-external-link" href="https://github.com/bdring/FluidNC/pull/457">PR</a></p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">SiemensV20:
  uart:
    txd_pin: gpio.17
    rxd_pin: gpio.16
    rts_pin: gpio.4
    baud: 9600
    mode: 8E1
  modbus_id: 1
  tool_num: 0
  speed_map: 0=0% 24000=100%
</code></pre>
<h2 class="toc-header" id="generic-modbusvfd-rs485"><a href="#generic-modbusvfd-rs485" class="toc-anchor">¶</a> (Générique) ModbusVFD (RS485)</h2>
<p>En spécifiant le format de certaines commandes Modbus via des éléments config, vous pouvez utiliser RS485 VFD qui ne sont pas déjà pris en charge. Vous pouvez spécifier le format de chaque commande Modbus en incluant les éléments config dans la section ModbusVFD. Pour certains types de VFD, nous savons déjà quels devraient être les formats de commande, donc au lieu de spécifier toutes les commandes, vous pouvez simplement définir <strong>l'élément modèle au</strong> nom du VFD, et les éléments de configuration de commande seront pré-remplis - mais vous pouvez les remplacer. Les éléments de configuration pertinents sont les suivants :</p>
<ul>
<li><strong><a href="#model">modèle :</a></strong> Une chaîne nommant le modèle VFD. Si la <strong>valeur</strong> du modèle correspond à l'un des modèles VFD prédéfinis qui sont connus de la société, les différents <strong></strong>éléments _ cmd seront pré-remplis avec les valeurs que nous pensons correctes, donc vous n'avez pas besoin de les spécifier. Si vous spécifiez un tel <strong></strong>élément _ cmd, il remplacera la valeur fournie par le système. Si <strong>le modèle ne correspond pas</strong> à un modèle connu, vous devez spécifier explicitement tous les <strong></strong>éléments _ cmd.  Le nom correspondant est insensible au cas par cas, donc la capitalisation n'a pas d'importance</li>.
<li><strong><a href="#cw_cmd">cw_cmd :</a></strong> Un modèle de commande Modbus indiquant au VFD de courir dans le sens des aiguilles d'une montre (vers l'avant).</li>
<li><strong><a href="#ccw_cmd">ccw_cmd :</a></strong> Un modèle de commande Modbus indiquant au VFD de tourner dans le sens inverse des aiguilles d'une montre.</li>
<li><strong><a href="#off_cmd">off_cmd :</a></strong> Un modèle de commande Modbus indiquant au VFD d'arrêter de fonctionner.</li>
<li><strong><a href="#set_rpm_cmd">set_rpm_cmd :</a></strong> Un modèle de commande Modbus indiquant au VFD de fonctionner à une vitesse donnée.</li>
<li><strong><a href="#max_rpm_cmd">get_max_rpm_cmd :</a></strong> Un modèle de commande Modbus pour récupérer la vitesse maximale pour laquelle le VFD est configuré.</li>
<li><strong><a href="#min_rpm_cmd">get_min_rpm_cmd :</a></strong> Un modèle de commande Modbus pour récupérer la vitesse minimale pour laquelle le VFD est configuré.</li>
<li><strong><a href="#get_rpm_cmd">get_rpm_cmd :</a></strong> Un modèle de commande Modbus pour récupérer la vitesse de fonctionnement VFD courante.</li>
<li><strong><a class="is-internal-link is-invalid-page" href="/en/config/config_spindles/debug">debug :</a></strong> Un entier qui contrôle les messages de débogage du sous-système VFD. Sa valeur par défaut de 0 ne signifie pas de débogage supplémentaire. Le paramétrer à 3 permet d'ajouter des messages montrant des commandes Modbus qui sont envoyées et reçues<strong>. debug</strong> s'applique non seulement au pilote ModbusVFD générique, mais aussi à d'autres RS485 VFD. Si vous définissez <strong>debug</strong> à un niveau plus élevé, vous devrez également envoyer $ message/level = debug pour permettre aux messages de déboguer de s'afficher</li>.
<li><strong><a class="is-internal-link is-invalid-page" href="/en/config/config_spindles/poll_ms">poll_ms :</a></strong> Un entier qui contrôle le temps entre les sondages VFD et les sondages. Sa valeur par défaut de 250 est bonne pour travailler VFD mais lorsque vous déboguez un nouveau VFD, il peut être préférable de le mettre à une valeur beaucoup plus grande comme 4000 pour éviter les messages trop fréquents lorsque les choses ne fonctionnent pas et donc causer beaucoup de rebondissements.</li>
<li>* <a class="is-internal-link is-invalid-page" href="/en/config/config_spindles/retries">* retries</a> :: Un entier qui contrôle le nombre de retries d'une commande défaillante avant que le VFD ne soit jugé non réactif. Sa valeur par défaut est</li> 5.
</ul>
<p>Les vitesses sont données en RPM, converties vers et à partir d'unités spécifiques à l'appareil via des spécificateurs d'échelle dans les modèles de commande. La plupart VFD spécifient des vitesses en unités de Hz, éventuellement à l'échelle d'un facteur 10 ou 100. Pour convertir de Hz en RPM, vous multiplieriez par 60 (secondes par minute). Si le VFD utilise deciHz (Hz * 10), vous multiplierez par 60 et diviserez par 10 - ou vous pourriez juste multiplier par 6.</p>
<h3 class="toc-header" id="modbus-command-templates"><a href="#modbus-command-templates" class="toc-anchor">¶</a> Modbus Templates de commande</h3>
<p>En général, une commande Modbus standard consiste en un « modbus ID » d'un octet suivi de quelques octets de commande et de données, suivi de deux octets de contrôle CRC. Le modbus ID et le CRC sont traités par code commun de sorte que le modèle de commande ne les spécifie pas.</p>
<p>Le standard Modbus définit quelques formats de commande communs, mais différents VFD sont très lâches dans leurs interprétations de la façon de les utiliser, de sorte que le format Template de commande vous permet de spécifier les octets exacts à envoyer et à recevoir. Voici un exemple d'une commande simple qui ne contient aucune donnée variable :</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-">  cw_cmd: 06 20 00 00 12 &gt; echo
</code></pre>
<p>Le pilote ModbusVFD enverrait l'octet modbus_id, puis les octets hex 0x06, 0x20, 0x00, 0x00, 0x12, suivi du CRC. Il s'attend alors à recevoir une réponse VFD qui est la même que la commande, d'où « écho ». En général, la séquence reçue n'est pas nécessairement la même que la commande, donc vous devrez souvent spécifier autre chose que « echo ».</p>
<p>Les commandes peuvent envoyer ou recevoir des valeurs de vitesse RPM. Dans cet exemple, nous envoyons la vitesse à l'échelle des appareils de déciHz (le VFD représente 400 Hz comme 4000).</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-">  set_rpm_cmd: 06 20 01 rpm*10/60 &gt; echo
</code></pre>
<p>Le pilote enverrait l'octet modbus_id, suivi des octets hex 0x06, 0x20 et 0x01. Il convertirait la vitesse demandée en RPM aux unités du dispositif en multipliant par 10 (deciHx par Hz) et en divisant par 60 (secondes par minute) et en envoyant le nombre résultant (deux octets), suivi des octets de contrôle CRC. Dans les spécificateurs d'échelle, la multiplication, si elle est présente, doit précéder la division. Les deux sont facultatifs. Dans cet exemple, * 10/60 est équivalent à/6, donc vous pouvez écrire juste rpm/6. « &gt; echo » signifie à nouveau que ce VFD répond à de telles commandes en les répétant.</p>
<p>Cet exemple reçoit une valeur de vitesse :</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-">get_rpm_cmd: 03 20 0b 00 01 &gt; 03 02 rpm*60/10
</code></pre>
<p>Le pilote enverrait la commande fixe modbus_id, 0x03, 0x20, 0x0b, 0x00, 0x01, CRC, puis s'attendait à recevoir la réponse modbus_id, 0x03, 0x02, (données de 2 octets), CRC. Les deux octets de données sont combinés en un entier de 16 bits et ramenés des unités de périphériques à RPM en multipliant par 60 et en divisant par 10 - l'inverse de l'échelle de RPM à unités de périphériques.</p>
<p>En plus de « rpm », vous pouvez spécifier « minrpm » dans la commande get_min_rpm et « maxrpm » dans le get_max_rpm_command. Pour certains VFD, il est possible d'obtenir les vitesses min et max avec une seule commande. Cet exemple fonctionne pour un VFD :</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-">   get_max_rpm_cmd:  03 03 08 00 02 &gt; 03 04 minrpm*6 maxrpm*6
</code></pre>
<p>Si vous pouvez obtenir les deux min et max dans une commande, il n'est pas nécessaire de spécifier get_min_rpm_cmd ; juste utiliser get_max_rpm_cmd pour les deux. Pour la plupart des VFD cela ne sera pas possible donc vous aurez besoin des deux commandes.</p>
<p>Le pilote ModbusVFD générique peut en fait être utilisé pour exécuter la plupart des déjà pris en charge. Voici un exemple complet pour YL620 :</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">ModbusVFD:
  uart_num: 1
  modbus_id: 1
  model: YL620
  cw_cmd: 06 20 00 00 12 &gt; echo
  ccw_cmd: 06 20 00 00 22 &gt; echo
  off_cmd: 06 20 00 00 01 &gt; echo
  set_rpm_cmd: 06 20 01 rpm*10/60 &gt; echo
  get_max_rpm_cmd: 03 03 09 00 01 &gt; 03 02 maxrpm*60/10
  get_min_rpm_cmd: 03 03 08 00 01 &gt; 03 02 minrpm*60/10
  get_rpm_cmd: 03 20 0b 00 01 &gt; 03 02 rpm*60/10
</code></pre>
<p>D'autres éléments communs de configuration de broche comme <strong>tool_num</strong>, <strong>spinup_ms</strong>, <strong>spindown_ms, m6_macro</strong><strong>, atc, disable_with_s0</strong> et <strong>s0_with disable</strong> peuvent également être spécifiés. Si get_rpm_cmd est présent, spinup_ms et spindown_ms sont ignorés, puisque le conducteur utilisera get_rpm_cmd pour déterminer quand le VFD a atteint la vitesse cible.</p>
<p>Il n'est pas nécessaire de spécifier speed_map, puisque le conducteur construira automatiquement une base speed_map appropriée sur les valeurs de TPM min et max.</p>
<p>Si votre VFD est incapable de déclarer des valeurs min et/ou max de RPM, il est possible de les spécifier explicitement via <strong>min_rpm et/ou</strong> <strong>max_rpm config</strong> items avec des valeurs entières données en unités de RPM. C'est un cas inhabituel ; des VFD que j'ai étudiés, tous peuvent rapporter max RPM, et tous sauf un peuvent rapporter min RPM.</p>
<h3 class="toc-header" id="scaling-specifiers"><a href="#scaling-specifiers" class="toc-anchor">¶</a> Spécificateurs d'échelle</h3>
<p>Les éléments de données nommés « rpm », « minrpm » ou « maxrpm » peuvent être mis à l'échelle des appareils VFD avec un « spécificateur d'échelle » du formulaire :</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-bnf">[%][*N][/N]
</code></pre>
<p>où [...] indique que le champ est facultatif et N est un nombre entier décimal. Si la donnée apparaît dans la commande sortante - avant le « &gt; » - l'échelle est appliquée à la valeur en RPM pour convertir en unités de périphérique, et la valeur convertie est insérée dans le paquet sortant. Le seul nom d'élément qui peut être utilisé pour les données sortantes est &quot;rpm&quot;, dans * * set _ rpm _ command &quot;. Si la donnée apparaît dans la réponse - après le '&gt;' - la valeur de l'unité périphérique est récupérée à partir du paquet de réponse puis portée à RPM. Tous les noms des articles sont disponibles pour les réponses.</p>
<p><code>*N</code> provoque la multiplication par le nombre décimal <strong>N</strong>.  <code>/N</code> provoque la division par le nombre décimal <strong>N.</strong> Pour les quelques VFD qui représentent les valeurs de vitesse en pourcentage de la vitesse maximale, <code>%</code> multiplie par 100 et divise par vRPM, calculant ainsi le pourcentage, qui peut alors être multiplié et/ou divisé par une constante.  <code>%</code> ne fonctionne correctement <strong>que dans set_rpm_command, pour les</strong> commandes sortantes.</p>
<h4 class="toc-header" id="details-of-scaling-operations"><a href="#details-of-scaling-operations" class="toc-anchor">¶</a> Détails des opérations de mise à l'échelle</h4>
<ul>
<li>Pour <strong>obtenir.. commandes</strong>, la valeur de 16 bits est extraite du paquet de réponse VFD. Le diviseur est réglé à 1. Si la spécification d'échelle commence par '%', la valeur est multipliée par 100. Ensuite, si l'élément suivant dans le spécificateur d'échelle est '* N', la valeur est multipliée par N. Alors, si l'élément suivant dans le spécificateur d'échelle est '/N ', la valeur est divisée par N. Enfin, la valeur est stockée dans la variable nommée (minrpm, maxrpm, ou rpm). (La notation « % » est rarement utilisée pour <em>obtenir</em> des opérations.)</li>
<li>Pour <strong>set_rpm_command,</strong> le diviseur est réglé à 1. Si la spécification de mise à l'échelle commence par '%', la valeur d'entrée est multipliée par 100 et le diviseur est réglé à TPM. Ensuite, si l'item suivant dans le spécificateur de mise à l'échelle est '* N', la valeur est multipliée par N. Alors, si l'item suivant dans le spécificateur de mise à l'échelle est '/N ', le diviseur est multiplié par N. Enfin, la valeur est divisée par le diviseur puis stockée dans le paquet copmmand VFD. (Reporter la division réelle jusqu'à la fin évite la perte de précision entière.)</li>
</ul>
<h3 class="toc-header" id="more-examples-of-using-modbusvfd"><a href="#more-examples-of-using-modbusvfd" class="toc-anchor">¶</a> Plus d'exemples d'utilisation de ModbusVFD</h3>
<h4 class="toc-header" id="huanyang-tested"><a href="#huanyang-tested" class="toc-anchor">¶</a> Huanyang (testé)</h4>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">ModbusVFD
  uart_num: 1
  modbus_id: 1
  model: Huanyang
  cw_cmd: 03 01 01 &gt; echo
  ccw_cmd: 03 01 11 &gt; echo
  off_cmd: 03 01 08 &gt; echo
  set_rpm_cmd: 05 02 rpm*100/60 &gt; echo
  get_min_rpm_cmd: 01 03 0b 00 00 &gt; 01 03 0B minRPM*60/100
  get_max_rpm_cmd: 01 03 05 00 00 &gt; 01 03 05 maxRPM*60/100
  get_rpm_cmd: 04 03 01 00 00 &gt; 04 03 01 rpm*60/100

</code></pre>
<h4 class="toc-header" id="nowforever-untested"><a href="#nowforever-untested" class="toc-anchor">¶</a> CentreForever (non testé)</h4>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">ModbusVFD
  uart_num: 1
  modbus_id: 1
  model: NowForever
  cw_cmd: 10 09 00 00 01 02 00 01 &gt; 10 09 00 00 02
  ccw_cmd: 10 09 00 00 01 02 00 03 &gt; 10 09 00 00 02
  off_cmd: 10 09 00 00 01 02 00 00 &gt; 10 09 00 00 02
  set_rpm_cmd: 10 09 01 00 01 02 rpm/60  &gt; 10 09 01 00 02
  get_max_rpm_cmd: 03 00 07 00 02 &gt; 03 04 maxrpm*60 minrpm*60
  get_rpm_cmd: 03 05 02 00 01 &gt; 03 02 rpm*60

</code></pre>
<h4 class="toc-header" id="h100-untested"><a href="#h100-untested" class="toc-anchor">¶</a> H100 (non testé)</h4>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">ModbusVFD
  uart_num: 1
  modbus_id: 1
  model: H100
  cw_cmd:  05 00 49 ff 00 &gt; 05 00 49 ff 00
  ccw_cmd: 05 00 4a ff 00 &gt; 05 00 4a ff 00
  off_cmd: 05 00 4b ff 00 &gt; 05 00 4b ff 00
  set_rpm_cmd: 06 02 01 rpm*100/60  &gt; echo
  get_max_rpm_cmd: 03 00 05 00 01 &gt; 03 02 maxrpm*60/100
  get_min_rpm_cmd: 03 00 0b 00 01 &gt; 03 02 minrpm*60/100
  get_rpm_cmd: 03 02 20 00 01 &gt; 03 02 rpm*60/100

</code></pre>
<h4 class="toc-header" id="h2a-untested"><a href="#h2a-untested" class="toc-anchor">¶</a> H2A (non testé)</h4>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">ModbusVFD
  uart_num: 1
  modbus_id: 1
  model: H2A
  cw_cmd:  06 20 00 00 01 &gt; echo
  ccw_cmd: 06 20 00 00 02 &gt; echo
  off_cmd:  06 20 00 00 06 &gt; echo
  set_rpm_cmd: 06 10 00 rpm%*100  &gt; echo
  get_max_rpm_cmd: 03 b0 05 00 01 &gt; 03 00 02 maxrpm*60
  get_min_rpm_cmd: 
  get_rpm_cmd: 03 70 0c 00 01 &gt; 03 00 02 rpm*??

</code></pre>
<h4 class="toc-header" id="siemensv20-untested"><a href="#siemensv20-untested" class="toc-anchor">¶</a> SiemensV20 (non testé)</h4>
<p>Note : La cartographie du numéro de registre dans la documentation de Siemens est très confuse donc je ne suis pas sûr des commandes min et max tpm.</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">ModbusVFD
  uart_num: 1
  modbus_id: 1
  model: SiemensV20
  cw_cmd: 06 00 63 0c 7f &gt; echo
  ccw_cmd: 06 00 63 04 7f &gt; echo
  off_cmd: 06 00 63 0c 7e &gt; echo
  set_rpm_cmd: 06 00 64 rpm  &gt; echo
  get_max_rpm_cmd: 03 10 82 00 01 &gt; 03 02 rpm*60/100
  get_min_rpm_cmd: 03 10 80 00 01 &gt; 03 02 rpm*60/100
  get_rpm_cmd: 03 00 6e 00 01 &gt; 03 02 rpm

</code></pre>
<h3 class="toc-header" id="folinn-bd600"><a href="#folinn-bd600" class="toc-anchor">¶</a> Folinn BD600</h3>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">board: 6x CNC Controller
name: PortalCnc by MP (@snoozemoose on Discord)
## Begin Folinn_BD600_24kRPM_@800Hz
##
# Manual where all commands are specified: https://cononmotor.com.au/wp-content/uploads/2017/09/BD600-Manual.pdf
# Initial note: This spindle defines CCW as forward running.
#
### GENERIC FORMULA FOR ANY AC MOTOR ###
# RPM = 60 x 2 x Hz / NumPoles
# Hz = RPM x NumPoles / 120
#
# This GPenny spindle has 4 poles, max Hz is 800, max rpm is 24k.
# 4 poles gives Hz = RPM * 4 /120 = RPM / 30
#
### Device speed _SET_ operation ###
# The value to send is the percentage of max Hz * 100 which is calulated as:
#   targetHz / maxHz * 100 * 100
# Note; The RPM percentage of max RPM is exactly the same as the Hz percentage of max Hz.
# Note2; 100 percent is here defined as 100, not 1.0
# 
# Example; setting a speed of 3k RPM (same as 100 Hz in this case) 
# calculates to (3 / 24 * 100) * 100 = 1250. 
# Using Hz we get the same result: (100 / 800 * 100) * 100 = 1250
#
# The set_rpm_cmd command therefore shall send the value RPM / maxRPM * 100 * 100 which is defined as:
#    rpm%*100 using the syntax of FluidNC Generic ModbusVFD
#
### Device speed _GET_ operation ### 
# The value received from the VFD for all fetch operations are defined as:
#    currentHz * 10
# Given that this VFD and Spindle has the formula RPM = Hz * 30 (see above), 
# the RPM is calculated from the received value as follows:
#    receivedValue = currentHz * 10
#    currentHz = receivedValue / 10
# And since RPM = Hz * 30
#    RPM = receivedValue / 10 * 30 
#    RPM = receivedValue * 3
# Therefore, the get rpm commands defines the value calculation as:
#    rpm*3 using the syntax of FluidNC Generic ModbusVFD
uart1:
  txd_pin: gpio.15
  rxd_pin: gpio.16
  rts_pin: gpio.14
  cts_pin: NO_PIN
  baud: 9600
  mode: 8N1
ModbusVFD:
  spinup_ms: 500
  spindown_ms: 1000
  uart_num: 1
  modbus_id: 1
  model: Folinn_BD600_24kRPM_@800Hz
  cw_cmd: 06 10 00 00 02 &gt; echo
  ccw_cmd: 06 10 00 00 01 &gt; echo
  off_cmd: 06 10 00 00 06 &gt; echo
  set_rpm_cmd: 06 30 00 rpm%*100 &gt; echo
  get_min_rpm_cmd: 03 F0 05 00 01 &gt; 03 02 minRPM*3
  get_max_rpm_cmd: 03 F0 04 00 01 &gt; 03 02 maxRPM*3
  get_rpm_cmd: 03 30 01 00 01 &gt; 03 02 rpm*3
</code></pre>
<h2 class="toc-header" id="pwm"><a href="#pwm" class="toc-anchor">¶</a> PWM</h2>
<p>La commande M4 (axe inversé) ne sera acceptée que si une broche de direction est affectée à une broche d'entrée/sortie.</p>
<img width="300" src="https://github.com/bdring/FluidNC/wiki/images/pwm_spindle.png">
<ul>
<li><strong><a href="#output_pin">output_pin :</a></strong></li>
<li><strong><a href="#output_pin">direction_pin :</a></strong></li>
<li><strong><a href="#output_pin">enable_pin :</a></strong></li>
<li><strong><a href="#pwm_hz">pwm_hz :</a></strong></li>
<li><strong><a href="#disable_with_s0">disable_with_s0 :</a></strong></li>
<li><strong><a href="#s0_with_disable">s0_with_disable :</a></strong></li>
<li><strong><a href="#spinup_ms">spinup_ms :</a></strong></li>
<li><strong><a href="#spindown_ms">spindown_ms :</a></strong></li>
<li><strong><a href="#tool_num">tool_num :</a></strong></li>
<li><strong><a href="#speed_map">speed_map :</a></strong></li>
</ul>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">pwm:
  pwm_hz: 5000
  direction_pin: NO_PIN
  output_pin: gpio.14
  enable_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 0
  speed_map: 0=0.000% 10000=100.000%
  off_on_alarm: false
</code></pre>
<h2 class="toc-header" id="besc"><a href="#besc" class="toc-anchor">¶</a> BESC</h2>
<img width="300" src="https://github.com/bdring/FluidNC/wiki/images/besc_example.jpg">
<p>BESC signifie « contrôleur électronique de vitesse Brushless » du type utilisé pour alimenter les moteurs à hélice des avions, hélicoptères et drones radiocommandés de type passe-temps. Ces moteurs peuvent être utilisés pour des broches à grande vitesse sur des machines légères qui n'ont pas de charges latérales importantes pour les outils. Ils utilisent le même type de signal PWM qu'un servo RC. Le PWM classique contrôle la puissance en réglant le rapport cyclique entre 0 % et 100 %, tandis que le RC servo PWM règle la longueur d'impulsion entre (typiquement) 1 ms (pour le moteur hors tension) et 2 ms (moteur plein allumage) dans une période de répétition d'impulsions d'environ 20 m. Une seule broche d'entrée/sortie capable de PWM est nécessaire. Il doit s'agir d'une broche de sortie numérique qui présente la forme d'onde PWM brute, et non d'une sortie PWM-analogique qui crée une tension continue variable par filtrage passe-bas de la forme d'onde PWM.</p>
<p>Les versions antérieures de l'appareil avaient un <strong></strong>type spécial de broche BESC, mais nous nous sommes rendu compte qu'avec des paramètres de configuration appropriés pour <strong>pwm_hz et</strong> <strong>speed_map</strong>, le <a href="#pwm"><strong></strong></a>type de broche PWM fonctionne parfaitement pour BESC.</p>
<p>Le taux habituel de répétition d'impulsions pour BESC est de 20ms, ce qui est de 50 Hz en unités de fréquence, alors réglez l'élément <strong>pwm_hz</strong> config à 50 (certains BESC peuvent fonctionner avec des taux de répétition d'impulsions plus élevés, jusqu'à peut-être 200Hz). Supposons que le temps d'impulsion minimum est le 1ms typique (moteur éteint) et le temps maximum est de 2 ms (moteur plein). 1ms est 5 % de 20ms et 2ms est 10 %. Supposons également que vous souhaitez régler la vitesse du moteur avec des valeurs de GCode S entre 0 et 1000. Par conséquent<strong>, l'élément speed_map</strong> config aurait la valeur « 0 = 5 % 1000 = 10 % ».</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">pwm:
 output_pin: gpio.4
 pwm_hz: 50
 speed_map: 0=5% 1000=10%
</code></pre>
<p>Vous pouvez affiner ces valeurs au besoin pour votre matériel spécifique. Si vous voulez utiliser des valeurs S en unités de RPM, et que votre moteur tourne à 20000 RPM à pleine puissance, il suffit de remplacer « 1000 » par « 20000 » en <strong>speed_map.</strong> La plupart des moteurs RC hobby n'ont pas de capteurs de vitesse de sorte que leur contrôle de vitesse n'est pas précis ; la valeur RPM ne serait qu'une approximation.</p>
<p>Les paramètres de config ci-dessus sont ceux qui sont absolument nécessaires pour un BESC. Vous pouvez définir d'autres éléments de config PWM pour des choses comme les retards de spinup et de spindown.</p>
<blockquote class="is-info">
<p>Cela pourrait également être utilisé pour contrôler un hobby servo dans une application comme un traceur de stylo. Avec cette configuration, vous pouvez utiliser déplacer le stylo vers le bas avec le GCode <code>M3 S1000</code> et le soulever avec <code>M5</code>  <code>M3 S0</code>.<br> Voir aussi la <a class="is-internal-link is-valid-page" href="/en/config/axes#rc_servo">fonction d'asservissement RC sous les axes</a> des moteurs.</p>
</blockquote>
<blockquote class="is-info">
<p>Hobby BESC ont souvent un « mode de programmation » qui peut être entré en alimentant le BESC avec le bâton d'accélérateur de l'émetteur de radio dans des positions spécifiques, puis en déplaçant l'accélérateur à d'autres positions après avoir entendu des bips du BESC. Il est parfois possible de le faire à partir de GCode, en utilisant des commandes comme « M3 S0 » pour les gaz minimums, « M3 S1000 » pour les gaz pleins, et « M3 S500 » pour les gaz moyens. Typiquement, vous émettrez la première commande M3 pour la position initiale des gaz avec le BESC éteint, puis l'alimenter et passer par la séquence spécifiée que le BESC répond avec des bips ou des flashs LED.</p>
</blockquote>
<h2 class="toc-header" id="hbridge"><a href="#hbridge" class="toc-anchor">¶</a> HBridge</h2>
<img width="400" src="https://github.com/bdring/FluidNC/wiki/images/h-bridge.png">
<p>C'est comme un axe PWM sauf que vous avez des signaux PWM séparés pour la rotation dans le sens horaire (CW) et dans le sens antihoraire (CCW). Ceci a été spécifiquement conçu pour commander directement un circuit de pont H.</p>
<ul>
<li><strong>output_cw_pin :</strong> 
<ul>
<li>Type : Pin</li>
<li>Gamme : gpio</li>
<li>Par défaut : NO_PIN</li>
<li>Détails : C'est la broche sur laquelle le signal PWM de sortie est mis en rotation CW. Il s'éteint avec M5.</li>
</ul>
</li>
<li><strong>output_ccw_pin :</strong> 
<ul>
<li>Type : Pin</li>
<li>Gamme : gpio</li>
<li>Par défaut : NO_PIN</li>
<li>Détails : C'est la broche que le signal PWM de sortie est activé pour la rotation CCW. Il s'éteint avec M5.</li>
</ul>
</li>
<li><strong><a href="#output_pin">enable_pin :</a></strong></li>
<li><strong><a href="#pwm_hz">pwm_hz :</a></strong></li>
<li><strong><a href="#disable_with_s0">disable_with_s0 :</a></strong></li>
<li><strong><a href="#s0_with_disable">s0_with_disable :</a></strong></li>
<li><strong><a href="#spinup_ms">spinup_ms :</a></strong></li>
<li><strong><a href="#spindown_ms">spindown_ms :</a></strong></li>
<li><strong><a href="#tool_num">tool_num :</a></strong></li>
<li><strong><a href="#speed_map">speed_map :</a></strong></li>
</ul>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">HBridge:
  pwm_hz: 5000
  output_cw_pin: gpio.4
  output_ccw_pin: gpio.16
  enable_pin: gpio.26
  disable_with_s0: false
  spinup_ms: 1000
  spindown_ms: 1000
  tool_num: 100
  speed_map: 0=0.000% 10000=100.000%
  off_on_alarm: false
</code></pre>
<h2 class="toc-header" id="laser"><a href="#laser" class="toc-anchor">¶</a> Laser</h2>
<img width="300" src="https://github.com/bdring/FluidNC/wiki/images/laser.png">
<p>Un laser est considéré comme un axe car gcode ne possède pas de codes spécifiques au laser. Il utilise la valeur RPM comme niveau de puissance. Les lasers ont également des exigences particulières.</p>
<ul>
<li>
<p>Ils fonctionnent toujours comme le <a class="is-external-link" href="https://github.com/gnea/grbl/wiki/Grbl-v1.1-Laser-Mode">mode laser avancé de Grbl</a></p>
<ul>
<li>Ils ne fonctionneront que dans les modes de mouvement G1, G2 ou G3. Ils ne fonctionneront pas pendant G0, Jog, Homing etc. Si vous en avez besoin pour fonctionner dans ces modes, utilisez une broche PWM.</li>
<li>Ils s'éteignent au ralenti ou font un mouvement rapide.</li>
<li>M3 est la puissance constante et M4 est le mode de puissance dynamique (échelles linéaires avec la vitesse pendant accel/decel)</li>
</ul>
</li>
<li>
<p><strong>speed_map :</strong> final xxx = 100 % peut être ce que vous voulez, mais il est typiquement 255 ou 1000. Cela devrait être utilisé dans le logiciel CAM comme le numéro de puissance max.</p>
</li>
<li>
<p><strong>off_on_alarm : true :</strong> est recommandé du point de vue de la sécurité pour s'assurer que le laser est éteint lorsque le mouvement est arrêté en raison de l'alarme déclenchée.</p>
</li>
</ul>
<p>Les 2 modes sont tout à fait différents et chacun optimisé pour différents types de travail.</p>
<p><strong>M3 Mode</strong></p>
<p>Ce mode est principalement utilisé pour la découpe de pièces. Le laser fonctionne chaque fois que vous êtes en mode régulateur de débit (G1, G2 ou G3). Il restera en tout temps à la pleine valeur Snnn. Cela inclut lorsqu'il n'y a pas de mouvement. Pour arrêter le laser, vous devez envoyer M5, G0 ou S0. Cela vous donne un contrôle total. Par exemple, vous pouvez vouloir habiter une fraction de seconde au début ou à la fin d'une coupe.</p>
<p>Voici un exemple de macro pour tester le laser à puissance minimale</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-gcode">M3 S1 ; lowest power
G1 F100  ; set G1 and an arbitray feedrate to turn on the laser
G4 P0.50  ; wait 0.5 seconds
G0       ; turn off the laser
M5       ; keep it off.
</code></pre>
<p><strong>M4 Mode</strong></p>
<p>Le mode M4 est principalement utilisé pour la gravure. Il compense la diminution de la puissance du laser lors de l'accélération et de la décélération pour éviter l'obscurcissement de ces sections. Il restera en suspens quand il n'y aura pas de mouvement.</p>
<p><strong>Config exemple</strong></p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">Laser:
  pwm_hz: 5000
  output_pin: gpio.4
  enable_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  tool_num: 0
  speed_map: 0=0.000% 255=100.000%
  off_on_alarm: true
</code></pre>
<h2 class="toc-header" id="relay"><a href="#relay" class="toc-anchor">¶</a> Relais</h2>
<img width="300" src="https://github.com/bdring/FluidNC/wiki/images/iot_relay.png">
<p>C'est comme un signal PWM sauf que la broche sera pleine pour toute vitesse supérieure à 0 que vous sélectionnez. Les signaux PWM peuvent rapidement détruire un relais.</p>
<ul>
<li><strong><a href="#direction_pin">direction_pin :</a></strong></li>
<li><strong><a href="#output_pin">output_pin :</a></strong></li>
<li><strong><a href="#enable_pin">enable_pin :</a></strong></li>
<li><strong><a href="#disable_with_s0">disable_with_s0 :</a></strong></li>
<li><strong><a href="#s0_with_disable">s0_with_disable :</a></strong></li>
<li><strong><a href="#spinup_ms">spinup_ms :</a></strong></li>
<li><strong><a href="#spindown_ms">spindown_ms :</a></strong></li>
<li><strong><a href="#tool_num">tool_num :</a></strong></li>
<li><strong><a href="#speed_map">speed_map :</a></strong></li>
</ul>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">relay:
  direction_pin: NO_PIN
  output_pin: gpio.26
  enable_pin: NO_PIN
  disable_with_s0: false
  s0_with_disable: true
  spinup_ms: 0
  spindown_ms: 0
  tool_num: 0
  speed_map: 0=0.000% 0=100.000% 1=100.000%
  off_on_alarm: false
</code></pre>
<h2 class="toc-header" id="plasma-experimental"><a href="#plasma-experimental" class="toc-anchor">¶</a> Plasma (expérimental)</h2>
<p><a class="is-external-link" href="http://wiki.fluidnc.com/en/development/plasma">Voir cette page</a></p>
<h2 class="toc-header" id="nospindle"><a href="#nospindle" class="toc-anchor">¶</a> NoSpindle</h2>
<p>Il s'agit d'une broche par défaut qui est automatiquement créée si vous n'avez pas spécifié une broche dans votre fichier config.</p>
<pre v-pre="true" class="prismjs line-numbers"><code class="language-yaml">NoSpindle: 
</code></pre>
<h1 class="toc-header" id="using-multiple-spindles-and-tool-numbers"><a href="#using-multiple-spindles-and-tool-numbers" class="toc-anchor">¶</a> Utilisation de plusieurs broches et numéros d'outils</h1>
<p>Vous pouvez définir autant de broches que votre matériel supportera. Ils agiront en toute indépendance. Vous devez utiliser des broches d'entrée/sortie séparées pour chacune d'elles. Il suffit d'ajouter chaque définition de broche au fichier config.</p>
<p>Chacun doit avoir un <strong>tool_num</strong> unique : Si vous avez un écart dans les chiffres, comme le premier axe est <code>tool_num: 0</code> et la deuxième broche est <code>tool_num: 10</code>, les nombres 0 à 9 appartiendraient à la première broche. Cela permet à n'importe quelle broche d'être une <a class="is-external-link" href="http://wiki.fluidnc.com/en/features/atc"></a>broche ATC (changement automatique d'outil).</p>
<p>Si vous avez seulement 1 broche définie, vous devez utiliser<strong> tool_num : 0</strong>. La broche acceptera tous les numéros d'outils.</p>
<p>Vous passez d'un outil à l'autre avec le changement d'outil gcode (M6). <strong>M6 T2 </strong>passerait à l'axe qui couvre l'outil numéro 2. Si les broches sont décalées dans l'un ou l'axe, vous devrez faire face à cela vous-même.</p>
<p>Façons de rezero la nouvelle broche.</p>
<ul>
<li>
<p>Vous pouvez utiliser un système de coordonnées séparé comme G54 pour un axe et G55 pour un autre.</p>
</li>
<li>
<p>Vous pourriez créer une petite macro qui zéros la machine basée sur l'offset connu, comme passer à zéro, déplacer le montant d'offset et rezero.</p>
</li>
</ul>
<h1 class="toc-header" id="troubleshooting"><a href="#troubleshooting" class="toc-anchor">¶</a> Dépannage</h1>
<ul>
 <li><strong>Je reçois Erreur 20 La commande non supportée pour M4</strong> M4 ne fonctionnera que sur les broches qui supportent l'inversion ou les lasers. S'il y a une broche de direction pour le type de broche que vous utilisez, il faut lui attribuer une broche</li>
</ul>
</div></div></html>