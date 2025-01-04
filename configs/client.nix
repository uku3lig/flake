{ lib, pkgs, ... }:
{
  imports = [
    ./common.nix

    ../programs/neovim
    ../programs/rust.nix
  ];

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
      askPassword = lib.mkDefault "${pkgs.curses-ssh-askpass}"; # see exprs/curses-ssh-askpass.nix
    };
  };

  virtualisation.docker.enable = true;
}
