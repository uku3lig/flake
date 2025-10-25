{ pkgs, ... }:
{
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  programs = {
    niri.enable = true;
    ssh.startAgent = false;
    dms-shell.enable = true;
  };

  environment.systemPackages = with pkgs; [
    adw-gtk3
    brightnessctl
    xwayland-satellite
  ];

  hj.".config/niri/config.kdl".source = ./config.kdl;
}
