{
  imports = [
    ./networking-stock.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  services.openssh.openFirewall = true;
}
