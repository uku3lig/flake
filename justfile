alias s := switch
alias d := deploy

check:
    nix flake check

switch *args:
    @sudo -v
    sudo nixos-rebuild switch --flake . --keep-going {{args}} --log-format internal-json |& nom --json

deploy system:
    nix run .#{{system}}

lint *args:
    statix check -i flake.nix **/hardware-configuration.nix {{args}}
