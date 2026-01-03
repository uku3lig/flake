{
  lib,
  pkgs,
  config,
  ...
}:
let
  ninjabrain-bot = pkgs.callPackage ./ninjabrain.nix { };
  waywork = pkgs.callPackage ./waywork.nix { };
  cfg = config.programs.waywall;
in
{
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
    # https://tesselslate.github.io/waywall/00_setup.html#instance-setup
    # overridden, see exprs/overlay.nix
    environment.systemPackages = [ pkgs.waywall ];

    hj.".config/waywall/init.lua".text = ''
      package.path = package.path .. ";${waywork}/?.lua"
      local ninb_path = "${lib.getExe ninjabrain-bot}"
      local resolution = { w = ${toString cfg.width}, h = ${toString cfg.height} }
      local images = {
        eye_overlay = "${./eye-overlay.png}",
        thin = "${./thin.png}",
        wide = "${./wide.png}",
        tall = "${./tall.png}",
      }
      -- end globals
    ''
    + builtins.readFile ./waywall.lua;
  };
}
