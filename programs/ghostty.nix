{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.ghostty ];

  hj.".config/ghostty/config".text = ''
    font-family = Iosevka Term
    font-feature = -calt
    font-feature = -dlig
    font-size = 12
    theme = light:Catppuccin Latte,dark:Catppuccin Mocha
  '';
}
