{modulesPath, ...}: {
  imports = ["${modulesPath}/profiles/qemu-guest.nix"];

  boot = {
    # arm so we can use systemd-boot
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    # set console because the console defaults to serial and
    # initialize the display early to get a complete log.
    # this is required for typing in LUKS passwords on boot too.
    kernelParams = ["console=tty"];

    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
      kernelModules = ["nvme" "virtio_gpu"];
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6FB6-65E7";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
}
