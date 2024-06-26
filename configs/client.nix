{pkgs, ...}: {
  imports = [./common.nix];

  environment.systemPackages = with pkgs; [
    nil
    ffmpeg
    yt-dlp
    hyfetch
  ];

  hm.programs.keychain = {
    enable = true;
    agents = ["ssh"];
    inheritType = "any";
    keys = ["id_ed25519"];
  };
}
