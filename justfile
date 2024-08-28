alias s := switch
alias d := deploy

check:
    nix flake check

switch *args:
    @sudo -v
    sudo nixos-rebuild switch --flake . --keep-going {{args}}

boot *args:
    @sudo -v
    sudo nixos-rebuild boot --flake . --keep-going {{args}}

deploy system:
    nix run .#{{system}}

lint *args:
    statix check -i flake.nix **/hardware-configuration.nix {{args}}
