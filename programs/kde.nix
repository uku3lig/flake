{ pkgs, ... }:
{
  imports = [ ./plm.nix ];

  services.desktopManager.plasma6.enable = true;

  programs.ssh.startAgent = false;

  environment = {
    systemPackages = with pkgs; [
      gnome-calculator
      kdePackages.koi
    ];

    plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      elisa
      okular
      kate
      khelpcenter
    ];
  };
}
