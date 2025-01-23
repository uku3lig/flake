{
  lib,
  pkgs,
  camasca,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
{
  environment.systemPackages = with pkgs; [
    gtkterm
    remmina
    camasca.packages.${system}.openwebstart
    camasca.packages.${system}.jaspersoft-studio-community
    jetbrains.pycharm-community-bin
  ];

  i18n.defaultLocale = lib.mkForce "fr_FR.UTF-8";

  hm.programs = {
    git.includes = [ { path = "~/.config/git/work_config"; } ];
    ssh.includes = [ "work_config" ];
  };

  services = {
    resolved = {
      dnssec = "allow-downgrade";
      dnsovertls = "false";
    };

    postgresql.enable = true;
  };
}
