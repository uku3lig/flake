alias s := switch
alias d := deploy

check:
    nix flake check

switch *args:
    @sudo -v
    sudo nixos-rebuild switch --flake . --keep-going {{args}}

rollback:
    @sudo -v
    sudo nixos-rebuild switch --rollback

boot *args:
    @sudo -v
    sudo nixos-rebuild boot --flake . --keep-going {{args}}

deploy system user="leo":
    #!/usr/bin/env bash
    set -euxo pipefail
    flake=$(nix eval --impure --raw --expr "(builtins.getFlake \"$PWD\").outPath")
    nix copy "$flake" --to "ssh://{{user}}@{{system}}"
    ssh -t "{{user}}@{{system}}" "sudo flock -w 60 /dev/shm/deploy-{{system}} nixos-rebuild switch --flake $flake#{{system}}"

lint *args:
    statix check -i flake.nix **/hardware-configuration.nix {{args}}
