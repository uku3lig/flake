{
  lib,
  pkgs,
  config,
  nixpkgs,
  ragenix,
  ...
}: {
  age = {
    identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets = {
      tailscaleKey.file = ../secrets/tailscaleKey.age;
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["quiet" "loglevel=3"];
  };

  console.keyMap = "fr";

  environment = {
    systemPackages = with pkgs; let
      inherit (pkgs.stdenv.hostPlatform) system;
    in [
      ragenix.packages.${system}.default
      neovim
      git
      curl
    ];

    variables = {
      EDITOR = lib.getExe pkgs.neovim;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "-d";
    };

    registry = let
      nixpkgsRegistry.flake = nixpkgs;
    in {
      nixpkgs = nixpkgsRegistry;
      n = nixpkgsRegistry;
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [(import ../exprs/overlay.nix)];
  };

  programs = {
    ssh.startAgent = true;

    direnv.enable = true;

    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = lib.mkDefault false;
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      extraUpFlags = ["--ssh"];
      authKeyFile = config.age.secrets.tailscaleKey.path;
    };
  };

  time.timeZone = "Europe/Paris";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkDefault "23.11"; # Did you read the comment?
}
