{ lib, pkgs, ... }:
let
  osuSessionFile =
    (pkgs.writeTextDir "share/wayland-sessions/osu.desktop" ''
      [Desktop Entry]
      Name=osu!
      Comment=Free-to-win rhythm game
      Exec=${lib.getExe pkgs.gamescope} -- ${lib.getExe pkgs.osu-lazer-bin}
      Type=Application
    '').overrideAttrs
      { passthru.providedSessions = [ "osu" ]; };
in
{
  hardware = {
    xone.enable = true;
    xpadneo.enable = true;
  };

  hm.home.packages = with pkgs; [
    obs-studio
    osu-lazer-bin

    (prismlauncher.override {
      jdks = [
        temurin-bin-21
        temurin-bin-17
        temurin-bin-8
      ];
    })
  ];

  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };

    gamemode.enable = true;
  };

  services.displayManager.sessionPackages = [ osuSessionFile ];
}
