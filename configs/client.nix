{ pkgs, ... }:
{
  imports = [
    ./common.nix

    ../programs/neovim
    ../programs/rust.nix
    ../programs/ssh-agent.nix
  ];

  environment.systemPackages = with pkgs; [
    ffmpeg-full
    fastfetch
    lazygit
    nixd
  ];

  networking = {
    useNetworkd = false;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      plugins = [ pkgs.networkmanager-fortisslvpn ];
    };
  };

  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;
}
