{
  lib,
  pkgs,
  config,
  ...
}: let
  username = "leo";
in {
  imports = [
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" username])

    ../../programs/fish.nix
    ../../programs/git.nix
    ../../programs/starship.nix
  ];

  hm.home.stateVersion = "23.11";

  wsl = {
    enable = true;
    defaultUser = username;
  };

  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["wheel"];
    hashedPasswordFile = config.age.secrets.userPassword.path;
  };
}
