{
  imports = [
    ../fuzzel.nix
  ];

  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  programs.niri.enable = true;
  programs.ssh.startAgent = false;
}
