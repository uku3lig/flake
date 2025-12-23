{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "L+ /opt/temurin-25 - - - - ${pkgs.temurin-bin-25}"
    "L+ /opt/temurin-21 - - - - ${pkgs.temurin-bin-21}"
    "L+ /opt/temurin-17 - - - - ${pkgs.temurin-bin-17}"
    "L+ /opt/temurin-8 - - - - ${pkgs.temurin-bin-8}"
  ];
}
