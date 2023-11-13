# Shamelessly taken from https://github.com/getchoo/flake/blob/d80d49cc7652ea84810c4688212c48277dfc71be/justfile

alias b := build
alias c := check
alias s := switch
alias t := test

default:
    @just --choose

[linux]
build *args:
    nixos-rebuild build --flake . {{ args }}
    nix run n#nvd -- diff /run/current-system/ result/

check:
    nix flake check

[linux]
switch *args:
    sudo nixos-rebuild switch --flake . --keep-going {{ args }}

[linux]
test:
    sudo nixos-rebuild test --flake .

update: (switch "--recreate-lock-file")
    nix-index
