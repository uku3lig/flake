{self, ...}: {
  flake.nixosModules = {
    reposilite = import ./reposilite/module.nix self;
  };

  perSystem = {pkgs, ...}: {
    packages = {
      reposilite = pkgs.callPackage ./reposilite/derivation.nix {};
      enigma = pkgs.callPackage ./pkgs/enigma.nix {};
      vineflower = pkgs.callPackage ./pkgs/vineflower.nix {};

      wine-discord-ipc-bridge = pkgs.callPackage ./pkgs/wine-discord-ipc-bridge.nix {
        inherit (pkgs.pkgsCross.mingw32) stdenv;
      };
    };
  };
}
