---
title: Pull Request Guidelines
description: 
published: true
date: 2026-09-01T23:06:32.584Z
tags: 
editor: markdown
dateCreated: 2022-07-21T19:51:09.854Z
---

# Guidelines for creating pull requests.

## Issue

Please create an issue for general discussion regarding the changes in the pull request. Ideally this is done before the pull request is submitted. Pull requests are always welcome and encouraged, but coordinating efforts saves time for everyone. Discussion via Discord is also acceptable. Put a link to the discussion in the PR description.

## Scope

Please limit the scope of a PR to only one concern.  We do not have time to consider omnibus PRs that address several things at once.  PRs that touch a very small number of files are strongly preferred.  If a PR touches a lot of files, it must be a very stylized change that is essentially the same edit across all the files.  The reviewer must be able to verify the change by understanding the transformation once and spot-checking that each file follows it, rather than reading every file on its own.  We will use AI to help, but the core of the change must be easily understandable by a human.

## Branches

Please target the *latest version of* the main branch with your pull requests.

**Before you submit your PR, be sure to pull all the latest changes into your working tree, otherwise a mess will result, possibly undoing work that is already committed.**  The git command `git pull --rebase upstream main` - or the equivalent operation from one of the Git UIs, is the best way to do it.  "Rebase" is the key.  If rebasing causes problems, another git workflow is to create a fresh branch based on the latest main, then "cherry pick" your commits from your working branch onto the fresh branch.

For experimental features, it is also acceptable to target other, non main, branches.

## Versioning

Versioning is applied when we do a release

## Code Style

[See this doc for our coding style](https://github.com/bdring/FluidNC/blob/main/CodingStyle.md)

Add your name to the top of the files. Include your @github and @discord user names so support questions can get to you.

## Important Code Guidelines.

- **ISRs:** The ISRs have to be very fast. They block all processing, including RTOS tasks. The ESP32 has a [floating point bug](https://esp32.com/viewtopic.php?t=1292) related to ISRs and the FPU. Do not use floats in ISRs or anything that could be called by an ISR. Doubles can be used. They bypass the FPU, but require a lot of time to process.  

## Review and approval process.

We are typically working on several things at the same time. These are typically on branches or PRs. We determine what we want included in the next release. Only the items we plan on releasing next will be merged with main. Feel free to try to convince us to add it to the next release via Discord, but be respectful of our decision.

If your PR is not targeted at our next release, it will have to wait.

## Discord

The devs do all their discussion on Discord. We have some dev only channels where only devs can post. We restrict it to keep the chatter down. If you need access to post, please request it on a public channel of Discord.

## The Wiki

If you are creating a new item that can be configured, you must also supply information for the wiki.
