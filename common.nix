{
  config,
  pkgs,
  inputs,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # apparently needed for mesa
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = false;
  };

  hardware.opengl.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
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

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  services.udisks2.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leo = {
    isNormalUser = true;
    description = "leo";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
    packages = with pkgs; [
      firefox
      kitty
      chezmoi
      starship
      waybar
      rofi-wayland
      hyprpaper
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
      hyfetch
      grim
      slurp
      swappy
      swayidle
      wl-clipboard
      cliphist
      libsForQt5.polkit-kde-agent
      font-manager
      nwg-look
      (catppuccin-gtk.override {
        variant = "macchiato";
        accents = ["sky" "sapphire"];
      })
      xfce.thunar
      xfce.thunar-volman
      xfce.thunar-archive-plugin
      jetbrains.idea-ultimate
      temurin-bin-17
      temurin-bin-8
      gcc
      gnumake
      mold
      sccache
      rustc
      cargo
      pavucontrol
      gnome.gnome-keyring
      gnome.seahorse
      obs-studio
      mpv
      ffmpeg_6
      vscode
      nil
      glfw-wayland-minecraft
      (prismlauncher.override {
        jdks = [temurin-bin-17];
      })
      vesktop
      grimblast
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  programs.hyprland.enable = true;
  programs.fish.enable = true;

  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.steam.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
  ];

  fonts.packages = with pkgs; [
    iosevka
    jetbrains-mono
    cantarell-fonts
    (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
