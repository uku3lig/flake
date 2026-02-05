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

  ninb-settings = {
    angle_adjustment_display_type = 1;
    angle_adjustment_type = 1;
    color_negative_coords = true;
    default_boat_type = 2;
    hotkey_decrement_code = 50;
    hotkey_decrement_modifier = 2;
    hotkey_increment_code = 51;
    hotkey_increment_modifier = 2;
    hotkey_reset_code = 19;
    hotkey_reset_modifier = 3;
    language_v2 = "en-US";
    overlay_auto_hide = true;
    overlay_hide_delay = 60;
    sensitivity = "0.02291165";
    sensitivity_manual = "0.02291165";
    settings_version = 2;
    show_angle_errors = true;
    show_angle_updates = true;
    sigma_boat = "0.0007";
    size = 1;
    theme = 1;
    translucent = false;
    use_obs_overlay = true;
    use_precise_angle = true;
    view = 1;
  };

  ninb-lines = lib.concatLines (
    lib.mapAttrsToList (k: v: "<entry key=\"${k}\" value=\"${toString v}\"/>") ninb-settings
  );
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

    hj.".java/.userPrefs/ninjabrainbot/prefs.xml".text = ''
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <!DOCTYPE map SYSTEM "http://java.sun.com/dtd/preferences.dtd">
      <map MAP_XML_VERSION="1.0">
    ''
    + ninb-lines
    + ''
      </map>
    '';
  };
}
