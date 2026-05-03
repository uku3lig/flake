{
  lib,
  pkgs,
  ...
}:
let
  # nixpkgs/pkgs/build-support/replace-vars/replace-vars-with.nix
  subst-var-by = name: value: [
    "--replace-fail"
    "@${name}@"
    value
  ];

  replaceVars' =
    src: replacements:
    pkgs.substitute {
      inherit src;
      substitutions = lib.concatLists (lib.mapAttrsToList subst-var-by replacements);
    };
in
{
  imports = [ ../plm.nix ];

  programs = {
    niri.enable = true;
    dms-shell.enable = true;

    ssh.startAgent = false;

    nautilus-open-any-terminal = {
      enable = true;
      terminal = "ghostty";
    };
  };

  environment.systemPackages = with pkgs; [
    adw-gtk3
    adwaita-icon-theme
    file-roller
    gnome-calculator
    loupe
    nautilus
    polkit_gnome
    xwayland-satellite
  ];

  hj.".config/niri/config.kdl".source = replaceVars' ./config.kdl {
    polkitAgent = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };
}
