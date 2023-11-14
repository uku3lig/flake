{
  description = "example flake idk";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    getchvim = {
      url = "github:getchoo/getchvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        parts.follows = "flake-parts";
      };
    };
  };

  outputs = {
    flake-parts,
    nixpkgs,
    lanzaboote,
    home-manager,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [./dev.nix];

      flake = let
        mkSystem = modules: name:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules =
              [
                ./${name}
                ./${name}/hardware-configuration.nix

                {networking.hostName = name;}
              ]
              ++ modules;
            specialArgs = inputs;
          };

        mkDesktop = mkSystem [
          ./common.nix
          lanzaboote.nixosModules.lanzaboote
          home-manager.nixosModules.home-manager
        ];
      in {
        nixosConfigurations = {
          fuji = mkDesktop "fuji";
          kilimandjaro = mkDesktop "kilimandjaro";
        };
      };
    };
}
