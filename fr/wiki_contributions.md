---
title: 3.9 Contributions au Wiki
description: Comment contribuer au wiki
published: true
date: 2026-08-01T19:37:21.350Z
tags: fr
editor: markdown
dateCreated: 2025-03-27T19:22:52.333Z
---

## Aperçu

Les contributions au wiki sont les bienvenues.

## Créer un compte

Cliquez sur l'icône du compte et créez un nouveau compte. 

> Le système de messagerie ne fonctionne pas sur le wiki, vous ne recevrez donc pas d'email d'activation. Contactez nous sur Discord et demandez à être activé et à recevoir la permission d'éditer ou de créer des pages. **N'oubliez pas de donner votre nom d'utilisateur, pour que je n'aie pas à deviner.
{.is-warning}


## Discuter

Avant d'effectuer des ajouts ou des modifications autres que des fautes de frappe, veuillez en discuter à l'avance sur [Discord](http://wiki.fluidnc.com/fr/support/discord).

## Page sur le matériel existant

Si vous ajoutez un élément matériel de votre conception à la [page Matériel existant](http://wiki.fluidnc.com/fr/hardware/existing_hardware), vous devez indiquer votre nom sur le [serveur FluidNC Discord](http://wiki.fluidnc.com/#discussion). 

# Style Guide

## Type de page

Wiki.js permet d'utiliser différents éditeurs pour créer les pages, mais une fois lancée, je pense qu'une page est bloquée dans ce type. Only use the **Markdown** editor. All the other pages are done with that editor.

> Sérieusement ! Je supprimerai probablement toutes les pages qui ne sont pas rédigées en Markdown.
{.is-warning}

## Rubriques

Utilisez les balises d'en-tête le cas échéant pour obtenir des liens dans le panneau de navigation. Utilisez les balises d'en-tête 1 et d'en-tête 2 pour placer des éléments dans le panneau de navigation.

## <a id="anchor_links"></a>Anchor Links

Anchor links allow cross linking in the wiki to specific items on a page. It is also helpful when providing links in support cases.


```html
<a id="something"></a>Anchor Links
```

Tous les éléments marqués dans l'en-tête, comme `## Mon texte`, sont automatiquement des ancres. Dans ce cas, vous devez spécifier `#mon-texte` dans l'URL. Les blancs doivent être remplacés par des tirets.

## Images

Elles ne doivent pas être trop grandes. Vous pouvez définir la largeur comme suit.

```hrml
![discord-logo_trans.png](/discord-logo_trans.png =x80) 
```

Régler l'alimentation comme suit

```
![discord-logo_trans.png](/discord-logo_trans.png){.align-center}
```

## Formatage des commandes FluidNC

Formatez toutes les commandes FluidNC avec les guillemets simples de markdown.

```
`$CD`
```

## Symboles spéciaux

Ce format semble bien fonctionner

`&deg;` pour &deg ; (symbole de degré)
`%pi;` pour &pi ; (symbole pi)

[Pour en savoir plus, cliquez ici](https://www.w3schools.com/charsets/ref_html_entities_4.asp)

## Formatage du code source

Le Gcode peut être formaté avec la balise gcode dans les sections de code.

```gcode
; Gcode example
G17 G20 G90 G94 G54
G0 Z0.25
X-0.5 Y0.
Z0.1
G01 Z0. F5.
G02 X0. Y0.5 I0.5 J0. F2.5
M30
(MSG We are done) 
``` 

## Éditeur de diagrammes

L'éditeur de diagrammes est très facile à utiliser une fois que l'on a appris les astuces :

- Prenez une boîte arrondie « processus » dans la section organigramme et redimensionnez-la à la taille souhaitée.
- Dans ses paramètres « Texte », décochez les cases « Word Wrap » et « Formatted Text ».
- Ensuite, copiez/collez-le au lieu d'en obtenir un nouveau.
- De même pour une boîte de diamant de décision
- Lorsque vous placez des boîtes, faites attention aux guides d'alignement qui apparaissent
- Pour créer rapidement des flèches de connexion, cliquez sur la boîte source et approchez le bord de sortie.  Cliquez sur la flèche bleu clair qui apparaît, et la connexion souhaitée sera réalisée en un seul clic.
- Pour étiqueter les flèches avec Oui/Non, double-cliquez sur la flèche.  Cliquez ensuite sur l'étiquette et décochez l'option « Texte formaté » dans les paramètres du texte.
- Pour placer du texte à l'intérieur d'une boîte, il suffit de cliquer dessus et de commencer à taper, en utilisant les retours pour la mise en forme.
- Cliquez avec le bouton droit de la souris pour accéder au menu d'édition
- Si les liens ne fonctionnent pas, vérifiez deux fois chaque élément pour vous assurer qu'aucune case « Word Wrap » ou « Formatted Text » n'est présente.

