{
  lib,
  pkgs,
  config,
  catppuccin,
  lanzaboote,
  ...
}: {
  imports = [
    catppuccin.nixosModules.catppuccin
    lanzaboote.nixosModules.lanzaboote

    ./client.nix

    ../programs/ghostty.nix
    ../programs/kde.nix
    # ../programs/vscode.nix

    # the world if hyprland
    # ../programs/hyprland.nix
    # ../programs/alacritty.nix
  ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
    kernelModules = ["v4l2loopback"];

    supportedFilesystems = ["ntfs"];

    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      sbctl
      wl-clipboard
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
    };
  };

  fonts = {
    packages = with pkgs; [
      cantarell-fonts
      inter
      iosevka
      jetbrains-mono
      twitter-color-emoji

      (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
    ];

    fontconfig.defaultFonts = {
      emoji = ["Twitter Color Emoji"];
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    pulseaudio.enable = false;
  };

  hm = {
    imports = [
      catppuccin.homeManagerModules.catppuccin
      ../programs/java.nix
    ];

    home = {
      packages = with pkgs; [
        gimp
        gparted
        idea-ultimate-fhs
        mpv
        obsidian
        strawberry
        teams-for-linux
        thunderbird
        (vesktop.override {withSystemVencord = false;})
        vscode

        # libreoffice stuff
        libreoffice-qt6-fresh
        hunspell
        hunspellDicts.en_US
        hunspellDicts.fr-moderne
      ];
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
    firefox.enable = true;
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

    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn; # mullvad only has the cli
    };

    ratbagd.enable = true;
    udisks2.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    virtualbox.host.enable = true;
  };

  xdg = {
    portal.enable = true;
    mime.enable = true;
    icons.enable = true;
  };
}
