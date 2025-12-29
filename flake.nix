{
  description = "example flake idk";

  outputs =
    {
      agenix,
      flake-parts,
      treefmt-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        treefmt-nix.flakeModule
        ./systems
      ];

      perSystem =
        {
          pkgs,
          system,
          ...
        }:
        {
          devShells.default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              agenix.packages.${system}.default
              just
              statix
            ];
          };

          treefmt = {
            projectRootFile = "flake.nix";

            settings.excludes = [
              ".envrc"
              ".gitignore"
              "*.age"
              "flake.lock"
              "justfile"
              "LICENSE"
            ];

            programs = {
              nixfmt.enable = true;
              prettier.enable = true;
              stylua.enable = true;
            };
          };
        };
    };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    camasca = {
      url = "https://git.uku3lig.net/uku/camasca/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:uku3lig/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.home-manager.follows = "";
      inputs.darwin.follows = "";
    };

    crane.url = "github:ipetkov/crane";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    getchvim = {
      url = "github:getchoo/getchvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "";
      inputs.home-manager.follows = "";
      inputs.zon2nix.follows = "";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.crane.follows = "crane";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.pre-commit.follows = "";
    };

    mystia = {
      url = "github:soopyc/mystia";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-update-soopy.follows = "";
      inputs.flake-compat.follows = "";
      inputs.treefmt-nix.follows = "";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-compat.follows = "";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix's most elaborate, overcomplicated joke
    systems.url = "github:nix-systems/default";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
  };
}
