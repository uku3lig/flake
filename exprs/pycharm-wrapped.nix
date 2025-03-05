{
  lib,
  jetbrains,
  makeWrapper,
  symlinkJoin,
  black,
}:
let
  inherit (jetbrains) pycharm-community-bin;
in
symlinkJoin {
  name = "pycharm-wrapped-${pycharm-community-bin.version}";

  paths = [ pycharm-community-bin ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/pycharm-community \
      --prefix PATH : ${lib.makeBinPath [ black ]}
  '';
}
