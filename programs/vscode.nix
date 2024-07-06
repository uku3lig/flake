{
  pkgs,
  vscode-extensions,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
  extensions = vscode-extensions.extensions.${system};

  patched = with pkgs.vscode-extensions; [
    ms-python.python
    ms-vscode.cpptools
    ms-vscode-remote.remote-ssh
    rust-lang.rust-analyzer
    wakatime.vscode-wakatime
  ];
in {
  hm.programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = with extensions.vscode-marketplace;
      patched
      ++ [
        # style
        bierner.markdown-preview-github-styles
        catppuccin.catppuccin-vsc

        # git
        donjayamanne.githistory
        eamodio.gitlens

        # misc
        github.copilot
        editorconfig.editorconfig
        mkhl.direnv
        tailscale.vscode-tailscale
        usernamehw.errorlens

        # rust
        dustypomerleau.rust-syntax
        serayuzgur.crates
        tamasfe.even-better-toml
        ms-vsliveshare.vsliveshare

        # nix
        jnoortheen.nix-ide

        # cpp
        mesonbuild.mesonbuild
        (ms-vscode.cmake-tools.overrideAttrs (_: {sourceRoot = "extension";}))
        (ms-vscode.makefile-tools.overrideAttrs (_: {sourceRoot = "extension";}))
        twxs.cmake
        xaver.clang-format

        # python
        donjayamanne.python-environment-manager
        ms-python.vscode-pylance

        # java
        redhat.java

        # web
        astro-build.astro-vscode
        vue.volar
        esbenp.prettier-vscode
        dbaeumer.vscode-eslint
      ];

    userSettings = {
      "cmake.configureOnOpen" = true;
      "editor.fontFamily" = "'Iosevka Nerd Font', monospace";
      "editor.fontSize" = 16;
      "editor.formatOnSave" = true;
      "editor.inlineSuggest.enabled" = true;
      "files.autoSave" = "afterDelay";
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "rust-analyzer.check.command" = "clippy";
      "terminal.integrated.fontFamily" = "Iosevka Nerd Font";
      "workbench.colorTheme" = "Catppuccin Macchiato";
      "errorLens.messageBackgroundMode" = "message";
      "java.jdt.ls.java.home" = "${pkgs.jdk17}/lib/openjdk";

      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[javascript]"."editor.defaultFormatter" = "esbenp.prettier-vscode";
      "[astro]"."editor.defaultFormatter" = "astro-build.astro-vscode";
      "[rust]"."editor.defaultFormatter" = "rust-lang.rust-analyzer";

      # fix for segfault on hyprland
      "window.titleBarStyle" = "custom";

      "remote.SSH.useLocalServer" = false;
      "remote.SSH.remotePlatform" = {
        "etna.fossa-macaroni.ts.net" = "linux";
        "contabo.fossa-macaroni.ts.net" = "linux";
      };
    };
  };
}
