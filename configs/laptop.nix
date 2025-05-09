{
  lib,
  pkgs,
  config,
  _utils,
  ...
}:
{
  imports = [ ./desktop.nix ];

  boot.initrd.kernelModules = [ "xe" ];

  hardware = {
    bluetooth.enable = true;

    graphics = {
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
        vpl-gpu-rt
      ];

      extraPackages32 = [ pkgs.driversi686Linux.intel-media-driver ];
    };
  };

  services = {
    libinput.enable = true;
    power-profiles-daemon.enable = true;
  };

  programs.light.enable = true;

  # hyprland stuff
  services.blueman = lib.mkIf config.programs.hyprland.enable { enable = true; };
  hj.".config/hypr/hyprland.conf".text = _utils.toHyprconf {
    exec-once = with pkgs; [
      "${lib.getExe networkmanagerapplet}"
      "${lib.getExe' blueman "blueman-applet"}"
    ];
  };
}
