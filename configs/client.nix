{ pkgs, config, ... }:
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

    # fix for wsl, `prefer` does not work if your SSH_ASKPASS is empty/unset
    variables.SSH_ASKPASS_REQUIRE = if config.programs.ssh.enableAskPassword then "prefer" else "never";
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
    ssh.startAgent = true;
  };

  virtualisation.docker.enable = true;
}
