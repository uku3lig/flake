{
  lib,
  inputs,
  ...
}: let
  toSystem = name: {
    role,
    system,
  }:
    inputs.nixpkgs.lib.nixosSystem
    {
      inherit system;

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
    fuji = {
      role = "desktop";
      system = "x86_64-linux";
    };

    fuji-wsl = {
      role = "client";
      system = "x86_64-linux";
    };

    kilimandjaro = {
      role = "desktop";
      system = "x86_64-linux";
    };

    etna = {
      role = "server";
      system = "x86_64-linux";
    };

    vesuvio = {
      role = "server";
      system = "aarch64-linux";
    };
  };
}
