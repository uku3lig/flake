{
  lib,
  pkgs,
  config,
  catppuccin,
  ...
}: {
  imports = [../programs];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    kernelModules = ["v4l2loopback"];

    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  environment.systemPackages = with pkgs; [sbctl];

  fonts = {
    packages = with pkgs; [
      iosevka
      jetbrains-mono
      cantarell-fonts
      twitter-color-emoji
      (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
    ];

    fontconfig.defaultFonts = {
      emoji = ["Twitter Color Emoji"];
    };
  };

  hardware = {
    opengl.enable = true;
    pulseaudio.enable = false;

    # xone.enable = true;
    xpadneo.enable = true;
  };

  hm = {
    imports = [
      catppuccin.homeManagerModules.catppuccin
    ];

    home = {
      packages = with pkgs; [
        font-manager
        gimp
        gnome.gnome-calculator
        jetbrains.idea-ultimate
        libreoffice-fresh
        mate.eom
        mold
        mpv
        nwg-look
        obs-studio
        obsidian
        osu-lazer-bin
        pavucontrol
        polkit_gnome
        prismlauncher
        sccache
        shotcut
        (vesktop.override {withSystemVencord = false;})
        wine-discord-ipc-bridge
      ];

      stateVersion = "23.11";
    };

    services = {
      gpg-agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    };

    gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        flavour = "macchiato";
        accent = "sky";
      };
    };
  };

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

  programs = {
    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    firefox = {
      enable = true;
      package = pkgs.librewolf;
    };

    seahorse.enable = true;
    file-roller.enable = true;

    steam.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-volman thunar-archive-plugin];
    };

    virt-manager.enable = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;

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

    ratbagd.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  sound.enable = true;

  virtualisation.libvirtd.enable = true;

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [xdg-desktop-portal-gtk];
    };

    mime.enable = true;
    icons.enable = true;
  };
}
