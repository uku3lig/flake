{
  pkgs,
  ...
}:
{
  environment.systemPackages = [ pkgs.ghostty ];

  hm.home.file.".config/ghostty/config".text = ''
    theme = light:catppuccin-latte,dark:catppuccin-mocha
    font-family = Iosevka Term
    font-size = 12
    font-feature = -calt
    font-feature = -dlig
  '';
}
