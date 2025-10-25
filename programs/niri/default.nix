{ pkgs, ... }:
{
  imports = [
    ../fuzzel.nix
    ../waybar
  ];

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  programs.niri.enable = true;
  programs.ssh.startAgent = false;

  environment.systemPackages = with pkgs; [
    brightnessctl
    swayidle
    swaylock
    xwayland-satellite
  ];
}
