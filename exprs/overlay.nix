final: prev: {
  vesktop = final.callPackage ./vesktop/default.nix {};

  shotcut = final.qt6Packages.callPackage ./shotcut.nix {};
}
