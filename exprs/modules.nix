{self, ...}: {
  flake.nixosModules = {
    reposilite = import ./reposilite/module.nix self;
  };
}
