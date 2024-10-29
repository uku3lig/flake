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

  programs.nix-ld.enable = true;
}
