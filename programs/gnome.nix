{ lib, pkgs, ... }:
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

  # ssh-agent is provided by gnome-keyring-daemon
  # (mabye soon by gcr, see NixOS/nixpkgs#140824)
  programs.ssh.startAgent = lib.mkForce false;

  environment = with pkgs; {
    systemPackages = [
      adw-gtk3
      gnome-tweaks
      gnomeExtensions.appindicator
      gnomeExtensions.dash-to-panel
      mission-center
      nautilus-python
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
