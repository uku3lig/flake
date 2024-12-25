{
  lib,
  inputs,
  ...
}:
let
  _utils = import ../global/utils.nix { inherit lib; };

  toSystem =
    name:
    {
      role,
      system,
    }:
    inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./${name}
        ./${name}/hardware-configuration.nix
        ../configs/${role}.nix

        { networking.hostName = name; }
      ];

      specialArgs = inputs // {
        inherit _utils;
      };
    };
in
{
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
      role = "laptop";
      system = "x86_64-linux";
    };

    mottarone = {
      role = "laptop";
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
