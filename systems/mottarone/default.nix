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

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs;
  };

  services.resolved.dnsovertls = lib.mkForce "false";

  virtualisation.docker.enable = true;
}
