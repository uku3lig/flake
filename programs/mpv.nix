{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.mpv ];

  hj.".config/mpv/mpv.conf".text = ''
    hwdec=yes
    vo=gpu-next
    gpu-context=waylandvk
    profile=high-quality
    screenshot-format=webp
    screenshot-webp-lossless=yes
  '';
}
