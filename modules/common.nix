{
  lib,
  pkgs,
  config,
  nixpkgs,
  ragenix,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["quiet" "loglevel=3"];
  };

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

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "fr";

  age = {
    identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

    secrets = {
      tailscaleKey.file = ../secrets/tailscaleKey.age; 
    };
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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
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

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [(import ../exprs/overlay.nix)];
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "-d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];
    };
  };

  nix.registry = let
    nixpkgsRegistry.flake = nixpkgs;
  in {
    nixpkgs = nixpkgsRegistry;
    n = nixpkgsRegistry;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkDefault "23.11"; # Did you read the comment?
}
