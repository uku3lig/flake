# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # apparently needed for mesa
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    displayManager.lightdm.enable = false;
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = false;
  };

  networking.hostName = "fuji"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.leo = {
    isNormalUser = true;
    description = "leo";
    extraGroups = ["networkmanager" "wheel"];
    shell = pkgs.fish;
    packages = with pkgs; [
      firefox
      neovim
      git
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
      ungoogled-chromium
      gnome.gnome-keyring
      gnome.seahorse
      obs-studio
      mpv
      ffmpeg_6
      vscode
      nil
      nixpkgs-fmt
      glfw-wayland-minecraft
      (prismlauncher.override {
        jdks = [temurin-bin-17];
      })
      shotcut
      vesktop
      grimblast
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
  };
  programs.fish.enable = true;

  programs.command-not-found.enable = false;
  programs.nix-index = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.steam.enable = true;

  nixpkgs.overlays = [
    (final: prev: {
      shotcut = prev.shotcut.overrideAttrs (old: {
        version = "23.09.29";
        src = prev.fetchFromGitHub {
          owner = "mltframework";
          repo = "shotcut";
          rev = "v23.09.29";
          sha256 = "1y46n5gmlayfl46l0vhg5g5dbbc0sg909mxb68sia0clkaas8xrh";
        };
      });
    })
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
  ];

  fonts.packages = with pkgs; [
    iosevka
    jetbrains-mono
    cantarell-fonts
    (nerdfonts.override {fonts = ["Iosevka" "JetBrainsMono"];})
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
