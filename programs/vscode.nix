{pkgs, ...}: {
  mainUser.packages = with pkgs; [vscode];

  hm.programs.vscode = {
    enable = true;
    enableUpdateCheck = false;

    extensions = with pkgs.vscode-extensions; [
      # style
      # bierner.markdown-preview-github-styles
      catppuccin.catppuccin-vsc

      # git
      donjayamanne.githistory
      eamodio.gitlens

      # misc
      github.copilot
      editorconfig.editorconfig
      mkhl.direnv
      usernamehw.errorlens
      wakatime.vscode-wakatime

      # rust
      # dustypomerleau.rust-syntax
      rust-lang.rust-analyzer
      serayuzgur.crates
      tamasfe.even-better-toml

      # nix
      jnoortheen.nix-ide

      # cpp
      # mesonbuild.mesonbuild
      ms-vscode.cmake-tools
      ms-vscode.cpptools
      ms-vscode.makefile-tools
      twxs.cmake
      xaver.clang-format

      # python
      # donjayamanne.python-environment-manager
      ms-python.python
      ms-python.vscode-pylance
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
      "workbench.colorTheme" = "Catppuccin Mocha";

      # fix for segfault on hyprland
      "window.titleBarStyle" = "custom";
    };
  };
}
