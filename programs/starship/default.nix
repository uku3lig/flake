{ lib, pkgs, ... }:
let
  toml = pkgs.formats.toml { };
in
{
  environment.systemPackages = [ pkgs.starship ];

  hj = {
    ".config/starship.toml" =
      toml.generate "starship.toml" {
        add_newline = false;

        directory = {
          truncation_length = 3;
          truncation_symbol = "…/";
        };
      }
      // (import ./nerd-font.nix);

    ".config/fish/config.fish".text = lib.mkAfter ''
      starship init fish | source
    '';
  };
}
