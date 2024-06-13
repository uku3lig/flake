{pkgs, ...}: {
  services = {
    xserver.desktopManager.gnome.enable = true;
    displayManager.defaultSession = "gnome";
  };

  environment = with pkgs; {
    systemPackages = [
      gnome.gnome-tweaks
      gnomeExtensions.appindicator
    ];

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
