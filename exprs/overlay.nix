final: prev: {
  wine-discord-ipc-bridge = prev.callPackage ./wine-discord-ipc-bridge.nix {
    inherit (prev.pkgsCross.mingw32) stdenv;
  };

  jmusicbot = prev.jmusicbot.overrideAttrs (_: rec {
    version = "0.4.3";

    src = prev.fetchurl {
      url = "https://github.com/jagrosh/MusicBot/releases/download/${version}/JMusicBot-${version}.jar";
      hash = "sha256-7CHFc94Fe6ip7RY+XJR9gWpZPKM5JY7utHp8C3paU9s=";
    };
  });
}
