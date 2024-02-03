final: prev: {
  electron_25 = prev.electron_25.overrideAttrs (_: {
    preFixup = "patchelf --add-needed ${prev.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
    meta.knownVulnerabilities = []; # NixOS/nixpkgs#273611
  });

  wine-discord-ipc-bridge = prev.callPackage ./wine-discord-ipc-bridge.nix {
    inherit (prev.pkgsCross.mingw32) stdenv;
  };

  reposilite = prev.callPackage ./reposilite/derivation.nix {};
}
