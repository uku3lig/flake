{
  description = "example flake idk";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = inputs: { 
    nixosConfigurations.miguel = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [./configuration.nix];
      specialArgs = inputs;
    };
  };
}
