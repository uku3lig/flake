{
  lib,
  pkgs,
  config,
  ...
}:
let
  toml = pkgs.formats.toml { };
in
{
  hj.".cargo/config.toml".source = toml.generate "config.toml" {
    build.target-dir = "${config.hjem.users.leo.directory}/.cargo/target";

    target.x86_64-unknown-linux-gnu = {
      linker = "${lib.getExe pkgs.clang}";
      rustflags = [
        "-C"
        "link-arg=-fuse-ld=${lib.getExe pkgs.mold}"
      ];
    };
  };
}
