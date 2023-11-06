{...}: {
  imports = [
    ./common.nix
    ./hardware/fuji.nix
  ];

  networking.hostName = "fuji";

  services.xserver.videoDrivers = ["nvidia"];

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = false;
  };

  programs.hyprland.enableNvidiaPatches = true;
}
