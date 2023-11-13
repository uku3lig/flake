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

    ragenix = {
      url = "github:yaxitech/ragenix";
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
    ragenix,
    lanzaboote,
    home-manager,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];

      flake = let
        mkSystem = name:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./common.nix

              ./${name}
              ./${name}/hardware-configuration.nix

              {networking.hostName = name;}

              ragenix.nixosModules.default
              lanzaboote.nixosModules.lanzaboote
              home-manager.nixosModules.home-manager
            ];
            specialArgs = inputs;
          };
      in {
        nixosConfigurations = nixpkgs.lib.genAttrs ["fuji" "kilimandjaro"] mkSystem;
      };

      perSystem = {system, ...}: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            alejandra
            fzf
            just
            nil
          ];
        };

        formatter = pkgs.alejandra;
      };
    };
}
