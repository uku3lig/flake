{pkgs, ...}: {
  services = {
    xserver.desktopManager.gnome.enable = true;
    displayManager.defaultSession = "gnome";
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

    gnome.excludePackages =
      [
        gnome-tour
        cheese # webcam tool
        gnome-terminal
        epiphany # web browser
        geary # email reader
        totem # video player
      ]
      ++ (with pkgs.gnome; [
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);
  };
}
