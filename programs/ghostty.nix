{ pkgs, ghostty, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  environment.systemPackages = [ ghostty.packages.${system}.ghostty ];

  hj.".config/ghostty/config".text = ''
    font-family = Iosevka Term
    font-feature = -calt
    font-feature = -dlig
    font-size = 12
    theme = light:Catppuccin Latte,dark:Catppuccin Mocha
  '';
}
