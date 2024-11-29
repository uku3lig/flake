{
  pkgs,
  camasca,
  ...
}: {
  imports = [
    camasca.nixosModules.asus-numpad
    ../../programs/games.nix
  ];

  environment.systemPackages = [
    (pkgs.jetbrains.rider.overrideAttrs (old: {
      postInstall = builtins.replaceStrings ["ln -s ${pkgs.dotnet-sdk_7}"] ["ln -s ${pkgs.dotnet-sdk_8.unwrapped}/share/dotnet"] old.postInstall or "";
    }))
  ];

  hm.imports = [../../programs/dotnet.nix];

  services.asus-numpad = {
    enable = true;
    settings.layout = "M433IA";
  };

  boot = {
    initrd.kernelModules = ["i915"];
    kernelParams = ["i915.force_probe=9a49"];
  };

  hardware.graphics.extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl intel-media-driver];
}
