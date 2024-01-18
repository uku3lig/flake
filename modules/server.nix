{
  lib,
  pkgs,
  config,
  ...
}: let
  username = "uku";
in {
  imports = [
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" username])

    ../programs/fish.nix
    ../programs/git.nix
    ../programs/starship.nix
  ];

  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel"];
    hashedPasswordFile = config.age.secrets.userPassword.path;
  };
}
