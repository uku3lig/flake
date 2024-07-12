final: prev: {
  wine-discord-ipc-bridge = prev.callPackage ./wine-discord-ipc-bridge.nix {
    inherit (prev.pkgsCross.mingw32) stdenv;
  };

  jmusicbot = prev.jmusicbot.overrideAttrs (_: rec {
    version = "0.4.2";

    src = prev.fetchurl {
      url = "https://github.com/jagrosh/MusicBot/releases/download/${version}/JMusicBot-${version}.jar";
      hash = "sha256-Jg6/ju3ADBd7fc3njRzoEDVjIL4SzAzlTc02I4Q9hz4=";
    };
  });
}
