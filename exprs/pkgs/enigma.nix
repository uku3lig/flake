{
  stdenv,
  fetchurl,
  temurin-bin,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "enigma";
  version = "2.5.0";

  src = fetchurl {
    url = with finalAttrs; "https://maven.fabricmc.net/cuchaz/enigma-swing/${version}/enigma-swing-${version}-all.jar";
    hash = "sha256-yOPPTKt96aRSbziYDBLBKqfLS2R9GeXgz5m2t1fgFHo=";
  };

  dontUnpack = true;

  nativeBuildInputs = [makeWrapper copyDesktopItems];

  installPhase = with finalAttrs; ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${name}
    cp ${src} $out/share/${name}/${name}.jar
    makeWrapper ${temurin-bin}/bin/java $out/bin/${name} --add-flags "-jar $out/share/${name}/${name}.jar"

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "enigma";
      desktopName = "Enigma";
      exec = "enigma";
      terminal = false;
    })
  ];

  meta.mainProgram = "enigma";
})
