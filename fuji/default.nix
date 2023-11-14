{lib, ...}: {
  services.xserver.videoDrivers = ["amdgpu"];

  hm.wayland.windowManager.hyprland.settings = {
    monitor = lib.mkForce ["DP-1,1920x1200@60,0x0,1" "HDMI-A-1,1440x900@60,1920x300,1"];
  };

  # services.xserver.videoDrivers = ["nvidia"];

  # hardware.opengl = {
  #   driSupport = true;
  #   driSupport32Bit = true;
  # };

  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement = {
  #     enable = true;
  #     finegrained = false;
  #   };
  #   open = false;
  #   nvidiaSettings = true;
  # };

  # boot.extraModprobeConfig = ''
  #   options nvidia NVreg_RegistryDwords="PowerMizerEnable=0x1; PerfLevelSrc=0x2222; PowerMizerLevel=0x3; PowerMizerDefault=0x3; PowerMizerDefaultAC=0x3"
  # '';

  # programs.hyprland.enableNvidiaPatches = true;
}
