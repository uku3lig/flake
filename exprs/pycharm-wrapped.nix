{
  lib,
  black,
  makeWrapper,
  pycharm,
  symlinkJoin,
}:
symlinkJoin {
  name = "pycharm-wrapped-${pycharm.version}";

  paths = [ pycharm ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/${pycharm.meta.mainProgram} \
      --prefix PATH : ${lib.makeBinPath [ black ]}
  '';
}
