final: prev: {
  wine-discord-ipc-bridge = prev.callPackage ./wine-discord-ipc-bridge.nix {
    inherit (prev.pkgsCross.mingw32) stdenv;
  };
}
