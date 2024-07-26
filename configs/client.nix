{pkgs, ...}: {
  imports = [./common.nix];

  environment.systemPackages = with pkgs; [
    nil
    ffmpeg
    yt-dlp
    hyfetch
  ];
}
