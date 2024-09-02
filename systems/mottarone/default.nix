{lib, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    chromium
    gtkterm
    (pkgs.callPackage ./teams.nix {})
  ];

  services.resolved.dnsovertls = lib.mkForce "false";
}
