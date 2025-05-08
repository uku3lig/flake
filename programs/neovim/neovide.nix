{ pkgs, ... }:
{
  environment.systemPackages = [ pkgs.neovide ];

  hj.".config/neovide/config.toml".text = "fork = true";
}
