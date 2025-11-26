{ pkgs, ... }:
{
  services = {
    desktopManager.gnome.enable = true;
    displayManager = {
      defaultSession = "gnome";
      gdm = {
        enable = true;
        wayland = true;
      };
    };

    gnome.gcr-ssh-agent.enable = true;
  };

  # ssh-agent is provided by gcr
  programs.ssh.startAgent = false;

  environment = with pkgs; {
    systemPackages = [
      adw-gtk3
      gnome-tweaks
      nautilus-python
      resources

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
