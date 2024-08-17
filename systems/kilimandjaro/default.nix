{pkgs, ...}: {
  boot = {
    initrd.kernelModules = ["i915"];
    kernelParams = ["i915.force_probe=9a49"];
  };

  hardware.graphics.extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl intel-media-driver];
}
