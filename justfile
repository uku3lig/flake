alias s := switch
alias d := deploy

check:
    nix flake check

switch *args:
    bash switch.sh {{ justfile_directory() }} {{args}}

rollback:
    sudo nixos-rebuild switch --rollback

boot *args:
    sudo nixos-rebuild boot --flake {{ justfile_directory() }} --keep-going {{args}}

deploy system user="leo":
    #!/usr/bin/env bash
    set -euo pipefail
    flake=$(nix eval --impure --raw --expr "(builtins.getFlake \"git+file://$PWD\").outPath")
    nix copy "$flake" --to "ssh://{{user}}@{{system}}"
    ssh -t "{{user}}@{{system}}" "bash $flake/switch.sh $flake"

lint *args:
    statix check -i flake.nix **/hardware-configuration.nix {{args}}
