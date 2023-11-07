{
  description = "example flake idk";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    getchvim = {
      url = "github:getchoo/getchvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations.fuji = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./fuji.nix];
      specialArgs = {inherit inputs;};
    };

    nixosConfigurations.kilimandjaro = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./kilimandjaro.nix];
      specialArgs = {inherit inputs;};
    };

    formatter.x86_64-linux = inputs.nixpkgs.legacyPackages.x86_64-linux.alejandra;
  };
}
