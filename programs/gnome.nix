{pkgs, ...}: {
  services = {
    xserver.desktopManager.gnome.enable = true;
    displayManager = {
      defaultSession = "gnome";
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  hm.programs.gnome-shell = {
    enable = true;
    extensions = with pkgs.gnomeExtensions; [
      {package = appindicator;}
      {package = dash-to-dock;}
      {package = blur-my-shell;}
    ];
  };

  environment = with pkgs; {
    systemPackages = [gnome-tweaks];

    gnome.excludePackages = [
      gnome-tour
      cheese # webcam tool
      gnome-terminal
      epiphany # web browser
      geary # email reader
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ];
  };
}
