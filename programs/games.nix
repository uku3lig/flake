{ pkgs, ... }:
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
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    gamemode.enable = true;
  };
}
