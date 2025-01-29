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
  imports = [
    ./glpi-agent.nix
    ./urbackup.nix
  ];

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

  networking.firewall.allowedTCPPorts = [ 8000 ];

  services = {
    resolved = {
      dnssec = "allow-downgrade";
      dnsovertls = "false";
    };

    postgresql.enable = true;
    pgadmin = {
      enable = true;
      initialEmail = "hi@uku.moe";
      initialPasswordFile = "/opt/pgadminpwd";
    };
  };
}
