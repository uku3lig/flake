{
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "vineflower";
  version = "1.10.1";

  src = fetchurl {
    url = with finalAttrs; "https://github.com/Vineflower/vineflower/releases/download/${version}/vineflower-${version}.jar";
    hash = "sha256-ubII5QeTtkZXprYpIGdSZhP1Sd50BfkkNiSwL0J25Ak=";
  };

  nativeBuildInputs = [makeWrapper];

  dontUnpack = true;

  installPhase = with finalAttrs; ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${name}
    cp ${src} $out/share/${name}/${name}.jar
    makeWrapper ${jre_headless}/bin/java $out/bin/${name} --add-flags "-jar $out/share/${name}/${name}.jar"

    runHook postInstall
  '';

  meta.mainProgram = "vineflower";
})
