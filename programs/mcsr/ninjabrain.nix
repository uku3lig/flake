{
  lib,
  stdenvNoCC,
  fetchurl,
  libx11,
  libxinerama,
  libxkbcommon,
  libxt,
  makeWrapper,
  temurin-bin-21,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ninjabrain-bot";
  version = "1.5.1";

  src = fetchurl {
    url = "https://github.com/Ninjabrain1/Ninjabrain-Bot/releases/download/${finalAttrs.version}/Ninjabrain-Bot-${finalAttrs.version}.jar";
    hash = "sha256-Rxu9A2EiTr69fLBUImRv+RLC2LmosawIDyDPIaRcrdw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/share/ninjabrain-bot/ninjabrain-bot.jar

    makeWrapper ${lib.getExe temurin-bin-21} $out/bin/ninjabrain-bot \
        --add-flags "-Dawt.useSystemAAFontSettings=on -jar $out/share/ninjabrain-bot/ninjabrain-bot.jar" \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libx11
            libxinerama
            libxkbcommon
            libxt
          ]
        }

    runHook postInstall
  '';

  meta = {
    description = "Stronghold calculator for Minecraft speedrunning";
    homepage = "https://github.com/Ninjabrain1/Ninjabrain-Bot";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "ninjabrain-bot";
  };
})
