{
  pkgs,
  nixpkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    nix-your-shell
  ];

  programs = {
    fish = {
      enable = true;
      interactiveShellInit = ''
        nix-your-shell fish | source
      '';
    };

    direnv.enable = true;

    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
  };

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
  system.stateVersion = "23.11"; # Did you read the comment?
}
