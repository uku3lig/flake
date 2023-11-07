{
  description = "example flake idk";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    getchvim = {
      url = "github:getchoo/getchvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.fuji = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./fuji.nix];
      specialArgs = inputs;
    };

    nixosConfigurations.kilimandjaro = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./kilimandjaro.nix];
      specialArgs = inputs;
    };

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
