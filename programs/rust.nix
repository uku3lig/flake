{
  pkgs,
  ...
}:
let
  toml = pkgs.formats.toml { };
in
{
  hj.".cargo/config.toml".source = toml.generate "config.toml" {
    build.target-dir = "~/.cargo/target";
  };
}
