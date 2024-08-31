{pkgs, ...}: {
  imports = [./common.nix];

  environment.systemPackages = with pkgs; [
    nil
    ffmpeg
    fastfetch
  ];

  networking = {
    useNetworkd = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };
}
