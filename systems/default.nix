{
  lib,
  inputs,
  ...
}: let
  toSystem = name: role:
    inputs.nixpkgs.lib.nixosSystem
    {
      modules = [
        ./${name}
        ./${name}/hardware-configuration.nix
        ../configs/${role}.nix

        {networking.hostName = name;}
      ];

      specialArgs = inputs;
    };
in {
  flake.nixosConfigurations = lib.mapAttrs toSystem {
    fuji = "desktop";
    fuji-wsl = "client";
    kilimandjaro = "desktop";
    etna = "server";
  };
}
