{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  name = "wine-discord-ipc-bridge";

  src = fetchFromGitHub {
    owner = "0e4ef622";
    repo = "wine-discord-ipc-bridge";
    rev = "f8198c9d52e708143301017a296f7557c4387127";
    hash = "sha256-tAknITFlG63+gI5cN9SfUIUZkbIq/MgOPoGIcvoNo4Q=";
  };

  postPatch = ''
    patchShebangs winediscordipcbridge-steam.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp winediscordipcbridge.exe $out/bin
    cp winediscordipcbridge-steam.sh $out/bin
  '';

  meta.platforms = ["i686-windows" "x86_64-linux"];
}
