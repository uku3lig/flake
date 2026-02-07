{
  lib,
  pkgs,
  config,
  mcsr-nixos,
  ...
}:
let
  cfg = config.programs.waywall;
  mcsrPkgs = mcsr-nixos.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [ mcsr-nixos.nixosModules.waywall ];

  options = {
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

  config = {
    hj.".config/waywall/init.lua".source = config.programs.waywall.config.finalFile;

    programs.waywall = {
      enable = true;
      config = {
        enableWaywork = true;
        programs = [ mcsrPkgs.ninjabrain-bot ];
        files = {
          eye_overlay = ./eye-overlay.png;
          thin = ./thin.png;
          wide = ./wide.png;
          tall = ./tall.png;
        };

        text = ''
          local resolution = { w = ${toString cfg.width}, h = ${toString cfg.height} }
        ''
        + builtins.readFile ./waywall.lua;

        linkWithSystemd = false;
      };
    };
  };
}
