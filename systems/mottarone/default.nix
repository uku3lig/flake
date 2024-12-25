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
    jetbrains.pycharm-professional
  ];

  i18n.defaultLocale = lib.mkForce "fr_FR.UTF-8";

  hm.programs = {
    git.enable = lib.mkForce false;
    ssh.enable = lib.mkForce false;
  };

  services = {
    resolved = {
      dnssec = "allow-downgrade";
      dnsovertls = "false";
    };

    postgresql.enable = true;
    pgadmin = {
      enable = true;
      initialEmail = "hi@uku.moe";
      initialPasswordFile = "/run/pgadminpwd";
    };
  };
}
