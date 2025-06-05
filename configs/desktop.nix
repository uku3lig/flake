{
  lib,
  pkgs,
  config,
  lanzaboote,
  camascaPkgs,
  ...
}:
{
  imports = [
    lanzaboote.nixosModules.lanzaboote

    ./client.nix

    ../programs/ghostty.nix
    ../programs/gnome.nix
    ../programs/java.nix
    ../programs/neovim/neovide.nix
  ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    kernelModules = [ "v4l2loopback" ];

    # intellij async-profiler
    kernel.sysctl = {
      "kernel.perf_event_paranoid" = 1;
      "kernel.kptr_restrict" = 0;
    };

    supportedFilesystems = [ "ntfs" ];

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

      chromium
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      gimp3
      gparted
      idea-wrapped
      mpv
      obsidian
      strawberry
      teams-for-linux
      thunderbird
      vscode

      (camascaPkgs.project-sekai-cursors.override { group = "N25"; })
      (camascaPkgs.touhou-cursors.override { character = "Patchouli"; })

      # libreoffice stuff
      libreoffice-qt6-fresh
      hunspell
      hunspellDicts.en_US
      hunspellDicts.fr-moderne

    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
    };
  };

  fonts = {
    packages = with pkgs; [
      cantarell-fonts
      google-sans # exprs/google-sans.nix
      inter
      iosevka-bin
      jetbrains-mono
      noto-fonts-cjk-sans
      twitter-color-emoji

      nerd-fonts.iosevka-term
    ];

    fontconfig.defaultFonts = {
      emoji = [ "Twitter Color Emoji" ];
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
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
    ssh.enableAskPassword = true;
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

    pulseaudio.enable = false;
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
