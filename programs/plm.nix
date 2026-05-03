{ pkgs, ... }:
{
  services.displayManager.plasma-login-manager = {
    enable = true;
  };
}
