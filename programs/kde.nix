{self, pkgs, ...}: {
  services.desktopManager.plasma6.enable = true;

  environment = {
    systemPackages = with pkgs; [
      flameshot
      self.packages.${pkgs.system}.koi
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
