# wee oo wee oo warning !!! this is a home manager module!!! destined to be put in hm's import, not nixos' !!!!
{
  config,
  pkgs,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  home = {
    packages = [ pkgs.jetbrains.rider ];

    file = {
      ".dotnet/8".source =
        mkOutOfStoreSymlink "${pkgs.dotnetCorePackages.dotnet_8.sdk.unwrapped}/share/dotnet";
      ".dotnet/mono".source = mkOutOfStoreSymlink pkgs.mono;
    };
  };
}
