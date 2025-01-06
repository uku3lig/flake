{
  pkgs,
  camasca,
  ...
}:
{
  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  security.pam.services.sddm.kwallet.enable = true;

  environment = {
    systemPackages = with pkgs; [
      gnome-calculator
      koi
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
