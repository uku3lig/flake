{ pkgs, ... }:
{
  services = {
    displayManager.defaultSession = "gnome";
    xserver = {
      desktopManager.gnome.enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  # ssh-agent is provided by gcr
  programs.ssh.startAgent = false;

  environment = with pkgs; {
    systemPackages = [
      adw-gtk3
      gnome-tweaks
      mission-center
      nautilus-python

      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-panel
      gnomeExtensions.night-theme-switcher
    ];

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
