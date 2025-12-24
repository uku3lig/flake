{ stdenvNoCC, fetchFromGitHub }:
stdenvNoCC.mkDerivation {
  pname = "waywork";
  version = "0-unstable-2025-11-29";

  src = fetchFromGitHub {
    owner = "Esensats";
    repo = "waywork";
    rev = "60ab89dfe32d894845a759a08cebd3d710262bcb";
    hash = "sha256-XF+FgnLRnn0MydVN3Qthg/CwC8p5+8jo0QhlpPpaWMc=";
  };

  dontBuild = true;
  dontCheck = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/waywork
    cp *.lua $out/waywork

    runHook postInstall
  '';
}
