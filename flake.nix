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
              nixfmt-rfc-style
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
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    camasca = {
      url = "git+https://git.uku3lig.net/uku/camasca";
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

    hjem = {
      url = "github:feel-co/hjem";
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

    # ==== non-flakes ====
    vencord = {
      url = "github:Vendicated/Vencord";
      flake = false;
    };
  };
}
