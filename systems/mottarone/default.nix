{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    chromium
    gtkterm
  ];

  i18n.defaultLocale = lib.mkForce "fr_FR.UTF-8";

  programs.git.package = pkgs.gitSVN;
  hm.programs = {
    git.enable = lib.mkForce false;
    ssh.enable = lib.mkForce false;
  };

  services.resolved.dnsovertls = lib.mkForce "false";

  services.tomcat = {
    enable = true;
    jdk = pkgs.temurin-bin-8;
  };
}
