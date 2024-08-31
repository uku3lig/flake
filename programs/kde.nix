{
  pkgs,
  camasca,
  ...
}: {
  services.desktopManager.plasma6.enable = true;

  environment = {
    variables.SSH_AUTH_SOCK = "/run/user/1000/ssh-agent";

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
