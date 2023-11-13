{
  lib,
  pkgs,
  nixpkgs,
  ragenix,
  getchvim,
  ...
}: let
  username = "leo";
in {
  imports = [
    (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" username])
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;

    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  hardware = {
    opengl.enable = true;
    pulseaudio.enable = false;
  };

  sound.enable = true;

  services = {
    # apparently needed for mesa
    xserver = {
      enable = true;
      xkb.layout = "fr";
      displayManager = {
        lightdm.enable = false;
        gdm = {
          enable = true;
          wayland = true;
        };
        defaultSession = "hyprland";
      };
    };

    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    udisks2.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    };

    mime.enable = true;
    icons.enable = true;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  console.keyMap = "fr";

  security.rtkit.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  hm = {
    home.packages = with pkgs; let
      inherit (pkgs.stdenv.hostPlatform) system;
    in [
      firefox
      kitty
      chezmoi
      starship
      waybar
      rofi-wayland
      hyprpaper
      swappy
      swayidle
      wl-clipboard
      cliphist
      font-manager
      polkit_gnome
      nwg-look
      (catppuccin-gtk.override {
        variant = "macchiato";
        accents = ["sky" "sapphire"];
      })
      jetbrains.idea-ultimate
      jetbrains.webstorm
      jetbrains.rust-rover
      jetbrains.clion
      mold
      sccache
      pavucontrol
      obs-studio
      mpv
      vscode
      nil
      glfw-wayland-minecraft
      (prismlauncher.override {
        jdks = [temurin-bin-17];
      })
      vesktop
      grimblast
      playerctl
      mate.eom
      osu-lazer-bin
      gnome.file-roller
      ragenix.packages.${system}.default
      getchvim.packages.${system}.default
      nix-your-shell
      neovide
    ];

    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentryFlavor = "gnome3";
      };
    };

    # wayland.windowManager.hyprland.enable = true;

    programs.git = {
      enable = true;
      userName = "uku";
      userEmail = "uku3lig@gmail.com";

      signing = {
        key = "0D2F5CFF394C558D4F1C58937D01D7B105E77166";
        signByDefault = true;
      };

      extraConfig = {
        core.autocrlf = "input";
        push.autoSetupRemote = true;
      };
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        nix-your-shell fish | source
      '';
    };

    hyprland.enable = true;

    git = {
      enable = true;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };

    direnv.enable = true;

    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };

    seahorse.enable = true;
    steam.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-volman thunar-archive-plugin];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "video"];
  };

  fonts.packages = with pkgs; [
    iosevka
    jetbrains-mono
    cantarell-fonts
    (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
  ];

  environment.systemPackages = with pkgs; [
    neovim
    git
    sbctl
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
      automatic = true;
      dates = "3d";
      options = "-d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
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
  system.stateVersion = "23.05"; # Did you read the comment?
  hm.home.stateVersion = "23.05";
}
