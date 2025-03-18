{
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "patchouli-cursors";
  version = "0";

  src = fetchFromGitHub {
    owner = "mabequinho";
    repo = "touhou-cursors";
    rev = "92a5513c5d247fb1813e27ac2986e85def510204";
    hash = "sha256-XYmEpRkvZK7O9F7s3nKFA9rd7xO0ECEWlVyUb8/whq4=";
  };

  installPhase = ''
    mkdir -p $out/share/icons
    cp -r Patchouli $out/share/icons
  '';
}
