{
  lib,
  pkgs,
  config,
  ...
}:
let
  # nixpkgs/pkgs/build-support/replace-vars/replace-vars-with.nix
  subst-var-by = name: value: [
    "--replace-fail"
    "@${name}@"
    value
  ];

  replaceVars' =
    src: replacements:
    pkgs.substitute {
      inherit src;
      substitutions = lib.concatLists (lib.mapAttrsToList subst-var-by replacements);
    };
in
{
  options = {
    programs.niri = {
      cursorTheme = lib.mkOption {
        type = lib.types.str;
        default = "N25 Miku";
      };

      cursorSize = lib.mkOption {
        type = lib.types.int;
        default = 24;
      };
    };
  };

  config = {
    services.displayManager.dms-greeter = {
      enable = true;
      compositor.name = "niri";
    };

    programs = {
      niri.enable = true;
      dms-shell.enable = true;

      ssh.startAgent = false;

      nautilus-open-any-terminal = {
        enable = true;
        terminal = "ghostty";
      };
    };

    environment.systemPackages = with pkgs; [
      adw-gtk3
      adwaita-icon-theme
      file-roller
      gnome-calculator
      loupe
      nautilus
      xwayland-satellite
    ];

    hj.".config/niri/config.kdl".source = replaceVars' ./config.kdl {
      inherit (config.programs.niri) cursorTheme cursorSize;
      switchLayout = ./switch-layout.fish;
    };

    system.replaceDependencies.replacements = [
      {
        oldDependency = pkgs.signal-desktop;
        newDependency = pkgs.signal-desktop.override {
          commandLineArgs = "--password-store=gnome-libsecret";
        };
      }
    ];
  };
}
