{
  description = "example flake idk";

  outputs = {
    self,
    flake-parts,
    nixinate,
    agenix,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux"];

      imports = [
        ./systems
      ];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        apps = (nixinate.nixinate.${system} self).nixinate;

        devShells.default = with pkgs;
          mkShellNoCC {
            packages = [
              just
              statix
              agenix.packages.${system}.default
            ];
          };

        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    camasca = {
      url = "git+https://git.uku3lig.net/uku/camasca";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:uku3lig/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "";
    };

    catppuccin.url = "github:Stonks3141/ctp-nix";

    crane.url = "github:ipetkov/crane";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    ghostty = {
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
      inputs.nixpkgs-unstable.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.crane.follows = "crane";
      inputs.pre-commit-hooks-nix.follows = "";
      inputs.flake-compat.follows = "";
    };

    mystia = {
      url = "github:soopyc/mystia";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-update-soopy.follows = "";
      inputs.flake-compat.follows = "";
    };

    nixinate = {
      url = "github:matthewcroughan/nixinate";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "";
    };

    # nix's most elaborate, overcomplicated joke
    systems.url = "github:nix-systems/default";

    vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "";
    };

    # ==== uku3lig stuff ====
    api-rs = {
      url = "github:uku3lig/api-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    ukubot-rs = {
      url = "github:uku3lig/ukubot-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    # ==== vencord ====
    vencord = {
      url = "github:Vendicated/Vencord";
      flake = false;
    };
  };
}
