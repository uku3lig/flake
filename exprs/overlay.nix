final: prev: {
  shotcut = final.qt6Packages.callPackage ./shotcut.nix {};

  # FUCK REPRODUCIBILITY RARGHGHGHGHDKGJDKLGJSDKLGMDJGLKSDJLMGSJDKMGJZEIZ
  vesktop = prev.vesktop.overrideAttrs (old: {patches = [];});

  obsidian = (
    prev.obsidian.override {
      electron = prev.electron_25.overrideAttrs (_: {
        preFixup = "patchelf --add-needed ${prev.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
        meta.knownVulnerabilities = []; # NixOS/nixpkgs#273611
      });
    }
  );
}
