{
  lib,
  pkgs,
  config,
  grimoire,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
  cfg = config.system.julie.games;

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
          --set SDL_VIDEO_DRIVER wayland \
          --set PIPEWIRE_LATENCY 128/48000 \
          --set PIPEWIRE_ALSA "{ alsa.format=S32_LE alsa.rate=48000 alsa.channels=2 alsa.buffer-bytes=1024 alsa.period-bytes=256 }"
      '';
    }
  ) { };
in
{
  options = {
    system.julie.games = {
      enable = lib.mkEnableOption "games";

      prism = {
        jdks = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };

        libs = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
        };
      };

      grimoire.enable = lib.mkEnableOption "grimoire (deadlock)";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = with pkgs; [
          gamescope
          heroic
          mangohud
          osu
          protonplus

          (olympus.override { celesteWrapper = "steam-run"; })
          (prismlauncher.override {
            additionalLibs = cfg.prism.libs;
            jdks = cfg.prism.jdks;
          })
        ];

        programs = {
          gamemode.enable = true;
          steam.enable = true;
        };

        # programs/java.nix
        system.julie.games.prism.jdks = [
          "/opt/temurin-25"
          "/opt/temurin-21"
          "/opt/temurin-17"
          "/opt/temurin-8"
        ];
      }
      (lib.mkIf cfg.grimoire.enable {
        environment.systemPackages = [ grimoire.packages.${system}.default ];
      })
    ]
  );
}
