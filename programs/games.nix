{ pkgs, ... }:
let
  osu = pkgs.callPackage (
    {
      makeWrapper,
      osu-lazer-bin,
      symlinkJoin,
    }:
    symlinkJoin {
      name = "osu-wrapped-${osu-lazer-bin.version}";
      paths = [ osu-lazer-bin ];
      nativeBuildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/osu! \
          --set SDL_VIDEODRIVER wayland \
          --set PIPEWIRE_LATENCY 128/48000 \
          --set PIPEWIRE_ALSA "{ alsa.format=S32_LE alsa.rate=48000 alsa.channels=2 alsa.buffer-bytes=1024 alsa.period-bytes=256 }"
      '';
    }
  ) { };
in
{
  imports = [ ./mcsr ];

  hardware = {
    xone.enable = true;
    xpadneo.enable = true;
  };

  environment.systemPackages = with pkgs; [
    avidemux
    gamescope
    heroic
    krita
    mangohud
    osu
    protonplus
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
