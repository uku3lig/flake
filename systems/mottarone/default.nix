{lib, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    chromium
    gtkterm
    (pkgs.callPackage ./teams.nix {})
    svn2git
  ];

  programs.git.package = pkgs.gitSVN;

  services.resolved.dnsovertls = lib.mkForce "false";
}
