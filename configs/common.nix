{
  lib,
  pkgs,
  config,
  nixpkgs,
  agenix,
  ...
}: let
  username = "leo";
  stateVersion = "23.11";
in {
  imports = [
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" username])

    ../programs/fish.nix
    ../programs/git.nix
    ../programs/starship
  ];

  age = {
    identityPaths = ["/etc/age/key"];

    secrets = {
      rootPassword.file = ../secrets/${config.networking.hostName}/rootPassword.age;
      userPassword.file = ../secrets/userPassword.age;
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
      agenix.packages.${system}.default
      neovim
      git
      curl
      wget
      nil
    ];

    variables = {
      EDITOR = lib.getExe pkgs.neovim;
    };
  };

  hm = {
    home = {inherit stateVersion;};

    programs.keychain = {
      enable = true;
      agents = ["ssh"];
      inheritType = "any";
      keys = ["id_ed25519"];
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

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

    nix-ld.enable = true;

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

    vscode-server.enable = true;

    resolved = {
      enable = lib.mkDefault true;
      dnssec = "allow-downgrade";
      extraConfig = lib.mkDefault ''
        [Resolve]
        DNS=1.1.1.1 1.0.0.1
        DNSOverTLS=yes
      '';
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      extraUpFlags = ["--ssh"];
      authKeyFile = config.age.secrets.tailscaleKey.path;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  time.timeZone = "Europe/Paris";

  users.users = {
    "${username}" = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["networkmanager" "wheel" "video" "libvirtd"];
      hashedPasswordFile = config.age.secrets.userPassword.path;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+7+KfdOrhcnHayxvOENUeMx8rE4XEIV/AxMHiaNUP8"
      ];
    };

    root.hashedPasswordFile = config.age.secrets.rootPassword.path;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkDefault stateVersion; # Did you read the comment?
}
