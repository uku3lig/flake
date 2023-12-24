{
  lib,
  inputs,
  ...
}: let
  # shamelessly borrowed from https://github.com/getchoo/flake/blob/94dc521310b34b80158d1a0ab65d4daa3a44d81e/systems/default.nix
  toSystem = builder: name: args:
    (args.builder or builder) (
      (builtins.removeAttrs args ["builder"])
      // {
        modules =
          args.modules
          ++ [
            ./${name}
            ./${name}/hardware-configuration.nix

            {networking.hostName = name;}
          ];
        specialArgs = inputs;
      }
    );

  mapNixOS = lib.mapAttrs (toSystem inputs.nixpkgs.lib.nixosSystem);

  nixos = with inputs; [
    ./common.nix
    agenix.nixosModules.default
  ];

  desktop = with inputs;
    [
      ./desktop.nix
      lanzaboote.nixosModules.lanzaboote
      home-manager.nixosModules.home-manager
      catppuccin.nixosModules.catppuccin
    ]
    ++ nixos;
in {
  flake.nixosConfigurations = mapNixOS {
    fuji = {
      system = "x86_64-linux";
      modules = desktop;
    };

    kilimandjaro = {
      system = "x86_64-linux";
      modules = desktop;
    };
  };
}
