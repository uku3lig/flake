{self, ...}: {
  flake.nixosModules = {
    reposilite = import ./reposilite/module.nix self;
  };

  perSystem = {pkgs, ...}: {
    packages = {
      reposilite = pkgs.callPackage ./reposilite/derivation.nix {};
      wine-discord-ipc-bridge = pkgs.callPackage ./wine-discord-ipc-bridge.nix {};
    };
  };
}
