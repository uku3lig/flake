{
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
  };
}
