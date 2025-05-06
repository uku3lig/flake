{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.neovide ];

  hjem.users.leo.files.".config/neovide/config.toml".text = "fork = true";
}
