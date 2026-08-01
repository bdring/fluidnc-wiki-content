---
title: Wiki Contributions
description: How to contribute to the wiki
published: true
date: 2026-08-01T19:32:25.877Z
tags: 
editor: markdown
dateCreated: 2022-07-23T19:19:02.475Z
---

## Overview

We welcome contributions to the wiki.  Follow the instructions below to get edit permission.

## Create an account

Click on the account icon and create a new account. 

> The email system is not working on the wiki, so you will not get an activation email. Reach out to us on Discord and ask to be activated and given permission to edit or create pages. **Be sure to give your user name, so I don't have to guess.**
{.is-warning}




## Discuss

Before making any additions or changes other than typos, please discuss them on [Discord](http://wiki.fluidnc.com/en/support/discord) in advance.

## Existing Hardware Page

If you are adding a hardware item of your design to the [Existing Hardware Page](http://wiki.fluidnc.com/en/hardware/existing_hardware), you must include your discord name from the [FluidNC Discord server](http://wiki.fluidnc.com/#discussion). 

# Style Guide

## Page Type

Wiki.js allows you to use different editors to create the pages, but once started, I think a page is stuck in that type. Only use the **Markdown** editor. All the other pages are done with that editor.

> Seriously! I will likely delete any pages not done in Markdown.
{.is-warning}


## Headings

Use heading tags where appropriate to get links in the navigation panel use heading 1 and heading 2 tags to put items in the navigation panel.

## <a id="anchor_links"></a>Anchor Links

Anchor links allow cross linking in the wiki to specific items on a page. It is also helpful when providing links in support cases.

```html
<a id="something"></a>Anchor Links
```

All header tagged items like `## My Text` automatically anchors. In this case you would specify `#my-text` in the URL. Blanks must be replaced by dashes.

## Images

They should not be too large. You can set the width like this.

```hrml
![discord-logo_trans.png](/discord-logo_trans.png =x80) 
```

Set the aliment like this
```
![discord-logo_trans.png](/discord-logo_trans.png){.align-center}

```

## FluidNC Command Formatting

Format all FluidNC commands with markdown's single tick block quotes.

```
`$CD`
```

## Special Symbols

This format appears to work well

`&deg;` for &deg; (degree symbol)
`%pi;` for &pi; (pi symbol)

[More can be found here](https://www.w3schools.com/charsets/ref_html_entities_4.asp)

## Gcode formatting

Gcode can be formatted with the gcode tag in code sections.

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

## Diagram Editor

The diagram editor is very easy to use once you learn the tricks:

- Get a rounded "process" box from the flowchart section and resize to the size you want
- In its "Text" settings, uncheck Word Wrap and Formatted Text
- Subsequently, copy/paste it instead of getting a new one
- Similarly for a decision diamond box
- When placing boxes, pay attention to the alignment guides that appear
- To make connection arrows quickly, click on the source box and hover near the output edge.  Click on the light blue arrow that appears, and the desired connection will be made in one click
- To label the arrows with Yes/No, double click on the arrow.  Then click on the label and uncheck "Formatted Text" in its Text settings
- To place text inside a box, just click on it and start typing, using returns for formatting
- Right click to find the edit link menu
- If links don't work, double-check every element to ensure that no "Word Wrap" or "Formatted Text" check is present
