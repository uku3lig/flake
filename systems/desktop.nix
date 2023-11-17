{
  lib,
  pkgs,
  config,
  getchvim,
  agenix,
  nixpkgs-stable,
  ...
}: let
  username = "leo";
in {
  imports = [
    ../programs
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

  age = {
    identityPaths = ["/home/${username}/.ssh/id_ed25519"];

    secrets = let
      base = ../secrets/desktop;
    in {
      rootPassword.file = "${base}/rootPassword.age";
      userPassword.file = "${base}/userPassword.age";
    };
  };

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
      glfw-wayland-minecraft
      (prismlauncher.override {
        jdks = [temurin-bin-17];
      })
      vesktop
      mate.eom
      osu-lazer-bin
      gnome.file-roller
      getchvim.packages.${system}.default
      agenix.packages.${system}.default
    ];

    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentryFlavor = "gnome3";
      };
    };
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gnome3";
    };

    seahorse.enable = true;
    steam.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-volman thunar-archive-plugin];
    };

    virt-manager = {
      enable = true;
      package = nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.virt-manager;
    };
  };

  virtualisation.libvirtd.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    ${username} = {
      isNormalUser = true;
      shell = pkgs.fish;
      extraGroups = ["networkmanager" "wheel" "video" "libvirtd"];
      hashedPasswordFile = config.age.secrets.userPassword.path;
    };

    root.hashedPasswordFile = config.age.secrets.rootPassword.path;
  };

  fonts.packages = with pkgs; [
    iosevka
    jetbrains-mono
    cantarell-fonts
    (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
  ];

  environment.systemPackages = with pkgs; [sbctl];

  hm.home.stateVersion = "23.11";
}
