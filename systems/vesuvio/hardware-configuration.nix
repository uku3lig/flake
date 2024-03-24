{modulesPath, ...}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };

    initrd = {
      availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
      kernelModules = ["nvme"];
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
