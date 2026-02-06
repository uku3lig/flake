{ pkgs, ... }:
{
  imports = [ ./mcsr ];

  hardware = {
    xone.enable = true;
    xpadneo.enable = true;
  };

  environment.systemPackages = with pkgs; [
    osu-lazer-bin
    krita
    ruffle

    (prismlauncher.override {
      additionalLibs = [
        jemalloc
        libxtst
        libxkbcommon
        libxt
        libxinerama
      ];

      jdks = [
        # programs/java.nix
        # avoids having to re-detect nix store paths every time
        "/opt/temurin-25"
        "/opt/temurin-21"
        "/opt/temurin-17"
        "/opt/temurin-8"
      ];
    })
  ];

  programs = {
    gamemode.enable = true;
    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-pipewire-audio-capture
        obs-source-record
      ];
    };
  };
}
