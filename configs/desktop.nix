{
  lib,
  pkgs,
  config,
  catppuccin,
  ...
}: {
  imports = [
    ../programs/alacritty.nix
    ../programs/gnome.nix
    ../programs/vscode.nix

    # the world if hyprland
    # ../programs/hyprland.nix
    # ../programs/fuzzel.nix
    # ../programs/waybar
  ];

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
        # font-manager
        chromium
        gimp
        gnome.gnome-calculator
        gparted
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
        (prismlauncher.override {
          jdks = [temurin-bin-21 temurin-bin-17 temurin-bin-8];
        })
        sccache
        shotcut
        (vesktop.override {withSystemVencord = false;})
        wine-discord-ipc-bridge
      ];
    };

    services = {
      gpg-agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    };

    xdg.enable = true;

    gtk = {
      enable = true;
      catppuccin = {
        enable = true;
        flavor = "macchiato";
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
    portal.enable = true;
    mime.enable = true;
    icons.enable = true;
  };
}
