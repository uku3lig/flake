final: prev: {
  # FUCK REPRODUCIBILITY RARGHGHGHGHDKGJDKLGJSDKLGMDJGLKSDJLMGSJDKMGJZEIZ
  vesktop = prev.vesktop.overrideAttrs (old: {patches = [];});

  electron_25 = prev.electron_25.overrideAttrs (_: {
    preFixup = "patchelf --add-needed ${prev.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
    meta.knownVulnerabilities = []; # NixOS/nixpkgs#273611
  });

  lunar-client = prev.callPackage ./lunar-client.nix {};
}
