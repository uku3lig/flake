# Shamelessly taken from https://github.com/getchoo/flake/blob/d80d49cc7652ea84810c4688212c48277dfc71be/justfile

alias c := check
alias s := switch

default:
    @just --choose

check:
    nix flake check

[linux]
switch *args:
    sudo nixos-rebuild switch --flake . --keep-going {{ args }}
