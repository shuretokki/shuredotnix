---
seo:
  title: dotnix - A Ready-to-Use NixOS Desktop
  description: A comprehensive, modular, and declarative NixOS configuration with Hyprland and Stylix. Clone, customize, and make it yours.
---

::u-page-hero
#title
A Ready-to-Use NixOS Desktop

#description
dotnix is a fully integrated NixOS configuration built with Hyprland and Stylix. Clone the repository, edit your identity file, and rebuild. Your complete desktop environment is ready.

#links
  :::u-button
  ---
  color: neutral
  size: xl
  to: /en/quick-start/installation
  trailing-icon: i-lucide-arrow-right
  ---
  Get Started
  :::

  :::u-button
  ---
  color: neutral
  icon: i-simple-icons-github
  size: xl
  to: https://github.com/shuretokki/dotnix
  variant: outline
  ---
  View on GitHub
  :::
::

::u-page-section
#title
What You Get

#features
  :::u-page-feature
  ---
  icon: i-lucide-rocket
  to: /en/quick-start/installation
  ---
  #title
  5-Minute Setup

  #description
  Clone, edit one file, rebuild. No hours of configuration needed.
  :::

  :::u-page-feature
  ---
  icon: i-lucide-palette
  to: /en/configuration/theming
  ---
  #title
  Unified Theming

  #description
  One color scheme applied everywhere. GTK, QT, terminals, and your window manager all match automatically via Stylix.
  :::

  :::u-page-feature
  ---
  icon: i-lucide-shield
  to: /en/features/encrypted-dns
  ---
  #title
  Private by Default

  #description
  Encrypted DNS out of the box. Your ISP cannot see which sites you visit.
  :::

  :::u-page-feature
  ---
  icon: i-lucide-git-fork
  to: /en/quick-start/introduction
  ---
  #title
  Forkable Design

  #description
  Built as a template. Change the identity file and the entire configuration adapts to your username, timezone, and preferences.
  :::

  :::u-page-feature
  ---
  icon: i-lucide-monitor
  to: /en/features/desktop
  ---
  #title
  Modern Desktop

  #description
  Hyprland window manager with smooth animations, blur effects, and window swallowing. Configured and ready to use.
  :::

  :::u-page-feature
  ---
  icon: i-lucide-refresh-cw
  to: /en/advanced/project-structure
  ---
  #title
  Reproducible

  #description
  Nix flakes ensure your system builds the same way every time. Share your config and others get the exact same result.
  :::
::
