{
  lib,
  pkgs,
  config,
  ...
}:
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
      gnome-calculator
      loupe
      nautilus
      xwayland-satellite
    ];

    hj.".config/niri/config.kdl".source = pkgs.substitute {
      src = ./config.kdl;
      substitutions = [
        "--replace"
        "@cursorTheme@"
        (config.programs.niri.cursorTheme)
        "--replace"
        "@cursorSize@"
        (config.programs.niri.cursorSize)
      ];
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
