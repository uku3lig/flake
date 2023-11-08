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
    modules' = [ragenix.nixosModules.default lanzaboote.nixosModules.lanzaboote];
  in {
    nixosConfigurations.fuji = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./fuji.nix] ++ modules';
      specialArgs = inputs;
    };

    nixosConfigurations.kilimandjaro = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./kilimandjaro.nix] ++ modules';
      specialArgs = inputs;
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
