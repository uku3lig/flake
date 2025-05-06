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
    ./urbackup.nix
  ];

  environment.systemPackages = with pkgs; [
    gtkterm
    remmina
    camasca.packages.${system}.openwebstart
    camasca.packages.${system}.jaspersoft-studio-community
    camasca.packages.${system}.sql-developer
    pycharm-wrapped
    recaf-launcher
  ];

  fonts.packages = with pkgs; [
    corefonts
    vistafonts
  ];

  i18n.defaultLocale = lib.mkForce "fr_FR.UTF-8";

  hjem.users.leo.files = {
    ".gitconfig".text = lib.generators.toGitINI {
      include.path = "~/.config/git/work_config";
    };

    ".ssh/config".text = lib.mkBefore ''
      Include work_config
    '';
  };

  networking.firewall.allowedTCPPorts = [ 8000 ];

  services = {
    resolved = {
      dnssec = "allow-downgrade";
      dnsovertls = "false";
    };

    glpiAgent = {
      enable = true;
      settings = {
        server = "https://assistance.sciencespo-lyon.fr";
        delaytime = 3600;
        lazy = 0;
        logger = "stderr";
      };
    };

    postgresql.enable = true;
    pgadmin = {
      enable = true;
      initialEmail = "hi@uku.moe";
      initialPasswordFile = "/opt/pgadminpwd";
    };
  };
}
