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

deploy system *args:
    #!/usr/bin/env bash
    set -euo pipefail
    flake=$(nix eval --impure --raw --expr "(builtins.getFlake \"git+file://$PWD\").outPath")
    nix copy "$flake" --to "ssh://{{system}}"
    ssh -t "{{system}}" "bash $flake/switch.sh $flake {{args}}"

lint *args:
    statix check -i flake.nix **/hardware-configuration.nix {{args}}

eval system *args:
    nix eval .#nixosConfigurations.{{system}}.config.system.build.toplevel {{args}}

eval-all *args:
    nix eval .#nixosConfigurations --apply 'builtins.mapAttrs (name: cfg: builtins.trace name cfg.config.system.build.toplevel)'
