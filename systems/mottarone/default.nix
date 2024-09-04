{
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    chromium
    gtkterm
    (pkgs.callPackage ./teams.nix {})
    svn2git
  ];

  programs.git.package = pkgs.gitSVN;
  hm.programs.git.enable = lib.mkForce false;

  services.resolved.dnsovertls = lib.mkForce "false";
}
