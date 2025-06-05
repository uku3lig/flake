{
  lib,
  pkgs,
  camascaPkgs,
  ...
}:
{
  imports = [
    ./urbackup.nix
  ];

  environment.systemPackages = with pkgs; [
    gtkterm
    remmina
    camascaPkgs.openwebstart
    camascaPkgs.jaspersoft-studio-community
    camascaPkgs.sql-developer
    pycharm-wrapped
    recaf-launcher
  ];

  fonts.packages = with pkgs; [
    corefonts
    vistafonts
  ];

  i18n.defaultLocale = lib.mkForce "fr_FR.UTF-8";

  hj = {
    ".gitconfig".text = lib.mkAfter (
      lib.generators.toGitINI {
        include.path = "~/.config/git/work_config";
      }
    );

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

    postgresql = {
      enable = true;
      authentication = ''
        local all postgres peer
        local all leo peer
        local all all md5
      '';
    };
    pgadmin = {
      enable = true;
      initialEmail = "hi@uku.moe";
      initialPasswordFile = "/opt/pgadminpwd";
    };
  };
}
