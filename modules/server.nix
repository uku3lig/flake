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
  
  hm.home.stateVersion = "23.11";

  services.tailscale.extraUpFlags = ["--advertise-exit-node"];

  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel"];
    hashedPasswordFile = config.age.secrets.userPassword.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+7+KfdOrhcnHayxvOENUeMx8rE4XEIV/AxMHiaNUP8"
    ];
  };
}
