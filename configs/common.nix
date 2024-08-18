{
  lib,
  pkgs,
  config,
  _utils,
  nixpkgs,
  agenix,
  home-manager,
  ...
}: let
  username = "leo";
  stateVersion = "23.11";

  rootPassword = _utils.setupSingleSecret config "rootPassword" {};
  secrets = _utils.setupSharedSecrets config {
    secrets = ["userPassword" "tailscaleKey"];
  };
in {
  imports = [
    agenix.nixosModules.default
    home-manager.nixosModules.home-manager

    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" username])

    rootPassword.generate
    secrets.generate

    ../programs/fish.nix
    ../programs/git.nix
    ../programs/rust.nix
    ../programs/starship
  ];

  age.identityPaths = ["/etc/age/key"];

  boot = {
    kernelPackages = pkgs.linuxPackages; # use lts
    kernelParams = ["quiet" "loglevel=3"];

    # faster tcp !!!
    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    tmp.cleanOnBoot = true;
  };

  console.keyMap = "fr";

  environment = {
    systemPackages = with pkgs; [
      agenix.packages.${pkgs.system}.default
      neovim
      git
      curl
      wget
      htop
      ripgrep
    ];

    variables = {
      EDITOR = lib.getExe pkgs.neovim;
    };
  };

  hm = {
    home = {inherit stateVersion;};

    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      forwardAgent = true;
    };

    services.ssh-agent.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    useNetworkd = lib.mkDefault true;
    nameservers = ["1.1.1.1" "1.0.0.1"];
  };

  nix = {
    package = pkgs.lix;

    gc = {
      automatic = true;
      dates = "weekly";
      options = "-d";
    };

    registry = let
      n.flake = nixpkgs;
    in {
      inherit n;
      nixpkgs = n;
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      trusted-users = ["root" "@wheel"];

      substituters = [
        "https://uku3lig.cachix.org"
        "https://ghostty.cachix.org"
      ];

      trusted-public-keys = [
        "uku3lig.cachix.org-1:C1/9DNUadh2pueAo+LUkVNUKyIVjF/CREd9RS9E+F2A="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [(import ../exprs/overlay.nix)];
  };

  programs = {
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
      dnssec = "allow-downgrade";
      dnsovertls = "true";
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      extraUpFlags = ["--ssh" "--stateful-filtering"];
      authKeyFile = secrets.get "tailscaleKey";
    };
  };

  system.switch = {
    enable = false;
    enableNg = true;
  };

  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  time.timeZone = "Europe/Paris";

  users.users = {
    "${username}" = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["networkmanager" "wheel" "video" "libvirtd"];
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
