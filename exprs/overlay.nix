final: prev: {
  wine-discord-ipc-bridge = prev.callPackage ./wine-discord-ipc-bridge.nix {
    inherit (prev.pkgsCross.mingw32) stdenv;
  };

  fuzzel = prev.fuzzel.overrideAttrs (_: rec {
    version = "1.10.2";

    src = prev.fetchFromGitea {
      domain = "codeberg.org";
      owner = "dnkl";
      repo = "fuzzel";
      rev = version;
      hash = "sha256-I+h93/I1Kra2S5QSi2XgICAVrcUmO9cmb8UttVuzjwg=";
    };
  });
}
