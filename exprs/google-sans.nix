{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "google-sans";
  version = "0-unstable-2018-07-18";

  src = fetchFromGitHub {
    owner = "hprobotic";
    repo = "Google-Sans-Font";
    rev = "ce4644946bd4e662fec8cf9736b3f99fefa7d308";
    hash = "sha256-87dKgkb27+O3Y3qQ203PDY3yLCduvIj7hFfNAV9gLOA=";
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';
}
