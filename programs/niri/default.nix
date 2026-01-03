{
  lib,
  pkgs,
  config,
  ...
}:
{
  options = {
    programs.niri.cursorTheme = lib.mkOption {
      type = lib.types.str;
      default = "N25 Miku";
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
    };

    environment.systemPackages = with pkgs; [
      adw-gtk3
      adwaita-icon-theme
      gnome-calculator
      loupe
      nautilus
      xwayland-satellite
    ];

    hj = {
      ".config/niri/config.kdl".source = pkgs.substitute {
        src = ./config.kdl;
        substitutions = [
          "--replace"
          "@cursorTheme@"
          (config.programs.niri.cursorTheme)
        ];
      };

      ".config/niri/toggle-scale-1.sh".source = ./toggle-scale-1.sh;
    };
  };
}
