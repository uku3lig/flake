{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./common.nix
    ./hardware/kilimandjaro.nix
  ];

  networking.hostName = "kilimandjaro";

  services.xserver = {
    videoDrivers = ["intel"];
    libinput.enable = true;
  };
}
