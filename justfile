alias s := switch
alias d := deploy

check:
    nix flake check

switch *args:
    #!/usr/bin/env bash
    set -euo pipefail
    configuration=$(sudo nixos-rebuild dry-activate --flake . --keep-going {{args}})
    echo $configuration
    read -n1 -p "Activate new configuration? [y/N] " answer
    if [[ $answer =~ ^[Yy]$ ]]; then
      sudo "$configuration/bin/switch-to-configuration" switch
    else
      echo "Not activating :("
      exit 1
    fi

rollback:
    sudo nixos-rebuild switch --rollback

boot *args:
    sudo nixos-rebuild boot --flake . --keep-going {{args}}

deploy system user="leo":
    #!/usr/bin/env bash
    set -euo pipefail
    flake=$(nix eval --impure --raw --expr "(builtins.getFlake \"git+file://$PWD\").outPath")
    sshout=$(mktemp)

    nix copy "$flake" --to "ssh://{{user}}@{{system}}"
    ssh -t "{{user}}@{{system}}" "sudo nixos-rebuild dry-activate --flake $flake --keep-going" | tee "$sshout"
    configuration=$(tail -n1 "$sshout" | grep -Po "/nix/store/[\w\d\.\-]+")
    echo "$configuration"
    rm "$sshout"

    read -n1 -p "Activate new configuration? [y/N] " answer
    if [[ $answer =~ ^[Yy]$ ]]; then
      ssh -t "{{user}}@{{system}}" "sudo \"$configuration/bin/switch-to-configuration\" switch"
    else
      echo "Not activating :("
      exit 1
    fi

lint *args:
    statix check -i flake.nix **/hardware-configuration.nix {{args}}
