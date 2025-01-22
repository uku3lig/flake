{ lib, pkgs, ... }:
{
  imports = [
    ./common.nix

    ../programs/neovim
    ../programs/rust.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages; # lts

  environment = {
    systemPackages = with pkgs; [
      ffmpeg-full
      fastfetch
      lazygit
      nixd
    ];

    variables.SSH_ASKPASS_REQUIRE = "prefer";
  };

  networking = {
    useNetworkd = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      plugins = [ pkgs.networkmanager-fortisslvpn ];
    };
  };

  programs = {
    nix-ld.enable = true;
    ssh = {
      startAgent = true;
      enableAskPassword = true;
      askPassword = lib.mkOverride 1200 "${pkgs.curses-ssh-askpass}"; # see exprs/curses-ssh-askpass.nix
    };
  };

  virtualisation.docker.enable = true;
}
