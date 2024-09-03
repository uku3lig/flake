{lib, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    chromium
    gtkterm
    (pkgs.callPackage ./teams.nix {})
  ];

  programs.git.package = pkgs.gitSVN;

  services.resolved.dnsovertls = lib.mkForce "false";
}
