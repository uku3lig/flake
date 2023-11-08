{
  description = "example flake idk";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    getchvim = {
      url = "github:getchoo/getchvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        parts.follows = "flake-parts";
        pre-commit.follows = "pre-commit";
      };
    };

    pre-commit = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
    };
  };

  outputs = {
    nixpkgs,
    ragenix,
    ...
  } @ inputs: {
    nixosConfigurations.fuji = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./fuji.nix ragenix.nixosModules.default];
      specialArgs = inputs;
    };

    nixosConfigurations.kilimandjaro = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./kilimandjaro.nix ragenix.nixosModules.default];
      specialArgs = inputs;
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
