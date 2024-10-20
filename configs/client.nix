{pkgs, ...}: {
  imports = [./common.nix];

  environment.systemPackages = with pkgs; [
    nil
    ffmpeg
    fastfetch
  ];

  hm.programs.keychain = {
    enable = true;
    agents = ["ssh"];
    keys = ["id_ed25519"];
  };

  networking = {
    useNetworkd = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      plugins = [pkgs.networkmanager-fortisslvpn];
    };
  };

  programs.nix-ld.enable = true;
}
