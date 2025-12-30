{ pkgs, ... }:
{
  services.displayManager.dms-greeter = {
    enable = true;
    compositor.name = "niri";
  };

  programs = {
    niri.enable = true;
    ssh.startAgent = false;
    dms-shell.enable = true;
  };

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
