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

  _common = with inputs; [
    ../configs/common.nix
    agenix.nixosModules.default
    home-manager.nixosModules.home-manager
    vscode-server.nixosModules.default
  ];

  physical-computer = with inputs; [
    ../configs/physical-computer.nix
    lanzaboote.nixosModules.lanzaboote
  ];

  client = [../configs/client.nix] ++ _common;

  server = [../configs/server.nix] ++ _common;

  desktop = with inputs;
    [
      ../configs/desktop.nix
      catppuccin.nixosModules.catppuccin
    ]
    ++ physical-computer
    ++ client;
in {
  flake.nixosConfigurations = mapNixOS {
    fuji = {
      system = "x86_64-linux";
      modules = desktop;
    };

    fuji-wsl = {
      system = "x86_64-linux";
      modules =
        client
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
        ++ physical-computer
        ++ (with inputs; [
          api-rs.nixosModules.default
          ukubot-rs.nixosModules.default
          self.nixosModules.reposilite
        ]);
    };
  };
}
