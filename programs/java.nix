# wee oo wee oo warning !!! this is a home manager module!!! destined to be put in hm's import, not nixos' !!!!
{
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  home.file = {
    ".jdks/temurin-21".source = mkOutOfStoreSymlink pkgs.temurin-bin-21;
    ".jdks/temurin-17".source = mkOutOfStoreSymlink pkgs.temurin-bin-17;
    ".jdks/temurin-8".source = mkOutOfStoreSymlink pkgs.temurin-bin-8;
  };
}
