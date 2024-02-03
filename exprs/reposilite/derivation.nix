{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jdk21,
}:
stdenv.mkDerivation rec {
  name = "reposilite";
  version = "3.5.3";

  src = fetchurl {
    url = "https://maven.reposilite.com/releases/com/reposilite/reposilite/${version}/reposilite-${version}-all.jar";
    hash = "sha256-ZqewhOWb49ykmzvIebolXkxtNKA46bCgM7L7yvkVgfE=";
  };

  nativeBuildInputs = [makeWrapper];

  phases = ["installPhase"];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${name}
    cp ${src} $out/share/${name}/${name}.jar
    makeWrapper ${jdk21}/bin/java $out/bin/${name} --add-flags "-jar $out/share/${name}/${name}.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lightweight and easy-to-use repository management software dedicated for the Maven based artifacts in the JVM ecosystem";
    homepage = "https://reposilite.com/";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "reposilite";
  };
}
