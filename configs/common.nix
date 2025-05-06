{
  lib,
  pkgs,
  config,
  _utils,
  agenix,
  camasca,
  home-manager,
  nixpkgs,
  nix-index-database,
  vencord,
  ...
}:
let
  username = "leo";
  stateVersion = "24.11";

  rootPassword = _utils.setupSingleSecret config "rootPassword" { };
  secrets = _utils.setupSharedSecrets config {
    secrets = [ "userPassword" ];
  };
in
{
  imports = [
    agenix.nixosModules.default
    home-manager.nixosModules.home-manager
    nix-index-database.nixosModules.nix-index

    (lib.mkAliasOptionModule [ "hm" ] [ "home-manager" "users" username ])

    rootPassword.generate
    secrets.generate

    ../programs/fish.nix
    ../programs/git.nix
    ../programs/neovim
  ];

  age = {
    ageBin = lib.getExe pkgs.rage;
    identityPaths = [ "/etc/age/key" ];
  };

  boot = {
    # see ./server.nix and ./client.nix for kernel versions
    kernelParams = [
      "quiet"
      "loglevel=3"
    ];

    # faster tcp !!!
    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    tmp.cleanOnBoot = true;
  };

  console.keyMap = "fr";

  environment.systemPackages = with pkgs; [
    btop
    curl
    fd
    git
    htop
    jq
    ncdu
    ripgrep
    wget
  ];

  hm = {
    home = { inherit stateVersion; };

    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      forwardAgent = true;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    useNetworkd = lib.mkDefault true;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };

  nix = {
    # package = pkgs.nixVersions.nix_2_24;
    channel.enable = false;
    # The `flake:` syntax in `$NIX_PATH` seems to do some weird copying on Nix 2.24
    nixPath = [ "nixpkgs=${config.nixpkgs.flake.source}" ];

    gc = {
      automatic = true;
      dates = "weekly";
      options = "-d";
    };

    registry = {
      n.flake = nixpkgs;
      nixpkgs.flake = nixpkgs;
      u.flake = camasca;
    };

    # give nix daemon lower priority
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedClass = "idle";

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      connect-timeout = 5; # fail fast if substituters are not available
      builders-use-substitutes = true;
      log-lines = 25;
      min-free = 512 * 1024 * 1024; # if free space drops under min, gc

      substituters = [
        "https://uku3lig.cachix.org"
      ];

      trusted-public-keys = [
        "uku3lig.cachix.org-1:C1/9DNUadh2pueAo+LUkVNUKyIVjF/CREd9RS9E+F2A="
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    flake.setNixPath = false;
    overlays = [ (import ../exprs/overlay.nix { inherit vencord; }) ];
  };

  programs = {
    direnv.enable = true;
    nix-index-database.comma.enable = true;
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;

    sudo = {
      execWheelOnly = true;
      extraConfig = ''
        Defaults lecture = never
      '';
    };
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = lib.mkDefault false;
    };

    resolved = {
      enable = true;
      dnssec = lib.mkDefault "true";
      dnsovertls = lib.mkDefault "true";
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
    };
  };

  systemd = {
    services.NetworkManager-wait-online.enable = lib.mkForce false;

    # NixOS/nixpkgs#267101
    tmpfiles.rules = [
      "L /usr/lib/locale/locale-archive - - - - /run/current-system/sw/lib/locale/locale-archive"
    ];
  };

  time.timeZone = "Europe/Paris";

  users.users = {
    "${username}" = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
        "libvirtd"
        "input"
        "docker"
      ];
      hashedPasswordFile = secrets.get "userPassword";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN+7+KfdOrhcnHayxvOENUeMx8rE4XEIV/AxMHiaNUP8"
      ];
    };

    root = {
      shell = pkgs.fish;
      hashedPasswordFile = rootPassword.path;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = lib.mkDefault stateVersion; # Did you read the comment?
}
