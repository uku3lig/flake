{ lib, pkgs, ... }:
let
  ninjabrain-bot = pkgs.callPackage ./ninjabrain.nix { };
  waywork = pkgs.callPackage ./waywork.nix { };
in
{
  # https://tesselslate.github.io/waywall/00_setup.html#instance-setup
  environment.systemPackages = [ pkgs.waywall ];

  hj.".config/waywall/init.lua".source = pkgs.replaceVars ./waywall.lua {
    inherit waywork;
    ninjabrain = lib.getExe ninjabrain-bot;
    eye-overlay = ./eye-overlay.png;
  };
}
