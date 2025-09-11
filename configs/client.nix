{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./common.nix

    ../programs/rust.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages; # lts

  environment = {
    systemPackages = with pkgs; [
      ffmpeg-full
      fastfetch
      imagemagick
      lazygit
      nixd
    ];

    # disable ssh-askpass on wsl namely, to simply have a normal prompt that reads from stdin
    variables.SSH_ASKPASS_REQUIRE = if config.programs.ssh.enableAskPassword then "prefer" else "never";
  };

  networking = {
    useNetworkd = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      plugins = [ pkgs.networkmanager-openvpn ];
    };
  };

  programs = {
    nix-ld.enable = true;
    ssh.startAgent = lib.mkDefault true;
  };

  virtualisation.docker.enable = true;
}
