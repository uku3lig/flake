{ pkgs, ... }:
{
  imports = [ ./mcsr ];

  hardware = {
    xone.enable = true;
    xpadneo.enable = true;
  };

  environment.systemPackages = with pkgs; [
    obs-studio
    osu-lazer-bin
    krita

    (prismlauncher.override {
      additionalLibs = [
        jemalloc
        libxtst
        libxkbcommon
        libxt
        libxinerama
      ];

      jdks = [
        temurin-bin-25
        temurin-bin-21
        temurin-bin-17
        temurin-bin-8
      ];
    })
  ];

  programs = {
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    gamemode.enable = true;
  };
}
