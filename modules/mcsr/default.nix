{
  lib,
  pkgs,
  config,
  mcsr-nixos,
  ...
}:
let
  cfg = config.system.julie.games.mcsr;
  wwcfg = config.programs.waywall;
  mcsrPkgs = mcsr-nixos.packages.${pkgs.stdenv.hostPlatform.system};

  thin = pkgs.fetchurl {
    url = "https://v.uku.moe/u/thin.png";
    hash = "sha256-VzT9a0/+JMG+To80+xuQSo4x2w6+zavCvUJ6irBkpVg=";
  };

  wide = pkgs.fetchurl {
    url = "https://v.uku.moe/u/wide.png";
    hash = "sha256-xJX+QladHQiQYBdKZEB9kuEaxBWVZuuStf4r4gIv5uo=";
  };

  tall = pkgs.fetchurl {
    url = "https://v.uku.moe/u/tall.png";
    hash = "sha256-RLyV6iFVDlJKKEdA3CBAQR/sIj2WnhZVBAmLzVmS7JA=";
  };
in
{
  imports = [ mcsr-nixos.nixosModules.waywall ];

  options = {
    system.julie.games.mcsr = {
      enable = lib.mkEnableOption "mcsr";
      withGraal = lib.mkEnableOption "graalvm";
    };

    programs.waywall = {
      width = lib.mkOption {
        type = lib.types.int;
        default = 1920;
      };

      height = lib.mkOption {
        type = lib.types.int;
        default = 1080;
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [
          mcsrPkgs.modcheck
          mcsrPkgs.obs-cli
          mcsrPkgs.paceman-tracker
        ];

        hj.".config/waywall/init.lua".source = config.programs.waywall.config.finalFile;

        programs.waywall = {
          enable = true;
          config = {
            enableWaywork = true;
            programs = [
              pkgs.ninjabrain-bot
              mcsrPkgs.obs-cli
            ];
            files = {
              eye_overlay = ./eye-overlay.png;
              inherit thin wide tall;
            };

            text = ''
              local resolution = { w = ${toString wwcfg.width}, h = ${toString wwcfg.height} }
            ''
            + builtins.readFile ./waywall.lua;

            linkWithSystemd = false;
          };
        };

        system.julie.games.prism.libs = with pkgs; [
          jemalloc
          libxtst
          libxkbcommon
          libxt
          libxinerama
        ];
      }
      (lib.mkIf cfg.withGraal {
        system.julie.games.prism.jdks = [ "/opt/graalvm-21" ];

        systemd.tmpfiles.rules = [
          "L+ /opt/graalvm-21 - - - - ${mcsrPkgs.graalvm-21}"
        ];
      })
    ]
  );
}
