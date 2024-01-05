{
  lib,
  pkgs,
  config,
  ...
}: let
  toml = pkgs.formats.toml {};
in {
  hm.home.file.".cargo/config.toml".source = toml.generate "config.toml" {
    build = {
      rustc-wrapper = "${lib.getExe' pkgs.sccache "sccache"}";
      target-dir = "${config.hm.home.homeDirectory}/.cargo/target";
    };

    target.x86_64-unknown-linux-gnu = {
      linker = "${lib.getExe pkgs.clang}";
      rustflags = ["-C" "link-arg=-fuse-ld=${lib.getExe pkgs.mold}"];
    };
  };
}
