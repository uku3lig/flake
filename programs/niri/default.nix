{ pkgs, ... }:
{
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
  };

  programs = {
    niri.enable = true;
    dms-shell.enable = true;

    ssh.startAgent = false;
  };

  #  services.gnome.gcr-ssh-agent.enable = ;

  environment.systemPackages = with pkgs; [
    adw-gtk3
    adwaita-icon-theme
    gnome-calculator
    loupe
    nautilus
    xwayland-satellite
  ];

  hj.".config/niri/config.kdl".source = ./config.kdl;
}
