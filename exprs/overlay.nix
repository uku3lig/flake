final: prev: {
  shotcut = final.qt6Packages.callPackage ./shotcut.nix {};

  # FUCK REPRODUCIBILITY RARGHGHGHGHDKGJDKLGJSDKLGMDJGLKSDJLMGSJDKMGJZEIZ
  vesktop = prev.vesktop.overrideAttrs (old: {patches = [];});
}
