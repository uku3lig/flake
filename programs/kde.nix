{
  camasca,
  pkgs,
  ...
}: {
  services.desktopManager.plasma6.enable = true;

  environment = {
    systemPackages = with pkgs; [
      flameshot
      camasca.packages.${pkgs.system}.koi
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