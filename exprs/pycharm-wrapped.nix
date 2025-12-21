{
  lib,
  jetbrains,
  makeWrapper,
  symlinkJoin,
  black,
}:
let
  inherit (jetbrains) pycharm;
in
symlinkJoin {
  name = "pycharm-wrapped-${pycharm.version}";

  paths = [ pycharm ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/pycharm \
      --prefix PATH : ${lib.makeBinPath [ black ]}
  '';
}
