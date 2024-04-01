{
  description = "example flake idk";

  nixConfig = {
    extra-substituters = ["https://uku3lig.cachix.org"];
    extra-trusted-public-keys = ["uku3lig.cachix.org-1:C1/9DNUadh2pueAo+LUkVNUKyIVjF/CREd9RS9E+F2A="];
  };

  outputs = {flake-parts, ...} @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./parts
        ./systems
        ./exprs/modules.nix
      ];
    };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";

    # nix's most elaborate, overcomplicated joke
    systems.url = "github:nix-systems/default";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:Stonks3141/ctp-nix";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pre-commit-hooks-nix.follows = "";
      inputs.flake-compat.follows = "";
    };

    agenix = {
      url = "github:uku3lig/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
      inputs.home-manager.follows = "home-manager";
      inputs.darwin.follows = "";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
      inputs.flake-compat.follows = "";
    };

    vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "";
    };

    # ==== uku3lig stuff ====
    api-rs = {
      url = "github:uku3lig/api-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.rust-overlay.follows = "";
    };

    ukubot-rs = {
      url = "github:uku3lig/ukubot-rs/76df1dd3caaa64a2b74b03250448f4b4a554899a";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.rust-overlay.follows = "";
    };
  };
}
