{pkgs, ...}: {
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.xserver = {
    videoDrivers = ["intel"];
    libinput.enable = true;
  };

  programs.light.enable = true;

  users.users.leo.packages = with pkgs; [networkmanagerapplet];
}
