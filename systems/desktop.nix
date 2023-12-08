{
  lib,
  pkgs,
  config,
  agenix,
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

    xone.enable = true;
    xpadneo.enable = true;
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
    tumbler.enable = true;
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

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    pam.services.login.enableGnomeKeyring = true;
  };

  age = {
    identityPaths = ["/etc/ssh/ssh_host_ed25519_key"];

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
      agenix.packages.${system}.default
      font-manager
      gimp
      jetbrains.idea-ultimate
      libreoffice-fresh
      mate.eom
      mold
      mpv
      nwg-look
      obs-studio
      osu-lazer-bin
      pavucontrol
      polkit_gnome
      prismlauncher
      sccache
      shotcut
      vesktop

      (catppuccin-gtk.override {
        variant = "macchiato";
        accents = ["sky" "sapphire"];
      })
    ];

    services = {
      gpg-agent = {
        enable = true;
        pinentryFlavor = "gnome3";
      };
    };
  };

  nixpkgs.overlays = [(import ../exprs/overlay.nix)];

  programs = {
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };

    firefox.enable = true;

    seahorse.enable = true;
    file-roller.enable = true;

    steam.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-volman thunar-archive-plugin];
    };

    virt-manager.enable = true;
  };

  virtualisation.libvirtd.enable = true;

  users.users."${username}" = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "video" "libvirtd"];
    hashedPasswordFile = config.age.secrets.userPassword.path;
  };

  users.users.root.hashedPasswordFile = config.age.secrets.rootPassword.path;

  fonts.packages = with pkgs; [
    iosevka
    jetbrains-mono
    cantarell-fonts
    (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
  ];

  environment.systemPackages = with pkgs; [sbctl];

  hm.home.stateVersion = "23.11";
}
