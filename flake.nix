{
  description = "example flake idk";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
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
    nixpkgs,
    ragenix,
    lanzaboote,
    ...
  } @ inputs: let
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
        ];
        specialArgs = inputs;
      };
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs ["fuji" "kilimandjaro"] mkSystem;

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
