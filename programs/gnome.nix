{pkgs, ...}: {
  services = {
    xserver.desktopManager.gnome.enable = true;
    displayManager.defaultSession = "gnome";
  };

  hm.programs.gnome-shell = {
    enable = true;
    extensions = [
      {package = pkgs.gnomeExtensions.appindicator;}
    ];
  };

  environment = with pkgs; {
    systemPackages = [gnome.gnome-tweaks];

    gnome.excludePackages =
      [gnome-tour]
      ++ (with pkgs.gnome; [
        cheese # webcam tool
        gnome-terminal
        epiphany # web browser
        geary # email reader
        totem # video player
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game
      ]);
  };
}
