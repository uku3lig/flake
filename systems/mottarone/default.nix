{
  lib,
  pkgs,
  camasca,
  ...
}: let
  inherit (pkgs.stdenv.hostPlatform) system;
in {
  environment.systemPackages = with pkgs; [
    gtkterm
    maven
    svn2git
    remmina
    camasca.packages.${system}.openwebstart
    jetbrains.pycharm-community
  ];

  i18n.defaultLocale = lib.mkForce "fr_FR.UTF-8";

  programs.git.package = pkgs.gitSVN;
  hm.programs = {
    git.enable = lib.mkForce false;
    ssh.enable = lib.mkForce false;
  };

  services.resolved = {
    dnssec = lib.mkForce "allow-downgrade";
    dnsovertls = lib.mkForce "false";
  };

  virtualisation.docker.enable = true;
}
