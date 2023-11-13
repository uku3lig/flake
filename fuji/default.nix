{
  services.xserver.videoDrivers = ["amdgpu"];

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
