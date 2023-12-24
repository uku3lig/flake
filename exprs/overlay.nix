final: prev: {
  # FUCK REPRODUCIBILITY RARGHGHGHGHDKGJDKLGJSDKLGMDJGLKSDJLMGSJDKMGJZEIZ
  vesktop = prev.vesktop.overrideAttrs (old: {patches = [];});

  electron_25 = prev.electron_25.overrideAttrs (_: {
    preFixup = "patchelf --add-needed ${prev.libglvnd}/lib/libEGL.so.1 $out/bin/electron"; # NixOS/nixpkgs#272912
    meta.knownVulnerabilities = []; # NixOS/nixpkgs#273611
  });

  aseprite = prev.aseprite.overrideAttrs (old: rec {
    version = "1.3.2";

    src = prev.fetchFromGitHub {
      owner = "aseprite";
      repo = "aseprite";
      rev = "v${version}";
      fetchSubmodules = true;
      hash = "sha256-8PXqMDf2ATxmtFqyZlGip+DhGrdK8M6Ztte7fGH6Fmo=";
    };

    meta.license = prev.lib.licenses.mit; # removes unfree error
  });
}
