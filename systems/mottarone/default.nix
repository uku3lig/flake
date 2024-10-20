{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gtkterm
    maven
    svn2git
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
