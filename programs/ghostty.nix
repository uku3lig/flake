{ lib, pkgs, ... }:
let
  package = pkgs.ghostty;
in
{
  environment.systemPackages = [ package ];
  systemd.packages = [ package ];
  services.dbus.packages = [ package ];

  hj.".config/ghostty/config".text = ''
    font-family = Iosevka Term
    font-feature = -calt
    font-feature = -dlig
    font-size = 12
    theme = light:Catppuccin Latte,dark:Catppuccin Mocha
  '';

  systemd.user.services."app-com.mitchellh.ghostty" = {
    restartIfChanged = false;
    overrideStrategy = "asDropin";

    # service "overrides" those, so we force them to null to keep nix dirs and whatnot
    environment = lib.genAttrs [ "PATH" "LOCALE_ARCHIVE" "TZDIR" ] (_: lib.mkForce null);
  };
}
