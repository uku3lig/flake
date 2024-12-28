alias s := switch
alias d := deploy

check:
    nix flake check

switch *args:
    @sudo -v
    nh os switch --no-nom --ask . -- --keep-going {{args}}

rollback:
    @sudo -v
    sudo nixos-rebuild switch --rollback

boot *args:
    @sudo -v
    nh os boot --no-nom --ask . -- --keep-going {{args}}

deploy system user="leo":
    #!/usr/bin/env bash
    set -euxo pipefail
    flake=$(nix eval --impure --raw --expr "(builtins.getFlake \"$PWD\").outPath")
    nix copy "$flake" --to "ssh://{{user}}@{{system}}"
    # -R/--bypass-root-check is needed because of a Git CVE regression in Nix 2.20
    # See NixOS/nix#10202, viperML/nh#200
    ssh -t "{{user}}@{{system}}" "sudo flock -w 60 /dev/shm/deploy-{{system}} nix run n#nh -- os switch --no-nom -R -H {{system}} --ask $flake"

lint *args:
    statix check -i flake.nix **/hardware-configuration.nix {{args}}
