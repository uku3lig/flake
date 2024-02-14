{
  lib,
  self,
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
    ../configs/common.nix
    agenix.nixosModules.default
    home-manager.nixosModules.home-manager
    vscode-server.nixosModules.default
  ];

  desktop = with inputs;
    [
      ../configs/desktop.nix
      lanzaboote.nixosModules.lanzaboote
      catppuccin.nixosModules.catppuccin
    ]
    ++ nixos;

  server = nixos ++ [../configs/server.nix];
in {
  flake.nixosConfigurations = mapNixOS {
    fuji = {
      system = "x86_64-linux";
      modules = desktop;
    };

    fuji-wsl = {
      system = "x86_64-linux";
      modules =
        nixos
        ++ (with inputs; [
          nixos-wsl.nixosModules.default
        ]);
    };

    kilimandjaro = {
      system = "x86_64-linux";
      modules = desktop;
    };

    etna = {
      system = "x86_64-linux";
      modules =
        server
        ++ (with inputs; [
          api-rs.nixosModules.default
          ukubot-rs.nixosModules.default
          self.nixosModules.reposilite
        ]);
    };
  };
}
