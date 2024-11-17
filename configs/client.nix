{pkgs, ...}: {
  imports = [
    ./common.nix

    ../programs/rust.nix
    ../programs/neovim
  ];

  environment.systemPackages = with pkgs; [
    nil
    (ffmpeg-full.override {withUnfree = true;})
    fastfetch
    jujutsu
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
